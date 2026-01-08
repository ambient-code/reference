#!/bin/bash
set -e

echo "Setting up Ambient Code Reference Repository..."
echo ""

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python version: $PYTHON_VERSION"

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv .venv

# Activate virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate

# Install uv if not already installed
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Install dependencies
echo "Installing documentation dependencies..."
uv pip install -r requirements-dev.txt

# Verify installation
echo "Verifying installation..."
echo "✓ Documentation tooling installed"

echo ""
echo "Setup complete! 🎉"
echo ""
echo "Next steps:"
echo "  1. Activate virtual environment: source .venv/bin/activate"
echo "  2. Explore documentation: cat docs/quickstart.md"
echo "  3. Validate Mermaid diagrams: ./scripts/validate-mermaid.sh"
echo "  4. Lint markdown: markdownlint docs/**/*.md --fix"
echo ""
echo "For a working application demo, see:"
echo "  https://github.com/ambient-code/demo-fastapi"
echo ""
