# Troubleshooting Guide

Common issues and solutions for mobile security assessments.

## Decompilation Issues

### Issue: JADX fails with "Out of Memory" error

**Symptoms:**
```
Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
```

**Solutions:**
1. Increase heap size:
   ```bash
   jadx -J-Xmx4G app.apk -d output/
   ```

2. Enable deobfuscation (can reduce memory usage):
   ```bash
   jadx --deobf app.apk -d output/
   ```

3. Use multi-threaded mode:
   ```bash
   jadx -j 4 app.apk -d output/  # Use 4 threads
   ```

---

### Issue: APKTool fails with "Framework not installed" 

**Symptoms:**
```
W: Framework directory doesn't exist
```

**Solution:**
```bash
apktool empty-framework-dir --force
apktool d app.apk -o output/
```

---

### Issue: High decompilation error rate (>10%)

**Symptoms:**
JADX log shows many ERROR lines

**Solutions:**
1. Try alternative decompilers:
   - CFR: `java -jar cfr.jar app.apk --outputdir output/`
   - Procyon: `java -jar procyon.jar app.apk -o output/`
   - JD-GUI: GUI-based alternative

2. Accept errors in heavily obfuscated code (check if errors are in third-party libs)

3. Use smali directly (no decompilation to Java):
   ```bash
   apktool d app.apk  # Generates smali code
   ```

---

## Search and Analysis Issues

### Issue: grep returns too many false positives

**Problem:** Searching for "password" returns thousands of results

**Solutions:**
1. Use more specific patterns:
   ```bash
   # Instead of:
   grep -r "password" .
   
   # Use:
   grep -r "private.*String.*password\s*=" . --include="*.java"
   ```

2. Exclude third-party libraries:
   ```bash
   grep -r "api.*key" ./com/myapp --include="*.java"  # App code only
   ```

3. Use ripgrep with type filters:
   ```bash
   rg "password\s*=\s*\"" -t java
   ```

---

### Issue: Can't determine if security control is enforced

**Problem:** Found root detection code but unclear if app blocks rooted devices

**Solution:**
1. Find the detection method:
   ```bash
   grep -r "isRooted" -A 10 decompiled/sources
   ```

2. Search for enforcement keywords:
   ```bash
   grep -r "isRooted()" decompiled/sources | grep -E "finish\(\)|exit\(\)|throw"
   ```

3. Look for conditional blocks:
   - If detection only leads to logging → Telemetry
   - If detection leads to `finish()`, `System.exit()`, exception → Enforced

---

## File Location Issues

### Issue: Can't find AndroidManifest.xml

**Expected Location:** `decompiled/resources/AndroidManifest.xml`

**Solutions:**
1. Check if APKTool extraction succeeded:
   ```bash
   ls decompiled/resources/
   ```

2. Re-extract with verbose output:
   ```bash
   apktool d app.apk -o output/ -v
   ```

3. Try direct unzip (APK is a ZIP file):
   ```bash
   unzip app.apk -d manual_extract/
   cat manual_extract/AndroidManifest.xml  # Will be binary
   ```

---

### Issue: Can't find main activity or entry point

**Solution:**
Search AndroidManifest.xml for launcher activity:
```bash
grep -A 5 "android.intent.action.MAIN" decompiled/resources/AndroidManifest.xml
```

Look for:
```xml
<activity android:name=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>
```

---

## MASVS Scoring Issues

### Issue: Unsure how to score when control is partially implemented

**Example:** App has basic root detection but no enforcement

**Solution:**
Use the PARTIAL scoring range (3-6/10):
- Detection exists: +2 points
- Detection is obfuscated: +1 point
- No enforcement: +0 points
- **Total: 3/10** (PARTIAL)

See detailed rubrics in `analysis-guides/MASVS-RESILIENCE-*-enhanced.md`

---

### Issue: Multiple findings map to same MASVS control

**Example:** Both "no obfuscation" and "readable strings" map to RESILIENCE-2

**Solution:**
- Create separate findings with different scopes
- Reference both in RESILIENCE-2 analysis
- Score represents overall control effectiveness, not individual findings

---

## Report Generation Issues

### Issue: CVSS calculator gives unexpected score

**Problem:** Expected CRITICAL but calculator shows HIGH

**Solution:**
Review each metric carefully:
- **Attack Vector (AV):** How is vulnerability accessed? (N=Network, A=Adjacent, L=Local, P=Physical)
- **Attack Complexity (AC):** How hard to exploit? (L=Low, H=High)
- **Privileges Required (PR):** Authentication needed? (N=None, L=Low, H=High)
- **User Interaction (UI):** User action needed? (N=None, R=Required)

Common mistakes:
- Hardcoded credentials: Often AV:N (accessible remotely via decompilation)
- Root detection weakness: Usually AV:L (requires local access to device)

---

### Issue: Report template doesn't match example reports

**Problem:** Template seems incomplete compared to example

**Solution:**
Templates provide structure - you fill in details. Compare:
- Template: `[VULNERABILITY_TITLE]`
- Example: `Hardcoded PushTNG API Credentials NOT Rotated`

Use example reports as reference for detail level and formatting.

---

## Tool Compatibility Issues

### Issue: Scripts don't work on Windows

**Solution:**
1. Use WSL2 (Windows Subsystem for Linux):
   ```powershell
   wsl --install
   ```

2. Or use Git Bash and modify scripts:
   - Replace `#!/bin/bash` with `#!/usr/bin/env bash`
   - Use forward slashes in paths

3. Or use Docker container (see GETTING_STARTED.md - Advanced Configuration section)

---

### Issue: Python scripts fail with import errors

**Solution:**
Install dependencies:
```bash
pip install -r tools/requirements.txt
```

Or use virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r tools/requirements.txt
```

---

## Performance Issues

### Issue: Assessment taking too long

**Solutions:**
1. Use AI-assisted workflow (faster discovery)
2. Focus on app packages first, skip third-party libs initially
3. Use parallel processing:
   ```bash
   find . -name "*.java" | parallel grep -l "password"
   ```

4. Use ripgrep instead of grep (10-100x faster):
   ```bash
   rg "pattern" instead of grep -r "pattern"
   ```

---

### Issue: Decompilation is very slow

**Solutions:**
1. Use more threads:
   ```bash
   jadx -j 8 app.apk  # Use 8 threads
   ```

2. Skip resources if not needed:
   ```bash
   jadx --no-res app.apk
   ```

3. Decompile specific packages only:
   ```bash
   jadx --no-res --no-imports app.apk -d output/
   ```

---

## Git and Repository Issues

### Issue: Git refuses to commit large APK files

**Solution:**
APK files should be gitignored. If you need to version them:
1. Use Git LFS:
   ```bash
   git lfs install
   git lfs track "*.apk"
   git add .gitattributes
   ```

2. Or store externally (cloud storage) and reference in README

---

### Issue: Accidental commit of sensitive data

**Solution:**
1. Remove from history immediately:
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/sensitive/file' \
     --prune-empty --tag-name-filter cat -- --all
   ```

2. Force push (if using remote):
   ```bash
   git push origin --force --all
   ```

3. Rotate any exposed credentials immediately

---

## Still Having Issues?

1. Check FAQ.md for common questions
2. Review GETTING_STARTED.md for setup verification
3. Consult example assessments in examples/
4. Contact security team for support

**For urgent issues:**
- Internal: Slack #security-team
- External: Open GitHub issue
