# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

<!-- TEMPLATE_HEADER_START: Custom header section - will be replaced per assessment -->
## Repository Purpose

This is the **Mobile Security Assessment Exemplar** - a template repository for conducting mobile application security assessments.

**This is NOT a specific app assessment** - it provides templates, guides, and examples for creating your own assessments.

To learn the assessment process, practice on sample apps downloaded from APKPure or APKMirror, following the workflow in GETTING_STARTED.md.

**This exemplar supports three assessment approaches:**

1. **🤖 AI-Assisted Workflow** - Use Claude Code to accelerate analysis (4-6 hours)
2. **🔧 Manual Workflow** - Traditional command-line tools and manual review (8-12 hours)
3. **🔀 Hybrid Workflow** - Combine AI assistance with manual verification (6-10 hours, recommended)

<!-- TEMPLATE_HEADER_END -->

<!-- TEMPLATE_SHARED_CONTENT_START: Shared content for all assessments -->

## Repository Structure

```
mobile-security-framework/
├── apk/                   # Application binary files (place APK/IPA here)
├── decompiled/            # Decompiled source code and resources
│   ├── sources/           # Decompiled source code
│   └── resources/         # Extracted resources
├── analysis-guides/       # OWASP MASVS guides and templates
│   └── ASSESSMENT_WORKFLOW.md  # Detailed methodology reference
├── assessment-reports/    # Security assessment reports
├── assessment-resources/  # Screenshots, evidence, and analysis artifacts
├── templates/             # Report and documentation templates
├── tools/                 # Analysis automation and utility scripts
│   └── create_new_assessment.sh  # Create new assessment from this exemplar
├── examples/
│   └── README.md          # Example assessments catalog
├── GETTING_STARTED.md     # PRIMARY GUIDE - Start here for setup and workflow
├── README.md              # Quick reference and documentation guide
└── CLAUDE.md              # This file - AI assistant guidance
```

## AI Assistant Guidelines

**When assisting with assessments in this repository:**

### Core Principles

1. **Always reference ASSESSMENT_WORKFLOW.md** for step-by-step procedures
2. **Balance AI efficiency with human judgment:**
   - 🤖 **AI excels at:** Pattern matching, bulk searches, report drafting, CVSS calculation
   - 🔍 **Human required for:** Enforcement logic analysis, false positive elimination, risk assessment, final decisions
3. **Use file:line format** for all code references (e.g., `AndroidManifest.xml:41`)
4. **Distinguish telemetry from enforcement** when analyzing security controls (critical for scoring)
5. **Provide CVSS scores** with justification for all findings
6. **Map findings to OWASP MASVS v2.0** controls and CWE identifiers
7. **Include 3-phase remediation** (Emergency/Short-term/Long-term) for all findings
8. **Document evidence** with file paths, commands used, and quantitative data
9. **Focus on application packages** (e.g., `com.exampleapp.*`) not third-party libraries initially
10. **Always recommend manual verification** - AI can produce false positives

### Where AI Assistance is Most Valuable

**High Value (AI excels):**
- Pattern-based vulnerability searches across large codebases
- Finding configuration files (Constants.java, Config.java)
- Sampling class names for obfuscation assessment
- Report generation and formatting
- CVSS score calculation with justification
- Creating remediation recommendations

**Medium Value (AI assists, human validates):**
- AndroidManifest.xml analysis (AI finds issues, human assesses severity)
- API endpoint discovery
- Identifying security control code (root detection, anti-debug)
- MASVS compliance mapping

**Low Value (human critical):**
- Analyzing enforcement vs. telemetry logic
- Determining actual exploitability
- Risk scoring and prioritization
- Final report review and sanitization
- Complex business logic vulnerabilities

### Common Tasks to Assist With

- Searching for hardcoded credentials, API keys, secrets
- Analyzing AndroidManifest.xml for security misconfigurations
- Assessing OWASP MASVS-RESILIENCE controls (obfuscation, root detection, anti-debug, tamper detection)
- Calculating risk scores and prioritizing remediation
- Generating professional security reports
- Formatting documentation and creating presentations

## Key Components

### Assessment Guides

This repository includes a layered documentation structure designed for both quick assessments and deep-dive analysis:

#### 📋 ASSESSMENT_WORKFLOW.md (Start Here)

**File:** `analysis-guides/ASSESSMENT_WORKFLOW.md`

**Purpose:** Your primary step-by-step guide for conducting mobile app security assessments

**What it contains:**
- Pre-assessment checklist and prerequisites
- 5 phases: Setup → Reconnaissance → Vulnerability Hunting → MASVS Analysis → Documentation
- Quick AI prompts for each phase (if using AI-assisted workflow)
- Manual command-line approaches (if using manual workflow)
- Time estimates: 6-10 hours for comprehensive hybrid assessment
- Common issues, pitfalls, and solutions
- References to enhanced guides for detailed analysis

**When to use:**
- ✅ **START HERE** for every assessment
- ✅ Follow phase-by-phase for first-time assessments
- ✅ Use as checklist for experienced assessors
- ✅ Reference when explaining workflow to team members

**AI Guidance:** Each phase includes both 🤖 AI-assisted and 🔧 manual approaches with specific prompts and commands.

#### 📖 Enhanced MASVS-RESILIENCE Guides (Deep Dive)

**Files:** `analysis-guides/MASVS-RESILIENCE-{1,2,3,4}-enhanced.md`

**Purpose:** Comprehensive analysis methodology for each OWASP MASVS v2.0 RESILIENCE control

**What each contains (1000+ lines):**
- AI-Assisted Analysis Approach section
  - 🤖 Quick AI Prompt (5-10 min) for initial discovery
  - 🔍 Deep Analysis Prompt (20-45 min) for comprehensive assessment
  - ⚠️ Manual Validation Required section (what AI can't do)
  - 🔀 Recommended Hybrid Approach workflow
- Initial Discovery Commands (manual grep/find patterns)
- Deep Dive Analysis section with example case studies
- Effectiveness Assessment with detailed 0-10 scoring rubric
- Common Implementation Patterns (7-8 patterns per control)
- Improvement Recommendations with descriptions (not code examples)
- Testing and Verification procedures
- **Use in Comparative Analysis** - Guidance for Phase 6 assessments
  - How to score both versions using the same rubric
  - Remediation quality assessment criteria
  - Evidence documentation templates for comparative reports
  - Remaining gaps identification
  - Control-specific verification testing
- Reporting Template

**Guide Breakdown:**
1. **RESILIENCE-1** (Root/Jailbreak Detection)
   - 8 detection patterns (SafetyNet, RootBeer, custom checks)
   - Enforcement vs. telemetry analysis (CRITICAL distinction)
   - Example: Bugsnag-based detection scored 2/10 (telemetry only)

2. **RESILIENCE-2** (Code Obfuscation)
   - 7 obfuscation levels (None → R8 → DexGuard)
   - ProGuard/R8 configuration analysis
   - Commercial tool comparison (DexGuard, iXGuard, Guardsquare)
   - Example: 0/10 (no obfuscation, all classes readable)

3. **RESILIENCE-3** (Anti-Debugging)
   - 7 anti-debugging techniques (TracerPid, Frida, timing, JDWP)
   - Native vs. Java implementation trade-offs
   - Multi-layer detection strategies
   - Example: 0/10 (no anti-debugging implemented)

4. **RESILIENCE-4** (Tamper Detection)
   - 8 integrity check types (signature, DEX, native, resources)
   - Expected value analysis (hardcoded vs. dynamic)
   - Multi-layer integrity checking
   - Example: 0/10 (no tamper detection)

**When to use these guides:**

| Scenario | Use Enhanced Guide? | Why |
|----------|---------------------|-----|
| First-time assessment of a RESILIENCE control | ✅ YES | Learn methodology, scoring rubric, what to look for |
| Complex implementation (multiple techniques) | ✅ YES | Detailed scoring criteria, pattern recognition |
| Need detailed report with justification | ✅ YES | Comprehensive evidence examples, reporting template |
| Writing remediation guidance | ✅ YES | Implementation descriptions, configuration guidance, best practices |
| **Comparative analysis (Phase 6)** | ✅ **YES** | **Scoring rubrics, remediation quality criteria, evidence templates** |
| Quick triage (clear PASS/FAIL) | ⚠️ OPTIONAL | Workflow guide has enough for obvious cases |
| Straightforward finding (e.g., no obfuscation) | ⚠️ OPTIONAL | Workflow guide provides basic scoring |

**Relationship to Workflow Guide:**
```
ASSESSMENT_WORKFLOW.md (Phase 4: MASVS Analysis)
│
├── Step 4.1: RESILIENCE-1 (Root Detection)
│   ├── Quick check commands
│   ├── Basic AI prompt
│   └── 📖 Link to MASVS-RESILIENCE-1-enhanced.md for deep dive
│
├── Step 4.2: RESILIENCE-2 (Obfuscation)
│   ├── Quick check commands
│   ├── Basic AI prompt
│   └── 📖 Link to MASVS-RESILIENCE-2-enhanced.md for deep dive
│
├── Step 4.3: RESILIENCE-3 (Anti-Debugging)
│   ├── Quick check commands
│   ├── Basic AI prompt
│   └── 📖 Link to MASVS-RESILIENCE-3-enhanced.md for deep dive
│
└── Step 4.4: RESILIENCE-4 (Tamper Detection)
    ├── Quick check commands
    ├── Basic AI prompt
    └── 📖 Link to MASVS-RESILIENCE-4-enhanced.md for deep dive
```

**Best Practice:**
1. Start with ASSESSMENT_WORKFLOW.md Phase 4
2. Use quick checks/prompts for initial discovery
3. If finding is complex or for detailed report → Open the enhanced guide
4. Use enhanced guide's scoring rubric and AI prompts
5. Return to workflow guide to complete assessment

#### 🗺️ OWASP_MASVS_MAPPING.md (Reference)

**File:** `analysis-guides/OWASP_MASVS_MAPPING.md`

**Purpose:** Complete OWASP MASVS v2.0 control reference and mapping guide

**When to use:**
- ✅ Understanding MASVS control categories and requirements
- ✅ Mapping findings to specific MASVS controls
- ✅ Creating MASVS compliance matrices in reports
- ✅ Explaining MASVS framework to stakeholders

### Assessment Templates

This repository provides comprehensive templates for assessment artifacts:

**Templates Available:**
- Security Assessment Report (`templates/REPORT_TEMPLATE.md`)
- Comparative Analysis Report (`templates/COMPARATIVE_TEMPLATE.md`)
- Finding Templates (`templates/findings/`)
- MASVS Controls Mapping (`templates/masvs/`)

**What to learn from templates:**
- Report structure and formatting standards
- How to document findings with evidence (file:line references)
- CVSS scoring methodology with justifications
- MASVS controls mapping approach
- Remediation recommendation formats

## Using AI Assistants for Assessments

**Prerequisites:**
- You've already read [GETTING_STARTED.md](GETTING_STARTED.md)
- You've created an assessment using `create_new_assessment.sh`
- You're now conducting the assessment with AI assistance

**This is NOT the assessment workflow** - see [GETTING_STARTED.md](GETTING_STARTED.md) for the complete workflow.

### When to Use AI During Assessments

| Assessment Phase | AI Capability | Manual Required? |
|-----------------|---------------|------------------|
| **Phase 1: Setup & Decompilation** | ❌ Not helpful | ✅ Manual only (JADX, APKTool) |
| **Phase 2: Initial Reconnaissance** | ⚠️ AI can read AndroidManifest.xml | ✅ Yes - validate findings |
| **Phase 3: Vulnerability Hunting** | ✅ Excellent for pattern searches | ✅ Yes - eliminate false positives |
| **Phase 4: MASVS Analysis** | ⚠️ Can find security code | ✅ Yes - analyze enforcement logic |
| **Phase 5: Documentation** | ✅ Excellent for report generation | ✅ Yes - review and sanitize |
| **Phase 6: Comparative Analysis** | ✅ Excellent for finding status checks | ✅ Yes - assess remediation quality |

### AI Workflow Best Practices

**Do:**
- ✅ Use AI for pattern-based searches across large codebases
- ✅ Ask AI to draft reports and calculate CVSS scores
- ✅ Request AI to find configuration files and API endpoints
- ✅ Have AI generate remediation recommendations
- ✅ Use AI to format documentation and create summaries
- ✅ **Verify all AI findings manually** before including in final report

**Don't:**
- ❌ Trust AI to determine enforcement vs. telemetry (requires manual code review)
- ❌ Accept CVSS scores without understanding the justification
- ❌ Skip manual review of AndroidManifest.xml (contains critical findings)
- ❌ Assume all AI search results are true positives (false positives are common)
- ❌ Let AI make final risk assessment decisions (requires human judgment)

## Common Workflows

### Analyzing Decompiled Code

**Search for security-sensitive patterns:**
```bash
# Find hardcoded credentials
grep -r "password\|secret\|key\|token" decompiled/sources/

# Find authentication logic
find decompiled/sources -path "*/login/*" -name "*.java"

# Find Constants files
find decompiled/sources -name "*Constants.java"
```

### OWASP MASVS-RESILIENCE Analysis

**Use enhanced guides for detailed analysis:**

1. **RESILIENCE-1 (Root/Jailbreak Detection):**
   - Review `analysis-guides/MASVS-RESILIENCE-1-enhanced.md`
   - Search: `grep -r "root\|jailbreak\|isRooted" decompiled/sources/`

2. **RESILIENCE-2 (Code Obfuscation):**
   - Review `analysis-guides/MASVS-RESILIENCE-2-enhanced.md`
   - Check: `find decompiled/sources -name "*Login*.java"` (if found = NO obfuscation)

3. **RESILIENCE-3 (Anti-Debugging):**
   - Review `analysis-guides/MASVS-RESILIENCE-3-enhanced.md`
   - Search: `grep -r "isDebuggerConnected\|frida\|xposed" decompiled/sources/ -i`

4. **RESILIENCE-4 (Tamper Detection):**
   - Review `analysis-guides/MASVS-RESILIENCE-4-enhanced.md`
   - Search: `grep -r "signature.*check\|integrity" decompiled/sources/ -i`

## File Naming Conventions

- `*_ASSESSMENT_REPORT.md` - Comprehensive security assessment reports
- `create_security_presentation.py` - Automated report generation scripts
- `*_Security_Assessment.pptx` - Generated presentation materials
- `decompiled/sources/` - Decompiled source code
- `decompiled/resources/` - Extracted application resources

## OWASP MASVS Analysis Conventions

This repository follows standardized conventions for OWASP MASVS v2.0 analysis:

- **File References:** Always use `file_path:line_number` format
- **Effectiveness Scoring:** 0-10 scale for RESILIENCE controls
- **Detection vs. Response:** Distinguish telemetry from security enforcement
- **Evidence Requirements:** File locations, command output, code snippets, quantitative data

See enhanced guides (`analysis-guides/MASVS-RESILIENCE-*-enhanced.md`) for detailed conventions.

## Security Best Practices

When working with this repository:
1. **Never commit actual binary files** to version control (except for archives)
2. **Sanitize reports** before external sharing (redact actual API keys if present)
3. **Respect responsible disclosure** timelines (90 days standard)
4. **Use findings ethically** for defensive security only
5. **Document evidence thoroughly** - Include file paths, line numbers, screenshots
6. **Verify findings** - Don't rely solely on automated tools
7. **Update CLAUDE.md** after each assessment with lessons learned

## Tools Referenced

**Decompilation:**
- **JADX** v1.5.0 - Dex to Java decompiler (primary tool)
- **APKTool** v2.12.1 - APK resource extraction and smali disassembly
- **class-dump** - Objective-C header extraction (iOS assessments)
- **Hopper Disassembler** - iOS binary analysis (iOS assessments)

**Analysis:**
- **grep/ripgrep** - Pattern-based code searching
- **find** - File system navigation
- **Claude Code** - AI-assisted analysis and documentation

**Reporting:**
- **python-pptx** - Presentation generation (tools/create_security_presentation.py)
- **Markdown** - Documentation format

**Version Control:**
- **git** - Repository management

## Quick Reference: Templates and Guides

This exemplar provides comprehensive templates and guides for assessments:

**Key Resources:**
- Report Templates (`templates/REPORT_TEMPLATE.md`, `templates/COMPARATIVE_TEMPLATE.md`)
- Finding Templates (`templates/findings/`)
- Enhanced MASVS Guides (`analysis-guides/MASVS-RESILIENCE-*.md`)
- Assessment Workflow (`analysis-guides/ASSESSMENT_WORKFLOW.md`)

**Use these resources when:**
- Structuring your own security assessment reports
- Understanding CVSS scoring methodology
- Mapping findings to OWASP MASVS v2.0 controls
- Writing remediation recommendations
- Creating executive summaries and email templates

---

## Using This Exemplar to Create New Assessments

**To start a new assessment, use the automated script:**

```bash
cd tools/
./create_new_assessment.sh \
  --name "MyApp" \
  --platform android \
  --version "1.0.0" \
  --package-id "com.example.myapp" \
  --assessor "Your Name"
```

This creates a new assessment directory (`../myapp-assessment/`) with:
- All templates and guides copied from exemplar
- Customized README.md and CLAUDE.md for your app
- Clean directories ready for your APK/IPA
- Git repository initialized (optional)

**After creating the assessment:**
1. Navigate to your new assessment directory
2. Place your APK/IPA in the `apk/` directory
3. Follow the workflow in `GETTING_STARTED.md` (copied to your assessment)
4. Use AI prompts from `CLAUDE.md` (customized for your app)
5. Document findings using templates in `templates/`

**See:** [GETTING_STARTED.md](GETTING_STARTED.md) for detailed setup and workflow instructions

## References

- **OWASP MASVS v2.0:** https://mas.owasp.org/MASVS/
- **OWASP MASTG:** https://mas.owasp.org/MASTG/
- **CVSS v3.1 Calculator:** https://www.first.org/cvss/calculator/3.1
- **CWE Database:** https://cwe.mitre.org/
- **Android Security:** https://developer.android.com/privacy-and-security
- **ProGuard/R8 Documentation:** https://developer.android.com/studio/build/shrink-code

---

## Document Version Information

**Exemplar Version:** 1.5
**Last Updated:** 2025-12-01
**Template Status:** ✅ Ready for use
**Recent Changes:**
- Added Phase 6 (Comparative Analysis) guidance throughout
- Updated enhanced guide descriptions to include "Use in Comparative Analysis" sections
- Added comparative analysis to AI capability table
- Added Phase 6 AI prompt for comparative assessments
- Updated "When to use these guides" table to include comparative analysis
- Clarified remediation recommendations use descriptions (not code examples)

---

## AI Prompts by Assessment Phase

Use these prompts when working with AI assistants (Claude Code, ChatGPT, etc.) during your assessment.

### Sample AI Prompts for Each Phase

**Phase 2 - AndroidManifest Analysis:**
```
Analyze decompiled/resources/AndroidManifest.xml for security issues:
1. Check usesCleartextTraffic setting
2. Find hardcoded API keys in <meta-data> tags
3. List exported components
4. Identify dangerous permissions
Provide findings with file:line references.
```

**Phase 3 - Hardcoded Secrets:**
```
Search decompiled/sources/sources/ for hardcoded secrets in com/[company]:
1. Find *Constants*.java and *Config*.java files
2. Search for API keys, tokens, passwords
3. Identify API base URLs
List findings with file:line references and code snippets.
```

**Phase 4 - Root Detection:**
```
Search for root detection in decompiled/sources/sources/:
1. Find code containing: root, isRooted, RootBeer, SafetyNet
2. Show detection methods with file:line references
Note: I will manually analyze if detection is enforced or telemetry-only.
```

**Phase 5 - Comprehensive Report Generation:**
```
Based on the security findings in this repository, please create a comprehensive
SECURITY_ASSESSMENT_REPORT.md file with OWASP MASVS v2.0 mappings.

Context: This is a security assessment of [APPLICATION_NAME] [Android/iOS]
application (version [X.X.X], package: [com.example.app]).

The report should follow this structure:

1. Executive Summary
   - Application information (name, version, package ID)
   - Assessment date and type
   - Key findings summary (count by severity)
   - Overall risk score
   - OWASP MASVS compliance overview

2. Assessment Methodology
   - Tools used (JADX, APKTool, etc.)
   - Analysis techniques
   - Scope of assessment
   - Standards applied (CVSS v3.1, OWASP MASVS v2.0, CWE)

3. Critical Security Risks (CVSS 9.0-10.0)
   For each finding include:
   - Title and severity
   - CVSS score with vector string
   - Location (file:line)
   - Detailed description
   - Technical evidence (code snippets from decompiled source)
   - Impact analysis (bullet points)
   - Attack scenario (step-by-step)
   - OWASP MASVS Mapping: Primary and secondary controls violated
   - CWE identifier(s)
   - OWASP Mobile Top 10 category
   - Remediation recommendations:
     * Immediate (24-48 hours)
     * Short-term (1-2 weeks)
     * Long-term (1-3 months)

4. High Security Risks (CVSS 7.0-8.9)
   Same structure as Critical

5. Medium Security Risks (CVSS 4.0-6.9)
   Same structure as Critical

6. Low Security Risks (CVSS 0.1-3.9)
   Brief descriptions with MASVS mapping

7. Risk Summary Table
   | Risk Level | Count | Remediation Timeframe |
   |------------|-------|----------------------|
   | CRITICAL   | X     | Immediate (24-48h)   |
   | HIGH       | X     | Urgent (1-2 weeks)   |
   | MEDIUM     | X     | Short-term (1 month) |
   | LOW        | X     | Next release         |

8. OWASP MASVS Coverage Analysis

   8.1 MASVS-RESILIENCE Controls Assessment
   | Control ID | Control Name | Status | Findings | Risk Level |
   |------------|--------------|--------|----------|------------|
   | RESILIENCE-1 | Runtime Integrity | ❌/✅ | Description | LEVEL |
   | RESILIENCE-2 | Impede Comprehension | ❌/✅ | Description | LEVEL |
   | RESILIENCE-3 | Impede Dynamic Analysis | ❌/✅ | Description | LEVEL |
   | RESILIENCE-4 | Impede Repackaging | ❌/✅ | Description | LEVEL |

   8.2 Complete MASVS Coverage Matrix
   | Category | Total Controls | Pass | Fail | Not Applicable | Coverage % |
   |----------|----------------|------|------|----------------|------------|
   | MASVS-STORAGE | 2 | X | X | X | X% |
   | MASVS-CRYPTO | 2 | X | X | X | X% |
   | MASVS-AUTH | 3 | X | X | X | X% |
   | MASVS-NETWORK | 2 | X | X | X | X% |
   | MASVS-PLATFORM | 3 | X | X | X | X% |
   | MASVS-CODE | 4 | X | X | X | X% |
   | MASVS-RESILIENCE | 4 | X | X | X | X% |
   | **TOTAL** | **20** | **X** | **X** | **X** | **X%** |

   8.3 Critical MASVS Gaps
   List of most critical missing controls requiring immediate attention

9. Detailed Remediation Roadmap
   - Phase 1: Emergency Response (24-48 hours)
   - Phase 2: Short-term Fixes (1-2 weeks)
   - Phase 3: Long-term Improvements (1-3 months)

10. Technical Recommendations
    - Code examples for fixes
    - Configuration recommendations
    - MASVS control implementation guidance
    - ProGuard/R8 configuration examples
    - Root detection implementation
    - Certificate pinning examples

11. Compliance Impact
    - PCI-DSS requirements affected
    - SOC 2 control violations
    - GDPR Article 32 compliance
    - OWASP MASVS v2.0 compliance status

12. Testing Recommendations
    - SAST tools (MobSF, Checkmarx, etc.)
    - DAST tools (Burp Suite, OWASP ZAP)
    - Manual testing approaches
    - MASVS verification testing procedures

13. Conclusion
    - Summary of critical issues
    - Overall security posture assessment
    - MASVS compliance status
    - Business risk summary
    - Immediate actions required

IMPORTANT:
- Use actual code snippets from decompiled source files
- Include specific file paths and line numbers
- Map ALL findings to OWASP MASVS v2.0 controls
- Emphasize RESILIENCE-1, RESILIENCE-2, RESILIENCE-3, and RESILIENCE-4
- Provide complete CVSS vector strings
- Include CWE identifiers for each finding
- Reference OWASP Mobile Top 10 categories

My validated findings to include:
[Provide your list of findings here]
```

**Phase 5 - MASVS-RESILIENCE Controls Mapping:**
```
Based on the MASVS-RESILIENCE analysis I've completed, create an OWASP_MASVS-RESILIENCE_Controls_Mapping.md file.

Application: [APP_NAME]
Platform: [Android/iOS]
Version: [X.X.X]
Assessment Date: [YYYY-MM-DD]

Use the template structure from templates/masvs/RESILIENCE_CONTROLS_MAPPING.md with these columns:
- Guard Category
- Guards
- Current State

My RESILIENCE findings to incorporate:
- RESILIENCE-1 (Root Detection): [Your findings]
- RESILIENCE-2 (Tamper Detection): [Your findings]
- RESILIENCE-3 (Obfuscation): [Your findings - include total class count]
- RESILIENCE-4 (Anti-Debugging): [Your findings]

For "Current State" column, use brief descriptions like:
- "Not present"
- "Detection present (via [SDK]), but no enforcement"
- "No code obfuscation. All [X,XXX] classes readable with descriptive names"
- "N/A (Android)" for iOS-specific guards on Android assessments

Mark platform-specific guards appropriately:
- Android: Mark "Jailbreak Detection" and "Swizzle Detection" as "N/A (Android)"
- iOS: Mark "Root Detection" as "N/A (iOS)" if assessing iOS
```

**Phase 6 - Comparative Analysis:**
```
I'm conducting comparative security analysis between two versions of [APP_NAME].

**Context:**
- Original version: v[X.X.X] assessed on [DATE]
- New version: v[Y.Y.Y] decompiled to: decompiled/sources/
- Original assessment report: [path or attachment]

**Original findings summary:**
[List or attach key findings from v1, including:
 - MASVS-RESILIENCE scores (e.g., RESILIENCE-1: 2/10, RESILIENCE-2: 0/10)
 - Critical/High findings
 - Specific vulnerabilities identified]

**Please help me:**

1. **Re-assess Each Original Finding in v[Y]:**
   - Search for the same vulnerability patterns in the new version
   - Determine status: Resolved / Partially Fixed / Unchanged / Regressed
   - Provide file:line evidence showing current state

2. **Score Remediation Quality (0-10):**
   - Use criteria from enhanced guides' "Use in Comparative Analysis" sections
   - 9-10: Excellent (root cause addressed, best practices followed)
   - 7-8: Good (issue fixed with minor gaps)
   - 4-6: Partial (some improvement, still exploitable)
   - 1-3: Poor (surface fix only)
   - 0: Unchanged

3. **Compare MASVS-RESILIENCE Scores:**
   - Re-score all 4 RESILIENCE controls for v[Y]
   - Use same scoring rubrics from enhanced guides
   - Show: v1 score → v2 score (change)
   - Example: RESILIENCE-1: 2/10 → 7/10 (+5 improvement)

4. **Identify New Vulnerabilities:**
   - Search for issues introduced in v[Y]
   - Check for regressions or new problems
   - Assess if remediation created vulnerabilities

5. **Calculate Security Improvement:**
   - Overall risk: v1 vs v2 (e.g., 7.8/10 → 5.2/10)
   - Percentage improvement
   - MASVS compliance change

6. **Document Evidence for COMPARATIVE_TEMPLATE.md:**
   - Detection method comparisons (v1 vs v2 file:line)
   - Enforcement comparisons
   - Code snippet comparisons
   - Effectiveness score justifications

**For each finding, provide:**
- Status in v[Y] with code evidence
- Remediation quality score and justification
- Remaining gaps if partially fixed
- References to enhanced guide sections used for scoring

**Important:**
- Use the same scoring rubrics from MASVS-RESILIENCE-*-enhanced.md guides
- Reference the "Use in Comparative Analysis" sections for methodology
- Provide file:line references for all evidence
- Distinguish between detection improvements and enforcement improvements
```

### Advanced Prompts

**Individual Finding Analysis with MASVS Mapping:**

Use this when you need detailed analysis of a specific vulnerability:

```
Analyze this security finding and provide comprehensive assessment with OWASP MASVS mapping:

**Finding:** [Brief description]
**File:** [path/to/file.java:123]
**Code Snippet:**
```[language]
[paste code here]
```

Please provide:

1. Severity Assessment
   - Severity level (CRITICAL/HIGH/MEDIUM/LOW)
   - CVSS v3.1 score with complete vector string
   - Justification for score

2. Detailed Description
   - What the vulnerability is
   - Why it's a security issue
   - Technical context

3. OWASP MASVS Mapping
   - Primary MASVS control(s) violated (with full control text)
   - Secondary MASVS control(s) affected
   - Specific focus on RESILIENCE-1, 2, 3, or 4 if applicable

4. Additional Classifications
   - CWE identifier(s) with descriptions
   - OWASP Mobile Top 10 category

5. Impact Analysis
   - Confidentiality impact
   - Integrity impact
   - Availability impact
   - Business impact
   - Compliance impact

6. Attack Scenario
   - Step-by-step exploitation process
   - Required attacker capabilities
   - Likelihood of exploitation

7. Remediation Recommendations
   - Immediate actions (24-48 hours) with code examples
   - Short-term fixes (1-2 weeks) with implementation guidance
   - Long-term improvements (1-3 months) with architecture changes
   - How to implement missing MASVS controls

8. Verification Testing
   - How to test that the vulnerability exists
   - How to verify the fix

9. References
   - OWASP MASVS control documentation
   - OWASP MSTG testing guidance
   - CWE reference
   - Industry best practices
```

### Continuous Improvement

**After each assessment:**
- Update CLAUDE.md with new lessons learned
- Document time savings from AI assistance
- Note any AI limitations encountered
- Share best practices with team

<!-- TEMPLATE_SHARED_CONTENT_END -->
