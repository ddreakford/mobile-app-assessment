# Getting Started with Mobile Security Assessments

This **Mobile Security Assessment Exemplar** repository provides a comprehensive framework for conducting professional-grade security assessments of mobile applications (Android/iOS) following OWASP MASVS v2.0 standards.

**Estimated Time:**
- **Repository Setup:** 30-60 minutes (one-time)
- **First Assessment:** 6-10 hours

---

## ⚠️ Before You Begin

**Ensure you have these tools installed:**
- [ ] **JADX** v1.5.0+ - APK decompilation ([jadx.io](https://github.com/skylot/jadx))
- [ ] **APKTool** v2.12+ - Resource extraction ([apktool.org](https://apktool.org/))
- [ ] **Java JDK 11+** - Required for JADX/APKTool ([oracle.com](https://www.oracle.com/java/technologies/downloads/))
- [ ] **Git** - Version control ([git-scm.com](https://git-scm.com/))
- [ ] **Python 3.11+** (optional) - For automation scripts ([python.org](https://www.python.org/))

**Don't have these?** Continue to [Platform Setup](#-platform-setup) section below.

**Have everything?** Continue to [Quick Start](#-quick-start).

---

## 📖 How to Use This Guide

This guide covers both repository setup and conducting assessments:

- **First-time users:** Read sections 1-3 (Setup), then continue to section 4 (Your First Assessment)
- **Returning users:** Skip to [Your First Assessment](#-your-first-assessment-step-by-step)
- **Team leads:** Review [Repository Setup Options](#-repository-setup-options) and [Team Onboarding](#-team-onboarding)

---

## 🎯 What You'll Learn

By following this guide, you'll be able to:
- ✅ Set up your assessment environment with all required tools
- ✅ Decompile and analyze Android APK files
- ✅ Identify security vulnerabilities using OWASP MASVS v2.0
- ✅ Assess MASVS RESILIENCE controls (obfuscation, root detection, anti-debugging, tamper detection)
- ✅ Generate professional security reports with CVSS scoring
- ✅ Compare security posture across application versions
- ✅ Provide actionable remediation guidance

---

# Part 1: Repository Setup

## 📦 Repository Structure

```
mobile-security-framework/
├── GETTING_STARTED.md          # This file - setup and assessment guide
├── README.md                   # Repository overview and quick reference
├── CLAUDE.md                   # AI assistant guidance for assessments
├── CONTRIBUTING.md             # Team collaboration guidelines
├── LICENSE                     # Usage terms and conditions
│
├── analysis-guides/            # Assessment methodology and standards
│   ├── ASSESSMENT_WORKFLOW.md  # Step-by-step assessment process
│   ├── MASVS-RESILIENCE-1-enhanced.md  # Root detection guide
│   ├── MASVS-RESILIENCE-2-enhanced.md  # Code obfuscation guide
│   ├── MASVS-RESILIENCE-3-enhanced.md  # Anti-debugging guide
│   ├── MASVS-RESILIENCE-4-enhanced.md  # Tamper detection guide
│   ├── OWASP_MASVS_MAPPING.md  # MASVS v2.0 reference
│
├── templates/                  # Reusable templates for new assessments
│   ├── REPORT_TEMPLATE.md      # Security assessment report template
│   ├── COMPARATIVE_TEMPLATE.md # App version comparison template
│   ├── findings/               # Specific types of findings templates
│   │   ├── hardcoded-credentials.md
│   │   ├── no-code-obfuscation.md
│   │   ├── root-detection-weak.md
│   │   └── ...
│   └── masvs/                  # MASVS compliance templates
│       └── RESILIENCE_CONTROLS_MAPPING.md
│
├── tools/                      # Analysis automation and utility scripts
│   ├── quick-scan.sh           # Fast initial security scan
│   ├── decompile.sh            # Automated APK decompilation
│   ├── search-credentials.sh   # Hardcoded secret detection
│   ├── check-obfuscation.sh    # Obfuscation assessment
│   ├── generate-report.py      # Report generation automation
│   ├── create_security_presentation.py  # Presentation generation
│   └── README_PRESENTATION.md  # Presentation generation guide
│
├── examples/                   # Placeholder for future example assessments
│   └── README.md               # Example assessments catalog (currently empty)
│
└── docs/                       # Additional documentation
    ├── FAQ.md                  # Frequently asked questions
    └── TROUBLESHOOTING.md      # Common issues and solutions
```

---

## 🚀 Quick Start: Create Your First Assessment

**All workflows use the automated setup script for consistency:**

### Step 1: Clone the Repository

```bash
# Clone the assessment template repository
git clone [REPOSITORY_URL] assessment-template
cd assessment-template/mobile-security-framework
```

### Step 2: Install Required Tools

See [Platform Setup](#-platform-setup) section below for detailed instructions:
- **macOS:** `brew install jadx apktool openjdk@11 ripgrep git python@3.11`
- **Linux:** See Linux Setup section
- **Windows:** Use WSL2 (see Windows Setup section)

Verify installations:
```bash
jadx --version
apktool --version
java -version
```

### Step 3: Create New Assessment Using Script

Use the automated setup script to create a new assessment repository:

```bash
cd tools/
./create_new_assessment.sh \
  --name "MyApp" \
  --platform android \
  --version "1.0.0" \
  --package-id "com.example.myapp" \
  --assessor "Your Name"
```

This creates `../myapp-assessment/` with:
- ✅ All templates and analysis guides copied from exemplar
- ✅ Customized README.md and CLAUDE.md for your app
- ✅ Clean directory structure ready for APK/IPA
- ✅ Git repository initialized (optional, use `--no-git` to skip)

### Step 4: Start Your Assessment

```bash
# Navigate to your new assessment
cd ../myapp-assessment/

# Place your APK/IPA in the appropriate directory
cp ~/Downloads/MyApp.apk apk/

# Continue to "Your First Assessment" section below
```

---

## 📖 Alternative Workflows

### For Organizations: Fork and Customize

If your organization wants to customize the exemplar:

```bash
# 1. Fork the repository to your organization's GitHub/GitLab

# 2. Clone your organizational fork
git clone [YOUR_ORG_REPOSITORY_URL] assessment-template
cd assessment-template/mobile-security-framework

# 3. Customize templates and guides
# - Modify templates/ to match your reporting standards
# - Update analysis-guides/ with organization-specific requirements
# - Add custom tools to tools/

# 4. Commit customizations
git add .
git commit -m "Customize exemplar for [YOUR_ORG]"
git push origin main

# 5. Team members use the script to create assessments
cd tools/
./create_new_assessment.sh --name "AppName" --platform android ...
```

### For Learning: Explore Templates and Guides

If you want to learn about the assessment framework:

```bash
# Clone the repository
git clone [REPOSITORY_URL] assessment-template
cd assessment-template/mobile-security-framework

# Explore the exemplar templates and guides
ls -la analysis-guides/
ls -la templates/

# Practice on a sample app downloaded from APKPure or APKMirror
# Follow the workflow in GETTING_STARTED.md to conduct your first assessment
```

---

## 🔧 Platform Setup

### macOS Setup

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install all required tools
brew install jadx apktool openjdk@11 ripgrep git python@3.11

# Link Java (if needed)
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# Verify installations
jadx --version        # Should show v1.5.0+
apktool --version     # Should show v2.12.0+
java -version         # Should show 11+
rg --version          # Should show latest
python3 --version     # Should show 3.11+
```

---

### Linux Setup (Ubuntu/Debian)

```bash
# Update package lists
sudo apt-get update

# Install base tools
sudo apt-get install -y openjdk-11-jdk git ripgrep python3 python3-pip unzip wget

# Install JADX
cd /tmp
wget https://github.com/skylot/jadx/releases/latest/download/jadx-1.5.0.zip
unzip jadx-1.5.0.zip -d jadx
sudo mv jadx /opt/
sudo ln -s /opt/jadx/bin/jadx /usr/local/bin/jadx

# Install APKTool
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.12.1.jar
sudo mv apktool /usr/local/bin/
sudo mv apktool_2.12.1.jar /usr/local/bin/apktool.jar
sudo chmod +x /usr/local/bin/apktool

# Verify installations
jadx --version
apktool --version
java -version
rg --version
```

---

### Windows Setup (WSL2 Recommended)

```powershell
# Install WSL2 with Ubuntu
wsl --install -d Ubuntu

# Open Ubuntu terminal and follow Linux setup instructions above

# Alternatively, use Windows-native tools:
# 1. Install Java JDK 11: https://adoptium.net/
# 2. Download JADX: https://github.com/skylot/jadx/releases
# 3. Download APKTool: https://ibotpeaches.github.io/Apktool/
# 4. Install Git: https://git-scm.com/download/win
# 5. Install ripgrep: https://github.com/BurntSushi/ripgrep/releases
```

---

## ⚙️ Additional Configuration

### Configure Scripts and Python Environment

```bash
# Navigate to repository
cd mobile-security-assessments

# Make all scripts executable
chmod +x tools/*.sh 2>/dev/null || true
chmod +x tools/*.py 2>/dev/null || true

# Set up Python virtual environment (for reporting tools)
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install Python dependencies (if requirements.txt exists)
if [ -f tools/requirements.txt ]; then
    pip install -r tools/requirements.txt
fi
```

---

### Git Configuration (Optional)

If you're using version control for your assessments:

```bash
# Configure git user (if not already set)
git config user.name "Your Name"
git config user.email "your.email@company.com"

# The repository includes a comprehensive .gitignore that excludes:
# - Large binary files (*.apk, *.ipa, *.dex, *.so)
# - Decompiled source code (assessments/*/decompiled/)
# - Sensitive data (*credentials*.txt, *secrets*.txt)
# - Build artifacts (*.class, *.jar, *.pyc)

# Add organization-specific exclusions if needed
echo "internal-tools/" >> .gitignore
echo "*-CONFIDENTIAL.md" >> .gitignore
```

---

### Environment Variables (Optional)

Create a `.env` file for tool configuration:

```bash
# Create .env file (do NOT commit to git - already in .gitignore)
cat > .env << 'EOF'
JADX_OPTS="-j 8"  # Number of threads for decompilation
APKTOOL_OPTS="--frame-path /tmp/apktool"
REPORT_AUTHOR="Security Team"
REPORT_COMPANY="Your Company Name"
EOF

# Load environment variables
source .env  # Or add to ~/.bashrc or ~/.zshrc
```

---

## ✅ Setup Verification Checklist

Before proceeding to your first assessment, verify your setup:

### Tools Installation
- [ ] JADX installed and accessible (`jadx --version`)
- [ ] APKTool installed and accessible (`apktool --version`)
- [ ] Java JDK 11+ installed (`java -version`)
- [ ] ripgrep installed (`rg --version`)
- [ ] Git installed (`git --version`)
- [ ] Python 3.11+ installed (optional, for reporting: `python3 --version`)

### Repository Structure
- [ ] `analysis-guides/` contains MASVS guides
- [ ] `templates/` contains report templates
- [ ] `tools/` contains automation scripts
- [ ] `examples/` directory present with README.md

### Configuration
- [ ] Scripts are executable (`ls -l tools/*.sh`)
- [ ] Python environment set up (optional)
- [ ] Git configured (if using version control)

### Test Your Setup

```bash
# Test that tools work
jadx --version
apktool --version

# Verify exemplar repository structure
ls -la analysis-guides/
ls -la templates/
ls -la tools/
```

**✅ If all checks pass, you're ready to conduct assessments!**

---

## 🎓 Team Onboarding

### For New Team Members

1. **Read Documentation (2 hours)**<br>→ Complete this GETTING_STARTED guide through Part 1 (Setup)<br>→ Review `analysis-guides/ASSESSMENT_WORKFLOW.md`<br>→ Study the templates and guides in this repository

2. **Set Up Environment (30 minutes)**<br>→ Follow platform setup instructions above<br>→ Verify all tools are installed<br>→ Complete setup verification checklist

3. **Complete Training Assessment (4-6 hours)**<br>→ Use a sample APK as training target (download from APKPure/APKMirror)<br>→ Follow Part 2 of this guide (Your First Assessment)<br>→ Compare your results with the report templates in `templates/`

4. **Peer Review (1 hour)**<br>→ Have experienced team member review your training assessment<br>→ Discuss findings and scoring methodology<br>→ Review report quality and completeness

5. **First Production Assessment (8-12 hours)**<br>→ Conduct real assessment under supervision<br>→ Document lessons learned<br>→ Add to `docs/LESSONS_LEARNED.md`

### For Team Leads

**Repository Governance:**
- Set up branch protection for `analysis-guides/`, `templates/`, `tools/`
- Allow direct commits for `assessments/` (individual work)
- Require peer review for template and guide changes

**Quality Standards:**
- Define minimum report requirements
- Establish peer review process
- Set CVSS scoring guidelines
- Create approval workflow

**Continuous Improvement:**
- Schedule monthly retrospectives
- Update `docs/LESSONS_LEARNED.md` after each assessment
- Refine templates based on feedback
- Share notable findings with team

---

## 🔄 Maintenance and Updates

### Weekly Maintenance

```bash
# Update tools to latest versions
brew upgrade jadx apktool  # macOS
# or: sudo apt-get update && sudo apt-get upgrade jadx apktool  # Linux

# Pull latest repository changes (if using centralized repo)
git pull origin main

# Update Python dependencies
source venv/bin/activate
pip install -U -r tools/requirements.txt
```

### Monthly Reviews

- Review and update `docs/LESSONS_LEARNED.md`
- Audit `templates/` for relevance and accuracy
- Update `analysis-guides/` with new techniques
- Check for OWASP MASVS updates

### Quarterly Updates

- Conduct tool evaluation (any new decompilers, scanners?)
- Review CVSS scoring guidelines for consistency
- Update example assessments with recent findings
- Organize training sessions for new techniques

---

## 🛠️ Advanced Configuration (Optional)

### Docker Setup (Isolated Environment)

```dockerfile
# Dockerfile
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    git \
    ripgrep \
    python3 \
    python3-pip \
    unzip \
    wget

# Install JADX
RUN cd /tmp && \
    wget https://github.com/skylot/jadx/releases/latest/download/jadx-1.5.0.zip && \
    unzip jadx-1.5.0.zip -d jadx && \
    mv jadx /opt/ && \
    ln -s /opt/jadx/bin/jadx /usr/local/bin/jadx

# Install APKTool
RUN wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && \
    wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.12.1.jar && \
    mv apktool /usr/local/bin/ && \
    mv apktool_2.12.1.jar /usr/local/bin/apktool.jar && \
    chmod +x /usr/local/bin/apktool

# Copy repository
COPY . /workspace
WORKDIR /workspace

# Set up Python environment
RUN pip3 install -r tools/requirements.txt 2>/dev/null || true

CMD ["/bin/bash"]
```

Build and run:
```bash
docker build -t mobile-security-assessments .
docker run -it -v $(pwd)/assessments:/workspace/assessments mobile-security-assessments
```

---

### Multi-User Setup (Shared Server)

```bash
# Create shared repository location
sudo mkdir -p /opt/mobile-security-assessments
sudo chown -R security-team:security-team /opt/mobile-security-assessments
cd /opt/mobile-security-assessments

# Clone repository
git clone [REPOSITORY_URL] .

# Create per-user assessment directories
mkdir -p assessments/{user1,user2,user3}
chmod 755 assessments/*

# Set up shared tools
sudo ln -s /opt/mobile-security-assessments/tools/* /usr/local/bin/

# Configure permissions
# - analysis-guides/: read-only for all
# - templates/: read-only for all
# - tools/: execute permissions for all
# - assessments/: write permissions for owners only
```

---

### CI/CD Integration

```yaml
# Example GitHub Actions workflow
# .github/workflows/security-assessment.yml
name: Automated Security Scan

on:
  push:
    paths:
      - 'assessments/**/apk/*.apk'

jobs:
  quick-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install tools
        run: |
          sudo apt-get install -y openjdk-11-jdk
          wget https://github.com/skylot/jadx/releases/latest/download/jadx-1.5.0.zip
          unzip jadx-1.5.0.zip -d jadx
          sudo mv jadx /opt/

      - name: Decompile APK
        run: |
          ./tools/decompile.sh assessments/*/apk/*.apk

      - name: Run quick scan
        run: |
          ./tools/quick-scan.sh

      - name: Upload results
        uses: actions/upload-artifact@v3
        with:
          name: quick-scan-results
          path: assessments/*/initial-findings.md
```

---

# Part 2: Your First Assessment

## 📋 Prerequisites

### Required Knowledge

**Minimum (for guided AI-assisted assessments):**
- Basic understanding of mobile app architecture
- Familiarity with command-line tools (bash, grep, find)
- Ability to read Java/Kotlin code (basic level)

**Recommended (for manual assessments):**
- Mobile app development experience (Android/iOS)
- Security testing fundamentals
- Understanding of OWASP Top 10 Mobile Risks
- Experience with static analysis tools

### Optional Tools

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **MobSF** | Automated SAST scanning | Initial triage, finding generation |
| **Frida** | Dynamic instrumentation | Runtime analysis, bypass testing |
| **Burp Suite** | Network traffic analysis | API security, certificate pinning |
| **Ghidra/IDA** | Native code analysis | Advanced reverse engineering |
| **ADB** | Android device debugging | Dynamic testing on real devices |

---

## 📖 Choose Your Assessment Approach

Based on your experience level and time constraints, choose one of three approaches:

### 🤖 Approach 1: AI-Assisted (Recommended for Beginners)
**Time:** 4-6 hours | **Skill Level:** Beginner | **AI Tool:** Required

**When to use:**
- First-time security assessor
- Large codebase (10,000+ classes)
- Time-constrained (need results quickly)
- Learning the assessment process

**How to proceed:**<br>1. Read: `analysis-guides/ASSESSMENT_WORKFLOW.md` → Section "AI-Assisted Workflow"<br>2. Use: Claude Code with prompts from `CLAUDE.md`<br>3. Follow: Step-by-step AI prompts for each phase

**Advantages:** Fast, guided, learning-focused  
**Limitations:** May miss nuanced findings, requires validation

---

### 🔧 Approach 2: Manual (Recommended for Learning)
**Time:** 8-12 hours | **Skill Level:** Intermediate | **AI Tool:** Not required

**When to use:**
- Want to deeply understand assessment methodology
- High-assurance requirements (financial, healthcare apps)
- Small to medium codebase (<5,000 classes)
- Building expertise in mobile security

**How to proceed:**<br>1. Read: `analysis-guides/ASSESSMENT_WORKFLOW.md` → Section "Manual Workflow"<br>2. Use: Command-line tools (grep, find, manual code review)<br>3. Follow: Enhanced MASVS guides for detailed analysis

**Advantages:** Deep understanding, high confidence in findings<br>
**Limitations:** Time-intensive, requires strong technical skills<br>

---

### 🔀 Approach 3: Hybrid (Recommended for Production)
**Time:** 6-10 hours | **Skill Level:** Intermediate | **AI Tool:** Optional

**When to use:**
- Production security assessments
- Need balance between speed and accuracy
- Medium to large codebase (5,000-15,000 classes)
- Experienced but want efficiency gains

**How to proceed:**<br>1. Use AI for initial discovery and pattern matching<br>2. Manually validate all findings<br>3. Deep dive into critical areas with enhanced MASVS guides

**Advantages:** Best balance of speed, accuracy, and learning<br>
**Limitations:** Requires judgment on when to use AI vs. manual<br>

---

## 🎓 Your First Assessment (Step-by-Step)

### Phase 1: Setup & Decompilation (30-60 min)

**Goals:**<br>→ Decompile APK to Java source code<br>→ Extract AndroidManifest.xml and resources<br>→ Document application metadata

**Steps:**

1. **Obtain Target Application**

**Option A: Download from App Store**
```bash
# Android - Use APKPure, APKMirror, or similar
# Download your target APK to apk/ directory
# Example: apk/MyApp_1.0.0.apk
```

**Option B: Extract from Device**
```bash
# Android - Extract installed APK
adb shell pm list packages | grep myapp
adb shell pm path com.example.myapp
adb pull /data/app/com.example.myapp-xxx/base.apk apk/MyApp_1.0.0.apk
```

**Option C: Use Sample APK for Learning**
```bash
# Download a sample APK for learning (e.g., from APKPure, APKMirror)
# Practice with any publicly available app to learn the assessment process
```

2. **Create Assessment Workspace**

**If you haven't already created an assessment using the script, do so now:**

```bash
cd mobile-security-framework/tools/
./create_new_assessment.sh \
  --name "MyApp" \
  --platform android \
  --version "1.0.0" \
  --package-id "com.example.myapp" \
  --assessor "Your Name"

# Navigate to your new assessment
cd ../../myapp-assessment/
```

**If you already created the assessment directory, navigate to it:**

```bash
cd myapp-assessment/  # or wherever you created it
```

The script automatically creates:
- Directory structure (apk/, decompiled/, assessment-reports/, etc.)
- Customized README.md and CLAUDE.md with your app details
- All templates and analysis guides
- Application metadata is embedded in README.md

3. **Decompile Application**

```bash
# Decompile with JADX (Dex → Java)
jadx apk/MyApp_1.0.0.apk -d decompiled/sources/

# Extract resources with APKTool
apktool d apk/MyApp_1.0.0.apk -o decompiled/resources/

# Verify decompilation
ls decompiled/sources/sources/
ls decompiled/resources/
```

**Expected Output:**
```
decompiled/
├── sources/
│   ├── sources/          # Java source code
│   │   ├── com/
│   │   ├── androidx/
│   │   └── ...
│   └── resources/        # Resources from DEX
└── resources/
    ├── AndroidManifest.xml
    ├── res/
    ├── smali/
    └── assets/
```

4. **Document Decompilation Results**

```bash
# Check decompilation success rate
echo "=== Decompilation Statistics ===" > decompilation-stats.txt
echo "APK Size: $(du -h apk/*.apk | cut -f1)" >> decompilation-stats.txt
echo "Total Classes: $(find decompiled/sources -name \"*.java\" | wc -l)" >> decompilation-stats.txt
echo "Decompilation Errors: $(grep -c \"ERROR\" decompiled/jadx_output.log 2>/dev/null || echo \"0\")" >> decompilation-stats.txt
cat decompilation-stats.txt
```

**✅ Checkpoint:** You should have decompiled sources, resources, and metadata documented.

---

### Phase 2: Initial Reconnaissance (30-60 min)

**Goals:**<br>→ Analyze AndroidManifest.xml for security issues<br>→ Identify application packages and structure<br>→ Discover configuration files

**Quick Security Checks:**

```bash
# 1. Check AndroidManifest.xml for critical issues
cat decompiled/resources/AndroidManifest.xml | grep -E "usesCleartextTraffic|allowBackup|debuggable" -A 1 -B 1

# 2. Find exposed API keys in manifest
cat decompiled/resources/AndroidManifest.xml | grep -E "api.*key|secret|token" -i -B 2 -A 2

# 3. Identify exported components (potential attack surface)
cat decompiled/resources/AndroidManifest.xml | grep "android:exported=\"true\"" -B 5

# 4. List application packages
find decompiled/sources/sources -maxdepth 3 -type d | grep -E "com\.|org\." | head -20

# 5. Find configuration files
find decompiled/sources -name "*Config*.java" -o -name "*Constants*.java" | head -20
```

**Document Findings:**
Create `assessment-reports/initial-findings.md` with your observations.

**✅ Checkpoint:** You should have a list of potential security issues and understanding of app structure.

---

### Phase 3: Vulnerability Hunting (2-4 hours)

**Goals:**<br>→ Search for hardcoded credentials, API keys, secrets<br>→ Identify insecure cryptography<br>→ Find sensitive data storage issues

**AI-Assisted Approach:**

Use Claude Code with this prompt:
```
I'm assessing [AppName] for security vulnerabilities. Please search the decompiled code in
decompiled/sources/sources/ for:

1. Hardcoded credentials (passwords, API keys, secrets, tokens)
2. Hardcoded URLs and API endpoints
3. Insecure cryptography usage (weak algorithms, hardcoded keys)
4. Sensitive data in logs

For each finding, provide:
- File path and line number
- Code snippet
- Severity assessment (CRITICAL/HIGH/MEDIUM/LOW)
- Brief description of the risk

Focus on application packages (com.example.*) not third-party libraries.
```

**Manual Approach:**

```bash
# 1. Search for hardcoded credentials
grep -r "password\s*=\s*[\"']" decompiled/sources/sources/ --include="*.java" -n | head -20
grep -r "api.*key\s*=\s*[\"']" decompiled/sources/sources/ --include="*.java" -n -i | head -20
grep -r "secret\s*=\s*[\"']" decompiled/sources/sources/ --include="*.java" -n | head -20

# 2. Find API endpoints
grep -r "https\?://" decompiled/sources/sources/ --include="*.java" -n | grep -v "^\s*//" | head -20

# 3. Check for weak cryptography
grep -r "DES\|MD5\|SHA1" decompiled/sources/sources/ --include="*.java" -n | head -20

# 4. Find logging of sensitive data
grep -r "Log\.\(d\|i\|v\)" decompiled/sources/sources/ --include="*.java" -n | grep -i "password\|token\|secret" | head -20
```

**✅ Checkpoint:** You should have a list of vulnerabilities with file locations and severity assessments.

---

### Phase 4: OWASP MASVS-RESILIENCE Analysis (2-3 hours)

This is the **core assessment** phase. You'll evaluate 4 critical security controls.<br>

For each control:<br>
  1. Perform the Quick check
  2. Perform the Deep Dive analysis, as recommended by the enhanced guide for the control (`analysis-guides/MASVS-RESILIENCE-*-enhanced.md`) for the control.

#### RESILIENCE-1: Root Detection

**Goal:** Determine if app detects rooted/jailbroken devices and how it responds

```bash
# Quick check
grep -r "root\|isRooted\|jailbreak\|SafetyNet" decompiled/sources/sources/ --include="*.java" -i -l | head -10

# AI-assisted prompt (recommended):
# "Analyze root detection in this application. Search for root detection methods and
# determine if detection is enforced (app blocks functionality) or just telemetry."
```

**Scoring:**<br>→ 0-2/10: No detection<br>→ 3-4/10: Detection without enforcement (telemetry only)<br>→ 5-7/10: Basic enforcement (blocks some features)<br>→ 8-10/10: Multi-layered detection with strong enforcement

**📖 Deep Dive:** See `analysis-guides/MASVS-RESILIENCE-1-enhanced.md`

---

#### RESILIENCE-2: Code Obfuscation

**Goal:** Assess whether code is obfuscated to impede reverse engineering

```bash
# Quick check - Sample class names
find decompiled/sources/sources/com/example -name "*.java" | head -20

# If you see readable names like:
# - MainActivity.java
# - LoginActivity.java
# - UserProfile.java
# → Score: 0/10 (No obfuscation)

# If you see obfuscated names like:
# - a.java
# - C0135.java
# - z.java
# → Score: 6-8/10 (R8/ProGuard obfuscation)
```

**Scoring:**<br>→ 0/10: All classes have readable names<br>→ 3-5/10: Partial obfuscation (some packages excluded)<br>→ 6-8/10: R8/ProGuard with good coverage<br>→ 9-10/10: Commercial obfuscation (DexGuard) + string encryption

**📖 Deep Dive:** See `analysis-guides/MASVS-RESILIENCE-2-enhanced.md`

---

#### RESILIENCE-3: Anti-Debugging

**Goal:** Determine if app detects and responds to debuggers

```bash
# Quick check
grep -r "isDebuggerConnected\|Debug\.isDebugger\|TracerPid" decompiled/sources/sources/ --include="*.java" -i -l

# AI-assisted prompt:
# "Search for anti-debugging mechanisms. Look for debugger detection, timing checks,
# or Frida/Xposed detection."
```

**Scoring:**<br>→ 0/10: No debugger detection<br>→ 3-4/10: Basic VMDebug check (easily bypassable)<br>→ 5-7/10: Multi-layer detection (VMDebug + TracerPid)<br>→ 8-10/10: Native anti-debug + Frida detection + continuous monitoring

**📖 Deep Dive:** See `analysis-guides/MASVS-RESILIENCE-3-enhanced.md`

---

#### RESILIENCE-4: Tamper Detection

**Goal:** Assess integrity checking and repackaging protection

```bash
# Quick check
grep -r "signature\|getPackageInfo.*SIGNATURE\|Play.*Integrity" decompiled/sources/sources/ --include="*.java" -i -l

# AI-assisted prompt:
# "Analyze tamper detection. Search for signature verification, DEX integrity checks,
# or Play Integrity API usage."
```

**Scoring:**<br>→ 0/10: No integrity checks<br>→ 3-4/10: Basic signature verification (easily bypassable)<br>→ 5-7/10: Play Integrity API or multi-layer checks<br>→ 8-10/10: Native integrity + Play Integrity + runtime verification

**📖 Deep Dive:** See `analysis-guides/MASVS-RESILIENCE-4-enhanced.md`

---

**✅ Checkpoint:** You should have scored all 4 RESILIENCE controls with evidence and justification.

---

### Phase 5: Documentation (2-4 hours)

**Goal:** Create professional security assessment deliverables

**Deliverables to Create:**<br>1. **Security Assessment Report** - Comprehensive findings with CVSS, MASVS mapping, remediation<br>2. **MASVS-RESILIENCE Controls Mapping** - Detailed guard-level breakdown table<br>3. **Email Summary** - Executive summary for stakeholder outreach

#### Step 5.1: Create Security Assessment Report

**Option 1: Use AI to Generate Report** (Recommended)

```
Based on my security assessment of [AppName], please create a comprehensive
SECURITY_ASSESSMENT_REPORT.md using the template in templates/REPORT_TEMPLATE.md.

Include all findings I've provided with:
- CVSS v3.1 scores and vector strings
- OWASP MASVS v2.0 mappings
- CWE identifiers
- 3-phase remediation (Emergency/Short-term/Long-term) with DESCRIPTIONS, not code examples
- RESILIENCE controls scoring (with justification)

IMPORTANT: For remediation sections, provide clear DESCRIPTIONS of what needs to be done,
NOT detailed code examples. Keep the report concise and actionable. Code examples will be
provided as a separate implementation support service.
```

**Option 2: Manual Report Writing**

1. Copy report template:
```bash
cp templates/REPORT_TEMPLATE.md assessment-reports/SECURITY_ASSESSMENT_REPORT.md
```

2. Fill in sections systematically:<br>   → Executive Summary<br>   → Assessment Methodology<br>   → Critical/High/Medium/Low Findings<br>   → MASVS Coverage Analysis<br>   → Remediation Roadmap

3. Use finding templates from `templates/findings/`

#### Step 5.2: Create MASVS-RESILIENCE Controls Mapping

The Controls Mapping table provides a detailed breakdown of each security guard within the RESILIENCE categories. This is valuable for communicating specific gaps to development teams.

**🤖 AI-Assisted Approach:**
```
Based on my MASVS-RESILIENCE analysis, create an OWASP_MASVS-RESILIENCE_Controls_Mapping.md file
using the template from templates/masvs/RESILIENCE_CONTROLS_MAPPING.md.

My findings:
- RESILIENCE-1: [Your root detection findings]
- RESILIENCE-2: [Your tamper detection findings]
- RESILIENCE-3: [Your obfuscation findings with class count]
- RESILIENCE-4: [Your anti-debugging findings]

Use brief "Current State" descriptions like "Not present" or "Detection present but no enforcement".
Mark platform-specific guards as N/A where appropriate.
```

**🔧 Manual Approach:**
```bash
cp templates/masvs/RESILIENCE_CONTROLS_MAPPING.md assessment-reports/OWASP_MASVS-RESILIENCE_Controls_Mapping.md
# Edit the file and fill in Current State for each guard
```

**✅ Checkpoint:** You should have a complete, professional security assessment report and controls mapping table.

---

## 📚 Next Steps

### After Your First Assessment

1. **Review Your Work**<br>→ Compare your report with templates in `templates/`<br>→ Verify all findings have proper MASVS mappings<br>→ Check that evidence is well-documented with file:line references<br>→ Ensure remediation recommendations are clear and actionable

2. **Perform Comparative Analysis** (Track Remediation Progress)

   After remediation efforts, assess improvements by comparing versions:

   **When to use:**<br>   → After development team fixes security issues<br>   → After major app updates<br>   → To validate remediation effectiveness<br>   → To track security posture over time

   **Process:**<br>   1. Conduct full assessment of new version (follow Phases 1-5 above)<br>   2. Use `templates/COMPARATIVE_TEMPLATE.md` as your report template<br>   3. Compare findings side-by-side with original assessment<br>   4. Score remediation effectiveness (Excellent/Good/Partial/Failed)<br>   5. Identify new issues introduced<br>   6. Calculate overall security improvement percentage

   **Time Estimate:** 8-12 hours (full assessment + comparison analysis)

   **See Section:** [Comparative Analysis Guide](#-comparative-analysis-tracking-remediation-progress) for detailed instructions

3. **Deep Dive into MASVS**<br>→ Read all 4 enhanced RESILIENCE guides<br>→ Study the scoring rubrics and examples<br>→ Learn advanced detection techniques

4. **Practice on More Apps**<br>→ Start with simple apps (fewer classes, clearer code)<br>→ Progress to complex apps (obfuscated, large codebases)<br>→ Try both AI-assisted and manual approaches

### Continuous Learning

| Resource | Type | Purpose |
|----------|------|---------|
| `analysis-guides/ASSESSMENT_WORKFLOW.md` | Guide | Master assessment workflow |
| `analysis-guides/MASVS-RESILIENCE-*.md` | Reference | Deep dive into each control |
| `docs/FAQ.md` | Knowledge Base | Frequently asked questions |
| `docs/TROUBLESHOOTING.md` | Knowledge Base | Common issues and solutions |
| [OWASP MASTG](https://mas.owasp.org/MASTG/) | External | Official testing guide |
| [OWASP MASVS](https://mas.owasp.org/MASVS/) | External | Security standards |

---

## 🆘 Troubleshooting

### Common Issues

#### Issue: "JADX decompilation failed with errors"

**Solution:**
```bash
# Check error percentage
grep "ERROR" decompiled/jadx_output.log | wc -l

# If errors < 1% of total classes, proceed (acceptable)
# If errors > 5%, try alternative tools:
jadx --deobf apk/MyApp.apk -d decompiled/sources/  # Enable deobfuscation
# Or use JD-GUI, CFR, Procyon as alternatives
```

#### Issue: "Too many grep results, can't find real issues"

**Solution:**
```bash
# Use more specific patterns
grep -r "private.*String.*password\s*=" decompiled/sources --include="*.java" -n

# Exclude third-party libraries
grep -r "api.*key" decompiled/sources/sources/com/myapp --include="*.java" -n

# Use ripgrep for better performance
rg "password\s*=\s*\"" decompiled/sources/sources/ -t java
```

#### Issue: "Can't determine if root detection is enforced"

**Solution:**<br>1. Find the detection method: `grep -r "isRooted" -A 10`<br>2. Search for where it's called: `grep -r "isRooted()" -B 5 -A 10`<br>3. Look for enforcement keywords: `finish()`, `System.exit()`, `killProcess()`, `throw`<br>4. If only logging/analytics → Telemetry-only (score: 2-3/10)<br>5. If app terminates/blocks → Enforced (score: 5-7/10)

**See**: `docs/TROUBLESHOOTING.md` for more solutions

---

## 📊 Comparative Analysis: Tracking Remediation Progress

### Overview

After delivering a security assessment, the development team will implement fixes. **Comparative analysis** validates that remediation was effective and tracks security improvements over time.

**Purpose:**<br>→ ✅ Verify that identified vulnerabilities were actually fixed<br>→ ✅ Assess quality of remediation (root cause vs. surface fix)<br>→ ✅ Identify any new vulnerabilities introduced<br>→ ✅ Quantify security improvement (risk reduction %)<br>→ ✅ Guide prioritization for remaining work

### When to Perform Comparative Analysis

| Scenario | Timing | Recommended Approach |
|----------|--------|----------------------|
| **After Critical Fixes** | 1-2 weeks after deployment | Focus on critical findings only (quick comparison) |
| **After Major Release** | Next version with security fixes | Full comparative assessment |
| **Quarterly Security Review** | Every 3-6 months | Track security posture trends |
| **Before Production Release** | Pre-release validation | Verify all fixes implemented |

### Comparative Analysis Workflow

#### Phase 1: Assess New Version (6-10 hours)

Conduct a full security assessment of the updated version following the standard workflow:

1. **Decompile new version**
   ```bash
   cd assessments/myapp-v2-assessment
   jadx apk/MyApp_v2.0.0.apk -d decompiled/sources/
   apktool d apk/MyApp_v2.0.0.apk -o decompiled/resources/
   ```

2. **Perform full assessment** (Phases 1-5 from main workflow)<br>   → Don't skip any phases - new issues may have been introduced<br>   → Use same methodology as original assessment for consistency

3. **Document new version findings**<br>   → Create `assessment-reports/SECURITY_ASSESSMENT_REPORT_v2.md`<br>   → Score all MASVS controls independently

#### Phase 2: Create Comparative Report (2-4 hours)

1. **Copy comparative template**
   ```bash
   cp templates/COMPARATIVE_TEMPLATE.md assessment-reports/COMPARATIVE_ANALYSIS.md
   ```

2. **Fill in metadata**<br>   → Version numbers, dates, build info<br>   → Link to original assessment report

3. **Track each original finding**

   For each finding from the original assessment, determine status:

   | Status | Criteria | Score |
   |--------|----------|-------|
   | 🟢 **RESOLVED** | Issue completely fixed, root cause addressed | 9-10/10 |
   | 🟢 **GOOD FIX** | Issue fixed with minor gaps | 7-8/10 |
   | 🟡 **PARTIAL** | Some improvement but issue still exploitable | 4-6/10 |
   | 🟡 **SURFACE FIX** | Symptom addressed but root cause remains | 3-4/10 |
   | 🔴 **UNCHANGED** | No remediation attempted | 0/10 |
   | 🔴 **REGRESSION** | Fix introduced new vulnerabilities | -1/10 |

4. **Compare MASVS-RESILIENCE scores**

   Create side-by-side comparison:
   ```markdown
   | Control | v1 Score | v2 Score | Improvement | Status |
   |---------|----------|----------|-------------|--------|
   | RESILIENCE-1 | 2/10 | 3/10 | +1 | 🟡 PARTIAL |
   | RESILIENCE-2 | 0/10 | 6/10 | +6 | 🟢 PASS |
   | RESILIENCE-3 | 0/10 | 4/10 | +4 | 🟡 PARTIAL |
   | RESILIENCE-4 | 0/10 | 7/10 | +7 | 🟢 PASS |
   ```

5. **Calculate overall security improvement**
   ```
   Improvement % = (Original Risk - New Risk) / Original Risk × 100

   Example:
   Original Risk: 7.8/10
   New Risk: 5.2/10
   Improvement: (7.8 - 5.2) / 7.8 × 100 = 33% improvement
   ```

6. **Identify new vulnerabilities introduced**<br>   → Any findings in v2 that weren't in v1<br>   → Assess if remediation itself created issues

#### Phase 3: Assess Remediation Quality

For each fixed finding, provide a detailed assessment:

**Excellent Remediation (9-10/10):**
```markdown
### Hardcoded API Credentials - EXCELLENT FIX

**Original Issue:** API keys hardcoded in `strings.xml`
**Remediation Applied:**<br>→ Credentials removed from resources ✅<br>→ Server-side credential delivery implemented ✅<br>→ Android Keystore used for storage ✅<br>→ Credential rotation performed ✅

**Why Excellent:** Root cause addressed, industry best practices followed

**Evidence:**<br>→ v1: `res/values/strings.xml:66` contained keys<br>→ v2: No hardcoded credentials found, KeyStore implementation at `CredentialManager.java:42`
```

**Failed Remediation (0/10):**
```markdown
### Hardcoded API Credentials - NOT FIXED

**Original Issue:** API keys hardcoded in `strings.xml`
**Attempted Remediation:** None visible
**Current Status:** Same credentials still present in v2

**Evidence:**<br>→ v1: `res/values/strings.xml:66` - Key: [REDACTED]<br>→ v2: `res/values/strings.xml:66` - **SAME KEY PRESENT**

**Impact:** CRITICAL - Credentials exposed for [X] months, must rotate immediately

**Recommendation:**<br>1. IMMEDIATE: Rotate API keys<br>2. SHORT-TERM: Implement server-side delivery<br>3. LONG-TERM: OAuth 2.0 implementation
```

#### Phase 4: Provide Forward Guidance

Based on comparison results, create prioritized recommendations:

```markdown
## Recommendations for Next Version

### Priority 1: CRITICAL (Must Fix Before Next Release)

1. **Rotate Exposed PushTNG Credentials**<br>   → **Why Critical:** Credentials exposed for 60+ days<br>   → **Estimated Effort:** 4 hours<br>   → **Owner:** Backend Team + Mobile Team

### Priority 2: HIGH (Fix in Next Sprint)

1. **Enable Root Detection Enforcement**<br>   → **Current Status:** Detection exists but no enforcement<br>   → **Recommended Fix:** Add device blocking for rooted devices<br>   → **Estimated Effort:** 8 hours<br>   → **Owner:** Mobile Team

### Priority 3: MEDIUM (Plan for Future)

1. **Increase Obfuscation Coverage**<br>   → **Current Gap:** Application packages still readable<br>   → **Recommended:** Adjust ProGuard keep rules<br>   → **Estimated Effort:** 4 hours
```

### AI-Assisted Comparative Analysis

Use this prompt with Claude Code:

```
I'm conducting a comparative security analysis between two versions of [APP_NAME].

Original assessment findings (v[X]):
[Paste or attach original assessment summary]

New version (v[Y]) decompiled to: decompiled/sources/

Please help me:<br>1. Re-assess each original finding in the new version<br>2. Determine remediation status (Resolved/Partial/Unchanged)<br>3. Score remediation quality (0-10)<br>4. Identify any new vulnerabilities introduced<br>5. Compare MASVS-RESILIENCE scores<br>6. Calculate overall security improvement percentage

For each finding, provide:<br>→ Status in v[Y] (code evidence with file:line)<br>→ Remediation quality assessment<br>→ Remaining gaps if partial fix
```

### Comparative Analysis Tips

When conducting comparative analysis:<br>→ Document both versions thoroughly<br>→ Use consistent scoring methodology<br>→ Calculate risk reduction percentages<br>→ Track fixed vs. unfixed issues<br>→ Document MASVS-RESILIENCE improvements<br>→ Score remediation quality for each finding

### Tips for Effective Comparative Analysis

1. **Be Objective**<br>   → Score remediations honestly (don't inflate scores)<br>   → Partial fixes are common - document gaps clearly

2. **Look for Regressions**<br>   → New version may introduce new issues<br>   → Remediation attempts can create vulnerabilities<br>   → Check for security library downgrades

3. **Quantify Impact**<br>   → "Risk reduced by 33%" is more impactful than "improved"<br>   → Show MASVS compliance percentage change<br>   → Calculate time/effort saved by proactive fixes

4. **Provide Actionable Guidance**<br>   → Specific file:line recommendations<br>   → Code examples for remaining fixes<br>   → Estimated effort for remaining work

5. **Track Trends**<br>   → Maintain version history (v1 → v2 → v3)<br>   → Identify recurring issues (same mistakes repeated)<br>   → Show security posture improvement over time

---

## 🎯 Success Criteria

You've successfully completed your first assessment when you can:

- [ ] Decompile an APK and extract resources
- [ ] Identify security vulnerabilities in decompiled code
- [ ] Score OWASP MASVS-RESILIENCE controls with justification
- [ ] Calculate CVSS scores for findings
- [ ] Generate a professional security assessment report
- [ ] Create a MASVS-RESILIENCE Controls Mapping table
- [ ] Provide actionable remediation recommendations
- [ ] Estimate time and effort for fixes

**Congratulations!** You're now ready to conduct professional mobile security assessments.

---

## 📞 Getting Help

### Resources

- **Documentation:** Check `analysis-guides/` for detailed methodology
- **Templates:** Use `templates/` for consistent reporting
- **Automation:** Leverage `tools/` for automation scripts

### Community

- **Internal:** Contact security team for peer review
- **External:** OWASP Mobile Security Testing Guide community
- **AI Assistant:** Use Claude Code with `CLAUDE.md` guidance

---

## 🚦 What's Next?

### Beginner Path
1. ✅ Complete first assessment (this guide)
2. 📖 Read: `analysis-guides/ASSESSMENT_WORKFLOW.md`
3. 🔍 Study: Templates and guides in this repository
4. 🎓 Practice: Assess 3-5 more sample applications
5. 📊 Learn: Comparative analysis techniques

### Intermediate Path
1. Master all 4 RESILIENCE controls
2. Learn dynamic analysis with Frida
3. Conduct network traffic analysis
4. Assess cryptography implementation (MASVS-CRYPTO)
5. Perform full 20-control MASVS assessment

### Advanced Path
1. Develop custom assessment automation
2. Create organization-specific MASVS profiles
3. Conduct security architecture reviews
4. Perform advanced native code analysis
5. Train junior security assessors

---

**Ready to begin?** Start with [Phase 1: Setup & Decompilation](#phase-1-setup--decompilation-30-60-min)!

**Questions?** See `docs/FAQ.md` or `docs/TROUBLESHOOTING.md`

**Want efficiency?** Jump to AI-Assisted workflow in `CLAUDE.md`

---

**Document Version:** 2.0 (Merged from SETUP.md and GETTING_STARTED.md)
**Last Updated:** 2025-11-19
**Maintained By:** Dwayne Dreakford
**License:** Internal Use Only
