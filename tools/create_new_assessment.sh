#!/bin/bash

################################################################################
# create_new_assessment.sh
#
# Creates a new mobile application security assessment repository from this
# template repository, preserving guides and workflow documentation while
# removing example (ExampleApp) specific content.
#
# This script is designed to run FROM the template repository and create a
# new assessment repository as a sibling directory.
#
# Usage:
#   ./tools/create_new_assessment.sh [OPTIONS]
#
# Options:
#   -n, --name NAME          Application name (required)
#   -p, --platform PLATFORM  Platform: android or ios (required)
#   -v, --version VERSION    Application version (required)
#   -i, --package-id ID      Package/Bundle ID (required)
#   -a, --assessor NAME      Assessor name/team (required)
#   -d, --directory DIR      Target directory (default: ../{NAME}-assessment)
#   -g, --git                Initialize git repository (default: true)
#   --no-git                 Skip git initialization
#   -h, --help               Show this help message
#
# Example:
#   ./tools/create_new_assessment.sh \
#     --name "MyBankingApp" \
#     --platform android \
#     --version "2.1.0" \
#     --package-id "com.example.banking" \
#     --assessor "Dwayne Dreakford"
#
#   # This creates: ../mybankingapp-assessment/
#
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
INIT_GIT=true
TARGET_DIR=""
APP_NAME=""
PLATFORM=""
VERSION=""
PACKAGE_ID=""
ASSESSOR=""
ASSESSMENT_DATE=$(date +%Y-%m-%d)

# Get script directory and template root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

################################################################################
# Helper Functions
################################################################################

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

usage() {
    sed -n '2,29p' "$0" | sed 's/^# \?//'
    exit 0
}

# Uppercase first character (portable version for Bash 3.2+)
uppercase_first() {
    local str="$1"
    local first=$(echo "${str:0:1}" | tr '[:lower:]' '[:upper:]')
    local rest="${str:1}"
    echo "${first}${rest}"
}

################################################################################
# Parse Command Line Arguments
################################################################################

while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            APP_NAME="$2"
            shift 2
            ;;
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -i|--package-id)
            PACKAGE_ID="$2"
            shift 2
            ;;
        -a|--assessor)
            ASSESSOR="$2"
            shift 2
            ;;
        -d|--directory)
            TARGET_DIR="$2"
            shift 2
            ;;
        -g|--git)
            INIT_GIT=true
            shift
            ;;
        --no-git)
            INIT_GIT=false
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

################################################################################
# Validate Required Parameters
################################################################################

MISSING_PARAMS=false

if [[ -z "$APP_NAME" ]]; then
    print_error "Application name is required (--name)"
    MISSING_PARAMS=true
fi

if [[ -z "$PLATFORM" ]]; then
    print_error "Platform is required (--platform)"
    MISSING_PARAMS=true
elif [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" ]]; then
    print_error "Platform must be 'android' or 'ios'"
    MISSING_PARAMS=true
fi

if [[ -z "$VERSION" ]]; then
    print_error "Version is required (--version)"
    MISSING_PARAMS=true
fi

if [[ -z "$PACKAGE_ID" ]]; then
    print_error "Package/Bundle ID is required (--package-id)"
    MISSING_PARAMS=true
fi

if [[ -z "$ASSESSOR" ]]; then
    print_error "Assessor name/team is required (--assessor)"
    MISSING_PARAMS=true
fi

if [[ "$MISSING_PARAMS" = true ]]; then
    echo ""
    echo "Use --help for usage information"
    exit 1
fi

# Set default target directory if not specified
if [[ -z "$TARGET_DIR" ]]; then
    # Convert app name to lowercase and replace spaces with hyphens
    SAFE_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    TARGET_DIR="$TEMPLATE_ROOT/../${SAFE_NAME}-assessment"
fi

# Convert to absolute path
TARGET_DIR=$(cd "$(dirname "$TARGET_DIR")" 2>/dev/null && pwd)/$(basename "$TARGET_DIR") || TARGET_DIR="$TARGET_DIR"

################################################################################
# Display Configuration
################################################################################

print_header "Create New Assessment from Template"

print_info "Configuration:"
echo "  Application:     $APP_NAME"
echo "  Platform:        $PLATFORM"
echo "  Version:         $VERSION"
echo "  Package ID:      $PACKAGE_ID"
echo "  Assessor:        $ASSESSOR"
echo "  Template Dir:    $TEMPLATE_ROOT"
echo "  Target Dir:      $TARGET_DIR"
echo "  Initialize Git:  $INIT_GIT"
echo "  Assessment Date: $ASSESSMENT_DATE"
echo ""

# Confirm before proceeding
read -p "Continue with setup? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Setup cancelled"
    exit 0
fi

################################################################################
# Step 1: Copy Template Repository
################################################################################

print_header "Step 1: Copying Template Repository"

# Check if target directory already exists
if [[ -d "$TARGET_DIR" ]]; then
    print_error "Directory already exists: $TARGET_DIR"
    read -p "Remove existing directory and continue? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$TARGET_DIR"
        print_warning "Removed existing directory"
    else
        print_error "Setup cancelled"
        exit 1
    fi
fi

# Copy entire template directory
cp -r "$TEMPLATE_ROOT" "$TARGET_DIR"
print_success "Copied template to: $TARGET_DIR"

# Navigate to target directory
cd "$TARGET_DIR"

################################################################################
# Step 2: Clean Example Content
################################################################################

print_header "Step 2: Cleaning Example Content"

# Remove ExampleApp specific binaries and decompiled code
rm -rf apk/* ipa/* 2>/dev/null || true
print_success "Cleared apk/ and ipa/ directories"

rm -rf decompiled/* 2>/dev/null || true
print_success "Cleared decompiled/ directory"

# Remove examples directory (will be empty in new assessment)
rm -rf examples/ 2>/dev/null || true
print_success "Removed examples/ directory"

# Remove example assessment report from template (if directory exists)
if [ -d assessment-reports ]; then
    rm -f assessment-reports/SECURITY_ASSESSMENT_REPORT.md 2>/dev/null || true
    print_success "Cleared example assessment report"
else
    mkdir -p assessment-reports
    print_success "Created assessment-reports/ directory"
fi

# Clear assessment resources
rm -rf assessment-resources/* 2>/dev/null || true
print_success "Cleared assessment-resources/ directory"

# Clear output directory if exists
rm -rf output/* 2>/dev/null || true

# Create .gitkeep files to preserve directory structure
touch apk/.gitkeep 2>/dev/null || touch ipa/.gitkeep
touch decompiled/.gitkeep
touch assessment-reports/.gitkeep
touch assessment-resources/.gitkeep
print_success "Created .gitkeep files"

################################################################################
# Step 3: Update README.md
################################################################################

print_header "Step 3: Updating README.md"

# Create new README.md
cat > README.md << EOF
# $APP_NAME Security Assessment

**Application:** $APP_NAME
**Platform:** $(uppercase_first "$PLATFORM")
**Package/Bundle ID:** $PACKAGE_ID
**Version:** $VERSION
**Assessment Date:** $ASSESSMENT_DATE
**Assessed By:** $ASSESSOR

## Getting Started

**For New Assessors:**

This repository supports **three assessment approaches**:

1. **AI-Assisted Workflow** - Use Claude Code or similar AI assistants to accelerate analysis
2. **Manual Workflow** - Traditional command-line tools and manual code review
3. **Hybrid Workflow** - Combine AI assistance with manual verification (recommended)

**Before beginning your assessment, review:**

1. **[Assessment Workflow Guide](analysis-guides/ASSESSMENT_WORKFLOW.md)** - Complete step-by-step guide for conducting mobile application security assessments (6-10 hours)
   - Includes guidance for both AI-assisted and manual approaches
   - Shows where AI can help and where manual review is critical
2. **[CLAUDE.md](CLAUDE.md)** - AI assistant guidance, repository documentation, and lessons learned
   - Required reading if using AI-assisted workflow
   - Best practices for working with Claude Code

**The Assessment Workflow provides:**
- Pre-assessment checklist
- Phase-by-phase instructions (Setup → Reconnaissance → Vulnerability Hunting → MASVS Analysis → Documentation)
- AI assistance tips for each phase
- Manual analysis commands and techniques
- Time estimates for each phase
- Common issues and solutions

## Assessment Status

- [x] Repository setup
- [ ] Application decompilation (JADX + APKTool)
- [ ] Security analysis (OWASP MASVS-RESILIENCE focus)
- [ ] Findings documentation
- [ ] Report generation
- [ ] Presentation creation

**Workflow:** 🔀 Hybrid (recommended)

## Quick Links

- [Assessment Workflow Guide](analysis-guides/ASSESSMENT_WORKFLOW.md) - Step-by-step assessment guide (START HERE)
- [Security Assessment Report](assessment-reports/SECURITY_ASSESSMENT_REPORT.md) - Assessment findings (to be created)
- [Assessment Evidence](assessment-resources/) - Screenshots and artifacts
- [CLAUDE.md](CLAUDE.md) - Repository documentation for AI assistance

## Directory Structure

\`\`\`
$(basename "$TARGET_DIR")/
├── $(if [[ "$PLATFORM" == "android" ]]; then echo "apk/"; else echo "ipa/"; fi)                    # Application binary files
├── decompiled/            # Decompiled source code and resources
│   ├── sources/           # Decompiled source code
│   └── resources/         # Extracted resources
├── analysis-guides/       # OWASP MASVS analysis guides and templates
├── assessment-reports/    # Security assessment reports
├── assessment-resources/  # Screenshots, evidence, and analysis artifacts
└── tools/                 # Analysis automation scripts
\`\`\`

## Tools Used

- **Decompilation:** JADX / APKTool (Android) or class-dump / Hopper (iOS)
- **Analysis:** Claude Code, grep/ripgrep
- **Standards:** OWASP MASVS v2.0, CVSS v3.1, CWE

## Next Steps

1. **Place application binary:**
   \`\`\`bash
   # Copy your APK or IPA to the appropriate directory
   $(if [[ "$PLATFORM" == "android" ]]; then echo "cp ~/Downloads/app.apk apk/"; else echo "cp ~/Downloads/app.ipa ipa/"; fi)
   \`\`\`

2. **Decompile application:**
   \`\`\`bash
   $(if [[ "$PLATFORM" == "android" ]]; then echo "# For Android:
   jadx apk/*.apk -d decompiled/sources/
   apktool d apk/*.apk -o decompiled/resources/"; else echo "# For iOS:
   unzip ipa/*.ipa -d decompiled/extracted/
   class-dump decompiled/extracted/Payload/*.app/* > decompiled/headers.h"; fi)
   \`\`\`

3. **Follow the Assessment Workflow:**
   \`\`\`bash
   cat analysis-guides/ASSESSMENT_WORKFLOW.md
   \`\`\`

4. **Review enhanced MASVS guides for detailed analysis:**
   - [RESILIENCE-1: Root/Jailbreak Detection](analysis-guides/MASVS-RESILIENCE-1-enhanced.md)
   - [RESILIENCE-2: Code Obfuscation](analysis-guides/MASVS-RESILIENCE-2-enhanced.md)
   - [RESILIENCE-3: Anti-Debugging](analysis-guides/MASVS-RESILIENCE-3-enhanced.md)
   - [RESILIENCE-4: Tamper Detection](analysis-guides/MASVS-RESILIENCE-4-enhanced.md)

## Findings Summary

**Status:** Assessment in progress

**Overall Risk Score:** TBD/10

**OWASP MASVS-RESILIENCE Controls:**
- RESILIENCE-1 (Runtime Integrity): [TBD]
- RESILIENCE-2 (Code Obfuscation): [TBD]
- RESILIENCE-3 (Anti-Debugging): [TBD]
- RESILIENCE-4 (Tamper Detection): [TBD]

## References

- [OWASP MASVS v2.0](https://mas.owasp.org/MASVS/)
- [OWASP Mobile Security Testing Guide](https://mas.owasp.org/MASTG/)
- [CVSS v3.1 Calculator](https://www.first.org/cvss/calculator/3.1)
- [CWE Database](https://cwe.mitre.org/)

## Security Notice

This repository contains security assessment artifacts. Handle responsibly:
- Follow responsible disclosure timelines
- Sanitize reports before external sharing
- Use findings for defensive security only
- Respect authorization boundaries

---

**Repository Setup Date:** $ASSESSMENT_DATE
**Setup Tool:** create_new_assessment.sh
**Template Version:** 1.5
EOF

print_success "Created new README.md"

################################################################################
# Step 4: Update CLAUDE.md
################################################################################

print_header "Step 4: Updating CLAUDE.md"

# Validate template has required markers
TEMPLATE_CLAUDE="$TEMPLATE_ROOT/CLAUDE.md"

if ! grep -q "TEMPLATE_SHARED_CONTENT_START" "$TEMPLATE_CLAUDE" || \
   ! grep -q "TEMPLATE_SHARED_CONTENT_END" "$TEMPLATE_CLAUDE"; then
    print_error "Template CLAUDE.md missing required markers. Please update exemplar."
    exit 1
fi

# Create custom header for this assessment
cat > CLAUDE.md << 'EOF_MARKER'
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a security assessment repository for the **
EOF_MARKER

cat >> CLAUDE.md << EOF
${APP_NAME}** $(uppercase_first "$PLATFORM") application (version $VERSION, package: $PACKAGE_ID). The repository contains decompiled code, security findings, and assessment artifacts.

**This repository supports three assessment approaches:**

1. **🤖 AI-Assisted Workflow** - Use Claude Code to accelerate analysis (4-6 hours)
2. **🔧 Manual Workflow** - Traditional command-line tools and manual review (8-12 hours)
3. **🔀 Hybrid Workflow** - Combine AI assistance with manual verification (6-10 hours, recommended)

**Application:** $APP_NAME
**Version:** $VERSION
**Package:** $PACKAGE_ID
**Platform:** $(uppercase_first "$PLATFORM")
**Assessment Date:** $ASSESSMENT_DATE
**Assessed By:** $ASSESSOR
**Overall Risk Score:** TBD/10

EOF

# Extract shared content between markers using awk, then apply substitutions
awk '
    /<!-- TEMPLATE_SHARED_CONTENT_START -->/ { printing=1; next }
    /<!-- TEMPLATE_SHARED_CONTENT_END -->/ { printing=0; next }
    printing { print }
' "$TEMPLATE_CLAUDE" | \
    sed 's/mobile-security-framework/'"$(basename "$TARGET_DIR")"'/g' | \
    sed 's/ExampleApp/'"$APP_NAME"'/g' | \
    sed 's/com\.exampleapp\.exampleapp/'"$PACKAGE_ID"'/g' | \
    sed 's/10\.45\.0/'"$VERSION"'/g' | \
    sed 's/2025-11-13/'"$ASSESSMENT_DATE"'/g' >> CLAUDE.md

print_success "Updated CLAUDE.md with marker-based content extraction"

################################################################################
# Step 5: Initialize Git (Optional)
################################################################################

if [[ "$INIT_GIT" = true ]]; then
    print_header "Step 5: Initializing Git Repository"

    # Remove existing git if present
    rm -rf .git 2>/dev/null || true

    git init
    print_success "Initialized git repository"

    git add .
    print_success "Staged initial files"

    git commit -m "feat: Initial repository setup for $APP_NAME security assessment

Application: $APP_NAME
Platform: $(uppercase_first "$PLATFORM")
Version: $VERSION
Package ID: $PACKAGE_ID
Assessment Date: $ASSESSMENT_DATE
Assessed By: $ASSESSOR

Repository structure created with:
- Assessment guides (ASSESSMENT_WORKFLOW.md, MASVS-RESILIENCE-*.md)
- Template files and scripts
- Initial README and CLAUDE.md
- Clean directories ready for assessment

Setup automated using create_new_assessment.sh

Template Version: 1.5"

    print_success "Created initial commit"
fi

################################################################################
# Summary and Next Steps
################################################################################

print_header "Setup Complete!"

print_success "New assessment repository created: $TARGET_DIR"
echo ""

print_info "Repository Statistics:"
echo "  Directories: $(find . -type d | wc -l | tr -d ' ')"
echo "  Files:       $(find . -type f | wc -l | tr -d ' ')"
echo ""

print_info "What was preserved:"
echo "  ✅ analysis-guides/ASSESSMENT_WORKFLOW.md - Step-by-step workflow"
echo "  ✅ analysis-guides/MASVS-RESILIENCE-*.md - Enhanced MASVS guides"
echo "  ✅ analysis-guides/OWASP_MASVS_MAPPING.md - MASVS reference"
echo "  ✅ tools/ - Automation scripts"
echo ""

print_info "What was customized:"
echo "  📝 README.md - Updated with $APP_NAME details"
echo "  📝 CLAUDE.md - Updated with $APP_NAME details"
echo "  🗑️  apk/, ipa/, decompiled/ - Cleared (ready for your app)"
echo "  🗑️  assessment-reports/ - Cleared (ready for your findings)"
echo "  🗑️  assessment-resources/ - Cleared (ready for your evidence)"
echo "  🗑️  examples/ - Removed (empty directory)"
echo ""

print_header "Next Steps"

echo -e "${BLUE}1. Navigate to the new repository:${NC}"
echo -e "   ${GREEN}cd $TARGET_DIR${NC}"
echo ""

echo -e "${BLUE}2. Place your application binary:${NC}"
if [[ "$PLATFORM" == "android" ]]; then
    echo -e "   ${GREEN}cp ~/Downloads/$APP_NAME.apk apk/${NC}"
else
    echo -e "   ${GREEN}cp ~/Downloads/$APP_NAME.ipa ipa/${NC}"
fi
echo ""

echo -e "${BLUE}3. Decompile the application:${NC}"
if [[ "$PLATFORM" == "android" ]]; then
    echo -e "   ${GREEN}jadx apk/*.apk -d decompiled/sources/${NC}"
    echo -e "   ${GREEN}apktool d apk/*.apk -o decompiled/resources/${NC}"
else
    echo -e "   ${GREEN}unzip ipa/*.ipa -d decompiled/extracted/${NC}"
    echo -e "   ${GREEN}class-dump decompiled/extracted/Payload/*.app/* > decompiled/headers.h${NC}"
fi
echo ""

echo -e "${BLUE}4. Follow the Assessment Workflow:${NC}"
echo -e "   ${GREEN}cat analysis-guides/ASSESSMENT_WORKFLOW.md${NC}"
echo ""

echo -e "${BLUE}5. Use Claude Code for assistance:${NC}"
echo -e "   ${GREEN}# Review CLAUDE.md for AI prompts and guidance${NC}"
echo ""

print_success "Assessment repository ready for $APP_NAME v$VERSION"
echo ""

# Return to original directory
cd - > /dev/null || true
