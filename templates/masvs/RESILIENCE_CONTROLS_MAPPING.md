# OWASP MASVS-RESILIENCE Controls - Mapping Table

**Application:** [APPLICATION_NAME]
**Platform:** [Android/iOS]
**Version:** [VERSION_NUMBER]
**Assessment Date:** [YYYY-MM-DD]

## Purpose

This mapping table provides a detailed breakdown of OWASP MASVS-RESILIENCE controls mapped to specific security guards (protective mechanisms). Use this table to:

- Track implementation status of individual security guards
- Identify specific gaps within each RESILIENCE control category
- Communicate findings to development teams with actionable detail
- Map assessment results to Application Security solutions

## Controls Mapping

| Guard Category | Guards | Current State |
|----------------|--------|---------------|
| **Unsafe Environment Guards** (OWASP MASVS-RESILIENCE-1) | Root Detection | [Detection status and enforcement level] |
| | Jailbreak Detection | [Detection status - N/A for Android] |
| | Emulator Detection | [Present/Not present] |
| | Virtualization Detection | [Present/Not present] |
| **Application Integrity Guards** (OWASP MASVS-RESILIENCE-2) | Checksum | [Signature verification or integrity checks status] |
| | Resource Verification | [Resource integrity verification status] |
| | Signature Check | [APK/IPA signature verification status] |
| | Code Lifting Detection | [Detection of code extraction attempts] |
| | Repair and Damage Guard | [Self-healing or damage response status] |
| **Obfuscation Guards** (OWASP MASVS-RESILIENCE-3) | String Encryption | [Encrypted/Readable cleartext] |
| | Code Obfuscation | [Obfuscation status with class count if applicable] |
| | Control Flow Obfuscation | [Flow obfuscation status] |
| | Resource Encryption | [Resource encryption status] |
| | Class Encryption | [Class-level encryption status] |
| | Numeric Literal Hiding | [Numeric constant protection status] |
| | Renaming | [Class/method renaming status with examples] |
| **Instrumentation Detection Guards** (OWASP MASVS-RESILIENCE-4) | Debugger Detection | [Debugger detection status] |
| | Dynamic Instrument Toolkit | [Frida/dynamic instrumentation detection] |
| | Hook Detection | [Method hooking detection status] |
| | Swizzle Detection | [Method swizzling detection - N/A for Android] |

---

## Current State Guidelines

Use these descriptions in the "Current State" column:

### RESILIENCE-1 (Unsafe Environment Guards)
- **Detection present, enforced:** "Detection present with enforcement (app terminates/blocks functionality)"
- **Detection present, no enforcement:** "Detection present (via [SDK_NAME]), but no enforcement"
- **Not present:** "Not present"
- **N/A:** "N/A (Android)" or "N/A (iOS)" for platform-specific guards

### RESILIENCE-2 (Application Integrity Guards)
- **Implemented:** "Signature verification present at [location]"
- **Partial:** "Basic checksum only, no comprehensive integrity verification"
- **Not present:** "No signature verification or integrity checks"

### RESILIENCE-3 (Obfuscation Guards)
- **Full obfuscation:** "Obfuscated (DexGuard/commercial tool)"
- **Standard obfuscation:** "R8/ProGuard obfuscation applied"
- **Partial:** "Partial obfuscation, [X] classes still readable"
- **None:** "No code obfuscation. All [X,XXX] classes readable with descriptive names"
- **String encryption:** "Readable cleartext" or "Strings encrypted"

### RESILIENCE-4 (Instrumentation Detection Guards)
- **Present:** "Detection present with response action"
- **Partial:** "Basic detection, easily bypassable"
- **Not present:** "Not present"

---

## Scoring Reference

| Score Range | Status | Description |
|-------------|--------|-------------|
| 8-10 | PASS | Comprehensive implementation with multiple layers |
| 5-7 | PARTIAL | Basic implementation with gaps |
| 1-4 | WEAK | Minimal implementation, easily bypassable |
| 0 | FAIL | No implementation detected |

---

## Related Documents

- **Full Assessment Report:** `SECURITY_ASSESSMENT_REPORT.md`
- **MASVS Reference:** `analysis-guides/OWASP_MASVS_MAPPING.md`
- **Enhanced Guides:** `analysis-guides/MASVS-RESILIENCE-{1,2,3,4}-enhanced.md`

---

**Template Version:** 1.0
**Created:** [YYYY-MM-DD]
**Last Updated:** [YYYY-MM-DD]
