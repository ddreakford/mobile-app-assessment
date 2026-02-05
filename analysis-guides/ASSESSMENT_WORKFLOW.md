# Mobile Application Security Assessment Workflow

**Quick Start Guide for Android/iOS Security Assessments**

Use this guide as a checklist for mobile app security assessments. This workflow supports **three assessment approaches**:

## Assessment Approaches

### 1. 🤖 AI-Assisted Workflow (Recommended for Speed)
- Use Claude Code or similar AI assistants to accelerate code analysis
- AI assists with: searching code, pattern matching, report generation, CVSS scoring
- Assessor focuses on: validation, context, complex logic analysis, final decisions
- **Time estimate:** 4-6 hours for comprehensive assessment
- **Best for:** Large codebases (15,000+ classes), time-constrained assessments

### 2. 🔧 Manual Workflow (Recommended for Depth)
- Traditional command-line tools (grep, find, ripgrep) and manual code review
- Assessor performs: all searches, all analysis, all documentation
- **Time estimate:** 8-12 hours for comprehensive assessment
- **Best for:** Small codebases (<5,000 classes), high-assurance requirements, learning

### 3. 🔀 Hybrid Workflow (Recommended Overall)
- Combine AI assistance with manual verification
- AI handles: bulk searches, initial triage, documentation drafting
- Assessor handles: validation, false positive elimination, risk scoring, final report
- **Time estimate:** 6-10 hours for comprehensive assessment
- **Best for:** Most assessments, balances speed and accuracy

**💡 Throughout this guide:**
- 🤖 indicates where AI can assist
- 🔍 indicates where manual review is critical
- ⚠️ indicates common pitfalls

---

## Pre-Assessment Checklist

**Before Starting:**
- [ ] Create assessment repository using [`create_new_assessment.sh`](../tools/create_new_assessment.sh)
- [ ] Obtain application binary (APK/IPA/XAPK)
- [ ] Verify tools installed: JADX, APKTool, grep/ripgrep
- [ ] Review OWASP MASVS v2.0 guidelines
- [ ] **Choose assessment approach:** AI-assisted / Manual / Hybrid
- [ ] **If using AI:** Review [CLAUDE.md](../CLAUDE.md) for AI assistant guidance
- [ ] Set up assessment timeline (4-12 hours depending on approach)

**Information to Gather:**
- [ ] Application name and version
- [ ] Package/Bundle ID
- [ ] Platform (Android/iOS)
- [ ] Source (Play Store, App Store, APKPure, etc.)
- [ ] Assessment scope and objectives

---

## Phase 1: Setup and Decompilation (30-60 min)

### Step 1.1: Handle APK/XAPK Files

**For XAPK files (common from APKPure, APKMirror):**

**⚠️ Common Issue:** Don't try to decompile XAPK directly - extract first!

```bash
cd apk/

# Inspect XAPK contents
unzip -l *.xapk

# Extract XAPK
unzip -q "APP_NAME_VERSION.xapk"

# Identify main APK (usually largest file)
ls -lh *.apk

# Expected files:
# - com.package.name.apk (main APK) - 30-40MB
# - config.*.apk (split APKs) - 100KB-5MB each
# - manifest.json
# - icon.png
```

**For standard APK files:**
```bash
cd apk/
ls -lh *.apk  # Verify APK is present
```

**✅ Checkpoint:** You should have the main APK file ready for decompilation.

### Step 1.2: Decompile with JADX

```bash
cd apk/

# Decompile APK to Java source
jadx com.package.name.apk -d ../decompiled/sources/ --show-bad-code

# Monitor progress:
# INFO: loading ...
# INFO: processing ...
# INFO: progress: X of Y (Z%)
# ERROR: finished with errors, count: N

# Acceptable error rate: <1% of total classes
# Example: 73 errors out of 17,506 classes = 0.4% ✅
```

**Expected Output Structure:**
```
decompiled/sources/
├── sources/
│   ├── com/
│   ├── org/
│   ├── androidx/
│   └── ...
└── resources/
    └── res/
```

**Time Estimate:** 2-5 minutes for 15,000-20,000 classes

**✅ Checkpoint:** Verify `decompiled/sources/sources/com/[package]/` exists

### Step 1.3: Extract Resources with APKTool

```bash
cd apk/

# Extract resources and manifest
apktool d com.package.name.apk -o ../decompiled/resources/ -f

# This extracts:
# - AndroidManifest.xml (readable format)
# - res/ (resources)
# - assets/ (app assets)
# - smali/ (bytecode - multiple directories if multi-dex)
```

**Expected Output Structure:**
```
decompiled/resources/
├── AndroidManifest.xml  ← PRIMARY TARGET
├── apktool.yml
├── assets/
├── res/
├── smali/
├── smali_classes2/
└── ...
```

**Time Estimate:** 1-3 minutes

**✅ Checkpoint:** Verify `AndroidManifest.xml` is readable

---

## Phase 2: Initial Reconnaissance (30-45 min)

### Step 2.1: Analyze AndroidManifest.xml

🔍 **CRITICAL:** Always review AndroidManifest.xml manually - often contains most severe vulnerabilities

**Priority Checks:**

**🔧 Manual Approach:**
```bash
cd ../decompiled/resources/

# 1. Check for cleartext traffic (CRITICAL)
grep "usesCleartextTraffic" AndroidManifest.xml

# FINDING: If "true" → HIGH severity vulnerability
# Location: Note line number (e.g., line 41)

# 2. Search for hardcoded API keys in metadata
grep -A 2 "<meta-data" AndroidManifest.xml | grep "value="

# FINDING: Look for:
# - API_KEY, api_key
# - Keys from Bugsnag, Firebase, Branch.io, etc.
# - Long alphanumeric strings

# 3. Find exported components (potential attack surface)
grep "android:exported=\"true\"" AndroidManifest.xml

# 4. Review permissions (dangerous permissions)
grep "<uses-permission" AndroidManifest.xml

# 5. Check deep link handlers
grep -A 5 "android.intent.action.VIEW" AndroidManifest.xml
```

**🤖 AI-Assisted Approach:**
Ask Claude Code to:
```
Analyze decompiled/resources/AndroidManifest.xml for security issues:
1. Check usesCleartextTraffic setting
2. Find hardcoded API keys in <meta-data> tags
3. List exported components (activities/services/receivers)
4. Identify dangerous permissions
5. Review deep link handlers and URL schemes
Provide findings with file:line references.
```

**Document Findings:**
- [ ] Cleartext traffic setting (line number)
- [ ] Exposed API keys (service name, key value, line number)
- [ ] Exported activities/services
- [ ] Dangerous permissions
- [ ] Deep link schemes

**✅ Checkpoint:** Complete AndroidManifest.xml analysis - often contains most critical findings

### Step 2.2: Explore Decompiled Code Structure

```bash
cd ../sources/sources/

# Get high-level overview
find . -type d -maxdepth 3 | sort | head -30

# Identify main application packages
ls -la com/

# Count total classes
find . -name "*.java" | wc -l

# Example output: 17506 classes
```

**Document:**
- [ ] Main package names (e.g., com.company.app)
- [ ] Total class count
- [ ] Architecture patterns observed (MVVM, MVC, etc.)

**✅ Checkpoint:** Understand codebase structure before detailed analysis

---

## Phase 3: Vulnerability Hunting (2-3 hours)

🤖 **AI EXCELS HERE:** Pattern-based searches across large codebases - AI can process thousands of files quickly

### Step 3.1: Search for Hardcoded Secrets

**🔧 Manual Approach:**

**Method 1: Find Configuration Files**

```bash
# Search for Constants and Config classes
find . -name "*Constants*.java" \
       -o -name "*Config*.java" \
       -o -name "*Key*.java" \
       -o -name "*Secret*.java" | head -30

# Review each file manually for:
# - API endpoints
# - API keys
# - Tokens
# - Passwords
```

**Priority Files to Review:**
- `*/constants/Constants.java`
- `*/api/ApiConstants.java`
- `*/config/*Config.java`
- `BuildConfig.java` files

**Method 2: Pattern-Based Search**

```bash
# Search for credential assignments
grep -r "(api[_-]?key|password|secret|token|auth[_-]?token)\s*[=:]\s*[\"'][^\"']{8,}" \
    com/[company] --include="*.java" -n | head -50

# Search for API base URLs
grep -r "https\?://" com/[company] --include="*.java" | \
    grep -i "api\|base\|url" | head -30

# Search for encryption keys
grep -r "AES\|DES\|RSA" com/[company] --include="*.java" -A 3 | \
    grep -i "key\|secret" | head -20
```

**🤖 AI-Assisted Approach:**
Ask Claude Code to:
```
Search decompiled/sources/sources/ for hardcoded secrets:
1. Find all *Constants*.java and *Config*.java files in com/[company]
2. Search for API keys, tokens, passwords (look for assignment patterns)
3. Find API base URLs (https:// patterns)
4. Identify hardcoded encryption keys (AES, RSA, DES patterns)
5. List findings with file:line references and code snippets
Note: Focus on application packages (com/[company]), not third-party libraries
```

🔍 **CRITICAL:** Manually verify all findings - many will be false positives (variable names, comments, test data)

**Document Findings:**
- [ ] Hardcoded API keys (file:line, key value)
- [ ] Hardcoded passwords (file:line, context)
- [ ] API endpoints (file:line, URL)
- [ ] Encryption keys (file:line, algorithm)

**⚠️ Warning:** Some matches may be false positives (e.g., variable names). Verify context.

**✅ Checkpoint:** Complete credential hunting

### Step 3.2: Assess Code Obfuscation (MASVS-RESILIENCE-2)

📖 **For comprehensive analysis, see:** [MASVS-RESILIENCE-2-enhanced.md](MASVS-RESILIENCE-2-enhanced.md)

🤖 **AI is excellent for this** - can quickly sample class names across the entire codebase

**🔧 Manual Approach - Quick Check:**

```bash
# Look for recognizable class names
find . -name "*Login*.java" \
       -o -name "*Auth*.java" \
       -o -name "*Password*.java" \
       -o -name "*Main*.java" | head -10

# If you find readable names like:
# - LoginViewModel.java
# - AuthenticationActivity.java
# - PasswordManager.java
# → NO OBFUSCATION (RESILIENCE-2 FAIL)

# If you find obfuscated names like:
# - a.java, b.java, c.java
# - a/b/c.java
# → OBFUSCATION PRESENT (need deeper analysis)
```

**Detailed Check:**

```bash
# Check package structure
ls -la com/[company]/features/authentication/

# Readable structure indicates no obfuscation:
# ├── viewmodel/
# │   ├── LoginViewModel.java
# │   ├── LoginState.java
# ├── view/
# │   ├── LoginActivity.java

# Check for ProGuard mapping file
find . -name "mapping.txt" -o -name "proguard-mapping.txt"

# If not found → No obfuscation was applied
```

**🤖 AI-Assisted Approach:**
Ask Claude Code to:
```
Assess code obfuscation level in decompiled/sources/sources/:
1. Sample 20-30 class names from com/[company] packages
2. Check if class names are readable (e.g., LoginActivity.java) or obfuscated (e.g., a.java)
3. Look for ProGuard/R8 mapping files (mapping.txt)
4. Check package structure - are folder names readable or obfuscated?
5. Score obfuscation: 0/10 (none), 5-7/10 (R8/ProGuard), 8-10/10 (DexGuard/commercial)
Provide examples and justification for the score.
```

**Scoring:**
- **Readable class names:** 0/10 (FAIL)
- **Obfuscated with R8/ProGuard:** 5-7/10 (PARTIAL)
- **DexGuard or equivalent:** 8-10/10 (PASS)

**Document:**
- [ ] Obfuscation status (YES/NO/PARTIAL)
- [ ] Example class names showing obfuscation level
- [ ] ProGuard/R8 evidence (mapping file presence)
- [ ] Effectiveness score (0-10)

**🔍 Deep Dive Analysis:**
For detailed scoring methodology, implementation patterns, and ExampleApp case study, see [MASVS-RESILIENCE-2-enhanced.md](MASVS-RESILIENCE-2-enhanced.md):
- 0-10 effectiveness scoring rubric with detailed criteria
- 7 implementation patterns (None, Basic R8, Aggressive R8, DexGuard, Native, etc.)
- Real-world ExampleApp analysis (0/10 score - no obfuscation)
- Comprehensive remediation guidance with ProGuard/R8 configuration examples
- Commercial obfuscation tool comparison (DexGuard, iXGuard, etc.)

**When to use the enhanced guide:**
- ✅ **Use for:** Initial assessments, evaluating obfuscation quality, ProGuard configuration
- ⚠️ **Optional for:** Quick triage (readable class names = instant FAIL)

**✅ Checkpoint:** RESILIENCE-2 assessment complete

### Step 3.3: Additional Vulnerability Searches

**SQL Injection:**
```bash
grep -r "rawQuery\|execSQL" com/[company] --include="*.java" -n -A 5
```

**Insecure Random:**
```bash
grep -r "new Random()" com/[company] --include="*.java" -n
```

**Logging Sensitive Data:**
```bash
grep -r "Log\.[devi].*password\|Log\.[devi].*token\|Log\.[devi].*secret" \
    com/[company] --include="*.java" -n
```

---

## Phase 4: OWASP MASVS-RESILIENCE Analysis (1-2 hours)

🤖 **AI can find code** but 🔍 **you must analyze enforcement logic manually**

### Step 4.1: RESILIENCE-1 (Root/Jailbreak Detection)

📖 **For comprehensive analysis, see:** [MASVS-RESILIENCE-1-enhanced.md](MASVS-RESILIENCE-1-enhanced.md)

**🔧 Manual Approach - Search for Root Detection:**

```bash
# Search for root detection code
grep -ri "root\|jailbreak\|isRooted\|RootBeer\|checkRoot" \
    com/[company] | grep -v "MainActivity" | head -20

# Search for SafetyNet
grep -ri "SafetyNet\|attestation" com/[company] | head -10

# Find root detection classes
find . -name "*Root*.java" | grep -v "androidx"
```

**🤖 AI-Assisted Approach:**
Ask Claude Code to:
```
Search for root/jailbreak detection in decompiled/sources/sources/:
1. Find code containing: root, jailbreak, isRooted, RootBeer, SafetyNet
2. Locate *Root*.java files (exclude androidx)
3. Identify where detection happens (Application.onCreate, security classes, etc.)
4. Show code snippets with file:line references
Note: Focus on com/[company] packages, but check third-party libs like Bugsnag
```

🔍 **CRITICAL - Manual Analysis of Enforcement:**

1. Open the root detection file
2. Check if detection leads to:<br>   → **Enforcement:** App terminates, shows error, blocks functionality<br>   → **Telemetry only:** Just logs/reports, app continues
3. Score accordingly:<br>   → No detection: 0/10 (FAIL)<br>   → Telemetry only: 2/10 (PARTIAL)<br>   → Enforcement: 6-8/10 (PASS/STRONG)

**Common Locations:**
- Third-party libraries: `com/bugsnag/android/RootDetector.java`
- Security packages: `com/[company]/security/RootCheck.java`
- Application class: `onCreate()` method

**Document:**
- [ ] Root detection present (YES/NO)
- [ ] Detection method (file:line)
- [ ] Enforcement type (TELEMETRY/ENFORCEMENT)
- [ ] Effectiveness score (0-10)

**🔍 Deep Dive Analysis:**
For detailed scoring methodology, implementation patterns, and ExampleApp case study, see [MASVS-RESILIENCE-1-enhanced.md](MASVS-RESILIENCE-1-enhanced.md):
- 0-10 effectiveness scoring rubric with detailed criteria
- 8 implementation patterns (Device checks, SafetyNet, RootBeer, Custom, etc.)
- Real-world ExampleApp analysis (Bugsnag detection: 2/10 score - telemetry only)
- Comprehensive remediation guidance with code examples

**When to use the enhanced guide:**
- ✅ **Use for:** Initial assessments, scoring complex implementations, writing detailed reports
- ⚠️ **Optional for:** Quick triage, straightforward cases (clear PASS/FAIL)

**✅ Checkpoint:** RESILIENCE-1 assessment complete

### Step 4.2: RESILIENCE-3 (Anti-Debugging)

📖 **For comprehensive analysis, see:** [MASVS-RESILIENCE-3-enhanced.md](MASVS-RESILIENCE-3-enhanced.md)

**Search for Debugging Checks:**

```bash
# Search for debugger detection
grep -ri "isDebugger\|Debug\.isDebugger\|waitingForDebugger" \
    com/[company] | head -20

# Search for Frida/Xposed detection
grep -ri "frida\|xposed\|substrate" com/[company] | head -20

# Search for TracerPid checks
grep -ri "TracerPid\|ptrace" com/[company] | head -10

# Check for timing-based detection
grep -ri "System\.currentTimeMillis\|System\.nanoTime" \
    com/[company]/security | head -20
```

**Check AndroidManifest:**
```bash
grep "debuggable" ../resources/AndroidManifest.xml

# If debuggable="true" in release build → vulnerability
# If not specified → defaults to false (OK)
```

**Scoring:**
- **No checks found:** 0/10 (FAIL)
- **Basic debugger checks:** 4-6/10 (PARTIAL)
- **Multiple anti-debug techniques:** 7-10/10 (PASS)

**Document:**
- [ ] Anti-debugging present (YES/NO)
- [ ] Detection methods (list techniques)
- [ ] Effectiveness score (0-10)

**🔍 Deep Dive Analysis:**
For detailed scoring methodology, implementation patterns, and ExampleApp case study, see [MASVS-RESILIENCE-3-enhanced.md](MASVS-RESILIENCE-3-enhanced.md):
- 0-10 effectiveness scoring rubric with detailed criteria
- 7 implementation patterns (TracerPid, Frida detection, timing checks, JDWP, etc.)
- Real-world ExampleApp analysis (0/10 score - no anti-debugging)
- Comprehensive remediation guidance with code examples
- Native vs. Java implementation trade-offs

**When to use the enhanced guide:**
- ✅ **Use for:** Initial assessments, evaluating multi-technique implementations, native code analysis
- ⚠️ **Optional for:** Quick triage, straightforward cases (clear PASS/FAIL)

**✅ Checkpoint:** RESILIENCE-3 assessment complete

### Step 4.3: RESILIENCE-4 (Tamper Detection)

📖 **For comprehensive analysis, see:** [MASVS-RESILIENCE-4-enhanced.md](MASVS-RESILIENCE-4-enhanced.md)

**Search for Signature Verification:**

```bash
# Search for signature checks
grep -ri "signature\|checkSignature\|GET_SIGNATURES\|GET_SIGNING_CERTIFICATES" \
    com/[company] | head -20

# Search for integrity checks
grep -ri "integrity\|tamper\|checksum\|crc" com/[company] | head-20

# Search for package info queries
grep -ri "getPackageInfo" com/[company] -A 5 | \
    grep -i "signature\|sign" | head -20
```

**Look for:**
- APK signature validation
- DEX file integrity checks
- Resource tampering detection
- Certificate pinning (related control)

**Scoring:**
- **No checks found:** 0/10 (FAIL)
- **Basic signature check:** 5-7/10 (PARTIAL)
- **Multi-layer integrity checks:** 8-10/10 (PASS)

**Document:**
- [ ] Tamper detection present (YES/NO)
- [ ] Detection methods (file:line)
- [ ] Effectiveness score (0-10)

**🔍 Deep Dive Analysis:**
For detailed scoring methodology, implementation patterns, and ExampleApp case study, see [MASVS-RESILIENCE-4-enhanced.md](MASVS-RESILIENCE-4-enhanced.md):
- 0-10 effectiveness scoring rubric with detailed criteria
- 8 implementation patterns (APK signature, DEX integrity, class verification, resource checks, etc.)
- Real-world ExampleApp analysis (0/10 score - no tamper detection)
- Comprehensive remediation guidance with code examples
- Multi-layer integrity checking strategies

**When to use the enhanced guide:**
- ✅ **Use for:** Initial assessments, complex implementations, native integrity checks
- ⚠️ **Optional for:** Quick triage, straightforward cases (clear PASS/FAIL)

**✅ Checkpoint:** RESILIENCE-4 assessment complete

---

## Phase 5: Documentation (2-3 hours)

🤖 **AI EXCELS HERE:** Report generation, formatting, CVSS calculation, remediation recommendations

### Assessment Deliverables

Phase 5 produces the following deliverables:

| Deliverable | Purpose | Template Location |
|-------------|---------|-------------------|
| **Security Assessment Report** | Comprehensive findings with CVSS, MASVS mapping, remediation | `templates/REPORT_TEMPLATE.md` |
| **MASVS-RESILIENCE Controls Mapping** | Detailed guard-level breakdown for stakeholder communication | `templates/masvs/RESILIENCE_CONTROLS_MAPPING.md` |
| **Email Summary** (optional) | Executive summary for initial stakeholder outreach | `templates/email/assessment_results_email_summary.txt` |

### Step 5.1: Create Security Assessment Report

**🔧 Manual Approach:**

Use the template structure from `assessment-reports/SECURITY_ASSESSMENT_REPORT.md`:

```markdown
# Security Assessment Report: [APP_NAME]

1. Executive Summary
   - Application info
   - Assessment date
   - Key findings (by severity)
   - Overall risk score
   - MASVS compliance

2. Assessment Methodology
   - Tools used
   - Analysis techniques
   - Scope

3. Findings
   - CRITICAL (CVSS 9.0-10.0)
   - HIGH (CVSS 7.0-8.9)
   - MEDIUM (CVSS 4.0-6.9)
   - LOW (CVSS 0.1-3.9)

4. OWASP MASVS Coverage Analysis
   - RESILIENCE controls table
   - Complete MASVS matrix
   - Critical gaps

5. Remediation Roadmap
   - Phase 1: Emergency (24-48h)
   - Phase 2: Short-term (1-2 weeks)
   - Phase 3: Long-term (1-3 months)

6. Technical Recommendations
   - Code examples
   - Configuration samples

7. Compliance Impact

8. Conclusion
```

**🤖 AI-Assisted Approach:**
Ask Claude Code to:
```
Create a security assessment report using assessment-reports/SECURITY_ASSESSMENT_REPORT.md as template:
1. Generate executive summary from my findings
2. Calculate CVSS scores for each finding with justification
3. Map findings to OWASP MASVS v2.0 controls and CWE identifiers
4. Create 3-phase remediation roadmap (Emergency/Short-term/Long-term)
5. Write technical recommendations with code examples
6. Format in markdown with proper structure

Findings to include:
[Provide your list of findings here]
```

🔍 **CRITICAL - Manual Review Required:**
- Verify all CVSS scores and vectors
- Validate MASVS/CWE mappings
- Review technical accuracy of remediation steps
- Check that all file:line references are correct
- Ensure no sensitive data is included (sanitize if needed)

**For Each Finding, Include:**
- Title and severity
- CVSS score with vector
- Location (file:line)
- Technical evidence (code snippets)
- Impact analysis
- Attack scenario
- OWASP MASVS mapping
- CWE identifier
- Remediation recommendations (3 phases)

### Step 5.2: Create MASVS-RESILIENCE Controls Mapping

The Controls Mapping table provides a detailed, guard-level breakdown of RESILIENCE findings. This is particularly valuable for:
- Communicating specific gaps to development teams
- Mapping findings to security solution capabilities
- Providing granular remediation guidance

**🔧 Manual Approach:**

1. Copy the mapping template:
```bash
cp templates/masvs/RESILIENCE_CONTROLS_MAPPING.md assessment-reports/OWASP_MASVS-RESILIENCE_Controls_Mapping.md
```

2. Fill in the "Current State" column for each guard based on your Phase 4 analysis

3. Use consistent terminology:<br>   → "Not present" - No implementation found<br>   → "Detection present (via [SDK]), but no enforcement" - Telemetry only<br>   → "No code obfuscation. All X classes readable with descriptive names" - For RESILIENCE-3<br>   → "N/A (Android)" or "N/A (iOS)" - For platform-specific guards

**🤖 AI-Assisted Approach:**

Ask Claude Code to:
```
Based on the MASVS-RESILIENCE analysis completed in Phase 4, create an OWASP_MASVS-RESILIENCE_Controls_Mapping.md file.

Use the template from templates/masvs/RESILIENCE_CONTROLS_MAPPING.md.

For each guard category, provide the current state based on these findings:<br>→ RESILIENCE-1: [Your root detection findings]<br>→ RESILIENCE-2: [Your tamper detection findings]<br>→ RESILIENCE-3: [Your obfuscation findings - include class count]<br>→ RESILIENCE-4: [Your anti-debugging findings]

Include:<br>→ Application metadata (name, platform, version, date)<br>→ Current state for each individual guard<br>→ Platform-specific notes (mark iOS-only guards as N/A for Android and vice versa)
```

🔍 **Manual Review Required:**
- Verify all guard statuses match your Phase 4 findings
- Ensure terminology is consistent with the Security Assessment Report
- Confirm platform-specific guards are correctly marked as N/A

**✅ Checkpoint:** Controls Mapping table complete with all guards documented

### Step 5.3: Update README.md

```markdown
## Findings Summary
**Overall Risk Score:** X.X/10

**Security Findings:**
- HIGH (X): [list]
- MEDIUM (X): [list]

**OWASP MASVS-RESILIENCE Controls:**
- RESILIENCE-1: ✅/⚠️/❌ (score/10) - [status]
- RESILIENCE-2: ✅/⚠️/❌ (score/10) - [status]
- RESILIENCE-3: ✅/⚠️/❌ (score/10) - [status]
- RESILIENCE-4: ✅/⚠️/❌ (score/10) - [status]

**Remediation Priorities:**
[3-phase plan summary]
```

### Step 5.4: Update CLAUDE.md

Add lessons learned from this specific assessment:
- What worked well
- What was challenging
- Time estimates
- Key file locations
- Notable findings

**✅ Checkpoint:** All documentation complete

---

## Post-Assessment Checklist

**Before Finalizing:**
- [ ] All findings have CVSS scores
- [ ] All findings mapped to OWASP MASVS
- [ ] All code references include file:line format
- [ ] Remediation recommendations for each finding
- [ ] Executive summary completed
- [ ] README.md updated
- [ ] CLAUDE.md updated with lessons learned
- [ ] All sensitive data sanitized (if sharing externally)

**Quality Checks:**
- [ ] No placeholder text (TBD, TODO, etc.)
- [ ] All file paths verified and accurate
- [ ] CVSS scores justified and accurate
- [ ] Code snippets formatted correctly
- [ ] Markdown renders correctly
- [ ] Links work (internal references)

**Deliverables:**
- [ ] SECURITY_ASSESSMENT_REPORT.md (comprehensive)
- [ ] OWASP_MASVS-RESILIENCE_Controls_Mapping.md (guard-level breakdown)
- [ ] README.md (updated)
- [ ] CLAUDE.md (updated)
- [ ] Decompiled code (in repository)
- [ ] Evidence files (screenshots, artifacts)
- [ ] Email summary (optional - templates/email/assessment_results_email_summary.txt)
- [ ] Presentation (optional - tools/create_security_presentation.py)

---

## Time Estimates Summary

### By Assessment Approach

| Phase | Task | 🔧 Manual | 🤖 AI-Assisted | 🔀 Hybrid |
|-------|------|-----------|----------------|-----------|
| 1 | Setup & Decompilation | 30-60 min | 30-60 min | 30-60 min |
| 2 | Initial Reconnaissance | 45-60 min | 20-30 min | 30-45 min |
| 3 | Vulnerability Hunting | 3-4 hours | 1-2 hours | 2-3 hours |
| 4 | MASVS Analysis | 2-3 hours | 1-1.5 hours | 1-2 hours |
| 5 | Documentation | 3-4 hours | 1-2 hours | 2-3 hours |
| **Total** | **Comprehensive Assessment** | **8-12 hours** | **4-6 hours** | **6-10 hours** |

**Notes:**
- **Manual:** Best for learning, small codebases, high-assurance requirements
- **AI-Assisted:** Best for speed, large codebases (15,000+ classes), time constraints
- **Hybrid (Recommended):** Best balance of speed and accuracy for most assessments
- Times assume familiarity with tools and methodology
- First assessment may take 50-100% longer
- Add 2-4 hours for presentation creation (optional)

---

## Common Issues and Solutions

### Issue: "Can't find APK in XAPK"
**Solution:** Extract XAPK first with `unzip`, then identify main APK (largest file)

### Issue: "JADX too many errors"
**Solution:** <1% error rate is acceptable. Focus on successfully decompiled code.

### Issue: "Can't find root detection"
**Solution:** Check third-party libraries (Bugsnag, SafetyNet). May not exist.

### Issue: "Too many grep results"
**Solution:** Use more specific patterns, limit to app packages (com/[company])

### Issue: "Unclear if obfuscation is effective"
**Solution:** Check 5-10 class names. If any are readable, obfuscation is weak/absent.

---

## Phase 6: Comparative Analysis (Post-Remediation)

**When to perform:** After development team implements security fixes

**Time Estimate:** 8-12 hours (full assessment + comparison)

**Purpose:** Validate remediation effectiveness and track security improvements

### Step 6.1: Assess Updated Version

Conduct full assessment of new version (repeat Phases 1-5):

```bash
# Create new assessment directory
mkdir -p assessments/myapp-v2-assessment
cd assessments/myapp-v2-assessment

# Decompile new version
jadx apk/MyApp_v2.0.0.apk -d decompiled/sources/
apktool d apk/MyApp_v2.0.0.apk -o decompiled/resources/

# Perform complete assessment
# Follow all phases: Setup → Recon → Vuln Hunting → MASVS → Documentation
```

**Important:** Don't skip phases - new issues may have been introduced.

### Step 6.2: Create Comparative Report

**🤖 AI-Assisted:**
```
I'm conducting comparative analysis of [APP_NAME]:
- Original version: v[X.X.X] assessed [DATE]
- New version: v[Y.Y.Y] in decompiled/sources/

Original findings:
[List or attach original finding summary]

Please:
1. Re-assess each original finding in v[Y]
2. Determine status (Resolved/Partial/Unchanged)
3. Score remediation quality (0-10)
4. Identify new vulnerabilities introduced
5. Compare MASVS-RESILIENCE scores
6. Calculate security improvement %

Provide file:line evidence for all assessments.
```

**🔧 Manual:**
```bash
# Copy comparative template
cp templates/COMPARATIVE_TEMPLATE.md assessment-reports/COMPARATIVE_ANALYSIS.md

# For each original finding, check if fixed:
grep -r "[SEARCH_PATTERN]" decompiled/sources/sources/

# Compare MASVS scores manually
# Document remediation quality (Excellent/Good/Partial/Failed)
```

### Step 6.3: Score Remediation Quality

For each fixed finding, assign quality score:

| Score | Status | Criteria |
|-------|--------|----------|
| 9-10 | 🟢 EXCELLENT | Root cause addressed, best practices followed |
| 7-8 | 🟢 GOOD | Issue fixed with minor gaps |
| 4-6 | 🟡 PARTIAL | Some improvement, still exploitable |
| 1-3 | 🔴 POOR | Surface fix only, root cause remains |
| 0 | 🔴 UNCHANGED | No remediation attempted |

**Example Assessment:**
```markdown
### Hardcoded API Credentials

**v1 Status:** 🔴 PRESENT at `strings.xml:66`
**v2 Status:** 🟢 RESOLVED
**Remediation Quality:** 9/10 (EXCELLENT)

**Evidence:**
- v1: Credentials hardcoded in resources
- v2: No hardcoded credentials found
- v2: Server-side delivery implemented at `CredentialManager.java:42`
- v2: Android Keystore used for storage

**Assessment:** Root cause addressed with industry best practices.
```

### Step 6.4: Calculate Security Improvement

**Risk Reduction:**
```
Improvement % = (Original Risk - New Risk) / Original Risk × 100

Example:
Original: 7.8/10 risk
New: 5.2/10 risk
Improvement: (7.8 - 5.2) / 7.8 × 100 = 33% reduction
```

**MASVS Compliance:**
```
Control improvements:
- RESILIENCE-1: 2/10 → 3/10 (+1)
- RESILIENCE-2: 0/10 → 6/10 (+6) ✅ MAJOR
- RESILIENCE-3: 0/10 → 4/10 (+4)
- RESILIENCE-4: 0/10 → 7/10 (+7) ✅ MAJOR

Average: 0.5/10 → 5.0/10 (10x improvement)
```

### Step 6.5: Identify New Issues

Check for regressions or new vulnerabilities:

```bash
# Look for new concerning patterns not in v1
grep -r "TODO.*security" decompiled/sources/sources/
grep -r "FIXME.*crypto" decompiled/sources/sources/

# Check for security library downgrades
# Compare AndroidManifest.xml versions
diff v1/AndroidManifest.xml v2/AndroidManifest.xml
```

### Step 6.6: Provide Forward Guidance

Based on comparison, create prioritized next steps:

**Unresolved Critical Issues:**
- List findings that must be fixed immediately
- Estimate effort for each

**Partial Fixes Requiring Completion:**
- List what was improved but incomplete
- Specify what remains to be done

**New Issues Introduced:**
- Document new vulnerabilities in v2
- Assess if remediation caused them

**Recommendations for Next Version:**
```markdown
### Priority 1: CRITICAL
1. **Rotate Exposed Credentials** (4 hours)

### Priority 2: HIGH
1. **Enable Root Detection Enforcement** (8 hours)
2. **Increase Obfuscation Coverage** (4 hours)

### Priority 3: MEDIUM
1. **Add Certificate Pinning** (12 hours)
```

---

## Next Steps

After completing assessment (or comparative analysis):
1. Review with team
2. Validate findings (test on real device if possible)
3. Share with stakeholders
4. Track remediation progress
5. Schedule follow-up assessment (30-60 days after fixes)

**Recommended Timeline:**
- Share report: 1-2 days post-assessment
- Remediation tracking: Weekly status updates
- Follow-up assessment: 30-60 days after fixes deployed
- Comparative analysis: After each major version with security fixes

---

## Learning Resources

### Assessment Templates and Guides

For comprehensive templates and guidance, refer to the resources in this repository:

**Available Templates:**
- Security Assessment Report: `../templates/REPORT_TEMPLATE.md`
- Comparative Analysis: `../templates/COMPARATIVE_TEMPLATE.md`
- Finding Templates: `../templates/findings/`
- MASVS Controls Mapping: `../templates/masvs/`

**Enhanced MASVS Guides:**
- MASVS-RESILIENCE-1 through 4: `MASVS-RESILIENCE-*-enhanced.md`
- All 4 RESILIENCE controls with detailed analysis methodology

**What to Learn from Templates:**
- Report structure and formatting standards
- How to document findings with evidence (file:line references)
- CVSS scoring methodology with justifications
- MASVS controls mapping approach
- Remediation recommendations (3-phase approach)
- How to handle telemetry vs enforcement distinctions
- Professional communication style for security findings

**When to Use Templates:**
- ✅ First-time assessments - Learn report structure
- ✅ Scoring RESILIENCE controls - Follow detailed rubrics
- ✅ Writing remediation guidance - Use consistent format
- ✅ Creating comparative analysis - Follow structured approach
- ✅ CVSS calculations - Apply consistent methodology

---

## Related Documentation

- **[README.md](../README.md)** - Quick reference and example findings summary
- **[CLAUDE.md](../CLAUDE.md)** - AI assistant guidance and repository documentation
- **[GETTING_STARTED.md](../GETTING_STARTED.md)** - Complete setup and first assessment guide

---

**Template Version:** 1.1  
**Last Updated:** 2025-11-14  
**Changes:** Added AI-Assisted, Manual, and Hybrid workflow guidance throughout all phases  
