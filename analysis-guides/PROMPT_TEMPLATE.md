# Security Assessment Repository Analysis Prompt Template

> **⚠️ DEPRECATED - This file is no longer maintained**
>
> **Use instead:** [CLAUDE.md](../CLAUDE.md) - Section "Sample AI Prompts for Each Phase"
>
> This template has been superseded by the integrated AI-assisted workflow documented in:
> - **[CLAUDE.md](../CLAUDE.md)** - Contains updated, comprehensive AI prompts for all phases
> - **[ASSESSMENT_WORKFLOW.md](ASSESSMENT_WORKFLOW.md)** - Integrated AI-assisted workflow guidance
>
> **Why deprecated:**
> - The new workflow integrates AI assistance throughout all phases (not just report generation)
> - CLAUDE.md is copied with the template repository (no need to generate it)
> - Phase-specific prompts in ASSESSMENT_WORKFLOW.md are more aligned with the hybrid approach
>
> **Migration:** All valuable prompts from this file have been integrated into CLAUDE.md under:
> - "Sample AI Prompts for Each Phase" (basic prompts)
> - "Advanced Prompts" (comprehensive report generation and individual finding analysis)
>
> **Last Updated:** 2025-11-14
> **Status:** Retained for reference only

---

## Legacy Content Below

This prompt template is designed for use with Claude Code when analyzing a security assessment repository. The prompts assume that the directory structure of the assessment repository has been set up.

This template includes prompts for the following scenarios:

- **Performing a NEW assessment** and providing reports
- **Analyzing an EXISTING assessment** repo to provide additional findings and reports

---
## Prompt for INITIAL Assessment and Documentation
Use this variant when starting a NEW assessment before analysis is complete:

```
Please create a CLAUDE.md file for this security assessment repository.

Context: This is a NEW security assessment repository for [APPLICATION_NAME]. The repository structure has been created but analysis is not yet complete.

What to add to CLAUDE.md:

1. **Repository Purpose**
   - Application being assessed: [APPLICATION_NAME]
   - Platform: [Android/iOS]
   - Package name/Bundle ID: [IDENTIFIER]
   - Version: [VERSION]

2. **Directory Structure**
   Document the following directories and their purposes:
   - apk/ or ipa/ - Original application packages
   - decompiled/ or sources/ - Decompiled source code
   - resources/ - Extracted resources
   - tools/ - Analysis and automation scripts
   - analysis-guides/ - Detailed guidance, commands and prompts
   - assessment-reports/ - Findings reports
   - assessment-resources/ - Screenshots and evidence
   
3. **Common Workflows**
   Include commands for:
   - Searching for hardcoded credentials
   - Finding authentication logic
   - Locating API endpoints
   - Identifying cryptographic implementations
   - Finding data storage code
   - Analyzing third-party libraries

4. **Tools Setup**
   Document how to:
   - Decompile the application
   - Run security analysis tools
   - Generate reports
   - Create presentations from findings

5. **Assessment Checklist**
   Create a checklist of security areas to assess:
   - [ ] Hardcoded credentials and API keys
   - [ ] Authentication and session management
   - [ ] Cryptographic implementations
   - [ ] Data storage security
   - [ ] Network communication security
   - [ ] Code obfuscation status
   - [ ] Third-party library vulnerabilities
   - [ ] Certificate pinning
   - [ ] Root/jailbreak detection
   - [ ] Debug and logging exposure

6. **Reporting Template**
   Reference the structure for security reports:
   - Executive Summary
   - Assessment Methodology
   - Findings (CRITICAL/HIGH/MEDIUM/LOW with OWASP MASVS mapping)
   - Technical Evidence
   - OWASP MASVS Coverage Analysis
   - Remediation Recommendations
   - Compliance Impact
```

---

## Prompt for EXISTING Assessment Analysis and Documentation

```
Please analyze this security assessment repository and create a CLAUDE.md file, which will be given to future instances of Claude Code to operate in this repository.

Context: This is a security assessment repository for analyzing mobile applications (Android APK or iOS IPA). It contains decompiled code, security findings, assessment reports, and related artifacts.

What to add to CLAUDE.md:

1. **Repository Purpose and Structure**
   - Clearly identify what application is being assessed
   - Document the directory structure (where APK/IPA, decompiled code, reports are located)
   - Explain the purpose of each major directory

2. **Key Components**
   - Location and description of decompiled source code
   - Location of security assessment reports and findings
   - Description of any automation scripts (presentation generators, analysis tools)
   - Important configuration files and their locations

3. **Common Commands and Workflows**
   - Commands for searching decompiled code for vulnerabilities
   - How to locate security-sensitive code patterns (auth, crypto, storage)
   - Commands for analyzing specific security concerns
   - File paths to commonly examined security-critical files

4. **Security Findings Summary**
   - High-level overview of critical findings (if assessment is complete)
   - Reference to detailed security reports
   - CVSS scores and severity classifications

5. **Architecture and Code Patterns**
   - Application architecture (MVVM, MVC, etc.)
   - Key frameworks and libraries identified
   - Authentication/authorization patterns
   - Data storage patterns
   - Network communication patterns

6. **Tools and Techniques**
   - Tools used for decompilation (JADX, APKTool, Hopper, etc.)
   - Analysis tools referenced in assessments
   - Commands for running analysis scripts

7. **Security Best Practices**
   - Guidelines for working with sensitive findings
   - Responsible disclosure reminders
   - Ethical use constraints

Usage notes:
- If there's already a CLAUDE.md, suggest improvements to it
- Focus on the "big picture" architecture that requires reading multiple files to understand
- Avoid listing every component or file that can be easily discovered
- Don't include generic development practices unless they're specific to security assessment
- Include information from any existing README.md or assessment documentation
- Don't make up information - only document what exists in the repository
```

---

## Prompt: Generate Security Assessment Report with OWASP MASVS Mapping

Use this prompt after completing analysis to generate a comprehensive report that maps the findings and risks to well-known best practice guidance.

```
Based on the security findings in this repository, please create a comprehensive SECURITY_ASSESSMENT_REPORT.md file with OWASP MASVS v2.0 mappings.

Context: This is a security assessment of [APPLICATION_NAME] [Android/iOS] application (version [X.X.X], package: [com.example.app]). I have documented findings in [location of findings notes].

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
   - **OWASP MASVS Mapping:**
     - Primary control(s) violated
     - Secondary control(s) affected
   - **CWE identifier(s)**
   - **OWASP Mobile Top 10 category**
   - Remediation recommendations:
     - Immediate (24-48 hours)
     - Short-term (1-2 weeks)
     - Long-term (1-3 months)

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

   **8.1 MASVS-RESILIENCE Controls Assessment**
   | Control ID | Control Name | Status | Findings | Risk Level |
   |------------|--------------|--------|----------|------------|
   | RESILIENCE-1 | Runtime Integrity | ❌ FAIL/✅ PASS | Description | LEVEL |
   | RESILIENCE-2 | Impede Comprehension | ❌ FAIL/✅ PASS | Description | LEVEL |
   | RESILIENCE-3 | Impede Dynamic Analysis | ❌ FAIL/✅ PASS | Description | LEVEL |
   | RESILIENCE-4 | Impede Repackaging | ❌ FAIL/✅ PASS | Description | LEVEL |

   **8.2 Complete MASVS Coverage Matrix**
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

   **8.3 Critical MASVS Gaps**
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
    - HIPAA (if applicable)
    - OWASP MASVS v2.0 compliance status
    - Industry-specific standards

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

14. Appendix
    - A. Tools used in assessment
    - B. Key files examined
    - C. References (OWASP MASVS, MSTG, CVSS, CWE)
    - D. OWASP MASVS v2.0 control definitions
    - E. Contact information

IMPORTANT:
- Use actual code snippets from decompiled source files
- Include specific file paths and line numbers
- Map ALL findings to OWASP MASVS v2.0 controls
- Emphasize RESILIENCE-1, RESILIENCE-2, RESILIENCE-3, and RESILIENCE-4
- Provide complete CVSS vector strings
- Include CWE identifiers for each finding
- Reference OWASP Mobile Top 10 categories
```

---

## Prompt: Analyze Specific Finding with MASVS Mapping

Use this prompt to get detailed analysis of individual findings:

```
Analyze this security finding and provide comprehensive assessment with OWASP MASVS mapping:

**Finding:** [Brief description]
**File:** [path/to/file.java:123]
**Code Snippet:**
```[language]
[paste code here]
```

Please provide:

1. **Severity Assessment**
   - Severity level (CRITICAL/HIGH/MEDIUM/LOW)
   - CVSS v3.1 score with complete vector string
   - Justification for score

2. **Detailed Description**
   - What the vulnerability is
   - Why it's a security issue
   - Technical context

3. **OWASP MASVS Mapping**
   - Primary MASVS control(s) violated (with full control text)
   - Secondary MASVS control(s) affected
   - Specific focus on RESILIENCE-1, 2, 3, or 4 if applicable

4. **Additional Classifications**
   - CWE identifier(s) with descriptions
   - OWASP Mobile Top 10 category

5. **Impact Analysis**
   - Confidentiality impact
   - Integrity impact
   - Availability impact
   - Business impact
   - Compliance impact

6. **Attack Scenario**
   - Step-by-step exploitation process
   - Required attacker capabilities
   - Likelihood of exploitation

7. **Remediation Recommendations**
   - Immediate actions (24-48 hours) with code examples
   - Short-term fixes (1-2 weeks) with implementation guidance
   - Long-term improvements (1-3 months) with architecture changes
   - How to implement missing MASVS controls

8. **Verification Testing**
   - How to test that the vulnerability exists
   - How to verify the fix

9. **References**
   - OWASP MASVS control documentation
   - OWASP MSTG testing guidance
   - CWE reference
   - Industry best practices
```

---

## Customization Instructions

When using these templates:

1. **Replace placeholders** with actual values:
   - `[APPLICATION_NAME]` - Name of the application being assessed
   - `[PLATFORM]` - Android, iOS, or cross-platform
   - `[IDENTIFIER]` - Package name (com.example.app) or Bundle ID
   - `[VERSION]` - Application version number

2. **Adjust directory paths** to match your repository structure

3. **Add platform-specific sections**:
   - For Android: Include AndroidManifest.xml analysis, ProGuard/R8 status
   - For iOS: Include Info.plist analysis, Swift/Objective-C indicators

4. **Include project-specific tools** if using custom analysis scripts

5. **Reference compliance requirements** if assessing for specific standards (PCI-DSS, HIPAA, etc.)

---

## Example Usage

### In Claude Code Terminal:

```bash
# Copy this prompt template to your new repository
cp PROMPT_TEMPLATE.md /path/to/new-assessment/

# Open Claude Code in the new repository directory
cd /path/to/new-assessment/

# Use the prompt with Claude Code (copy from PROMPT_TEMPLATE.md and paste)
# Claude will analyze the repository and create CLAUDE.md
```

### Using with Claude Code Chat:

1. Navigate to your assessment repository
2. Copy the appropriate prompt from this template
3. Paste into Claude Code
4. Review and refine the generated CLAUDE.md
5. Commit the CLAUDE.md to your repository

---

## Benefits of Using This Template

- **Consistency** across multiple assessment repositories
- **Onboarding** - New team members can quickly understand the repository
- **Context** for AI assistants - Claude Code can work more effectively
- **Documentation** - Maintains assessment methodology and findings
- **Reusability** - Quick setup for new assessments

---

## Maintenance

Update this template when you:
- Discover new effective analysis techniques
- Add new tools to your assessment workflow
- Identify additional security patterns to document
- Refine your reporting structure
- Add new compliance requirements
