#!/bin/bash
# Quick Security Scan - Rapid initial assessment
# Usage: ./quick-scan.sh [apk_directory]

set -e

APK_DIR="${1:-.}"
REPORT_FILE="initial-findings.md"

echo "=== Quick Security Scan ==="
echo "Scanning: $APK_DIR"
echo ""

# Check if decompiled directory exists
if [ ! -d "$APK_DIR/decompiled" ]; then
    echo "❌ Error: No decompiled/ directory found"
    echo "Run decompile.sh first!"
    exit 1
fi

echo "🔍 Scanning for security issues..."
echo ""

# Create report
cat > "$REPORT_FILE" << 'REPORT_START'
# Quick Security Scan Results

**Scan Date:** $(date +"%Y-%m-%d %H:%M:%S")
**Directory:** $APK_DIR

## Summary

REPORT_START

# AndroidManifest Analysis
echo "## AndroidManifest.xml Analysis" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

if [ -f "$APK_DIR/decompiled/resources/AndroidManifest.xml" ]; then
    echo "### Critical Settings" >> "$REPORT_FILE"
    echo "\`\`\`xml" >> "$REPORT_FILE"
    grep -E "usesCleartextTraffic|allowBackup|debuggable" "$APK_DIR/decompiled/resources/AndroidManifest.xml" || echo "No critical settings found"
    echo "\`\`\`" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    echo "### Exported Components" >> "$REPORT_FILE"
    grep -c "android:exported=\"true\"" "$APK_DIR/decompiled/resources/AndroidManifest.xml" | xargs echo "Count:"
fi

# Hardcoded Credentials
echo "## Potential Hardcoded Credentials" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "Searching for passwords, API keys, secrets..." >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
grep -r "password\|api.*key\|secret\|token" "$APK_DIR/decompiled/sources" --include="*.java" -i | head -20 >> "$REPORT_FILE" 2>/dev/null || echo "None found"
echo "\`\`\`" >> "$REPORT_FILE"

# Obfuscation Check
echo "## Code Obfuscation Assessment" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "Sample class names:" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
find "$APK_DIR/decompiled/sources" -name "*.java" | head -20 >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"

echo "✅ Quick scan complete! Results saved to: $REPORT_FILE"
