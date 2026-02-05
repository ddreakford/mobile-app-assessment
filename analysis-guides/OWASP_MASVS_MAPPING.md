# OWASP MASVS Mapping Guide for Security Assessments

This guide explains how to map security findings to OWASP Mobile Application Security Verification Standard (MASVS) controls, with emphasis on RESILIENCE categories.

---

## Understanding CVSS vs OWASP MASVS

### CVSS (Common Vulnerability Scoring System)
- **Purpose**: Quantifies **severity** of vulnerabilities (0.0-10.0)
- **Answers**: "How bad is this vulnerability?"
- **Used for**: Risk prioritization, remediation timelines
- **Output**: Numerical score + severity rating (CRITICAL/HIGH/MEDIUM/LOW)

### OWASP MASVS (Mobile Application Security Verification Standard)
- **Purpose**: Categorizes **security control** requirements
- **Answers**: "What security control is this related to?"
- **Used for**: Compliance, security requirements baseline
- **Output**: Control category (STORAGE-1, CRYPTO-2, RESILIENCE-3, etc.)

### Relationship

```
Security Finding = CVSS Score + OWASP MASVS Control(s) + CWE

Example:
Finding: "Application lacks code obfuscation"
├─ CVSS Score: 7.5 (HIGH)           ← Severity/Risk
├─ OWASP MASVS: RESILIENCE-2        ← Control Category
├─ CWE: CWE-656                     ← Weakness Type
└─ OWASP Mobile Top 10: M7          ← Top Risk Category
```

**Benefits of Combined Mapping**:
- **CVSS**: Drives remediation priority (fix 9.8 before 4.2)
- **MASVS**: Ensures comprehensive security coverage (did we address all controls?)
- **CWE**: Links to knowledge base and remediation patterns
- **Mobile Top 10**: Executive communication and trend analysis

---

## OWASP MASVS v2.0 Categories

### Primary Categories

| Category | Focus Area | Control Count |
|----------|------------|---------------|
| **MASVS-STORAGE** | Data storage and privacy | 2 controls |
| **MASVS-CRYPTO** | Cryptography | 2 controls |
| **MASVS-AUTH** | Authentication and authorization | 3 controls |
| **MASVS-NETWORK** | Network communication | 2 controls |
| **MASVS-PLATFORM** | Platform interaction | 3 controls |
| **MASVS-CODE** | Code quality | 4 controls |
| **MASVS-RESILIENCE** | Reverse engineering resistance | 4 controls |

### MASVS-RESILIENCE Controls (Detailed)

#### MASVS-RESILIENCE-1: Runtime Integrity
**Control**: The app validates the integrity of the platform and detects tampering.

**Requirements**:
- Root/jailbreak detection
- Runtime integrity checks
- System integrity validation
- Bootloader/firmware verification
- Emulator detection

**Example Findings**:
- ✗ No root detection implemented
- ✗ No jailbreak detection
- ✗ App runs on rooted devices without warning
- ✗ Missing emulator detection

**Code Patterns to Search**:
```bash
# Android
grep -r "RootBeer\|isRooted\|checkRoot" .
grep -r "su.*binary\|Superuser\|Magisk" .

# iOS
grep -r "jailbreak\|Cydia\|/Applications/Cydia.app" .
```

---

#### MASVS-RESILIENCE-2: Impede Comprehension
**Control**: The app implements anti-static analysis mechanisms to impede comprehension of the app's behavior.

**Requirements**:
- Code obfuscation (ProGuard/R8 for Android, Swift obfuscation for iOS)
- String encryption
- Control flow obfuscation
- Dead code insertion
- Class/method/variable name obfuscation

**Example Findings**:
- ✗ No code obfuscation enabled (ProGuard/R8 disabled)
- ✗ Readable class and method names
- ✗ String literals in plaintext
- ✗ Complete business logic visible after decompilation

**Code Patterns to Search**:
```bash
# Check if obfuscation is present
# Obfuscated code has short, meaningless names: a, b, c, a0, b1, etc.
ls decompiled/sources/  # Look for meaningful package names

# Check ProGuard/R8 configuration
find . -name "proguard-rules.pro"
find . -name "build.gradle" -exec grep "minifyEnabled" {} \;

# If you see clear names, obfuscation is likely missing
find . -name "*Login*.java" -o -name "*Password*.java"
```

---

#### MASVS-RESILIENCE-3: Impede Dynamic Analysis
**Control**: The app implements anti-dynamic analysis techniques to prevent debugging and runtime manipulation.

**Requirements**:
- Anti-debugging techniques
- Debugger detection
- Debug flag checks
- Frida/instrumentation detection
- Hooking detection
- Memory protection

**Example Findings**:
- ✗ No debugger detection
- ✗ App runs with debugger attached
- ✗ No Frida detection
- ✗ Missing anti-hooking mechanisms
- ✗ Debuggable flag enabled in release builds

**Code Patterns to Search**:
```bash
# Android - Check if debuggable
grep "android:debuggable" AndroidManifest.xml

# Anti-debugging code
grep -r "isDebuggerConnected\|Debug.isDebuggerConnected" .
grep -r "JDWP\|ptrace" .

# Frida detection
grep -r "frida\|xposed\|substrate" . -i
```

---

#### MASVS-RESILIENCE-4: Impede Repackaging
**Control**: The app validates its integrity to detect modification and repackaging.

**Requirements**:
- APK/IPA signature verification
- Code integrity checks
- Checksum validation
- Installation source verification
- Tamper detection

**Example Findings**:
- ✗ No signature verification at runtime
- ✗ App accepts modified/repackaged versions
- ✗ No checksum validation of critical files
- ✗ Missing tamper detection

**Code Patterns to Search**:
```bash
# Signature verification
grep -r "PackageManager.*GET_SIGNATURES\|signature" .
grep -r "getPackageInfo.*SIGNATURES" .

# Checksum/hash verification
grep -r "MessageDigest\|SHA-256\|checksum" .
grep -r "integrity.*check\|tamper.*detect" . -i
```

---

## Mapping Findings to MASVS

### Step-by-Step Mapping Process

**1. Identify the Finding**
```
Finding: Application lacks ProGuard/R8 code obfuscation
Location: Entire codebase - readable class/method names
```

**2. Determine CVSS Score**
```
CVSS v3.1: 7.5 (HIGH)
Vector: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N
```

**3. Map to OWASP MASVS**
```
Primary: MASVS-RESILIENCE-2 (Impede Comprehension)
Secondary: MASVS-CODE-4 (Code quality and build configuration)
```

**4. Map to CWE**
```
CWE-656: Reliance on Security Through Obscurity
```

**5. Map to OWASP Mobile Top 10**
```
M7: Insufficient Binary Protections (2016)
M10: Insufficient Cryptography (can be related)
```

---

## Complete Mapping Examples

### Example 1: Hardcoded Private Keys

```yaml
Finding: Hardcoded RSA Private Keys
Severity: CRITICAL
CVSS: 9.8
Location: resources/config_aws_jwt.properties

OWASP MASVS Mapping:
  Primary:
    - MASVS-STORAGE-1: The app securely stores sensitive data
    - MASVS-CRYPTO-2: The app performs key management according to industry best practices

  Secondary:
    - MASVS-CODE-2: The app is built and signed in a secure and reproducible way

CWE:
  - CWE-321: Use of Hard-coded Cryptographic Key
  - CWE-798: Use of Hard-coded Credentials

OWASP Mobile Top 10:
  - M2: Insecure Data Storage
  - M5: Insufficient Cryptography
```

### Example 2: Lack of Code Obfuscation

```yaml
Finding: No Code Obfuscation (ProGuard/R8 Disabled)
Severity: HIGH
CVSS: 7.5
Location: Entire application codebase

OWASP MASVS Mapping:
  Primary:
    - MASVS-RESILIENCE-2: Impede comprehension of app behavior

  Secondary:
    - MASVS-CODE-4: The app only uses software components without known vulnerabilities

CWE:
  - CWE-656: Reliance on Security Through Obscurity

OWASP Mobile Top 10:
  - M7: Poor Code Quality
  - M9: Reverse Engineering
```

### Example 3: No Root Detection

```yaml
Finding: Missing Root/Jailbreak Detection
Severity: MEDIUM
CVSS: 5.3
Location: Application startup/initialization

OWASP MASVS Mapping:
  Primary:
    - MASVS-RESILIENCE-1: The app validates runtime integrity

  Secondary:
    - MASVS-PLATFORM-2: The app uses platform APIs in a secure manner

CWE:
  - CWE-250: Execution with Unnecessary Privileges
  - CWE-273: Improper Check for Dropped Privileges

OWASP Mobile Top 10:
  - M1: Improper Platform Usage
  - M9: Reverse Engineering
```

### Example 4: Superuser Tokens in SharedPreferences

```yaml
Finding: Superuser Authentication Tokens Stored Insecurely
Severity: CRITICAL
CVSS: 9.1
Location: Constants.java:636-639, SharedPreferences storage

OWASP MASVS Mapping:
  Primary:
    - MASVS-STORAGE-1: The app securely stores sensitive data
    - MASVS-AUTH-2: The app performs local authentication securely

  Secondary:
    - MASVS-PLATFORM-1: The app uses IPC mechanisms securely
    - MASVS-RESILIENCE-1: Runtime integrity validation

CWE:
  - CWE-256: Plaintext Storage of a Password
  - CWE-311: Missing Encryption of Sensitive Data
  - CWE-522: Insufficiently Protected Credentials

OWASP Mobile Top 10:
  - M2: Insecure Data Storage
  - M4: Insecure Authentication
```

### Example 5: Exposed Cryptographic Implementation

```yaml
Finding: Exposed AWS4Signer Cryptographic Implementation
Severity: HIGH
CVSS: 7.3
Location: com/amazonaws/auth/AWS4Signer.java

OWASP MASVS Mapping:
  Primary:
    - MASVS-CRYPTO-1: The app uses strong cryptography according to industry best practices
    - MASVS-RESILIENCE-2: Impede comprehension of security mechanisms

  Secondary:
    - MASVS-CODE-4: Code quality and security
    - MASVS-NETWORK-1: Network communication security

CWE:
  - CWE-327: Use of a Broken or Risky Cryptographic Algorithm
  - CWE-656: Reliance on Security Through Obscurity

OWASP Mobile Top 10:
  - M5: Insufficient Cryptography
  - M9: Reverse Engineering
```

---

## MASVS Mapping Matrix

### Quick Reference Table

| Finding Type | CVSS Range | Primary MASVS | Secondary MASVS |
|--------------|------------|---------------|-----------------|
| Hardcoded keys/credentials | 9.0-10.0 | STORAGE-1, CRYPTO-2 | CODE-2 |
| Plaintext sensitive storage | 7.0-9.0 | STORAGE-1 | AUTH-2, PLATFORM-1 |
| Weak cryptography | 7.0-8.5 | CRYPTO-1 | STORAGE-1 |
| No code obfuscation | 7.0-8.0 | RESILIENCE-2 | CODE-4 |
| Exposed crypto implementation | 6.5-7.5 | CRYPTO-1, RESILIENCE-2 | NETWORK-1 |
| No certificate pinning | 6.0-7.5 | NETWORK-1 | NETWORK-2 |
| Missing root detection | 4.0-6.0 | RESILIENCE-1 | PLATFORM-2 |
| No anti-debugging | 4.0-6.0 | RESILIENCE-3 | CODE-4 |
| No tamper detection | 4.0-6.0 | RESILIENCE-4 | CODE-2 |
| Debug flags enabled | 4.0-5.5 | CODE-2, RESILIENCE-3 | PLATFORM-1 |
| Excessive logging | 3.0-5.0 | STORAGE-1 | CODE-4 |

---

## Updated Report Structure with MASVS Mapping

### Finding Template with MASVS

```markdown
### Finding #X: [Title]

**Severity:** CRITICAL
**CVSS Score:** 9.8 (CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)
**Location:** [file:line]

**OWASP MASVS Mapping:**
- **Primary Controls:**
  - MASVS-STORAGE-1: The app securely stores sensitive data
  - MASVS-CRYPTO-2: Key management best practices
- **Secondary Controls:**
  - MASVS-CODE-2: Secure build and signing

**CWE:**
- CWE-321: Use of Hard-coded Cryptographic Key
- CWE-798: Use of Hard-coded Credentials

**OWASP Mobile Top 10:**
- M2: Insecure Data Storage
- M5: Insufficient Cryptography

#### Description
[Detailed description]

#### Technical Evidence
```java
[Code snippet]
```

#### Impact
- [Impact details]

#### Remediation
[Remediation steps]
```

### MASVS Coverage Summary Section

Add this section to your security report:

```markdown
## OWASP MASVS Coverage Analysis

This section maps all identified findings to OWASP MASVS v2.0 controls.

### MASVS-RESILIENCE Controls Assessment

| Control ID | Control Name | Status | Findings | Risk Level |
|------------|--------------|--------|----------|------------|
| RESILIENCE-1 | Runtime Integrity | ❌ FAIL | No root detection implemented | MEDIUM |
| RESILIENCE-2 | Impede Comprehension | ❌ FAIL | No code obfuscation (Finding #3) | HIGH |
| RESILIENCE-3 | Impede Dynamic Analysis | ❌ FAIL | No anti-debugging mechanisms | MEDIUM |
| RESILIENCE-4 | Impede Repackaging | ❌ FAIL | No signature validation | MEDIUM |

### Complete MASVS Coverage Matrix

| Category | Total Controls | Pass | Fail | Not Applicable | Coverage |
|----------|----------------|------|------|----------------|----------|
| MASVS-STORAGE | 2 | 0 | 2 | 0 | 0% |
| MASVS-CRYPTO | 2 | 0 | 2 | 0 | 0% |
| MASVS-AUTH | 3 | 1 | 2 | 0 | 33% |
| MASVS-NETWORK | 2 | 0 | 2 | 0 | 0% |
| MASVS-PLATFORM | 3 | 1 | 2 | 0 | 33% |
| MASVS-CODE | 4 | 1 | 3 | 0 | 25% |
| MASVS-RESILIENCE | 4 | 0 | 4 | 0 | 0% |
| **TOTAL** | **20** | **3** | **17** | **0** | **15%** |

### Critical MASVS Gaps

**Immediate Attention Required:**
1. ❌ MASVS-STORAGE-1: Critical data stored in plaintext (Findings #1, #2)
2. ❌ MASVS-CRYPTO-2: Hardcoded private keys (Finding #1)
3. ❌ MASVS-RESILIENCE-2: Complete absence of obfuscation (Finding #3)

**High Priority:**
1. ❌ MASVS-NETWORK-1: Missing certificate pinning
2. ❌ MASVS-RESILIENCE-1: No runtime integrity checks
3. ❌ MASVS-CODE-2: Insecure build configuration
```

---

## MASVS Testing Checklist

### RESILIENCE-1: Runtime Integrity

- [ ] Root/jailbreak detection implemented
- [ ] Detection functions are protected/obfuscated
- [ ] App behavior changes on rooted devices
- [ ] Emulator detection implemented
- [ ] SafetyNet/Play Integrity API used (Android)
- [ ] DeviceCheck/App Attest used (iOS)

### RESILIENCE-2: Impede Comprehension

- [ ] ProGuard/R8 enabled with aggressive settings (Android)
- [ ] Swift obfuscation configured (iOS)
- [ ] Class names obfuscated (single letters or meaningless)
- [ ] Method names obfuscated
- [ ] String encryption implemented
- [ ] Control flow obfuscation applied
- [ ] Dead code insertion present

### RESILIENCE-3: Impede Dynamic Analysis

- [ ] Debugger detection implemented
- [ ] Debug flag disabled in release builds
- [ ] Frida detection implemented
- [ ] Xposed detection implemented (Android)
- [ ] Substrate detection implemented (iOS)
- [ ] Memory protection techniques used
- [ ] Anti-hooking mechanisms present

### RESILIENCE-4: Impede Repackaging

- [ ] APK/IPA signature verification at runtime
- [ ] Code integrity checks implemented
- [ ] Checksum validation for critical files
- [ ] Installation source verification
- [ ] Tamper detection mechanisms
- [ ] Response to tampering (app termination/server notification)

---

## Automation: Search Commands for MASVS

### Search for RESILIENCE Controls

```bash
#!/bin/bash
# Search for MASVS-RESILIENCE implementations

echo "=== MASVS-RESILIENCE-1: Runtime Integrity ==="
grep -r "root\|jailbreak\|Cydia\|su.*binary" decompiled/sources/ | wc -l
grep -r "SafetyNet\|PlayIntegrity\|DeviceCheck" decompiled/sources/ | wc -l

echo "=== MASVS-RESILIENCE-2: Code Obfuscation ==="
# Check for meaningful class names (indicates no obfuscation)
find decompiled/sources -name "*Login*.java" -o -name "*Password*.java" | wc -l

echo "=== MASVS-RESILIENCE-3: Anti-Debugging ==="
grep -r "isDebuggerConnected\|Debug.isDebuggerConnected" decompiled/sources/ | wc -l
grep -r "frida\|xposed\|substrate" decompiled/sources/ -i | wc -l

echo "=== MASVS-RESILIENCE-4: Tamper Detection ==="
grep -r "getPackageInfo.*SIGNATURES\|signature.*check" decompiled/sources/ | wc -l
grep -r "integrity.*check\|tamper" decompiled/sources/ -i | wc -l
```

---

## Claude Code Prompt: Generate MASVS Mapping

Use this prompt with Claude Code to automatically generate MASVS mappings:

```
Based on the security findings in this repository, please create an OWASP MASVS mapping section for the security report.

For each finding, provide:
1. Primary MASVS control(s) violated
2. Secondary MASVS control(s) affected
3. CWE identifier(s)
4. OWASP Mobile Top 10 category

Then create:
1. MASVS-RESILIENCE Controls Assessment table
2. Complete MASVS Coverage Matrix (all 7 categories)
3. Critical MASVS Gaps summary

Findings to map:
[List your findings here]

Use OWASP MASVS v2.0 control structure with emphasis on RESILIENCE-1, RESILIENCE-2, RESILIENCE-3, and RESILIENCE-4.
```

---

## References

- **OWASP MASVS v2.0**: https://mas.owasp.org/MASVS/
- **OWASP MSTG**: https://mas.owasp.org/MASTG/
- **CVSS v3.1 Calculator**: https://www.first.org/cvss/calculator/3.1
- **CWE Database**: https://cwe.mitre.org/
- **OWASP Mobile Top 10**: https://owasp.org/www-project-mobile-top-10/

---

**Version:** 1.0
**Last Updated:** 2025-10-30
**Standards:** OWASP MASVS v2.0, CVSS v3.1
