#!/usr/bin/env bash
# Gmail Direct - Setup Script
# Run this once after installing the skill

set -e
cd "$(dirname "$0")"

echo "Setting up Gmail Direct skill..."

# Create venv if not exists
if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
fi

# Install dependencies
echo "Installing dependencies..."
.venv/bin/pip install -q -r requirements.txt

echo ""
echo "Dependencies installed."
echo ""

# Check for credentials
if [ ! -f "credentials.json" ]; then
    echo "⚠️  credentials.json not found!"
    echo ""
    echo "Next steps:"
    echo "1. Go to https://console.cloud.google.com/apis/credentials"
    echo "2. Create OAuth client ID (Desktop app)"
    echo "3. Download JSON and save as: $(pwd)/credentials.json"
    echo "4. Run: ./setup.sh auth"
    exit 0
fi

# Auth if requested
if [ "$1" = "auth" ]; then
    echo "Starting OAuth authorization..."
    .venv/bin/python skill.py auth
    echo ""
    echo "✓ Setup complete! Gmail Direct is ready to use."
else
    echo "✓ Dependencies ready."
    echo ""
    echo "To authorize Gmail access, run:"
    echo "  cd $(pwd) && ./setup.sh auth"
fi
