#!/bin/bash

# This script builds both PDF and HTML versions of the GPSA Rulebook using Quarto
# Usage: ./dev-docs/rulebook/build-quarto.sh

set -e  # Exit on any error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "=========================================="
echo "GPSA Rulebook - Quarto Build"
echo "=========================================="
echo ""

# Check if Quarto is installed
if ! command -v quarto &> /dev/null; then
    echo "Error: Quarto is not installed."
    echo ""
    echo "Please install Quarto:"
    echo "  - macOS: brew install quarto"
    echo "  - Or download from: https://quarto.org/docs/get-started/"
    echo ""
    exit 1
fi

# Display Quarto version
echo "Using Quarto version: $(quarto --version)"
echo ""

# Navigate to rulebook directory
cd "$SCRIPT_DIR"

# Render both formats
echo "Rendering rulebook (HTML + PDF)..."
quarto render

echo ""
echo "=========================================="
echo "Build Complete!"
echo "=========================================="
echo "HTML: docs/ (served from GitHub Pages at rulebook.gpsaswimming.org)"
echo "PDF:  docs/GPSA-Rulebook.pdf"
echo "ePub: docs/GPSA-Rulebook.epub"
echo ""
echo "To preview HTML locally:"
echo "  quarto preview"
echo ""
echo "To deploy:"
echo "  git add . && git commit -m 'Update content' && git push origin main"
echo ""
