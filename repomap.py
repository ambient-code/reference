#!/usr/bin/env python3
# /// script
# dependencies = [
#     # Keep versions in sync with requirements.txt
#     "tree-sitter>=0.20.0",
#     "tree-sitter-python>=0.20.0",
#     "tree-sitter-javascript>=0.20.0",
#     "tree-sitter-typescript>=0.20.0",
#     "tree-sitter-go>=0.20.0",
#     "tree-sitter-bash>=0.20.0",
# ]
# ///
"""
Repomap - Generate AI-friendly code structure maps using tree-sitter

Inspired by Aider's repomap.py (https://github.com/Aider-AI/aider/blob/main/aider/repomap.py)

Purpose: Context window optimization for AI-assisted development - reduces tokens while
maintaining code understanding, improving performance and reducing costs.
"""

import argparse
import os
import sys
from collections import defaultdict
from concurrent.futures import ProcessPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Set

try:
    import tree_sitter_bash as tsbash
    import tree_sitter_go as tsgo
    import tree_sitter_javascript as tsjavascript
    import tree_sitter_python as tspython
    import tree_sitter_typescript as tstypescript
    from tree_sitter import Language, Parser, Query, QueryCursor
except ImportError:
    print("Error: Required tree-sitter packages not installed.", file=sys.stderr)
    print("Install with: pip install tree-sitter tree-sitter-python tree-sitter-javascript tree-sitter-typescript tree-sitter-go tree-sitter-bash", file=sys.stderr)
    sys.exit(1)


# Language configurations
LANGUAGE_CONFIGS = {
    ".py": {
        "language": Language(tspython.language()),
        "queries": {
            "function": "(function_definition name: (identifier) @name)",
            "class": "(class_definition name: (identifier) @name)",
        },
    },
    ".js": {
        "language": Language(tsjavascript.language()),
        "queries": {
            "function": "(function_declaration name: (identifier) @name)",
            "class": "(class_declaration name: (identifier) @name)",
        },
    },
    ".ts": {
        "language": Language(tstypescript.language_typescript()),
        "queries": {
            "function": "(function_declaration name: (identifier) @name)",
            "class": "(class_declaration name: (identifier) @name)",
            "interface": "(interface_declaration name: (type_identifier) @name)",
        },
    },
    ".tsx": {
        "language": Language(tstypescript.language_tsx()),
        "queries": {
            "function": "(function_declaration name: (identifier) @name)",
            "class": "(class_declaration name: (identifier) @name)",
            "interface": "(interface_declaration name: (type_identifier) @name)",
        },
    },
    ".go": {
        "language": Language(tsgo.language()),
        "queries": {
            "function": "(function_declaration name: (identifier) @name)",
            "method": "(method_declaration name: (field_identifier) @name)",
            "struct": "(type_declaration (type_spec name: (type_identifier) @name))",
        },
    },
    ".sh": {
        "language": Language(tsbash.language()),
        "queries": {
            "function": "(function_definition name: (word) @name)",
        },
    },
    ".bash": {
        "language": Language(tsbash.language()),
        "queries": {
            "function": "(function_definition name: (word) @name)",
        },
    },
}


@dataclass
class CodeSymbol:
    """Represents a code symbol (function, class, method, etc.)"""

    name: str
    type: str  # 'function', 'class', 'method', etc.
    line: int
    parent: Optional[str] = None


@dataclass
class FileInfo:
    """Information about a parsed file"""

    path: str
    symbols: List[CodeSymbol]
    error: Optional[str] = None


class RepomapGenerator:
    """Generate repository structure maps using tree-sitter"""

    def __init__(self, root_dir: str, max_file_size: int = 1024 * 1024, verbose: bool = False):
        self.root_dir = Path(root_dir).resolve()
        self.max_file_size = max_file_size
        self.verbose = verbose
        self.gitignore_patterns = self._load_gitignore()

    def _load_gitignore(self) -> Set[str]:
        """Load .gitignore patterns (simplified implementation)"""
        gitignore_path = self.root_dir / ".gitignore"
        patterns = set()

        # Common patterns to always ignore
        patterns.update([".git", "__pycache__", "node_modules", ".venv", "venv", "*.pyc", ".DS_Store"])

        if gitignore_path.exists():
            try:
                with open(gitignore_path, "r") as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith("#"):
                            patterns.add(line)
            except Exception as e:
                if self.verbose:
                    print(f"Warning: Could not read .gitignore: {e}", file=sys.stderr)

        return patterns

    def _should_ignore(self, path: Path) -> bool:
        """Check if path should be ignored based on gitignore patterns"""
        relative_path = path.relative_to(self.root_dir)
        path_str = str(relative_path)

        # Check each pattern
        for pattern in self.gitignore_patterns:
            # Simple pattern matching (not full gitignore spec)
            if pattern.startswith("*"):
                if path_str.endswith(pattern[1:]):
                    return True
            elif pattern in path.parts:
                return True
            elif path_str.startswith(pattern):
                return True

        return False

    def _is_binary(self, file_path: Path) -> bool:
        """Check if file is binary"""
        try:
            with open(file_path, "rb") as f:
                chunk = f.read(1024)
                return b"\0" in chunk
        except Exception:
            return True

    def _get_file_extension(self, file_path: Path) -> Optional[str]:
        """Get file extension if it's a supported language"""
        ext = file_path.suffix.lower()
        return ext if ext in LANGUAGE_CONFIGS else None

    def _discover_files(self) -> List[Path]:
        """Discover all parseable files in the repository"""
        files = []

        for path in self.root_dir.rglob("*"):
            # Skip if not a file
            if not path.is_file():
                continue

            # Skip if ignored
            if self._should_ignore(path):
                continue

            # Skip if no supported extension
            if not self._get_file_extension(path):
                continue

            # Skip if binary
            if self._is_binary(path):
                continue

            # Skip if too large
            try:
                if path.stat().st_size > self.max_file_size:
                    if self.verbose:
                        print(f"Skipping large file: {path}", file=sys.stderr)
                    continue
            except Exception:
                continue

            files.append(path)

        return sorted(files)

    def _parse_file(self, file_path: Path) -> FileInfo:
        """Parse a single file and extract symbols"""
        relative_path = file_path.relative_to(self.root_dir)
        ext = self._get_file_extension(file_path)

        if not ext:
            return FileInfo(str(relative_path), [], error="Unsupported file type")

        config = LANGUAGE_CONFIGS[ext]
        language = config["language"]

        try:
            # Read file content
            with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                code = f.read()

            # Parse with tree-sitter
            parser = Parser(language)
            tree = parser.parse(bytes(code, "utf8"))

            # Extract symbols
            symbols = []
            for symbol_type, query_str in config["queries"].items():
                try:
                    query = Query(language, query_str)
                    cursor = QueryCursor(query)
                    captures_dict = cursor.captures(tree.root_node)

                    # Get nodes for the "name" capture
                    if "name" in captures_dict:
                        for node in captures_dict["name"]:
                            symbol_name = code[node.start_byte : node.end_byte]
                            line = node.start_point[0] + 1  # Convert to 1-indexed
                            symbols.append(CodeSymbol(name=symbol_name, type=symbol_type, line=line))
                except Exception as e:
                    if self.verbose:
                        print(f"Warning: Query failed for {symbol_type} in {relative_path}: {e}", file=sys.stderr)

            return FileInfo(str(relative_path), symbols)

        except Exception as e:
            return FileInfo(str(relative_path), [], error=str(e))

    def _format_output(self, file_infos: List[FileInfo]) -> str:
        """Format file information as a tree structure"""
        output = []

        # Group files by directory
        dir_files = defaultdict(list)
        for file_info in file_infos:
            path = Path(file_info.path)
            dir_path = str(path.parent) if path.parent != Path(".") else ""
            dir_files[dir_path].append(file_info)

        # Sort directories
        sorted_dirs = sorted(dir_files.keys())

        for dir_path in sorted_dirs:
            # Print directory header
            if dir_path:
                output.append(f"{dir_path}/")

            # Print files in directory
            for file_info in sorted(dir_files[dir_path], key=lambda f: f.path):
                file_name = Path(file_info.path).name
                indent = "  " if dir_path else ""

                output.append(f"{indent}{file_name}")

                # Print symbols
                if file_info.error:
                    if self.verbose:
                        output.append(f"{indent}  # Error: {file_info.error}")
                else:
                    # Group symbols by type (classes first, then functions/methods)
                    classes = sorted([s for s in file_info.symbols if s.type in ("class", "struct", "interface")], key=lambda s: s.line)
                    functions = sorted([s for s in file_info.symbols if s.type in ("function", "method")], key=lambda s: s.line)

                    # Track which functions have been shown as methods
                    shown_functions = set()

                    for i, symbol in enumerate(classes):
                        output.append(f"{indent}  {symbol.type} {symbol.name}")

                        # Find methods that belong to this class
                        # Methods are between this class and the next class (or end of file)
                        next_class_line = classes[i + 1].line if i + 1 < len(classes) else float("inf")

                        for func in functions:
                            if symbol.line < func.line < next_class_line:
                                output.append(f"{indent}    def {func.name}()")
                                shown_functions.add(func.line)

                    # Show standalone functions (those not shown under classes)
                    for func in functions:
                        if func.line not in shown_functions:
                            output.append(f"{indent}  def {func.name}()")

        return "\n".join(output)

    def generate(self, parallel: bool = True) -> str:
        """Generate the repository map"""
        files = self._discover_files()

        if not files:
            return "# No parseable files found"

        if self.verbose:
            print(f"Processing {len(files)} files...", file=sys.stderr)

        # Parse files
        if parallel and len(files) > 1:
            # Use process pool for parallel parsing
            file_infos = []
            with ProcessPoolExecutor() as executor:
                futures = {executor.submit(self._parse_file, f): f for f in files}
                for future in as_completed(futures):
                    try:
                        file_infos.append(future.result())
                    except Exception as e:
                        file_path = futures[future]
                        if self.verbose:
                            print(f"Error processing {file_path}: {e}", file=sys.stderr)
        else:
            # Sequential parsing
            file_infos = []
            for file_path in files:
                file_infos.append(self._parse_file(file_path))

        # Format and return output
        return self._format_output(file_infos)


def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(
        description="Generate AI-friendly code structure maps using tree-sitter",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  repomap .                    # Map current directory
  repomap /path/to/repo        # Map specific directory
  repomap . --verbose          # Show processing details
  repomap . > repomap.txt      # Save to file

Supported languages:
  Python (.py), TypeScript (.ts, .tsx), JavaScript (.js),
  Go (.go), Shell (.sh, .bash)
        """,
    )

    parser.add_argument("directory", nargs="?", default=".", help="Directory to map (default: current directory)")

    parser.add_argument("--max-file-size", type=int, default=1024 * 1024, help="Maximum file size in bytes (default: 1MB)")

    parser.add_argument("--verbose", "-v", action="store_true", help="Show verbose output")

    parser.add_argument("--no-parallel", action="store_true", help="Disable parallel processing")

    args = parser.parse_args()

    # Validate directory
    if not os.path.isdir(args.directory):
        print(f"Error: '{args.directory}' is not a valid directory", file=sys.stderr)
        sys.exit(1)

    try:
        generator = RepomapGenerator(root_dir=args.directory, max_file_size=args.max_file_size, verbose=args.verbose)

        output = generator.generate(parallel=not args.no_parallel)
        print(output)

    except KeyboardInterrupt:
        print("\nInterrupted by user", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        if args.verbose:
            import traceback

            traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
