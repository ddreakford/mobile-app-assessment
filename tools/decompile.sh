#!/bin/bash
# Automated APK Decompilation
# Usage: ./decompile.sh <apk_file>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <apk_file>"
    echo "Example: $0 myapp.apk"
    exit 1
fi

APK_FILE="$1"
OUTPUT_DIR="decompiled"

if [ ! -f "$APK_FILE" ]; then
    echo "❌ Error: APK file not found: $APK_FILE"
    exit 1
fi

echo "=== APK Decompilation ==="
echo "APK: $APK_FILE"
echo "Output: $OUTPUT_DIR"
echo ""

# Create output directories
mkdir -p "$OUTPUT_DIR"/{sources,resources}

# Decompile with JADX
echo "🔧 Decompiling with JADX..."
jadx "$APK_FILE" -d "$OUTPUT_DIR/sources/" 2>&1 | tee "$OUTPUT_DIR/jadx_output.log"

# Extract resources with APKTool
echo "🔧 Extracting resources with APKTool..."
apktool d "$APK_FILE" -o "$OUTPUT_DIR/resources/" -f

echo ""
echo "✅ Decompilation complete!"
echo "  Sources: $OUTPUT_DIR/sources/"
echo "  Resources: $OUTPUT_DIR/resources/"
echo "  Log: $OUTPUT_DIR/jadx_output.log"
