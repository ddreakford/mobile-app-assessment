# Mobile Security Assessment - Quick Reference Commands

**One-page command reference for Android mobile app security assessments**

---

## 1. Initial Setup

```bash
# Extract XAPK (if applicable)
cd apk/ && unzip -l *.xapk && unzip -q *.xapk && ls -lh *.apk

# Decompile with JADX
jadx com.package.name.apk -d ../decompiled/sources/ --show-bad-code

# Extract resources with APKTool
apktool d com.package.name.apk -o ../decompiled/resources/ -f
```

---

## 2. AndroidManifest.xml Analysis

```bash
cd decompiled/resources/

# Critical: Check cleartext traffic
grep "usesCleartextTraffic" AndroidManifest.xml

# Find exposed API keys in metadata
grep -A 2 "<meta-data" AndroidManifest.xml | grep "value="

# Find exported components
grep "android:exported=\"true\"" AndroidManifest.xml

# Check permissions
grep "<uses-permission" AndroidManifest.xml

# Deep links
grep -A 5 "android.intent.action.VIEW" AndroidManifest.xml
```

---

## 3. Hardcoded Secrets Search

```bash
cd decompiled/sources/sources/

# Find config files
find . -name "*Constants*.java" -o -name "*Config*.java" -o -name "*Key*.java"

# Search for credentials
grep -r "(api[_-]?key|password|secret|token)" com/company --include="*.java" -n

# Find API URLs
grep -r "https://" com/company --include="*.java" | grep -i "api\|base\|url"

# Check specific files
cat com/company/core/model/constants/Constants.java
cat com/company/api/ApiConstants.java
```

---

## 4. Code Obfuscation Check (RESILIENCE-2)

```bash
# Quick check: Look for readable class names
find . -name "*Login*.java" -o -name "*Auth*.java" -o -name "*Main*.java"

# If found → NO OBFUSCATION (FAIL)
# If not found → Check deeper

# Look for ProGuard mapping
find . -name "mapping.txt" -o -name "proguard-mapping.txt"

# Examine package structure
ls -la com/company/features/authentication/
```

**Scoring:**
- Readable names: 0/10 (FAIL)
- Obfuscated: 5-7/10 (PARTIAL)
- DexGuard: 8-10/10 (PASS)

---

## 5. Root Detection (RESILIENCE-1)

```bash
# Search for root detection
grep -ri "root\|isRooted\|RootBeer" com/company | grep -v "MainActivity"

# Check SafetyNet
grep -ri "SafetyNet\|attestation" com/company

# Find root detector classes
find . -name "*Root*.java" | grep -v "androidx"

# Review Bugsnag (common location)
cat com/bugsnag/android/RootDetector.java
```

**Check Enforcement:**
- Telemetry only: 2/10 (PARTIAL)
- Blocks execution: 6-8/10 (PASS)

---

## 6. Anti-Debugging (RESILIENCE-3)

```bash
# Search for debugger detection
grep -ri "isDebugger\|Debug.isDebugger\|waitingForDebugger" com/company

# Frida/Xposed detection
grep -ri "frida\|xposed\|substrate" com/company

# TracerPid checks
grep -ri "TracerPid\|ptrace" com/company

# Check manifest
grep "debuggable" ../resources/AndroidManifest.xml
```

**Scoring:**
- No checks: 0/10 (FAIL)
- Basic checks: 4-6/10 (PARTIAL)
- Multiple techniques: 7-10/10 (PASS)

---

## 7. Tamper Detection (RESILIENCE-4)

```bash
# Signature verification
grep -ri "signature\|checkSignature\|GET_SIGNATURES" com/company

# Integrity checks
grep -ri "integrity\|tamper\|checksum" com/company

# Package info with signatures
grep -ri "getPackageInfo" com/company -A 5 | grep -i "sign"
```

**Scoring:**
- No checks: 0/10 (FAIL)
- Basic signature check: 5-7/10 (PARTIAL)
- Multi-layer checks: 8-10/10 (PASS)

---

## 8. Additional Vulnerability Searches

```bash
# SQL Injection
grep -r "rawQuery\|execSQL" com/company --include="*.java" -A 5

# Insecure Random
grep -r "new Random()" com/company --include="*.java"

# Logging sensitive data
grep -r "Log\.[devi].*password\|Log\.[devi].*token" com/company --include="*.java"

# Backup enabled
grep "allowBackup" ../resources/AndroidManifest.xml

# WebView security
grep -r "setJavaScriptEnabled\|addJavascriptInterface" com/company --include="*.java"

# SSL/TLS issues
grep -r "TrustManager\|HostnameVerifier" com/company --include="*.java" -A 10
```

---

## 9. Quick Statistics

```bash
cd decompiled/sources/sources/

# Count total classes
find . -name "*.java" | wc -l

# Count application classes only
find ./com/company -name "*.java" | wc -l

# Show package structure
find ./com/company -type d -maxdepth 3 | sort

# File sizes
du -sh decompiled/sources/
du -sh decompiled/resources/
```

---

## 10. CVSS Quick Reference

**Severity Levels:**
- **CRITICAL:** 9.0-10.0
- **HIGH:** 7.0-8.9
- **MEDIUM:** 4.0-6.9
- **LOW:** 0.1-3.9

**Common Scores:**
- Cleartext traffic: 8.6 (HIGH)
- Exposed API keys: 7.5 (HIGH)
- No obfuscation: 7.3 (HIGH)
- No root detection: 5.3 (MEDIUM)
- No anti-debug: 5.3 (MEDIUM)
- No tamper detection: 5.3 (MEDIUM)

**CVSS Calculator:** https://www.first.org/cvss/calculator/3.1

---

## 11. MASVS Effectiveness Scoring

**0-10 Scale:**
- **0-2:** Telemetry only, no enforcement (FAIL)
- **3-4:** Minimal protection, easily bypassed (FAIL)
- **5-7:** Moderate protection, requires effort to bypass (PARTIAL)
- **8-10:** Strong protection, difficult to bypass (PASS)

**Key Distinction:** Detection vs. Enforcement
- Just logs/reports = TELEMETRY (score ≤3)
- Blocks execution = ENFORCEMENT (score ≥6)

---

## 12. Common File Locations

**Configuration:**
- `AndroidManifest.xml` (decompiled/resources/)
- `BuildConfig.java` (multiple locations)
- `*Constants.java` (*/constants/)
- `*Config.java` (*/config/)

**Security Code:**
- `*/security/` packages
- Third-party libs (Bugsnag, SafetyNet)
- Application class (`*Application.java`)

**Authentication:**
- `*/auth*/` or `*/authentication*/` packages
- `*LoginViewModel.java`
- `*SessionManager.java`

---

## 13. Report File Locations

```bash
# View assessment report
cat assessment-reports/SECURITY_ASSESSMENT_REPORT.md

# View README
cat README.md

# View AI guidance
cat CLAUDE.md

# View workflow guide
cat analysis-guides/ASSESSMENT_WORKFLOW.md
```

---

## 14. Time Tracking

Track actual time for continuous improvement:

| Phase | Estimated | Actual |
|-------|-----------|--------|
| Setup & Decompilation | 30-60 min | ___ min |
| Initial Reconnaissance | 30-45 min | ___ min |
| Vulnerability Hunting | 2-3 hours | ___ hours |
| MASVS Analysis | 1-2 hours | ___ hours |
| Documentation | 2-3 hours | ___ hours |
| **Total** | **6-10 hours** | **___ hours** |

---

## 15. Emergency Remediation Commands

**For developers to fix critical issues:**

```gradle
// build.gradle - Disable cleartext traffic
android {
    defaultConfig {
        // Add to manifest via build
    }
}
```

```xml
<!-- AndroidManifest.xml -->
<application
    android:usesCleartextTraffic="false"
    android:networkSecurityConfig="@xml/network_security_config">
```

```gradle
// build.gradle - Enable obfuscation
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'),
                         'proguard-rules.pro'
        }
    }
}
```

---

## 16. Useful One-Liners

```bash
# Count exported components
grep -c "android:exported=\"true\"" decompiled/resources/AndroidManifest.xml

# List all permissions
grep "<uses-permission" decompiled/resources/AndroidManifest.xml | \
    sed 's/.*android:name="\([^"]*\)".*/\1/' | sort

# Find all API keys in manifest
grep "API_KEY\|api_key\|ApiKey" decompiled/resources/AndroidManifest.xml

# Quick obfuscation test
ls decompiled/sources/sources/com/*/*/viewmodel/*.java 2>/dev/null | head -5

# Check for test/debug code in release
find decompiled/sources/sources/com/company -name "*Test*.java" -o -name "*Debug*.java"
```

---

**Version:** 1.0
**Last Updated:** 2025-11-13
**Keep this reference handy during assessments!**
