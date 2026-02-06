# Mobile Security Assessment Exemplar

**Purpose:** Template and reference for conducting mobile application security assessments

This exemplar repository provides:
- **Complete assessment workflow and methodology** - Step-by-step guides for Android/iOS
- **Enhanced OWASP MASVS-RESILIENCE analysis guides** - Deep-dive into each control
- **Templates for reports and documentation** - Professional security assessment reporting
- **Tools and automation scripts** - Streamline the assessment process
- **Best practices and lessons learned** - Gleaned from real-world assessments

> **Note:** This exemplar contains **process guidance only** (templates, guides, tools). The `apk/`, `decompiled/`, `output/`, and `assessment-resources/` directories are empty placeholders that will be populated when you create a new assessment from this template.

---

## 🚀 Quick Start

**New to mobile security assessments?**
→ Start here: [GETTING_STARTED.md](GETTING_STARTED.md)

**Experienced assessor creating another assessment?**
→ Jump to: [Create New Assessment](#using-this-exemplar)

---

## 📖 Documentation

### Essential Documents (Read in Order)

1. **[GETTING_STARTED.md](GETTING_STARTED.md)** - Setup tools, create assessment, conduct analysis
   - Part 1: Tool installation and repository setup (30-60 min)
   - Part 2: Your first assessment - step-by-step (6-10 hours)
   - **Time:** ~7-11 hours total for first assessment

2. **[CLAUDE.md](CLAUDE.md)** - AI assistant prompts and best practices
   - Read this if using AI (Claude Code, ChatGPT, etc.) to assist
   - Contains prompts for each assessment phase
   - Tips for effective AI collaboration
   - **Time:** 4-6 hours with AI assistance

3. **[ASSESSMENT_WORKFLOW.md](analysis-guides/ASSESSMENT_WORKFLOW.md)** - Detailed methodology reference
   - Deep dive into each assessment phase
   - Advanced techniques and edge cases
   - Use as reference during assessment

### Optional Documents

- **Enhanced MASVS Guides:** See `analysis-guides/MASVS-RESILIENCE-*.md` for deep-dive analysis
- **Team Setup:** See [GETTING_STARTED.md](GETTING_STARTED.md) for organizational setup options

---

## Directory Structure

```
mobile-security-framework/
├── analysis-guides/       # OWASP MASVS enhanced guides and workflow
│   ├── ASSESSMENT_WORKFLOW.md          # Step-by-step assessment methodology
│   ├── MASVS-RESILIENCE-1-enhanced.md  # Root/Jailbreak Detection deep-dive
│   ├── MASVS-RESILIENCE-2-enhanced.md  # Code Obfuscation deep-dive
│   ├── MASVS-RESILIENCE-3-enhanced.md  # Anti-Debugging deep-dive
│   ├── MASVS-RESILIENCE-4-enhanced.md  # Tamper Detection deep-dive
│   ├── OWASP_MASVS_MAPPING.md          # MASVS v2.0 control reference
│   ├── PROMPT_TEMPLATE.md              # AI prompt templates
│   ├── QUICK_REFERENCE_COMMANDS.md     # Common analysis commands
│   └── sanitize_guides.py              # Script to remove sensitive content
├── templates/             # Report and documentation templates
│   ├── REPORT_TEMPLATE.md              # Main security assessment report
│   ├── COMPARATIVE_TEMPLATE.md         # Before/after analysis report
│   ├── findings/                       # Individual finding templates
│   │   └── hardcoded-credentials.md    # Example finding template
│   ├── masvs/                          # MASVS compliance templates
│   │   └── RESILIENCE_CONTROLS_MAPPING.md
│   └── email/                          # Email summary templates
│       └── assessment_results_email_summary.txt
├── tools/                 # Analysis automation and utility scripts
│   ├── create_new_assessment.sh        # Create new assessment from exemplar
│   ├── check-dependencies.sh           # Verify required tools installed
│   ├── decompile.sh                    # APK/IPA decompilation wrapper
│   ├── quick-scan.sh                   # Fast security scan
│   └── search-credentials.sh           # Find hardcoded secrets
├── docs/                  # Additional documentation
│   ├── FAQ.md                          # Frequently asked questions
│   └── TROUBLESHOOTING.md              # Common issues and solutions
├── apk/                   # [EMPTY] Placeholder for APK/IPA files
├── decompiled/            # [EMPTY] Placeholder for decompiled source
├── output/                # [EMPTY] Placeholder for analysis outputs
├── assessment-resources/  # [EMPTY] Placeholder for screenshots/evidence
├── .claude/               # Claude Code configuration
├── .claude_instructions   # Claude Code project instructions
├── .gitignore             # Git ignore patterns
├── CONTRIBUTING.md        # Contribution guidelines
├── GETTING_STARTED.md     # Setup and assessment guide
├── CLAUDE.md              # AI assistant guidance
├── LICENSE                # Repository license
└── README.md              # This file
```

**Note:** Directories marked `[EMPTY]` are placeholders. When you create a new assessment using `tools/create_new_assessment.sh`, these directories will be copied to your assessment project where you'll add your APK files, decompiled code, and findings.

## Using This Exemplar

### To Create a New Assessment

Use the automated setup script:

```bash
cd tools/
./create_new_assessment.sh \
  --name "MyApp" \
  --platform android \
  --version "1.0.0" \
  --package-id "com.example.myapp" \
  --assessor "Your Name"
```

This creates a new assessment directory with:
- All templates and guides copied from exemplar
- Customized README and CLAUDE.md
- Clean directories ready for your APK/IPA
- Git repository initialized (optional)

### Assessment Workflow Overview

1. **Setup & Decompilation** (30-60 min)
   - Place APK/IPA in appropriate directory
   - Decompile with JADX and APKTool
   - Verify decompilation success

2. **Initial Reconnaissance** (30-60 min)
   - Analyze AndroidManifest.xml / Info.plist
   - Explore code structure
   - Identify main packages

3. **Vulnerability Hunting** (2-4 hours)
   - Search for hardcoded credentials
   - Identify insecure configurations
   - Find potential vulnerabilities

4. **MASVS-RESILIENCE Analysis** (2-3 hours)
   - Assess root/jailbreak detection
   - Evaluate code obfuscation
   - Test anti-debugging mechanisms
   - Verify tamper detection

5. **Documentation** (2-4 hours)
   - Generate security assessment report
   - Create MASVS controls mapping
   - Provide remediation recommendations

**See:** [ASSESSMENT_WORKFLOW.md](analysis-guides/ASSESSMENT_WORKFLOW.md) for detailed instructions

## References

- [OWASP MASVS v2.0](https://mas.owasp.org/MASVS/)
- [OWASP Mobile Security Testing Guide](https://mas.owasp.org/MASTG/)
- [CVSS v3.1 Calculator](https://www.first.org/cvss/calculator/3.1)
- [CWE Database](https://cwe.mitre.org/)

## Standards and Best Practices

This exemplar follows:
- **OWASP MASVS v2.0** - Mobile Application Security Verification Standard
- **OWASP MSTG** - Mobile Security Testing Guide
- **CVSS v3.1** - Common Vulnerability Scoring System
- **CWE** - Common Weakness Enumeration

### Security and Ethics

When conducting assessments:
- Only assess applications you're **authorized to test**
- Follow **responsible disclosure** practices (90-day timelines)
- **Sanitize sensitive data** before sharing reports
- Use findings for **defensive security only**
- Respect **authorization boundaries** and legal requirements

---

**Exemplar Version:** 1.5
**Last Updated:** 2026-02-05
**Maintained By:** Dwayne Dreakford
**Change:** Removed assessment artifacts to separate process guidance from actual assessment results 
