#!/bin/bash
# Search for Hardcoded Credentials
# Usage: ./search-credentials.sh [directory]

DIR="${1:-decompiled/sources}"

echo "=== Searching for Hardcoded Credentials ==="
echo "Directory: $DIR"
echo ""

echo "🔍 Searching for passwords..."
grep -r "password\s*=\s*[\"']" "$DIR" --include="*.java" -n | head -10

echo ""
echo "🔍 Searching for API keys..."
grep -r "api.*key\s*=\s*[\"']" "$DIR" --include="*.java" -n -i | head -10

echo ""
echo "🔍 Searching for secrets..."
grep -r "secret\s*=\s*[\"']" "$DIR" --include="*.java" -n | head -10

echo ""
echo "🔍 Searching for tokens..."
grep -r "token\s*=\s*[\"']" "$DIR" --include="*.java" -n | head -10

echo ""
echo "✅ Search complete"
