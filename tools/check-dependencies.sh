#!/bin/bash
# Check if all required dependencies are installed

echo "=== Dependency Check ==="
echo ""

check_tool() {
    if command -v "$1" &> /dev/null; then
        version=$($1 --version 2>&1 | head -1)
        echo "✅ $1: $version"
        return 0
    else
        echo "❌ $1: NOT FOUND"
        return 1
    fi
}

all_found=true

check_tool jadx || all_found=false
check_tool apktool || all_found=false
check_tool java || all_found=false
check_tool rg || all_found=false
check_tool git || all_found=false
check_tool python3 || all_found=false

echo ""
if [ "$all_found" = true ]; then
    echo "✅ All dependencies satisfied!"
    exit 0
else
    echo "❌ Some dependencies are missing. See SETUP.md for installation instructions."
    exit 1
fi
