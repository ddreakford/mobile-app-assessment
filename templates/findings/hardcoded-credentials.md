# Finding Template: Hardcoded Credentials

## Metadata
- **Finding ID:** [CRIT/HIGH/MED/LOW]-[NUMBER]
- **Title:** Hardcoded [Credential Type] in [Location]
- **Severity:** CRITICAL/HIGH
- **CVSS Score:** [8.0-9.5] typical range
- **Status:** [DRAFT/CONFIRMED/FALSE_POSITIVE]

## CVSS Vector
**CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:L**

Justification:
- AV:N - APK downloadable, credentials extractable remotely
- AC:L - Trivial to decompile and extract
- PR:N - No authentication required to decompile
- UI:N - No user interaction needed
- C:H - Credentials fully exposed
- I:H - Unauthorized API access possible
- A:L - Potential service disruption

## Location
**Primary:**
- `[file_path]:[line_number]`
- Example: `decompiled/resources/res/values/strings.xml:66`

**Secondary Locations:**
- `[additional_locations_if_referenced_multiple_places]`

## Description
The application contains hardcoded [credential type - API key/password/secret] stored in plaintext in [location - resources/source code]. These credentials provide access to [service/API] and can be trivially extracted by:

1. Downloading the APK from app store
2. Decompiling with JADX or APKTool
3. Reading credentials from [specific file]

## Evidence
```[xml/java/kotlin]
<!-- decompiled/resources/res/values/strings.xml -->
<string name="api_key">[REDACTED_IN_REPORT]</string>
<string name="api_secret">[REDACTED_IN_REPORT]</string>
```

Or for source code:
```java
// com/example/app/Config.java:42
private static final String API_KEY = "[REDACTED]";
private static final String API_SECRET = "[REDACTED]";
```

**Screenshot:** [If applicable, reference screenshot in assessment-resources/]

## Impact Analysis

### Confidentiality: HIGH
- Credentials are fully exposed to anyone who decompiles the APK
- No additional authentication required to extract

### Integrity: HIGH  
- Attackers can use credentials to [specific abuse scenarios]
- Unauthorized [API calls/data modification/service access]

### Availability: LOW/MEDIUM
- Potential for [API quota exhaustion/service disruption]
- Legitimate users may be affected by attacker actions

### Business Impact
- **Reputational Risk:** [Describe impact]
- **Financial Risk:** [API quota costs, potential abuse]
- **Compliance Risk:** [PCI-DSS, GDPR, etc. if applicable]
- **User Privacy:** [If credentials access user data]

## Attack Scenario

**Attacker Profile:** Script kiddie (low skill)
**Required Resources:** APK file + JADX decompiler (free tools)
**Time to Exploit:** 5-10 minutes

**Steps:**
1. Download APK from [app store/website]
   ```bash
   # APK available publicly
   ```

2. Decompile APK:
   ```bash
   jadx MyApp.apk -d output/
   ```

3. Extract credentials:
   ```bash
   cat output/resources/res/values/strings.xml | grep -i "api.*key"
   # Output: <string name="api_key">HARDCODED_VALUE</string>
   ```

4. Use credentials to access [service]:
   ```bash
   curl -H "X-API-Key: HARDCODED_VALUE" https://api.service.com/
   ```

5. Perform unauthorized actions:
   - [Specific abuse scenarios based on API capabilities]

**Likelihood:** HIGH (trivial exploit, publicly available APK)
**Impact:** HIGH (see above)

## OWASP MASVS Mapping

**Primary Violations:**
- **MASVS-STORAGE-2:** The app uses secure storage APIs
  - Violation: Credentials stored in plaintext resources
- **MASVS-CODE-4:** The app does not contain sensitive data in code or resources
  - Violation: Hardcoded credentials in resources/source

**Secondary:**
- **MASVS-RESILIENCE-2:** (If no obfuscation) Easy to locate credentials

**CWE:**
- **CWE-798:** Use of Hard-coded Credentials
- **CWE-259:** Use of Hard-coded Password (if password)
- **CWE-321:** Use of Hard-coded Cryptographic Key (if crypto key)

**OWASP Mobile Top 10:**
- **M9:** Insecure Data Storage

## Remediation

### Emergency Actions (0-48 hours)

**Priority: IMMEDIATE**

1. **Rotate Credentials**
   ```bash
   # On credential server/dashboard:
   # 1. Generate new API key/secret
   # 2. Update backend to accept new credentials
   # 3. Revoke old credentials: [OLD_KEY]
   ```

2. **Audit API Usage**
   ```bash
   # Check server logs for unauthorized access
   # Look for unusual patterns, IPs, usage spikes
   ```

3. **Release Emergency Patch**
   - Remove hardcoded credentials from next build
   - Force update for all users
   - **DO NOT** push new credentials hardcoded again

**Owner:** Backend Team + Mobile Team
**Timeline:** 24-48 hours maximum

### Short-term Fix (1-2 weeks)

**Implement Server-Side Credential Delivery:**

```java
// Instead of hardcoded:
// private static final String API_KEY = "hardcoded_value";

// Fetch from secure backend on first launch:
public class CredentialManager {
    private SecureApiClient apiClient;
    
    public void fetchCredentials() {
        apiClient.getServiceCredentials()
            .thenAccept(credentials -> {
                // Store in Android Keystore (hardware-backed)
                storeInKeystore(credentials.getApiKey());
            })
            .exceptionally(e -> {
                Log.e(TAG, "Failed to fetch credentials", e);
                return null;
            });
    }
    
    private void storeInKeystore(String apiKey) {
        try {
            KeyStore keyStore = KeyStore.getInstance("AndroidKeyStore");
            keyStore.load(null);
            
            // Generate encryption key
            KeyGenerator keyGen = KeyGenerator.getInstance(
                KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
            keyGen.init(new KeyGenParameterSpec.Builder(
                "api_credentials",
                KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .build());
            
            SecretKey key = keyGen.generateKey();
            
            // Encrypt and store credentials
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] encrypted = cipher.doFinal(apiKey.getBytes());
            
            // Save encrypted credentials to SharedPreferences
            getSharedPreferences("secure_prefs", MODE_PRIVATE)
                .edit()
                .putString("encrypted_api_key", Base64.encodeToString(encrypted, Base64.DEFAULT))
                .putString("iv", Base64.encodeToString(cipher.getIV(), Base64.DEFAULT))
                .apply();
                
        } catch (Exception e) {
            Log.e(TAG, "Keystore error", e);
        }
    }
}
```

**Owner:** Mobile Team
**Timeline:** 1-2 weeks
**Testing Required:** Verify credentials never in code/resources

### Long-term Improvements (1-3 months)

1. **Implement OAuth 2.0 or Similar**
   - Use industry-standard authentication
   - Per-device tokens instead of shared credentials
   - Token rotation policy

2. **Certificate Pinning for Credential Endpoint**
   ```java
   OkHttpClient client = new OkHttpClient.Builder()
       .certificatePinner(new CertificatePinner.Builder()
           .add("api.yourservice.com", "sha256/AAAAAAAAAA...")
           .build())
       .build();
   ```

3. **Automated Secret Scanning**
   ```bash
   # Add to CI/CD pipeline
   - name: Scan for secrets
     run: |
       git-secrets --scan
       truffleHog --regex --entropy=True .
   ```

4. **Security Code Review Process**
   - Pre-commit hooks to block credential commits
   - Mandatory security review for auth code changes

**Owner:** Security Team + DevOps
**Timeline:** 2-3 months

## Verification & Testing

### Verify Fix
```bash
# After remediation, verify credentials NOT in code:
jadx MyApp-fixed.apk -d output/
grep -r "api.*key\|secret" output/ --include="*.java"
# Expected: No hardcoded values found

# Verify credentials NOT in resources:
apktool d MyApp-fixed.apk -o resources/
grep -r "api.*key\|secret" resources/res/
# Expected: No hardcoded values found
```

### Test Credential Fetch
```java
// Add instrumentation test
@Test
public void testCredentialFetch() {
    CredentialManager manager = new CredentialManager();
    manager.fetchCredentials();
    
    // Verify credentials retrieved and stored securely
    assertNotNull(manager.getStoredCredentials());
    
    // Verify NOT hardcoded
    assertFalse(containsHardcodedCredentials());
}
```

## References
- **OWASP MASVS:** https://mas.owasp.org/MASVS/controls/MASVS-STORAGE-2/
- **CWE-798:** https://cwe.mitre.org/data/definitions/798.html
- **Android Keystore:** https://developer.android.com/training/articles/keystore
- **CVSS Calculator:** https://www.first.org/cvss/calculator/3.1

## Notes
- **Date Identified:** [YYYY-MM-DD]
- **Identified By:** [Your Name]
- **Validated:** [Yes/No] [By Whom] [Date]
- **False Positive Check:** [Any reason this might not be exploitable?]

---

*Use this template for all hardcoded credential findings. Adjust severity based on credential scope and impact.*
