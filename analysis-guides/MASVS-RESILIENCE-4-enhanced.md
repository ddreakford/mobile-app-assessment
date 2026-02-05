# MASVS-RESILIENCE-4: Impede Repackaging (Tamper Detection) - Enhanced Analysis Guide

## Overview

**OWASP MASVS v2.0 Control**: RESILIENCE-4
**Category**: Anti-Tampering / Repackaging Detection
**MASVS-L2 Requirement**: The app detects modifications and terminates when tampered with

### What This Control Validates

MASVS-RESILIENCE-4 verifies that the application implements mechanisms to:
1. **Detect APK signature modifications** (repackaging detection)
2. **Verify code integrity at runtime** (DEX/classes integrity)
3. **Validate asset and resource integrity** (configuration files, native libraries)
4. **Monitor runtime environment** for hooking frameworks and code injection
5. **Respond appropriately to tampering** (terminate, alert server, degrade functionality)

### Why This Matters

Without tamper detection:
- Attackers can modify app binaries to bypass security controls
- Malware can be injected into legitimate apps and redistributed
- License checks, premium features, and DRM can be removed
- Security mechanisms (root detection, SSL pinning) can be disabled
- Malicious actors can distribute trojanized versions on third-party stores

---

## AI-Assisted Analysis Approach

This section provides guidance on using AI assistants (like Claude Code) to accelerate RESILIENCE-4 analysis while ensuring comprehensive tamper detection coverage.

### 🤖 Quick AI Prompt (5-10 minutes)

Use this prompt for initial tamper detection discovery:

```
Search for tamper detection mechanisms in decompiled/sources/sources/:

1. APK Signature verification:
   - Find: GET_SIGNATURES, GET_SIGNING_CERTIFICATES, PackageInfo.signatures
   - Show code checking signature hashes or certificate chains

2. DEX/APK integrity checks:
   - Find: classes.dex, base.apk with hash/digest/checksum
   - Find: getPackageCodePath, getPackageResourcePath

3. Hash/checksum validation:
   - Find: MessageDigest, SHA-256, SHA-1, CRC32, Adler32
   - Look for file integrity verification code

4. Tamper detection keywords:
   - Find: tamper, integrity, verify.*signature, repackag, modified

5. Native library checks:
   - Find: .so file verification, lib integrity checks

6. Resource tampering detection:
   - Find: asset verification, resource hash checks

Focus on com/[company] packages, but check third-party security libraries too.
Provide file:line references for all findings.
```

**Expected AI Output:**
- List of tamper detection mechanisms found (if any)
- File locations with line numbers
- Types of integrity checks detected
- Initial assessment (YES/NO/PARTIAL)

**Why AI excels here:**
- Can quickly search for signature verification patterns across thousands of files
- Identifies hash/digest usage faster than manual grep
- No false positives for signature verification API calls

### 🔍 Deep Analysis Prompt (30-45 minutes)

Use this prompt for comprehensive tamper detection assessment:

```
Perform comprehensive tamper detection analysis on [file:line references from quick search]:

For each tamper detection mechanism found:

1. **Integrity Check Type:**
   - What is being verified? (APK signature, DEX hash, native .so, resources)
   - Show complete verification logic with code snippets
   - Where is the check performed? (Application.onCreate, security class, native code)

2. **Verification Method:**
   - How is integrity verified? (Signature comparison, hash matching, CRC check)
   - What is the expected value compared against? (Hardcoded hash, server-provided, runtime computed)
   - Is verification in Java or native (JNI)?

3. **Enforcement Analysis (CRITICAL):**
   - What happens when tampering is detected?
   - Does app TERMINATE (System.exit, finish, SecurityException)?
   - Or just LOG the event (log.d, reportError)?
   - Trace verification result to enforcement action

4. **Coverage Assessment:**
   - How many integrity checks are implemented?
   - Count: APK signature, DEX integrity, native lib checks, resource checks, runtime hooking detection
   - Does it check multiple layers or just one?

5. **Bypassability:**
   - Are checks in Java (hookable with Frida) or native (harder)?
   - Are expected hash values hardcoded (easy to patch) or dynamically generated?
   - Is there multi-layer checking (if one bypassed, others trigger)?

6. **Effectiveness Score (0-10):**
   - Apply scoring rubric from this guide (see Effectiveness Assessment section)
   - Consider: check types, implementation quality, enforcement strength, bypassability

7. **Evidence for Report:**
   - File locations with line numbers
   - Code snippets showing verification AND enforcement
   - Justification for effectiveness score

IMPORTANT: Distinguish between "integrity check for telemetry" vs "integrity check for enforcement".
Only enforcement mechanisms get high scores.
```

**Expected AI Output:**
- Detailed breakdown of each tamper detection mechanism
- Code flow from verification → enforcement
- Coverage assessment (what is/isn't protected)
- Preliminary effectiveness score with justification
- Evidence snippets for security report

### ⚠️ Manual Validation Required

**AI limitations - You MUST manually verify:**

1. **Enforcement Logic (CRITICAL):**
   - AI can find signature verification code but may misinterpret enforcement
   - **YOU must read the code** to confirm: Does detection actually block the app?
   - Example: App checks signature but only logs mismatch → 2/10, not 7/10

2. **Expected Values Analysis:**
   - AI can identify hash comparisons but cannot verify if expected values are correct
   - **YOU must check** if hardcoded hashes match the actual APK signature
   - Incorrect expected values = ineffective check (0/10)

3. **Native Code Analysis:**
   - AI can search decompiled Java but cannot analyze native integrity checks
   - **YOU must use** strings, objdump, or Ghidra to analyze .so file tamper detection
   - Native implementations score higher (harder to bypass)

4. **False Positives:**
   - AI may flag version code checks or update verification as tamper detection
   - **YOU must distinguish** between security integrity checks vs feature checks

5. **Coverage Gaps:**
   - AI can find implemented checks, but **YOU must identify** what's NOT checked
   - Example: Checks APK signature but doesn't verify DEX/native libs = partial coverage

6. **Business Context:**
   - Only **YOU can decide** if tamper detection level matches app risk profile
   - Financial/DRM apps need 7-10/10; informational apps may not need any (0/10 acceptable)

### 🔀 Recommended Hybrid Approach

**Best Practice Workflow:**

1. **AI Quick Search (5 min):** Find all signature verification and integrity check code
2. **Manual Review (15 min):** Read top 3-5 integrity check implementations, assess enforcement
3. **AI Deep Analysis (15 min):** Analyze coverage, code flow, and verification methods
4. **Manual Native Check (15 min):** Use `strings lib*.so | grep -i "signature\|tamper\|integrity"`
5. **Manual Scoring (10 min):** Apply 0-10 rubric from "Effectiveness Assessment"
6. **AI Report Draft (5 min):** Generate finding description with evidence
7. **Manual Final Review (5 min):** Verify accuracy, add native analysis, identify coverage gaps

**Total Time:** ~70 minutes (vs 120+ minutes fully manual)

**Key Insight:**
- AI excels at finding signature verification API calls (unambiguous patterns)
- You must manually verify enforcement logic and expected hash values
- Native code analysis and coverage gap identification require human expertise
- Scoring requires understanding of bypass techniques (human judgment)

---

## Initial Discovery Commands

Run these commands from the decompiled source directory to identify tamper detection mechanisms:

### 1. Signature Verification Detection

```bash
# Find signature verification calls
echo "=== Signature Verification Checks ==="
grep -r "GET_SIGNATURES\|GET_SIGNING_CERTIFICATES\|PackageInfo.*signature" \
  --include="*.java" . 2>/dev/null | wc -l

# Find files implementing signature verification
grep -r "GET_SIGNATURES\|GET_SIGNING_CERTIFICATES" \
  --include="*.java" -l . 2>/dev/null | head -20

# Find actual signature comparison/verification logic
grep -r "signature" --include="*.java" -i . 2>/dev/null | \
  grep -i "verify\|check\|compare\|match" | head -20
```

### 2. Checksum and Hash Validation

```bash
# Find MessageDigest usage (cryptographic hashing)
echo "=== Checksum/Hash validation ==="
grep -r "MessageDigest\|\.digest(\|SHA-256\|SHA-1" \
  --include="*.java" . 2>/dev/null | wc -l

# Find CRC32/checksum implementations
grep -r "CRC32\|Adler32\|checksum" \
  --include="*.java" -l . 2>/dev/null | head -10

# Find files with MessageDigest
grep -r "MessageDigest" --include="*.java" -l . 2>/dev/null | head -15
```

### 3. DEX/APK Integrity Checks

```bash
# Look for DEX or APK file integrity verification
echo "=== DEX/APK hash verification ==="
grep -r "classes\.dex\|base\.apk" --include="*.java" . 2>/dev/null | \
  grep -i "hash\|digest\|checksum\|verify" | head -10

# Look for runtime integrity checks on code path
grep -r "getPackageCodePath\|getPackageResourcePath\|ApplicationInfo.*sourceDir" \
  --include="*.java" . 2>/dev/null | head -15
```

### 4. Tamper Detection Keywords

```bash
# Search for tamper/integrity/repackaging keywords
echo "=== Tamper/Integrity keywords ==="
grep -ri "tamper\|integrity.*check\|repackag\|modified.*apk" \
  --include="*.java" . 2>/dev/null | wc -l

# Search main app package for tamper detection
grep -r "signature\|tamper\|integrity\|repackag" \
  --include="*.java" ./com/nthgensoftware/traderev/android/ 2>/dev/null | wc -l
```

### 5. Certificate Pinning (Network Integrity)

```bash
# Certificate pinning (network security, not APK integrity but related)
echo "=== Certificate Pinning ==="
grep -r "CertificatePinner\|TrustManager\|X509TrustManager" \
  --include="*.java" . 2>/dev/null | wc -l

# Find certificate pinning implementations
grep -r "CertificatePinner\|X509TrustManager" \
  --include="*.java" -l . 2>/dev/null | head -10
```

### 6. Asset and Native Library Verification

```bash
# Asset protection/verification
echo "=== Asset protection/verification ==="
grep -r "AssetManager.*verify\|asset.*integrity\|resource.*tamper" \
  --include="*.java" . 2>/dev/null | wc -l

# Native library verification
echo "=== Native library verification ==="
grep -r "System\.loadLibrary\|System\.load" --include="*.java" -A 5 . 2>/dev/null | \
  grep -i "verify\|check\|integrity" | wc -l
```

---

## Effectiveness Assessment

### Application Tamper Detection Score: **0/10 (CRITICAL FAILURE)**

**Breakdown**:

| Detection Type | Implementation | Score | Notes |
|----------------|----------------|-------|-------|
| Signature Verification | None | 0/2 | Only retrieval, no verification |
| DEX Integrity | None | 0/2 | No classes.dex validation |
| Native Library Integrity | None | 0/2 | No .so file verification |
| Asset/Resource Integrity | None | 0/1 | Config files unprotected |
| Runtime Hook Detection | None | 0/2 | No Frida/Xposed detection |
| Response Mechanism | None | 0/1 | No termination or alerts |
| **TOTAL** | **NONE** | **0/10** | **CRITICAL** |

### Security Impact

**CVSS 3.1 Base Score**: 8.1 (HIGH)
**Vector**: `CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:N`

**Exploitation Scenario**:

1. **Attacker downloads the assessed application APK** from official source
2. **Decompiles with JADX/APKTool** (already done in this assessment)
3. **Modifies code** to:
   - Remove root detection (zg/g.java)
   - Bypass authentication checks
   - Steal credentials and send to attacker server
   - Remove SSL certificate pinning
4. **Repackages and signs** with attacker's certificate
5. **Distributes trojanized APK** on third-party app stores or via phishing
6. **Users install modified app** - NO detection, NO warnings
7. **App runs normally** with attacker's malicious code active

**Real-World Risk**:
- **Time to Exploit**: 2-4 hours for experienced attacker
- **Detection Probability**: 0% (no tamper detection)
- **User Impact**: Complete compromise of authentication, data exfiltration
- **Organizational Impact**: Reputational damage, regulatory violations, data breach

---

## Tamper Detection Techniques

### 1. APK Signature Verification

**Purpose**: Detect if APK has been repackaged with a different signing certificate

**Implementation Levels**:

#### Basic: Certificate Hash Comparison

```java
public class TamperDetector {
    // Expected production certificate SHA-256 hash (hardcode in JNI for better protection)
    private static final String EXPECTED_CERT_HASH =
        "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6";

    public static boolean verifyAppSignature(Context context) {
        try {
            PackageManager pm = context.getPackageManager();
            String packageName = context.getPackageName();

            // Get signing certificates (Android 9+)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                PackageInfo packageInfo = pm.getPackageInfo(
                    packageName,
                    PackageManager.GET_SIGNING_CERTIFICATES
                );

                SigningInfo signingInfo = packageInfo.signingInfo;
                Signature[] signatures = signingInfo.getApkContentsSigners();

                return verifyCertificateHash(signatures[0]);
            } else {
                // Legacy support (Android 4.4 - 8.1)
                PackageInfo packageInfo = pm.getPackageInfo(
                    packageName,
                    PackageManager.GET_SIGNATURES
                );

                Signature[] signatures = packageInfo.signatures;
                return verifyCertificateHash(signatures[0]);
            }
        } catch (Exception e) {
            // Signature check failed - assume tampered
            return false;
        }
    }

    private static boolean verifyCertificateHash(Signature signature) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] certHash = md.digest(signature.toByteArray());
            String certHashHex = bytesToHex(certHash);

            return EXPECTED_CERT_HASH.equalsIgnoreCase(certHashHex);
        } catch (NoSuchAlgorithmException e) {
            return false;
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
```

**Usage**:
```java
// In Application.onCreate() or MainActivity.onCreate()
if (!TamperDetector.verifyAppSignature(this)) {
    Log.e("Security", "App signature verification failed - tampering detected");
    // Response: terminate app
    android.os.Process.killProcess(android.os.Process.myPid());
    System.exit(1);
}
```

#### Advanced: Certificate Chain Validation

```java
public static boolean verifyAppSignatureAdvanced(Context context) {
    try {
        PackageManager pm = context.getPackageManager();
        PackageInfo packageInfo = pm.getPackageInfo(
            context.getPackageName(),
            PackageManager.GET_SIGNING_CERTIFICATES
        );

        SigningInfo signingInfo = packageInfo.signingInfo;
        Signature[] signatures = signingInfo.getApkContentsSigners();

        // Parse certificate
        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
        ByteArrayInputStream bis = new ByteArrayInputStream(signatures[0].toByteArray());
        X509Certificate cert = (X509Certificate) certFactory.generateCertificate(bis);

        // Verify certificate properties
        if (!verifyCertificateSubject(cert)) return false;
        if (!verifyCertificateIssuer(cert)) return false;
        if (!verifyCertificateValidity(cert)) return false;
        if (!verifyCertificatePublicKey(cert)) return false;

        return true;
    } catch (Exception e) {
        return false;
    }
}

private static boolean verifyCertificateSubject(X509Certificate cert) {
    String expectedSubject = "CN=the assessed application Production,O=KAR Global,C=US";
    return cert.getSubjectX500Principal().getName().equals(expectedSubject);
}

private static boolean verifyCertificatePublicKey(X509Certificate cert) {
    try {
        PublicKey publicKey = cert.getPublicKey();
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] keyHash = md.digest(publicKey.getEncoded());
        String keyHashHex = bytesToHex(keyHash);

        String expectedKeyHash = "f1e2d3c4b5a6978869504d3e2f1a0b9c8d7e6f5a4b3c2d1e0f";
        return expectedKeyHash.equalsIgnoreCase(keyHashHex);
    } catch (Exception e) {
        return false;
    }
}
```

### 2. DEX Integrity Verification

**Purpose**: Detect modifications to application bytecode (classes.dex files)

#### Basic: Single DEX Hash Verification

```java
public class DexIntegrityChecker {
    // Expected SHA-256 hash of classes.dex (compute during build, embed in native code)
    private static native String getExpectedDexHash();

    public static boolean verifyDexIntegrity(Context context) {
        try {
            ApplicationInfo appInfo = context.getApplicationInfo();
            String apkPath = appInfo.sourceDir;

            // Extract classes.dex from APK
            ZipFile zipFile = new ZipFile(apkPath);
            ZipEntry dexEntry = zipFile.getEntry("classes.dex");

            if (dexEntry == null) {
                return false; // No DEX found - suspicious
            }

            // Compute hash of DEX file
            InputStream is = zipFile.getInputStream(dexEntry);
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                md.update(buffer, 0, bytesRead);
            }

            is.close();
            zipFile.close();

            byte[] dexHash = md.digest();
            String dexHashHex = bytesToHex(dexHash);

            String expectedHash = getExpectedDexHash(); // From native code
            return expectedHash.equalsIgnoreCase(dexHashHex);

        } catch (Exception e) {
            Log.e("Security", "DEX integrity check failed", e);
            return false;
        }
    }
}
```

#### Advanced: Multi-DEX with CRC Validation

```java
public static boolean verifyAllDexFiles(Context context) {
    try {
        ApplicationInfo appInfo = context.getApplicationInfo();
        ZipFile zipFile = new ZipFile(appInfo.sourceDir);

        // Get expected hashes from native code (JNI)
        Map<String, String> expectedHashes = getExpectedDexHashesNative();

        // Verify all DEX files
        for (String dexName : expectedHashes.keySet()) {
            ZipEntry dexEntry = zipFile.getEntry(dexName);

            if (dexEntry == null) {
                zipFile.close();
                return false; // Missing DEX file
            }

            // Verify CRC-32 (fast check)
            long actualCrc = dexEntry.getCrc();
            long expectedCrc = getExpectedCrcNative(dexName);

            if (actualCrc != expectedCrc) {
                zipFile.close();
                return false; // CRC mismatch
            }

            // Verify SHA-256 hash (thorough check)
            if (!verifyDexHash(zipFile, dexEntry, expectedHashes.get(dexName))) {
                zipFile.close();
                return false;
            }
        }

        zipFile.close();
        return true;

    } catch (Exception e) {
        return false;
    }
}
```

### 3. Native Library Integrity Verification

**Purpose**: Detect modifications to native (.so) libraries before loading

```java
public class NativeLibraryVerifier {
    // Expected hashes of native libraries
    private static native Map<String, String> getExpectedLibraryHashes();

    public static boolean verifyAndLoadLibrary(Context context, String libraryName) {
        try {
            // Get library file path
            String libraryPath = getNativeLibraryPath(context, libraryName);

            if (libraryPath == null) {
                return false; // Library not found
            }

            // Compute hash of library file
            File libFile = new File(libraryPath);
            FileInputStream fis = new FileInputStream(libFile);

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                md.update(buffer, 0, bytesRead);
            }

            fis.close();

            byte[] libHash = md.digest();
            String libHashHex = bytesToHex(libHash);

            // Compare with expected hash
            Map<String, String> expectedHashes = getExpectedLibraryHashes();
            String expectedHash = expectedHashes.get(libraryName);

            if (!libHashHex.equalsIgnoreCase(expectedHash)) {
                Log.e("Security", "Library " + libraryName + " integrity check failed");
                return false;
            }

            // Load library only if integrity check passed
            System.loadLibrary(libraryName);
            return true;

        } catch (Exception e) {
            Log.e("Security", "Library verification failed", e);
            return false;
        }
    }

    private static String getNativeLibraryPath(Context context, String libraryName) {
        ApplicationInfo appInfo = context.getApplicationInfo();
        String libName = "lib" + libraryName + ".so";

        // Check in primary ABI directory
        String primaryAbi = Build.SUPPORTED_ABIS[0];
        String libPath = appInfo.nativeLibraryDir + "/" + libName;

        File libFile = new File(libPath);
        if (libFile.exists()) {
            return libPath;
        }

        return null;
    }
}
```

**Usage**:
```java
// Instead of: System.loadLibrary("native-lib");
// Use:
if (!NativeLibraryVerifier.verifyAndLoadLibrary(this, "native-lib")) {
    // Tampered library detected
    android.os.Process.killProcess(android.os.Process.myPid());
}
```

### 4. Asset and Resource Integrity

**Purpose**: Protect critical configuration files and resources from modification

```java
public class AssetIntegrityChecker {
    // Critical assets with expected hashes
    private static final Map<String, String> CRITICAL_ASSETS = new HashMap<String, String>() {{
        put("config_aws_jwt.properties", "abc123def456..."); // SHA-256
        put("firebase_config.json", "789ghi012jkl...");
        put("gtm_config.json", "345mno678pqr...");
    }};

    public static boolean verifyAssetIntegrity(Context context) {
        AssetManager assetManager = context.getAssets();

        for (Map.Entry<String, String> entry : CRITICAL_ASSETS.entrySet()) {
            String assetName = entry.getKey();
            String expectedHash = entry.getValue();

            try {
                InputStream is = assetManager.open(assetName);

                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] buffer = new byte[8192];
                int bytesRead;

                while ((bytesRead = is.read(buffer)) != -1) {
                    md.update(buffer, 0, bytesRead);
                }

                is.close();

                byte[] assetHash = md.digest();
                String assetHashHex = bytesToHex(assetHash);

                if (!assetHashHex.equalsIgnoreCase(expectedHash)) {
                    Log.e("Security", "Asset " + assetName + " has been modified");
                    return false;
                }

            } catch (IOException e) {
                Log.e("Security", "Asset " + assetName + " not found or unreadable");
                return false;
            } catch (NoSuchAlgorithmException e) {
                return false;
            }
        }

        return true; // All critical assets verified
    }
}
```

### 5. Runtime Hook Detection (Frida/Xposed)

**Purpose**: Detect code injection and method hooking frameworks

```java
public class HookDetector {

    public static boolean detectHookingFrameworks() {
        return detectFrida() || detectXposed() || detectSubstrate();
    }

    // Detect Frida dynamic instrumentation
    private static boolean detectFrida() {
        // Check for Frida server on default ports
        if (checkFridaPort(27042)) return true;
        if (checkFridaPort(27043)) return true;

        // Check for Frida named pipes
        if (new File("/data/local/tmp/frida-server").exists()) return true;

        // Check for Frida libraries in memory
        try {
            BufferedReader reader = new BufferedReader(
                new FileReader("/proc/self/maps")
            );
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("frida") ||
                    line.contains("gadget") ||
                    line.contains("gum-js-loop")) {
                    reader.close();
                    return true;
                }
            }
            reader.close();
        } catch (Exception e) {
            // Ignore
        }

        // Check for Frida threads
        Set<Thread> threads = Thread.getAllStackTraces().keySet();
        for (Thread thread : threads) {
            if (thread.getName().contains("frida") ||
                thread.getName().contains("gmain")) {
                return true;
            }
        }

        return false;
    }

    private static boolean checkFridaPort(int port) {
        try {
            Socket socket = new Socket("127.0.0.1", port);
            socket.close();
            return true; // Port is open - Frida may be present
        } catch (Exception e) {
            return false; // Port closed
        }
    }

    // Detect Xposed framework
    private static boolean detectXposed() {
        try {
            // Check for Xposed bridge class
            Class.forName("de.robv.android.xposed.XposedBridge");
            return true; // Xposed is present
        } catch (ClassNotFoundException e) {
            // Xposed not found
        }

        // Check for Xposed files
        if (new File("/system/framework/XposedBridge.jar").exists()) return true;
        if (new File("/system/lib/libxposed_art.so").exists()) return true;

        // Check system properties
        try {
            String propValue = getSystemProperty("ro.xposed.installed");
            if (propValue != null && !propValue.isEmpty()) {
                return true;
            }
        } catch (Exception e) {
            // Ignore
        }

        return false;
    }

    // Detect Substrate framework
    private static boolean detectSubstrate() {
        try {
            Class.forName("com.saurik.substrate.MS$MethodPointer");
            return true;
        } catch (ClassNotFoundException e) {
            // Not found
        }

        if (new File("/system/lib/libsubstrate.so").exists()) return true;
        if (new File("/system/lib/libsubstrate-dvm.so").exists()) return true;

        return false;
    }

    private static String getSystemProperty(String key) {
        try {
            Class<?> systemProperties = Class.forName("android.os.SystemProperties");
            Method get = systemProperties.getMethod("get", String.class);
            return (String) get.invoke(null, key);
        } catch (Exception e) {
            return null;
        }
    }
}
```

### 6. Response Mechanisms

**Purpose**: Take appropriate action when tampering is detected

```java
public class TamperResponse {

    public static void handleTamperDetection(Context context, String detectionType) {
        Log.e("Security", "TAMPER DETECTED: " + detectionType);

        // 1. Alert server (if network available)
        reportTamperToServer(context, detectionType);

        // 2. Clear sensitive data
        clearSensitiveData(context);

        // 3. Show user warning (optional, can be silent)
        // showTamperWarning(context);

        // 4. Terminate application
        terminateApp();
    }

    private static void reportTamperToServer(Context context, String detectionType) {
        // Send tamper alert to backend
        try {
            String deviceId = getDeviceId(context);
            String appVersion = getAppVersion(context);

            JSONObject payload = new JSONObject();
            payload.put("device_id", deviceId);
            payload.put("app_version", appVersion);
            payload.put("detection_type", detectionType);
            payload.put("timestamp", System.currentTimeMillis());

            // Send to security endpoint (implement API call)
            // SecurityApi.reportTamper(payload);

        } catch (Exception e) {
            // Continue to termination even if reporting fails
        }
    }

    private static void clearSensitiveData(Context context) {
        // Clear SharedPreferences
        SharedPreferences prefs = context.getSharedPreferences(
            "secure_prefs",
            Context.MODE_PRIVATE
        );
        prefs.edit().clear().apply();

        // Clear cached credentials
        // AuthManager.clearTokens();

        // Clear database
        // DatabaseHelper.clearSensitiveTables();
    }

    private static void terminateApp() {
        // Kill process immediately
        android.os.Process.killProcess(android.os.Process.myPid());
        System.exit(1);
    }
}
```

### 7. Native Code Protection (JNI/NDK)

**Purpose**: Implement tamper detection in native code for better resistance to reverse engineering

**C/C++ Implementation** (`native-lib.cpp`):

```cpp
#include <jni.h>
#include <string>
#include <android/log.h>
#include <unistd.h>
#include <dlfcn.h>

#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "NativeSecurity", __VA_ARGS__)

// Expected certificate hash (hardcoded in native code)
const char* EXPECTED_CERT_HASH = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6";

// Expected DEX hashes
const char* EXPECTED_DEX1_HASH = "abc123def456ghi789jkl012mno345pqr678stu901vwx234yz5";
const char* EXPECTED_DEX2_HASH = "fed654cba321jih987lkm654onp321qrs876tvu109xwz432yx1";

extern "C" JNIEXPORT jstring JNICALL
Java_com_nthgensoftware_traderev_android_security_TamperDetector_getExpectedCertHashNative(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(EXPECTED_CERT_HASH);
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_nthgensoftware_traderev_android_security_DexIntegrityChecker_getExpectedDexHash(
        JNIEnv* env,
        jobject /* this */) {
    return env->NewStringUTF(EXPECTED_DEX1_HASH);
}

// Detect Frida by checking for gadget library
extern "C" JNIEXPORT jboolean JNICALL
Java_com_nthgensoftware_traderev_android_security_HookDetector_detectFridaNative(
        JNIEnv* env,
        jobject /* this */) {

    // Check if frida-gadget is loaded
    void* handle = dlopen("libfrida-gadget.so", RTLD_NOW);
    if (handle != nullptr) {
        dlclose(handle);
        return JNI_TRUE; // Frida detected
    }

    // Check /proc/self/maps for frida
    FILE* fp = fopen("/proc/self/maps", "r");
    if (fp != nullptr) {
        char line[512];
        while (fgets(line, sizeof(line), fp)) {
            if (strstr(line, "frida") != nullptr ||
                strstr(line, "gadget") != nullptr) {
                fclose(fp);
                return JNI_TRUE;
            }
        }
        fclose(fp);
    }

    return JNI_FALSE;
}

// Anti-debugging check (TracerPid)
extern "C" JNIEXPORT jboolean JNICALL
Java_com_nthgensoftware_traderev_android_security_HookDetector_isBeingDebugged(
        JNIEnv* env,
        jobject /* this */) {

    FILE* fp = fopen("/proc/self/status", "r");
    if (fp == nullptr) {
        return JNI_FALSE;
    }

    char line[256];
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "TracerPid:", 10) == 0) {
            int tracerPid = atoi(line + 10);
            fclose(fp);

            if (tracerPid != 0) {
                LOGE("Debugger detected! TracerPid: %d", tracerPid);
                return JNI_TRUE;
            }
            return JNI_FALSE;
        }
    }

    fclose(fp);
    return JNI_FALSE;
}
```

---

## Implementation Guide

### Step 1: Basic Signature Verification

**Priority**: IMMEDIATE (HIGH)
**Effort**: 2-4 hours
**Impact**: HIGH - Prevents basic repackaging

1. **Add TamperDetector class** to main app package
2. **Call in Application.onCreate()**:
   ```java
   public class AppApplication extends Application {
       @Override
       public void onCreate() {
           super.onCreate();

           // Perform tamper detection on app startup
           if (!TamperDetector.verifyAppSignature(this)) {
               TamperResponse.handleTamperDetection(this, "Signature Mismatch");
           }
       }
   }
   ```

3. **Get production certificate hash**:
   ```bash
   # Get signing certificate from APK
   keytool -printcert -jarfile sample_app.apk

   # Or from keystore
   keytool -list -v -keystore release.keystore -alias release

   # Extract SHA-256 fingerprint and hardcode in TamperDetector
   ```

4. **Test**:
   ```bash
   # Repackage APK with different signature
   apktool d sample_app.apk -o app_decompiled
   apktool b app_decompiled -o app_repackaged.apk

   # Sign with debug keystore
   jarsigner -keystore ~/.android/debug.keystore app_repackaged.apk androiddebugkey

   # Install and verify it terminates
   adb install app_repackaged.apk
   ```

### Step 2: DEX Integrity Verification

**Priority**: HIGH
**Effort**: 4-8 hours
**Impact**: HIGH - Detects code modifications

1. **Create DexIntegrityChecker class**
2. **Compute DEX hashes during build**:
   ```gradle
   // build.gradle (app module)
   android {
       applicationVariants.all { variant ->
           variant.outputs.all { output ->
               variant.assemble.doLast {
                   def apkFile = output.outputFile
                   def zipFile = new java.util.zip.ZipFile(apkFile)
                   def dexEntry = zipFile.getEntry("classes.dex")

                   def md = java.security.MessageDigest.getInstance("SHA-256")
                   md.update(zipFile.getInputStream(dexEntry).bytes)
                   def hash = md.digest().encodeHex().toString()

                   println "DEX Hash: ${hash}"
                   // Store in BuildConfig or native code
               }
           }
       }
   }
   ```

3. **Add verification call**:
   ```java
   if (!DexIntegrityChecker.verifyDexIntegrity(this)) {
       TamperResponse.handleTamperDetection(this, "DEX Modified");
   }
   ```

### Step 3: Native Code Protection

**Priority**: MEDIUM
**Effort**: 8-16 hours
**Impact**: VERY HIGH - Much harder to bypass

1. **Create NDK module** with JNI security functions
2. **Move sensitive checks to native code**:
   - Certificate hash comparison
   - DEX hash storage and verification
   - Frida/Xposed detection
3. **Obfuscate native code** with LLVM obfuscator
4. **Strip symbols** from .so files

### Step 4: Runtime Hook Detection

**Priority**: MEDIUM
**Effort**: 4-6 hours
**Impact**: MEDIUM - Detects dynamic analysis

1. **Add HookDetector class** with Frida/Xposed detection
2. **Call periodically**:
   ```java
   // Check every 30 seconds
   Handler handler = new Handler(Looper.getMainLooper());
   handler.postDelayed(new Runnable() {
       @Override
       public void run() {
           if (HookDetector.detectHookingFrameworks()) {
               TamperResponse.handleTamperDetection(
                   AppApplication.this,
                   "Hooking Framework"
               );
           }
           handler.postDelayed(this, 30000);
       }
   }, 30000);
   ```

### Step 5: Asset Integrity

**Priority**: LOW
**Effort**: 2-3 hours
**Impact**: MEDIUM - Protects config files

1. **Create AssetIntegrityChecker**
2. **Compute hashes of critical assets**:
   ```bash
   sha256sum apk/the assessed application/resources/config_aws_jwt.properties
   ```
3. **Add verification before using assets**

### Step 6: Server-Side Reporting

**Priority**: MEDIUM
**Effort**: 4-8 hours (requires backend API)
**Impact**: HIGH - Enables monitoring and response

1. **Create tamper alert endpoint** on backend
2. **Report detection events** from TamperResponse
3. **Monitor for patterns**:
   - Multiple tamper events from same device ID
   - Unusual geographic distribution
   - Spike in tamper alerts (indicates new attack)
4. **Trigger response**:
   - Blacklist device IDs
   - Require re-authentication
   - Flag account for review

---

## Testing and Verification

### Positive Tests (Should Pass)

1. **Original APK**:
   ```bash
   adb install app_original.apk
   # Should launch successfully
   ```

2. **Reinstall Without Modification**:
   ```bash
   adb uninstall com.nthgensoftware.traderev.android
   adb install app_original.apk
   # Should launch successfully
   ```

### Negative Tests (Should Fail/Terminate)

1. **Repackaged APK**:
   ```bash
   apktool d sample_app.apk -o decompiled
   apktool b decompiled -o repackaged.apk
   jarsigner -keystore debug.keystore repackaged.apk androiddebugkey
   adb install repackaged.apk
   # Should detect signature mismatch and terminate
   ```

2. **Modified DEX**:
   ```bash
   # Modify smali code
   vim decompiled/smali/com/nthgensoftware/traderev/android/features/login/LoginActivity.smali
   # (make any change)
   apktool b decompiled -o modified.apk
   # Re-sign and install
   # Should detect DEX modification and terminate
   ```

3. **Frida Instrumentation**:
   ```bash
   # Start Frida server on device
   adb push frida-server /data/local/tmp/
   adb shell "/data/local/tmp/frida-server &"

   # Launch app
   adb shell am start -n com.nthgensoftware.traderev.android/.MainActivity

   # Attach Frida
   frida -U -n "the assessed application" -l hook_script.js
   # Should detect Frida and terminate
   ```

4. **Xposed Module**:
   ```bash
   # Install Xposed framework and module targeting the assessed application
   # Launch app
   # Should detect Xposed and terminate
   ```

### Verification Checklist

- [ ] Signature verification detects repackaging
- [ ] DEX integrity check detects code modifications
- [ ] Native library verification prevents .so replacement
- [ ] Asset integrity check protects config files
- [ ] Frida detection terminates app when instrumented
- [ ] Xposed detection terminates app with module active
- [ ] Tamper events reported to server
- [ ] App terminates within 2 seconds of detection
- [ ] No false positives on legitimate installations

---

## Use in Comparative Analysis

**When conducting comparative analysis (Phase 6 of assessment workflow), use this guide to:**

### 1. Score Both Versions Using the Same Rubric

**For v1 (Original Assessment):**<br>→ Use the [Effectiveness Assessment](#effectiveness-assessment) scoring rubric (0-10 scale)<br>→ Document tamper detection mechanisms found (or absence thereof)<br>→ Record integrity check types and enforcement<br>→ Note in original assessment report

**For v2 (Post-Remediation Assessment):**<br>→ Re-apply the same scoring rubric for consistency<br>→ Use identical criteria to measure improvement<br>→ Compare integrity check implementations and enforcement

**Example:**
```markdown
| Version | Integrity Checks | Enforcement | Score | Status |
|---------|-----------------|-------------|-------|--------|
| v1 | None found | N/A | 0/10 | 🔴 FAIL |
| v2 | APK signature verification + Play Integrity API | App exits on tamper | 7/10 | 🟢 PASS |
| **Change** | **+Multi-layer integrity checks** | **+Enforcement added** | **+7** | **✅ MAJOR IMPROVEMENT** |
```

### 2. Assess Remediation Quality

Use this guide's [Implementation Guide](#implementation-guide) section to evaluate fix quality:

**Excellent Remediation (9-10/10):**<br>→ APK signature verification implemented<br>→ DEX integrity checks added<br>→ Play Integrity API integrated with server-side verification<br>→ Native library integrity checks<br>→ Resource/asset integrity verification<br>→ Enforcement response (app terminates on tamper detection)<br>→ Multi-layer defense-in-depth approach

**Good Remediation (7-8/10):**<br>→ APK signature verification + Play Integrity API<br>→ Enforcement added (app terminates)<br>→ Server-side reporting implemented<br>→ Minor gaps (e.g., no DEX integrity or native lib checks)

**Partial Remediation (4-6/10):**<br>→ Basic signature verification only<br>→ Enforcement present but bypassable<br>→ Or integrity checks without enforcement<br>→ Single-layer approach (easily defeated)

**Failed Remediation (0-3/10):**<br>→ No tamper detection added<br>→ Or checks added but trivially bypassable<br>→ Or detection without enforcement

### 3. Document Evidence for Comparative Report

**Required evidence for `COMPARATIVE_TEMPLATE.md`:**

**Integrity Check Comparison:**
```markdown
**v1:** No tamper detection implemented
**v2:**
- APK signature verification at TamperDetector.java:45
- Play Integrity API calls at IntegrityManager.java:123
- DEX checksum validation at DexVerifier.java:67
- Enforcement at SecurityManager.java:189
```

**Enforcement Comparison:**
```markdown
**v1:** N/A (no detection)
**v2:** App terminates via System.exit(0) when signature mismatch detected
```

**Play Integrity Implementation:**
```markdown
**v1:** Not present
**v2:** Play Integrity token requested at startup, verified server-side
```

**Effectiveness Score Justification:**
```markdown
**v1 Score: 0/10** - Per RESILIENCE-4 rubric: "No integrity checks"
**v2 Score: 7/10** - Per RESILIENCE-4 rubric: "Play Integrity + signature verification with enforcement"
**Improvement: +7 points** - Comprehensive integrity protection added
```

### 4. Identify Remaining Gaps

Even if remediation improved the score, document what's still missing:

```markdown
**Remaining Gaps (for next version):**
- [ ] No native library (.so) integrity verification
- [ ] No resource/asset integrity checks
- [ ] Play Integrity token not verified frequently (only at startup)
- [ ] No runtime hook detection (Frida/Xposed)
- [ ] Integrity check code itself not obfuscated/protected
```

### 5. Test Tamper Detection Effectiveness

**Verify v2 implementation with repackaging test:**
```bash
# Test 1: Repackage and resign APK
apktool d app-v2.apk -o app-v2-decoded
# [Make modifications to code/resources]
apktool b app-v2-decoded -o app-v2-repackaged.apk
jarsigner -keystore test.keystore app-v2-repackaged.apk test-key

# Install repackaged APK
adb install app-v2-repackaged.apk

# Expected v1: App runs normally (vulnerable)
# Expected v2: App detects signature mismatch and terminates

# Test 2: Modify DEX without resigning (if DEX checks implemented)
# Test 3: Test Play Integrity API response (requires device/emulator)
```

### 6. Verify Server-Side Integration

**Check if Play Integrity tokens are verified server-side:**
```markdown
**v2 Assessment:**
1. Capture Play Integrity token using proxy (Burp/Charles)
2. Check if token is sent to backend API
3. Verify backend validates token (try replaying old/invalid tokens)
4. Assess if backend enforcement is bypassed when token invalid

**Scoring Impact:**
- Client-only checks: 5-6/10
- Client + server verification: 7-8/10
```

### 7. Reference This Guide's Sections

When writing comparative analysis, reference specific sections:

**For scoring methodology:**<br>→ Link to: [Effectiveness Assessment](#effectiveness-assessment)

**For tamper detection techniques:**<br>→ Link to: [Tamper Detection Techniques](#tamper-detection-techniques)

**For implementation guidance:**<br>→ Link to: [Implementation Guide](#implementation-guide)

**For verification testing:**<br>→ Link to: [Testing and Verification](#testing-and-verification)

### Related Documentation

**Comparative Analysis Guides:**<br>→ **Process:** `GETTING_STARTED.md` Comparative Analysis section (tutorial)<br>→ **Checklist:** `ASSESSMENT_WORKFLOW.md` Phase 6<br>→ **Template:** `templates/COMPARATIVE_TEMPLATE.md` (deliverable structure)

---

## Reporting Template

### Finding Title
**Lack of Tamper Detection and Anti-Repackaging Controls**

### Severity
**HIGH** (CVSS: 8.1)

### CVSS Vector
```
CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:N
```

### CWE Classification
- **CWE-353**: Missing Support for Integrity Check
- **CWE-494**: Download of Code Without Integrity Check
- **CWE-656**: Reliance on Security Through Obscurity

### OWASP MASVS v2.0
- **MASVS-RESILIENCE-4**: FAIL - No tamper detection implemented

### OWASP Mobile Top 10 2024
- **M10: Insufficient Binary Protections** - No integrity verification or anti-tampering

### Description

The the assessed application Android application (version 4.172.1) lacks comprehensive tamper detection and anti-repackaging mechanisms, allowing attackers to modify and redistribute malicious versions of the app without detection.

**Technical Details**:

The application implements ZERO tamper detection controls:

1. **No APK Signature Verification**
   - Application does not verify its signing certificate at runtime
   - No comparison against expected production certificate hash
   - Repackaged APK with different signature executes normally

2. **No DEX Integrity Checks**
   - No verification of `classes.dex` files
   - Bytecode can be modified without detection
   - Example: `zg/g.java` root detection can be disabled via Smali modification

3. **No Native Library Verification**
   - `.so` files loaded without integrity validation
   - No hash checks before `System.loadLibrary()` calls

4. **No Asset/Resource Protection**
   - Critical files not validated (e.g., `config_aws_jwt.properties`)
   - Configuration containing hardcoded keys can be modified

5. **No Runtime Hook Detection**
   - No detection of Frida, Xposed, or other instrumentation frameworks
   - Application can be dynamically analyzed and manipulated

6. **No Response Mechanism**
   - Even if detection existed, no termination or alerting logic

**Limited Signature Usage**:
- `fj/a.java:280-282`: Generic signature retrieval (NO verification)
- `io/intercom/android/sdk/metrics/AppTypeDetector.java`: Debug build detection (telemetry only)
- `u5/a.java:43`: Font provider verification (not app tamper detection)

**Certificate Pinning Present**: The app implements HTTPS certificate pinning (129 occurrences), but this protects network communications only, NOT application integrity.

### Evidence

**File Locations**:
```
sources/fj/a.java:280-282 (signature retrieval only)
sources/io/intercom/android/sdk/metrics/AppTypeDetector.java:30-45 (debug detection)
sources/u5/a.java:43 (font provider verification)
sources/fd0/n.java:177-183 (MessageDigest utility, not used for integrity)
sources/zc0/b.java (HTTPS certificate pinning, not APK integrity)
```

**Discovery Command Output**:
```bash
$ grep -r "GET_SIGNATURES\|GET_SIGNING_CERTIFICATES" --include="*.java" . | wc -l
4

$ grep -r "classes\.dex\|base\.apk" --include="*.java" . | grep -i "hash\|digest\|verify" | wc -l
0

$ grep -ri "tamper\|integrity.*check\|repackag" --include="*.java" . | wc -l
1 (false positive)
```

### Impact

**Attack Scenario**:

1. Attacker downloads legitimate the assessed application APK from Google Play Store
2. Decompiles APK using JADX/APKTool (publicly available tools)
3. Modifies code to:
   - Remove root detection (`zg/g.java:94-101`)
   - Bypass authentication checks
   - Inject credential-stealing functionality
   - Remove SSL certificate pinning
4. Repackages and signs APK with attacker's certificate
5. Distributes trojanized version via:
   - Third-party app stores
   - Phishing emails/SMS
   - Social engineering campaigns
6. Users install modified app - NO warnings, NO detection
7. Malicious code executes with full access to user credentials and data

**Business Impact**:
- **Credential Theft**: Stolen user credentials used for unauthorized transactions
- **Data Breach**: Customer personal information exfiltrated
- **Reputational Damage**: Brand damage from malicious app versions
- **Compliance Violations**: PCI-DSS 6.5.10, SOC 2 CC6.1
- **Financial Loss**: Fraud, regulatory fines, incident response costs

**User Impact**:
- Account compromise and unauthorized access
- Financial fraud on auto auction platform
- Privacy violation and data exposure
- Malware infection of personal devices

### Proof of Concept

**Repackaging Test**:

```bash
# 1. Decompile original APK
apktool d sample_app.apk -o app_modified

# 2. Modify code (example: disable root detection)
vim app_modified/smali/zg/g.smali
# Change method g() to always return false

# 3. Repackage
apktool b app_modified -o app_trojan.apk

# 4. Sign with malicious certificate
keytool -genkey -v -keystore malicious.keystore -alias attacker \
  -keyalg RSA -keysize 2048 -validity 10000

jarsigner -keystore malicious.keystore \
  -signedjar app_trojan_signed.apk \
  app_trojan.apk attacker

# 5. Install and execute
adb install app_trojan_signed.apk
adb shell am start -n com.nthgensoftware.traderev.android/.MainActivity

# RESULT: App launches successfully despite:
# - Different signing certificate
# - Modified bytecode
# - Disabled security controls
```

**Time to Exploit**: 2-4 hours for experienced attacker

### Remediation

**IMMEDIATE (Week 1-2)**:

**1. Implement APK Signature Verification**<br>→ Add signature verification in `Application.onCreate()` lifecycle method<br>→ Compare runtime signature against expected production certificate hash<br>→ Terminate app immediately if mismatch detected (enforcement response)<br>→ Use `PackageManager.getPackageInfo()` with `GET_SIGNATURES` flag

**2. Enable Build-Time DEX Hashing**<br>→ Compute SHA-256 hashes of all DEX files during release build process<br>→ Embed expected hashes in native code for protection against tampering<br>→ Store hashes in obfuscated format within compiled native libraries

**SHORT-TERM (Month 1-2)**:

**3. Implement DEX Integrity Verification**<br>→ Verify `classes.dex` file hash at runtime against expected value<br>→ Store expected hash in native code (JNI) for additional protection<br>→ Perform integrity check on app startup and periodically during runtime<br>→ Implement enforcement response when tampering detected

**4. Add Runtime Hook Detection**<br>→ Detect Frida presence (check ports 27042/27043, scan `/proc/self/maps` for libraries)<br>→ Detect Xposed framework (check for `XposedBridge.jar`, `libxposed_art.so`)<br>→ Run detection checks every 30-60 seconds during app runtime<br>→ Terminate app if instrumentation detected

**5. Implement Server-Side Reporting**<br>→ Create tamper detection alert endpoint on backend API<br>→ Report device ID, app version, and detection type when tampering detected<br>→ Monitor backend logs for attack patterns and trends<br>→ Implement response strategies based on threat intelligence

**LONG-TERM (Month 3-6)**:

**6. Move Security to Native Code**<br>→ Implement tamper detection logic in C/C++ using JNI/NDK<br>→ Obfuscate native code with LLVM-Obfuscator for additional protection<br>→ Strip debug symbols from compiled `.so` files<br>→ Native implementation increases difficulty of reverse engineering

**7. Verify Native Library Integrity**<br>→ Compute SHA-256 hashes of all `.so` files at build time<br>→ Verify library hash before calling `System.loadLibrary()`<br>→ Store expected hashes in protected memory region<br>→ Detect and respond to native library replacement attacks

**8. Protect Critical Assets**<br>→ Compute integrity hashes for sensitive configuration files<br>→ Verify asset integrity before parsing configuration data<br>→ Encrypt sensitive strings and values in application assets<br>→ Implement file integrity monitoring for critical resources

**9. Consider Commercial Solutions**<br>→ **DexGuard** ($20K-50K/year): Advanced obfuscation with RASP capabilities<br>→ **Guardsquare iXGuard**: Enterprise-grade mobile app protection<br>→ **Arxan Application Protection**: Comprehensive runtime self-protection<br>→ Evaluate ROI and security requirements before purchasing

**Defense-in-Depth**:

**10. Combine with Other MASVS-RESILIENCE Controls**<br>→ Implement code obfuscation using ProGuard/R8 (MASVS-RESILIENCE-2)<br>→ Deploy root detection mechanisms (MASVS-RESILIENCE-1)<br>→ Add anti-debugging protections (MASVS-RESILIENCE-3)<br>→ Implement SSL certificate pinning for network security (MASVS-NETWORK-1)

### Implementation Support

We can provide detailed code examples, integrity verification libraries, and hands-on technical guidance for implementing these tamper detection recommendations. Our services include:

→ **Tamper detection code libraries** - Ready-to-use signature and integrity verification implementations<br>→ **Native security workshops** - JNI/NDK implementation training for tamper detection<br>→ **Build process integration** - Configure DEX hashing and hash embedding in your build pipeline<br>→ **Defense-in-depth strategy** - Design and implement multi-layered tamper protection<br>→ **Commercial solution evaluation** - Assist with DexGuard/Arxan assessment and integration<br>→ **Ongoing consultation** - Support during remediation implementation and testing

Contact us to schedule implementation assistance.

### Remediation Priority
**HIGH** - Implement signature verification and DEX integrity within 2 weeks

### Testing Recommendations

**Verify Remediation**:

1. **Positive Test**: Original APK should launch normally
2. **Negative Tests**:
   ```bash
   # Repackaged APK should terminate
   # Modified DEX should be detected
   # Frida attachment should be blocked
   ```

3. **Monitoring**:
   - Track tamper alerts from backend
   - Identify attack patterns and respond
   - Update detection logic as new bypass techniques emerge

**Regression Testing**:
- Ensure legitimate installations are not flagged
- Test on various Android versions (8.0 - 14.0)
- Test on different device manufacturers (Samsung, Google, OnePlus)

### References

- OWASP MASVS v2.0: https://mas.owasp.org/MASVS/controls/MASVS-RESILIENCE-4/
- OWASP Mobile Top 10: https://owasp.org/www-project-mobile-top-10/
- Android App Bundle Code Transparency: https://developer.android.com/guide/app-bundle/code-transparency
- CWE-353: Missing Support for Integrity Check: https://cwe.mitre.org/data/definitions/353.html
- NIST SP 800-163: Vetting the Security of Mobile Applications

---

## Summary

### Key Takeaways

1. **the assessed application Has ZERO Tamper Detection**: Score 0/10
2. **Critical Risk**: App can be repackaged and redistributed with malicious modifications
3. **Signature Verification Missing**: No validation of APK signing certificate
4. **DEX Integrity Unchecked**: Bytecode can be modified without detection
5. **No Runtime Protection**: Frida/Xposed instrumentation undetected
6. **Immediate Action Required**: Implement signature verification within 2 weeks

### Implementation Priority

| Control | Priority | Effort | Impact | Timeline |
|---------|----------|--------|--------|----------|
| APK Signature Verification | CRITICAL | Low | High | Week 1-2 |
| DEX Integrity Check | HIGH | Medium | High | Week 3-4 |
| Runtime Hook Detection | MEDIUM | Medium | Medium | Month 2 |
| Native Code Protection | MEDIUM | High | Very High | Month 3-6 |
| Asset Integrity | LOW | Low | Medium | Month 2 |
| Server Reporting | MEDIUM | Medium | High | Month 2 |

### Effectiveness After Remediation

With full implementation of recommended controls:

| Detection Type | Before | After | Improvement |
|----------------|--------|-------|-------------|
| Signature Verification | 0/2 | 2/2 | +100% |
| DEX Integrity | 0/2 | 2/2 | +100% |
| Native Library Integrity | 0/2 | 2/2 | +100% |
| Asset/Resource Integrity | 0/1 | 1/1 | +100% |
| Runtime Hook Detection | 0/2 | 2/2 | +100% |
| Response Mechanism | 0/1 | 1/1 | +100% |
| **TOTAL** | **0/10** | **10/10** | **+1000%** |

**Expected Security Posture**: Moving from CRITICAL (0/10) to EXCELLENT (10/10) eliminates the most critical repackaging risk and raises the bar significantly for attackers attempting to distribute trojanized versions of the assessed application.

---

**End of MASVS-RESILIENCE-4 Enhanced Analysis Guide**
