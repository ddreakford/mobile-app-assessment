# Frequently Asked Questions

## General Questions

### Q: What tools do I need to start?
A: At minimum, you need JADX (decompiler), APKTool (resource extractor), and Java JDK 11+. See `GETTING_STARTED.md` (Platform Setup section) for full installation instructions.

### Q: How long does an assessment take?
A: 
- AI-assisted: 4-6 hours
- Manual: 8-12 hours  
- Hybrid (recommended): 6-10 hours

### Q: Can I assess iOS apps with this framework?
A: The framework is optimized for Android but many concepts apply to iOS. You'll need different tools (class-dump, Hopper) and the process differs.

### Q: Do I need programming experience?
A: Basic understanding of Java/Kotlin helps, but AI-assisted workflow can guide beginners. Start with `GETTING_STARTED.md`.

## Technical Questions

### Q: JADX decompilation has many errors - is this normal?
A: Yes, 1-5% error rate is acceptable. Errors often occur in obfuscated or reflection-heavy code. If >10% errors, try alternative decompilers.

### Q: How do I know if root detection is enforced vs. telemetry?
A: Search for where the detection method is called. If it leads to `System.exit()`, `finish()`, or blocking features = enforced. If only logging/analytics = telemetry.

### Q: What's the difference between R8 and ProGuard?
A: R8 is Google's newer optimizer/obfuscator (default since Android Studio 3.4). ProGuard is the older tool. R8 is generally better but uses similar configuration.

### Q: How do I score MASVS-RESILIENCE controls?
A: Use the detailed scoring rubrics in `analysis-guides/MASVS-RESILIENCE-*-enhanced.md`. Score 0-10 based on implementation quality, not just presence.

### Q: Should I report third-party library vulnerabilities?
A: Note them for awareness, but focus on application code first. Third-party vulns should be separate "informational" findings unless directly exploitable in app context.

## Workflow Questions

### Q: Can I skip phases in the assessment workflow?
A: Each phase builds on the previous. You can reduce depth (quick vs. deep analysis) but shouldn't skip entirely.

### Q: Should I use AI-assisted or manual workflow?
A: Hybrid approach is recommended: use AI for discovery, manually validate findings. See `ASSESSMENT_WORKFLOW.md` for comparison.

### Q: How do I handle large codebases (50,000+ classes)?
A: Use AI-assisted approach and focus on application packages first (e.g., `com.company.*`). Exclude framework packages initially.

## Reporting Questions

### Q: How do I calculate CVSS scores?
A: Use https://www.first.org/cvss/calculator/3.1 and refer to `docs/CVSS_SCORING_GUIDE.md` for guidance on selecting metrics.

### Q: What's the difference between CVSS score and risk score?
A: CVSS measures technical severity of individual findings. Risk score (0-10) is the weighted average across all findings for the entire app.

### Q: How detailed should remediation guidance be?
A: Provide 3 levels: Emergency (immediate steps), Short-term (proper fix with code examples), Long-term (architectural improvements).

### Q: Should I include code snippets in reports?
A: Yes! Evidence is critical. Include file:line references and relevant code snippets for all findings.

## MASVS Questions

### Q: What's the difference between MASVS v1 and v2?
A: MASVS v2.0 (2023) restructured controls and added more granularity. This framework uses v2.0. See `OWASP_MASVS_MAPPING.md`.

### Q: Do I need to assess all 20 MASVS controls?
A: No. This framework focuses on RESILIENCE controls (4 controls). Full assessment would cover all categories.

### Q: What does "RESILIENCE" mean in MASVS?
A: RESILIENCE controls protect against reverse engineering and tampering. They're optional but recommended for apps handling sensitive data.

## Troubleshooting

### Q: APKTool fails with "Framework not found" error
A: Run `apktool empty-framework-dir --force` then retry

### Q: JADX crashes with out of memory error
A: Increase heap: `jadx --deobf -Xmx4G app.apk -d output/`

### Q: Can't find MainActivity or entry point
A: Check AndroidManifest.xml for `<intent-filter>` with `android.intent.action.MAIN`

### Q: grep returns too many results
A: Use more specific patterns, exclude third-party paths, or use ripgrep with file type filters

See `docs/TROUBLESHOOTING.md` for more solutions.
