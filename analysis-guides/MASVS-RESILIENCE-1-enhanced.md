# MASVS-RESILIENCE-1: Runtime Integrity (Root/Jailbreak Detection)

## Enhanced Analysis Guide for Mobile Application Security Assessment

**OWASP MASVS Control:** RESILIENCE-1
**Category:** Reverse Engineering Resistance
**Control Description:** The app implements checks to detect and respond to the presence of a rooted or jailbroken device.

---

## Table of Contents

1. [Overview](#overview)
2. [Initial Discovery Commands](#initial-discovery-commands)
3. [Deep Dive Analysis](#deep-dive-analysis)
4. [Effectiveness Assessment](#effectiveness-assessment)
5. [Common Implementation Patterns](#common-implementation-patterns)
6. [Improvement Recommendations](#improvement-recommendations)
7. [Testing and Verification](#testing-and-verification)
8. [Use in Comparative Analysis](#use-in-comparative-analysis)
9. [Reporting Template](#reporting-template)

---

## Overview

Root/jailbreak detection is a critical security control that helps protect mobile applications from running in compromised environments. When devices are rooted (Android) or jailbroken (iOS), attackers gain elevated privileges that can be used to:

- Bypass application security controls
- Hook into application methods (Frida, Xposed)
- Access protected data in memory or storage
- Modify application behavior at runtime
- Reverse engineer proprietary algorithms
- Steal cryptographic keys from memory

**Risk Level:** Failure to implement effective root detection = **HIGH** severity finding

---

## AI-Assisted Analysis Approach

This section provides guidance on using AI assistants (like Claude Code) to accelerate RESILIENCE-1 analysis while maintaining analytical rigor.

### 🤖 Quick AI Prompt (5-10 minutes)

Use this prompt for initial triage and discovery:

```
Search for root/jailbreak detection in decompiled/sources/sources/:

1. Find code containing: root, jailbreak, isRooted, RootBeer, SafetyNet, Magisk
2. Locate *Root*.java, *Jailbreak*.java, *Integrity*.java files (exclude androidx)
3. Search for suspicious file path checks (e.g., "/system/xbin/su", "/data/local/su")
4. Identify where detection happens (Application.onCreate, security classes, third-party libs)
5. Show code snippets with file:line references

Focus on com/[company] packages, but also check third-party libraries like:
- com/bugsnag/android/RootDetector.java
- com/scottyab/rootbeer/RootBeer.java
- com/google/android/gms/safetynet/

Provide a summary of findings with file locations.
```

**Expected AI Output:**
- List of files containing root detection code
- Code snippets showing detection methods
- Initial assessment of detection presence (YES/NO/PARTIAL)

### 🔍 Deep Analysis Prompt (30-45 minutes)

Use this prompt for comprehensive enforcement analysis:

```
Perform comprehensive root detection analysis on [file:line references from quick search]:

For each detection implementation found:

1. **Detection Method:**
   - What root detection technique is used? (file checks, build.tags, SafetyNet, etc.)
   - Show the complete detection logic with code snippets

2. **Enforcement Analysis (CRITICAL):**
   - What happens when root is detected?
   - Does the app TERMINATE or just LOG the event?
   - Search for: System.exit(), finish(), throw SecurityException(), or just log.d()/reportError()
   - Trace the detection result to see if it blocks app functionality

3. **Effectiveness Score (0-10):**
   - Apply the scoring rubric from this guide (see Effectiveness Assessment section)
   - Consider: detection methods, enforcement strength, bypassability

4. **Evidence for Report:**
   - File locations with line numbers
   - Code snippets showing detection AND enforcement
   - Justification for the effectiveness score

IMPORTANT: Distinguish between "detection for telemetry" (logs/reports but continues)
vs "detection for enforcement" (blocks app execution).
```

**Expected AI Output:**
- Detailed breakdown of enforcement logic
- Code flow from detection → response
- Preliminary effectiveness score with justification
- Evidence snippets for the security report

### ⚠️ Manual Validation Required

**AI limitations - You MUST manually verify:**

1. **Enforcement Logic (CRITICAL):**
   - AI can find detection code but may misinterpret enforcement
   - **YOU must read the code** to confirm: Does detection actually block the app?
   - Example: Bugsnag detects root but only for telemetry (continues execution) = 2/10, not 8/10

2. **False Positives:**
   - AI may flag "root.MainActivity" or "root" XML namespaces as root detection
   - **YOU must filter** search results to eliminate non-security matches

3. **Scoring Decisions:**
   - AI can suggest a score, but **YOU must apply the detailed rubric** from this guide
   - Consider: Detection technique count, implementation quality, native vs Java, response mechanism

4. **Business Logic:**
   - Only **YOU can decide** if root detection is appropriate for this app's risk profile
   - Some apps don't need root detection (low-sensitivity, public data)

### 🔀 Recommended Hybrid Approach

**Best Practice Workflow:**

1. **AI Quick Search (5 min):** Find all potential root detection code locations
2. **Manual Review (15 min):** Open top 3-5 files, read enforcement logic carefully
3. **AI Deep Analysis (15 min):** Ask AI to analyze enforcement flow in specific files
4. **Manual Scoring (10 min):** Apply the 0-10 rubric from "Effectiveness Assessment" section
5. **AI Report Draft (5 min):** Generate finding description with evidence
6. **Manual Final Review (5 min):** Verify accuracy, add context, sanitize for client

**Total Time:** ~55 minutes (vs 90+ minutes fully manual)

---

## Initial Discovery Commands

### Step 1: Quick Keyword Search

```bash
cd decompiled/sources

# Search for root/jailbreak detection keywords
grep -r "root\|jailbreak\|isRooted\|Cydia" . 2>/dev/null | wc -l

# Expected: High count (thousands) indicates potential implementation
# Low count (<100) indicates likely missing or minimal implementation
```

### Step 2: Search for Standard APIs

**Android:**
```bash
# SafetyNet Attestation API (Google's official integrity check)
grep -r "SafetyNet\|SafetyNetClient\|attest" . 2>/dev/null

# Play Integrity API (newer Google API)
grep -r "PlayIntegrity\|IntegrityManager" . 2>/dev/null

# Root management apps
grep -r "com.topjohnwu.magisk\|eu.chainfire.supersu" . 2>/dev/null
```

**iOS:**
```bash
# DeviceCheck API (Apple's integrity check)
grep -r "DeviceCheck\|DCDevice" . 2>/dev/null

# Cydia (jailbreak package manager)
grep -r "Cydia\|cydia://\|/Applications/Cydia.app" . 2>/dev/null
```

### Step 3: Find Implementation Files

```bash
# Find files that likely contain root detection logic
find . -name "*Root*.java" -o -name "*Jailbreak*.java" -o -name "*Integrity*.java"

# Search for suspicious file path checks
grep -r "File.*system.*su\|File.*xbin.*su\|File.*Superuser" . 2>/dev/null | head -20
```

---

## Effectiveness Assessment

### Scoring Criteria

| Criterion | Weight | Score (0-10) | Comments |
|-----------|--------|--------------|----------|
| **API Coverage** | 30% | 0 | No SafetyNet/Play Integrity API |
| **File Path Checks** | 20% | 2 | Only 2 paths checked, outdated |
| **Runtime Checks** | 20% | 0 | No attempt to execute `su` |
| **Package Checks** | 15% | 0 | No check for root management apps |
| **Property Checks** | 10% | 3 | Checks Build.TAGS (partial) |
| **Bypass Resistance** | 5% | 1 | Easily hooked with Frida |
| ****TOTAL SCORE** | **100%** | **2/10** | **POOR - Ineffective** |

### Generic Implementation Example

**Note:** Actual scoring should be based on your specific assessment findings.

**Verdict:** This implementation would **FAIL** to detect modern root methods used in 2020-2025.

#### What It Detects:
- ✅ Very old Superuser.apk (pre-2015)
- ✅ SU binary in `/system/xbin/su` only
- ✅ Custom ROM builds with test-keys

#### What It Misses (95%+ of modern root):
- ❌ **Magisk** (most popular root solution, ~95% market share)
- ❌ **KernelSU** (kernel-level root)
- ❌ **APatch** (newer systemless root)
- ❌ **Magisk Hide/DenyList** (root cloaking)
- ❌ SU binaries in other locations (`/sbin/su`, `/system/bin/su`, etc.)
- ❌ Root management apps installed
- ❌ SELinux permissive mode
- ❌ Dangerous build properties (`ro.debuggable=1`, `ro.secure=0`)

---

## Common Implementation Patterns

### Pattern 1: File Path Checking (Basic)

**Effectiveness: Low (2/10)**

```java
private static final String[] SU_PATHS = {
    "/system/bin/su",
    "/system/xbin/su",       // the assessed application only checks this one
    "/system/sbin/su",
    "/sbin/su",
    "/vendor/bin/su",
    "/data/local/xbin/su",
    "/data/local/bin/su",
    "/su/bin/su",
    "/system/sd/xbin/su",
    "/system/bin/failsafe/su",
    "/data/local/su",
    "/su/bin/su"
};

public static boolean checkSuPaths() {
    for (String path : SU_PATHS) {
        if (new File(path).exists()) {
            return true;  // Root detected
        }
    }
    return false;
}
```

**Bypass:** Easily defeated with Frida:
```javascript
// Frida hook to hide file existence
Java.use("java.io.File").exists.implementation = function() {
    var path = this.getAbsolutePath();
    if (path.includes("su")) {
        return false;  // Hide SU binary
    }
    return this.exists.call(this);
};
```

### Pattern 2: Package Manager Check (Medium)

**Effectiveness: Medium (4/10)**

```java
private static final String[] ROOT_PACKAGES = {
    "com.noshufou.android.su",           // Superuser
    "com.noshufou.android.su.elite",
    "eu.chainfire.supersu",               // SuperSU
    "com.koushikdutta.superuser",
    "com.thirdparty.superuser",
    "com.yellowes.su",
    "com.topjohnwu.magisk",               // Magisk Manager
    "com.kingroot.kinguser",
    "com.kingo.root",
    "com.smedialink.oneclickroot",
    "com.zhiqupk.root.global",
    "com.alephzain.framaroot"
};

public static boolean checkRootPackages(Context context) {
    PackageManager pm = context.getPackageManager();
    for (String pkg : ROOT_PACKAGES) {
        try {
            pm.getPackageInfo(pkg, 0);
            return true;  // Root app detected
        } catch (PackageManager.NameNotFoundException e) {
            // Not installed
        }
    }
    return false;
}
```

### Pattern 3: Build Properties (Medium)

**Effectiveness: Medium (5/10)**

```java
public static boolean checkBuildProperties() {
    // Check test-keys (the assessed application does this)
    String buildTags = Build.TAGS;
    if (buildTags != null && buildTags.contains("test-keys")) {
        return true;
    }

    // Check dangerous properties
    String[] props = {
        "ro.debuggable",
        "ro.secure",
        "ro.build.selinux"
    };

    // Use reflection to read system properties
    try {
        Class<?> c = Class.forName("android.os.SystemProperties");
        Method get = c.getMethod("get", String.class);

        String debuggable = (String) get.invoke(c, "ro.debuggable");
        if ("1".equals(debuggable)) {
            return true;  // Device is debuggable
        }

        String secure = (String) get.invoke(c, "ro.secure");
        if ("0".equals(secure)) {
            return true;  // Device security disabled
        }
    } catch (Exception e) {
        // Property check failed
    }

    return false;
}
```

### Pattern 4: Runtime Command Execution (Medium-High)

**Effectiveness: Medium-High (6/10)**

```java
public static boolean checkSuCommand() {
    Process process = null;
    try {
        process = Runtime.getRuntime().exec(new String[]{"/system/xbin/which", "su"});
        BufferedReader in = new BufferedReader(
            new InputStreamReader(process.getInputStream()));
        String line = in.readLine();
        if (line != null) {
            return true;  // SU command found
        }
    } catch (Exception e) {
        // Command failed
    } finally {
        if (process != null) {
            process.destroy();
        }
    }
    return false;
}

public static boolean executeSuCommand() {
    Process process = null;
    try {
        // Try to execute 'id' as root
        process = Runtime.getRuntime().exec("su");
        DataOutputStream os = new DataOutputStream(process.getOutputStream());
        os.writeBytes("id\n");
        os.writeBytes("exit\n");
        os.flush();

        // Check if we got root access
        BufferedReader in = new BufferedReader(
            new InputStreamReader(process.getInputStream()));
        String line = in.readLine();
        if (line != null && line.toLowerCase().contains("uid=0")) {
            return true;  // Root access granted!
        }
    } catch (Exception e) {
        // SU command failed
    } finally {
        if (process != null) {
            process.destroy();
        }
    }
    return false;
}
```

### Pattern 5: SELinux Status (Medium)

**Effectiveness: Medium (5/10)**

```java
public static boolean checkSelinuxStatus() {
    Process process = null;
    try {
        process = Runtime.getRuntime().exec("getenforce");
        BufferedReader in = new BufferedReader(
            new InputStreamReader(process.getInputStream()));
        String mode = in.readLine();

        // Rooted devices often have SELinux in Permissive mode
        if ("Permissive".equalsIgnoreCase(mode)) {
            return true;
        }
    } catch (Exception e) {
        // Command failed
    } finally {
        if (process != null) {
            process.destroy();
        }
    }
    return false;
}
```

### Pattern 6: Google SafetyNet/Play Integrity API (Best Practice)

**Effectiveness: High (9/10)**

**SafetyNet (Deprecated but still used):**
```java
import com.google.android.gms.safetynet.SafetyNet;
import com.google.android.gms.safetynet.SafetyNetApi;

public void performSafetyNetCheck(Context context) {
    String apiKey = "YOUR_API_KEY";
    byte[] nonce = generateNonce();  // Random bytes

    SafetyNet.getClient(context)
        .attest(nonce, apiKey)
        .addOnSuccessListener(response -> {
            String jwsResult = response.getJwsResult();

            // Send JWS to your backend for verification
            // Backend should verify with Google's servers

            // Basic client-side check (not sufficient alone)
            if (!response.isCtsProfileMatch()) {
                // Device failed CTS (likely rooted/modified)
                handleRootedDevice();
            }

            if (!response.isBasicIntegrity()) {
                // Device lacks basic integrity (definitely compromised)
                handleRootedDevice();
            }
        })
        .addOnFailureListener(e -> {
            // SafetyNet check failed
            handleSafetyNetError(e);
        });
}
```

**Play Integrity API (Recommended):**
```java
import com.google.android.play.core.integrity.IntegrityManager;
import com.google.android.play.core.integrity.IntegrityManagerFactory;
import com.google.android.play.core.integrity.IntegrityTokenRequest;

public void performPlayIntegrityCheck(Context context) {
    IntegrityManager integrityManager =
        IntegrityManagerFactory.create(context);

    // Generate a nonce that includes your request information
    String nonce = generateNonce();

    IntegrityTokenRequest request = IntegrityTokenRequest.builder()
        .setNonce(nonce)
        .build();

    integrityManager.requestIntegrityToken(request)
        .addOnSuccessListener(response -> {
            String token = response.token();

            // CRITICAL: Send token to your backend for verification
            // Never trust client-side checks alone
            verifyIntegrityTokenOnServer(token);
        })
        .addOnFailureListener(e -> {
            // Integrity check failed
            handleIntegrityFailure(e);
        });
}
```

### Pattern 7: Magisk-Specific Detection (Advanced)

**Effectiveness: Medium-High (7/10)**

```java
private static final String[] MAGISK_PATHS = {
    "/data/adb/magisk",
    "/data/adb/magisk.db",
    "/data/adb/modules",
    "/data/adb/post-fs-data.d",
    "/data/adb/service.d",
    "/cache/magisk.log",
    "/dev/.magisk",
    "/sbin/.magisk"
};

public static boolean checkMagisk() {
    // Check Magisk files
    for (String path : MAGISK_PATHS) {
        if (new File(path).exists()) {
            return true;
        }
    }

    // Check for Magisk package
    try {
        PackageManager pm = context.getPackageManager();
        pm.getPackageInfo("com.topjohnwu.magisk", 0);
        return true;
    } catch (PackageManager.NameNotFoundException e) {
        // Not installed
    }

    // Check mount points for Magisk
    try {
        Process process = Runtime.getRuntime().exec("mount");
        BufferedReader in = new BufferedReader(
            new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = in.readLine()) != null) {
            if (line.contains("magisk") || line.contains("core_only")) {
                return true;
            }
        }
    } catch (Exception e) {
        // Check failed
    }

    return false;
}
```

### Pattern 8: Native Code Detection (Most Resistant)

**Effectiveness: High (8/10)**

Implement checks in C/C++ using JNI/NDK:

```c
// native-lib.cpp
#include <jni.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>

extern "C" JNIEXPORT jboolean JNICALL
Java_com_yourapp_SecurityUtils_isRootedNative(JNIEnv* env, jobject obj) {
    // Check SU paths
    const char* paths[] = {
        "/system/bin/su",
        "/system/xbin/su",
        "/sbin/su",
        "/data/local/xbin/su",
        NULL
    };

    for (int i = 0; paths[i] != NULL; i++) {
        struct stat st;
        if (stat(paths[i], &st) == 0) {
            return JNI_TRUE;  // Root detected
        }
    }

    // Check Magisk
    if (stat("/data/adb/magisk", &st) == 0) {
        return JNI_TRUE;
    }

    return JNI_FALSE;
}
```

**Advantages:**
- Harder to hook (requires native hooking)
- Can obfuscate detection logic
- Can implement anti-tampering checks

---

## Improvement Recommendations

### Priority 1: IMMEDIATE (24-48 hours)

#### 1. Integrate Google Play Integrity API

**Why:** Industry-standard, server-verified, hardest to bypass

**Implementation Steps:**
```gradle
// build.gradle
dependencies {
    implementation 'com.google.android.play:integrity:1.2.0'
}
```

**Backend Verification (CRITICAL):**
- Never trust client-side integrity checks alone
- Always verify integrity tokens on your backend server
- Use Google's verification endpoint
- Implement rate limiting and fraud detection

#### 2. Expand File Path Checks

Update `zg/g.java` to check all common SU locations:

```java
private static final String[] SU_PATHS = {
    "/system/bin/su",
    "/system/xbin/su",        // Currently only this one checked
    "/system/sbin/su",
    "/sbin/su",
    "/vendor/bin/su",
    "/data/local/xbin/su",
    "/data/local/bin/su",
    "/su/bin/su",
    "/system/sd/xbin/su",
    "/system/bin/failsafe/su",
    "/data/local/su"
};

// Replace single file check with loop
for (String path : SU_PATHS) {
    if (new File(path).exists()) {
        return true;
    }
}
```

#### 3. Add Magisk Detection

**Critical:** Magisk represents 95%+ of modern root installations

```java
private static final String[] MAGISK_FILES = {
    "/data/adb/magisk",
    "/data/adb/magisk.db",
    "/data/adb/modules"
};

public static boolean detectMagisk() {
    for (String path : MAGISK_FILES) {
        if (new File(path).exists()) {
            return true;
        }
    }
    return false;
}
```

### Priority 2: SHORT-TERM (1-2 weeks)

#### 4. Add Package Manager Checks

```java
private static final String[] ROOT_APPS = {
    "com.topjohnwu.magisk",
    "eu.chainfire.supersu",
    "com.noshufou.android.su",
    "com.koushikdutta.superuser",
    "com.thirdparty.superuser",
    "com.yellowes.su"
};

public static boolean detectRootApps(Context context) {
    PackageManager pm = context.getPackageManager();
    for (String pkg : ROOT_APPS) {
        try {
            pm.getPackageInfo(pkg, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            // Continue checking
        }
    }
    return false;
}
```

#### 5. Add Runtime Execution Checks

```java
public static boolean canExecuteSu() {
    try {
        Process process = Runtime.getRuntime().exec("su");
        DataOutputStream os = new DataOutputStream(process.getOutputStream());
        os.writeBytes("id\n");
        os.flush();

        BufferedReader in = new BufferedReader(
            new InputStreamReader(process.getInputStream()));
        String output = in.readLine();

        if (output != null && output.toLowerCase().contains("uid=0")) {
            return true;  // Root access successful
        }
    } catch (Exception e) {
        // Expected on non-rooted devices
    }
    return false;
}
```

#### 6. Add SELinux Check

```java
public static boolean isSelinuxPermissive() {
    try {
        Process process = Runtime.getRuntime().exec("getenforce");
        BufferedReader in = new BufferedReader(
            new InputStreamReader(process.getInputStream()));
        String mode = in.readLine();
        return "Permissive".equalsIgnoreCase(mode);
    } catch (Exception e) {
        return false;
    }
}
```

### Priority 3: LONG-TERM (1-3 months)

#### 7. Implement Native Code Checks

Move critical detection logic to C/C++ using NDK:

**Benefits:**
- Harder to hook (requires native hooking frameworks)
- Can obfuscate detection algorithms
- Better performance
- Can check `/proc/mounts` and `/proc/self/maps` for suspicious entries

#### 8. Add Anti-Hooking Protection

**Detect Frida:**
```java
public static boolean detectFrida() {
    // Check for Frida server process
    try {
        Process process = Runtime.getRuntime().exec("ps");
        BufferedReader in = new BufferedReader(
            new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = in.readLine()) != null) {
            if (line.contains("frida-server") ||
                line.contains("frida-agent")) {
                return true;
            }
        }
    } catch (Exception e) {
        // Check failed
    }

    // Check for Frida-related files
    String[] fridaPaths = {
        "/data/local/tmp/frida-server",
        "/sdcard/frida-server"
    };
    for (String path : fridaPaths) {
        if (new File(path).exists()) {
            return true;
        }
    }

    return false;
}
```

**Detect Xposed:**
```java
public static boolean detectXposed() {
    try {
        throw new Exception();
    } catch (Exception e) {
        for (StackTraceElement element : e.getStackTrace()) {
            if (element.getClassName().contains("de.robv.android.xposed") ||
                element.getClassName().contains("XposedBridge")) {
                return true;
            }
        }
    }

    // Check for Xposed packages
    String[] xposedPackages = {
        "de.robv.android.xposed.installer",
        "com.saurik.substrate"
    };
    PackageManager pm = context.getPackageManager();
    for (String pkg : xposedPackages) {
        try {
            pm.getPackageInfo(pkg, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            // Not installed
        }
    }

    return false;
}
```

#### 9. Implement Randomized Check Timing

```java
public class RootDetectionScheduler {
    private static final long MIN_INTERVAL = 30_000;  // 30 seconds
    private static final long MAX_INTERVAL = 300_000; // 5 minutes

    public void scheduleRandomChecks() {
        Handler handler = new Handler(Looper.getMainLooper());
        Runnable checkRunnable = new Runnable() {
            @Override
            public void run() {
                performRootCheck();

                // Schedule next check at random interval
                long delay = MIN_INTERVAL +
                    (long)(Math.random() * (MAX_INTERVAL - MIN_INTERVAL));
                handler.postDelayed(this, delay);
            }
        };

        // Start first check
        handler.post(checkRunnable);
    }
}
```

#### 10. Server-Side Verification

**Client sends:**
```json
{
    "deviceId": "abc123",
    "integrityToken": "eyJhbGc...",
    "rootDetection": {
        "suBinaryFound": false,
        "rootAppsFound": false,
        "magiskDetected": false,
        "selinuxPermissive": false
    },
    "timestamp": 1699999999
}
```

**Server validates:**
- Verify Play Integrity token with Google
- Compare client-reported values with token
- Flag inconsistencies
- Track patterns across sessions
- Implement risk scoring

---

## Testing and Verification

### Manual Testing Checklist

- [ ] Test on non-rooted device (should return false)
- [ ] Test on device with Magisk (should return true)
- [ ] Test on device with Magisk Hide enabled (bypass check)
- [ ] Test on device with SuperSU (should return true)
- [ ] Test with Frida hooking detection methods (should still detect or fail safely)
- [ ] Test on emulator (should handle gracefully)
- [ ] Verify SafetyNet/Play Integrity API integration
- [ ] Test server-side verification endpoint
- [ ] Verify behavior when Play Services unavailable

### Automated Testing

**Unit Test Example:**
```java
@Test
public void testRootDetection_NonRootedDevice() {
    // Mock file system to simulate non-rooted device
    when(mockFile.exists()).thenReturn(false);

    boolean result = SecurityUtils.isDeviceRooted(mockContext);
    assertFalse("Non-rooted device incorrectly detected as rooted", result);
}

@Test
public void testRootDetection_MagiskPresent() {
    // Mock Magisk file presence
    when(mockFile.exists()).thenReturn(true);

    boolean result = SecurityUtils.detectMagisk();
    assertTrue("Failed to detect Magisk installation", result);
}
```

### Bypass Testing (Ethical Only)

**Test with Frida:**
```javascript
// Hook File.exists() to hide SU binary
Java.perform(function() {
    var File = Java.use("java.io.File");
    File.exists.implementation = function() {
        var path = this.getAbsolutePath();
        if (path.includes("su") || path.includes("magisk")) {
            console.log("[*] Hiding file: " + path);
            return false;
        }
        return this.exists();
    };
});
```

**Expected:** Modern detection should:
1. Use multiple checks (not just file paths)
2. Implement anti-hooking measures
3. Rely on server-side verification (can't be bypassed)

---

## Use in Comparative Analysis

**When conducting comparative analysis (Phase 6 of assessment workflow), use this guide to:**

### 1. Score Both Versions Using the Same Rubric

**For v1 (Original Assessment):**<br>→ Use the [Effectiveness Assessment](#effectiveness-assessment) scoring rubric (0-10 scale)<br>→ Document detection methods, enforcement type, and score<br>→ Record in original assessment report

**For v2 (Post-Remediation Assessment):**<br>→ Re-apply the same scoring rubric to ensure consistency<br>→ Use identical criteria to measure improvement<br>→ Compare detection methods and enforcement changes

**Example:**
```markdown
| Version | Detection Method | Enforcement | Score | Status |
|---------|------------------|-------------|-------|--------|
| v1 | Bugsnag telemetry only | None | 2/10 | 🔴 FAIL |
| v2 | Play Integrity API + enforcement | App terminates | 7/10 | 🟢 PASS |
| **Change** | **+Multi-layer detection** | **+Enforcement added** | **+5** | **✅ MAJOR IMPROVEMENT** |
```

### 2. Assess Remediation Quality

Use this guide's [Improvement Recommendations](#improvement-recommendations) section to evaluate fix quality:

**Excellent Remediation (9-10/10):**<br>→ Multi-layered detection implemented (Play Integrity + device checks)<br>→ Enforcement added (app terminates or blocks functionality)<br>→ Server-side verification integrated<br>→ Root cause addressed per this guide's recommendations

**Good Remediation (7-8/10):**<br>→ Detection upgraded (e.g., basic → SafetyNet/Play Integrity)<br>→ Enforcement added<br>→ Minor gaps remain (e.g., no server-side verification)

**Partial Remediation (4-6/10):**<br>→ Detection improved but enforcement weak<br>→ Or enforcement added but detection bypassable<br>→ Surface fix without addressing root cause

**Failed Remediation (0-3/10):**<br>→ No changes made<br>→ Or changes made but still telemetry-only<br>→ Or changes introduce new vulnerabilities

### 3. Document Evidence for Comparative Report

**Required evidence for `COMPARATIVE_TEMPLATE.md`:**

**Detection Method Comparison:**
```markdown
**v1:** Bugsnag RootDetector.java:42 (file checks only)
**v2:** PlayIntegrityManager.java:127 (attestation + device checks)
```

**Enforcement Comparison:**
```markdown
**v1:** Detection result logged but app continues (telemetry only)
**v2:** App terminates when root detected at SecurityManager.java:89
```

**Effectiveness Score Justification:**
```markdown
**v1 Score: 2/10** - Per RESILIENCE-1 rubric: "Telemetry-only detection"
**v2 Score: 7/10** - Per RESILIENCE-1 rubric: "Play Integrity + enforcement"
**Improvement: +5 points** - Detection upgraded and enforcement added
```

### 4. Identify Remaining Gaps

Even if remediation improved the score, document what's still missing:

```markdown
**Remaining Gaps (for next version):**
- [ ] No server-side Play Integrity token verification (recommendation from RESILIENCE-1 guide)
- [ ] Detection could be more frequent (currently only at startup)
- [ ] No anti-hooking protection for detection code itself
```

### 5. Reference This Guide's Sections

When writing comparative analysis, reference specific sections:

**For scoring methodology:**<br>→ Link to: [Effectiveness Assessment](#effectiveness-assessment)

**For improvement recommendations:**<br>→ Link to: [Improvement Recommendations](#improvement-recommendations)

**For implementation patterns:**<br>→ Link to: [Common Implementation Patterns](#common-implementation-patterns)

**For verification testing:**<br>→ Link to: [Testing and Verification](#testing-and-verification)

### Related Documentation

**Comparative Analysis Guides:**<br>→ **Process:** `GETTING_STARTED.md` Comparative Analysis section (tutorial)<br>→ **Checklist:** `ASSESSMENT_WORKFLOW.md` Phase 6<br>→ **Template:** `templates/COMPARATIVE_TEMPLATE.md` (deliverable structure)

---

## Reporting Template

### Finding Title
**Inadequate Root Detection - MASVS-RESILIENCE-1**

### Severity
**HIGH** (CVSS 7.0-7.5)

### CVSS Vector
```
CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N
```

**Breakdown:**
- **AV:L** - Local attack (requires device access)
- **AC:L** - Low complexity (easy to root device)
- **PR:N** - No privileges required
- **UI:N** - No user interaction
- **S:U** - Unchanged scope
- **C:H** - High confidentiality impact (data exposure)
- **I:H** - High integrity impact (app behavior modification)
- **A:N** - No availability impact

### OWASP MASVS Mapping

**Primary Controls:**
- **MASVS-RESILIENCE-1**: The app implements checks to detect and respond to the presence of a rooted or jailbroken device
- **MASVS-PLATFORM-2**: The app uses inter-process communication (IPC) mechanisms securely

**Secondary Controls:**
- **MASVS-STORAGE-1**: The app securely stores sensitive data
- **MASVS-CRYPTO-2**: The app performs key management according to industry best practices

### CWE
- **CWE-250**: Execution with Unnecessary Privileges
- **CWE-693**: Protection Mechanism Failure

### OWASP Mobile Top 10
- **M1**: Improper Platform Usage
- **M9**: Reverse Engineering

### Location
**File:** `[decompiled source path]:94-101`

### Technical Evidence

```java
public static boolean g() {
    boolean zF = f();
    String str = Build.TAGS;
    if ((zF || str == null || !str.contains("test-keys"))
        && !new File("/system/app/Superuser.apk").exists()) {
        return !zF && new File("/system/xbin/su").exists();
    }
    return true;
}
```

### Description

The application implements root detection, but the implementation is **ineffective against modern root methods**. The current implementation only checks:

1. Build tags for "test-keys"
2. Presence of `/system/app/Superuser.apk` (outdated, ~2011-2013)
3. Presence of `/system/xbin/su` (one of many possible locations)

**Effectiveness Score: 2/10 (POOR)**

This implementation would **fail to detect**:
- Magisk (95%+ of modern root installations)
- KernelSU, APatch (modern root methods)
- SU binaries in other common locations
- Root management applications
- SELinux permissive mode
- Magisk Hide/DenyList (root cloaking)

### Impact

**Confidentiality:**
- Rooted devices allow memory dumping, exposing:
  - Cryptographic keys (Finding #1: hardcoded RSA keys)
  - Session tokens (Finding #2: superuser tokens)
  - Sensitive user data in memory

**Integrity:**
- Attackers can use Frida/Xposed to:
  - Bypass authentication checks
  - Modify API requests/responses
  - Alter business logic
  - Inject malicious code at runtime

**Business Impact:**
- Compliance violations (PCI-DSS 6.5, SOC 2)
- Increased fraud risk
- Reputation damage if user data compromised
- Regulatory penalties (GDPR Article 32)

### Attack Scenario

1. **Attacker roots device** using Magisk (< 30 minutes)
2. **Magisk Hide enabled** - conceals root from basic detection
3. **App launches normally** - weak root detection bypassed
4. **Attacker uses Frida** to hook security functions:
   ```javascript
   // Hook authentication to always return success
   Java.perform(function() {
       var Auth = Java.use("com.app.AuthManager");
       Auth.validateUser.implementation = function() {
           console.log("[*] Auth bypassed!");
           return true;  // Always authenticated
       };
   });
   ```
5. **Attacker extracts data** from memory or storage
6. **Hardcoded keys exposed** (RSA private key from Finding #1)

### OWASP MASVS Context

**Violated Controls:**

**MASVS-RESILIENCE-1:** The app attempts root detection but implementation is inadequate:
- No use of Google Play Integrity API
- Outdated file path checks
- No Magisk-specific detection
- No runtime SU execution checks
- Easily bypassed with Frida hooks

**Why This Matters:**
OWASP MASVS-RESILIENCE category exists specifically to protect against reverse engineering attacks. Without effective root detection:
- All other security controls can be bypassed
- Code obfuscation becomes ineffective (can be bypassed with hooks)
- Stored credentials can be extracted
- API communications can be intercepted and modified

### Remediation

#### Immediate (24-48 hours) - Priority: CRITICAL

1. **Integrate Google Play Integrity API**<br>   → Add Play Integrity library to project dependencies<br>   → Implement client-side token generation<br>   → Latest stable version recommended (1.2.0+)

2. **Implement server-side verification**<br>   → Verify integrity tokens on backend API<br>   → Never trust client-side checks alone<br>   → Implement risk-based authentication based on device integrity scores

3. **Expand file path checks to include all SU binary locations:**<br>   → `/system/bin/su`, `/system/sbin/su`, `/sbin/su`<br>   → `/vendor/bin/su`, `/data/local/xbin/su`, `/data/local/bin/su`<br>   → `/system/xbin/su` and other common locations

4. **Add Magisk detection mechanisms**<br>   → Check for Magisk installation directory (`/data/adb/magisk`)<br>   → Scan for Magisk package presence<br>   → Inspect mount points for Magisk modifications

#### Short-term (1-2 weeks)

5. **Add package manager checks**<br>   → Detect root management applications (Magisk Manager, SuperSU, KingRoot)<br>   → Check for Xposed/Frida framework packages<br>   → Scan for common root-enabling tools

6. **Implement runtime integrity checks**<br>   → Attempt to execute `su` command and monitor result<br>   → Check SELinux enforcement status via `getenforce`<br>   → Verify build properties for test-keys and debug signatures

7. **Add anti-hooking detection measures**<br>   → Detect Frida server presence (network ports, processes)<br>   → Check for Xposed framework indicators<br>   → Monitor stack traces for hooking framework signatures

#### Long-term (1-3 months)

8. **Migrate detection logic to native code (JNI/NDK)**<br>   → Implement root checks in C/C++ for Java layer protection<br>   → Apply native code obfuscation (harder to hook than Java)<br>   → Use NDK for performance-critical detection routines

9. **Implement multi-layered defense-in-depth strategy**<br>   → Deploy multiple detection methods at randomized intervals<br>   → Implement variable check timing to prevent prediction<br>   → Ensure secure failure modes if detection is tampered with

10. **Deploy server-side risk scoring and behavioral analysis**<br>    → Track device behavior patterns and anomaly detection<br>    → Flag suspicious activities for investigation<br>    → Implement graduated response model (not binary block/allow)

### Implementation Support

Detailed code examples, configuration templates, and step-by-step implementation guides are available upon request. Contact us for:

→ **Sample code libraries** - Ready-to-use root detection implementations<br>→ **Integration workshops** - Hands-on guidance for your development team<br>→ **Custom detection strategies** - Tailored to your app's security requirements<br>→ **Testing and validation** - Verify detection effectiveness against bypass techniques

### Verification Steps

**To verify vulnerability exists:**
```bash
# 1. Root device with Magisk
# 2. Enable Magisk Hide/DenyList
# 3. Launch the assessed application app
# Expected: App runs normally (root NOT detected)
```

**To verify fix:**
```bash
# 1. Root device with Magisk
# 2. Enable Magisk Hide/DenyList
# 3. Launch updated app
# Expected: App detects root and responds appropriately
# - Shows warning message, OR
# - Limits sensitive functionality, OR
# - Requires additional authentication
```

### References

- **OWASP MASVS v2.0**: https://mas.owasp.org/MASVS/05-MASVS-RESILIENCE/
- **OWASP MASTG - Root Detection**: https://mas.owasp.org/MASTG/Android/0x05j-Testing-Resiliency-Against-Reverse-Engineering/#root-detection
- **Google Play Integrity API**: https://developer.android.com/google/play/integrity
- **CWE-250**: https://cwe.mitre.org/data/definitions/250.html
- **CWE-693**: https://cwe.mitre.org/data/definitions/693.html

---

## Additional Resources

### Tools for Root Detection Testing

- **Magisk**: https://github.com/topjohnwu/Magisk
- **Frida**: https://frida.re/
- **Xposed Framework**: https://repo.xposed.info/
- **RootBeer Library**: https://github.com/scottyab/rootbeer (comprehensive detection library)
- **SafetyNet Helper**: https://github.com/scottyab/safetynethelper

### Recommended Reading

1. OWASP Mobile Security Testing Guide - Root Detection
2. "Android Application Security" by Dominic Chell
3. Google Play Integrity API Documentation
4. Magisk Documentation (to understand bypass techniques)

---

**Document Version:** 1.0
**Last Updated:** 2025-10-31
**Assessment Target:** the assessed application APK v4.172.1
**Standards:** OWASP MASVS v2.0, CVSS v3.1, CWE
