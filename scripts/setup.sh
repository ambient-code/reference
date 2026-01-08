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

# Install pre-commit hooks
echo "Installing pre-commit hooks..."
.venv/bin/pre-commit install

# Check for npm tools
echo ""
echo "Checking npm tools..."
if command -v markdownlint &> /dev/null; then
    echo "✓ markdownlint installed"
else
    echo "⚠ markdownlint not found - install with: npm install -g markdownlint-cli"
fi

if command -v mmdc &> /dev/null; then
    echo "✓ mermaid-cli installed"
else
    echo "⚠ mermaid-cli not found - install with: npm install -g @mermaid-js/mermaid-cli"
fi

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Activate virtual environment: source .venv/bin/activate"
echo "  2. Install npm tools (if missing): npm install -g markdownlint-cli @mermaid-js/mermaid-cli"
echo "  3. Validate docs: pre-commit run --all-files"
echo ""
echo "For a working application demo, see:"
echo "  https://github.com/ambient-code/demo-fastapi"
echo ""
