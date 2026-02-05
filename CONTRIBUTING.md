# Contributing to Mobile Security Assessment Exemplar

Thank you for your interest in improving our mobile security assessment framework! This document provides guidelines for contributing to this repository.

## 🎯 Ways to Contribute

1. **Improve Documentation** - Fix typos, clarify instructions, add examples
2. **Add Templates** - Create new finding or report templates
3. **Enhance Tools** - Improve automation scripts or add new ones
4. **Share Knowledge** - Add to docs/LESSONS_LEARNED.md
5. **Update MASVS Guides** - Keep guides current with latest OWASP standards
6. **Report Issues** - Identify gaps or errors in the framework

## 📋 Contribution Process

### For Team Members (Internal)

1. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/issue-description
   ```

2. **Make Your Changes**
   - Follow existing structure and formatting
   - Update relevant documentation
   - Test your changes

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: Add comprehensive description"
   # or "fix:", "docs:", "chore:", etc.
   ```

4. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Request Peer Review**
   - At least one security team member must review
   - Address review comments
   - Merge after approval

### For External Contributors

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request with detailed description
5. Wait for maintainer review

## 📝 Coding Standards

### Documentation

- Use Markdown for all documentation files
- Include code examples where applicable
- Provide file:line references for findings
- Use tables for structured data

### Templates

- Include placeholder text in [BRACKETS]
- Provide inline comments explaining each section
- Follow existing template structure
- Include examples from real assessments (sanitized)

### Scripts

**Bash Scripts:**
```bash
#!/bin/bash
# Script description
# Usage: script.sh [arguments]

set -e  # Exit on error

# Function definitions
function main() {
    # Implementation
}

main "$@"
```

**Python Scripts:**
```python
#!/usr/bin/env python3
"""
Script description and usage
"""

def main():
    """Main function"""
    # Implementation

if __name__ == "__main__":
    main()
```

### Commit Messages

Follow conventional commits format:

- `feat:` New feature or enhancement
- `fix:` Bug fix or correction
- `docs:` Documentation changes
- `chore:` Maintenance tasks
- `refactor:` Code restructuring

Examples:
- `feat: Add automated CVSS calculator tool`
- `fix: Correct MASVS-RESILIENCE-2 scoring rubric`
- `docs: Update GETTING_STARTED with iOS instructions`

## 🧪 Testing Requirements

### For Templates

- [ ] All placeholder variables use [BRACKET] format
- [ ] Template compiles/renders correctly
- [ ] Examples are included for complex sections
- [ ] Template matches existing style

### For Scripts

- [ ] Script executes without errors
- [ ] Help text (`--help`) is clear and complete
- [ ] Error handling is robust
- [ ] Dependencies are documented

### For Documentation

- [ ] Links work correctly
- [ ] Code examples are tested
- [ ] Markdown renders properly
- [ ] No confidential information included

## 📚 Documentation Guidelines

### File Organization

```
docs/
├── FAQ.md                  # Frequently asked questions
├── TROUBLESHOOTING.md      # Common issues and solutions
├── LESSONS_LEARNED.md      # Best practices from assessments
├── CVSS_SCORING_GUIDE.md   # CVSS calculation reference
└── [new-guides].md         # Additional guides as needed
```

### Writing Style

- **Be Clear:** Use simple, direct language
- **Be Concise:** Remove unnecessary words
- **Be Specific:** Provide concrete examples
- **Be Helpful:** Anticipate user questions

### Code Examples

Always include:
1. Context (what the code does)
2. Complete, runnable examples
3. Expected output
4. Common variations

## 🔍 Pull Request Checklist

Before submitting a PR, ensure:

- [ ] Code follows repository style guidelines
- [ ] Documentation is updated
- [ ] Examples are sanitized (no real credentials)
- [ ] Commit messages follow conventional format
- [ ] Changes are tested
- [ ] No sensitive information included
- [ ] Related issues are referenced

## 🎓 Review Process

### For Maintainers

When reviewing PRs:

1. **Check Accuracy**
   - Verify technical correctness
   - Test code examples
   - Validate MASVS/CVSS references

2. **Check Completeness**
   - Documentation updated?
   - Examples included?
   - Tests passing?

3. **Check Security**
   - No credentials or secrets?
   - Sanitized examples?
   - Responsible disclosure followed?

4. **Provide Feedback**
   - Be constructive
   - Suggest improvements
   - Explain reasoning

### Review Timeline

- **Urgent fixes:** 24 hours
- **New features:** 2-5 business days
- **Documentation:** 1-3 business days

## 🌟 Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes for significant contributions
- Team meetings and retrospectives

## 📞 Questions?

- **Internal:** Contact security team lead
- **External:** Open an issue for discussion

Thank you for helping improve our mobile security assessment framework!

---

**Document Version:** 1.0
**Last Updated:** 2025-11-19
**Maintained By:** Dwayne Dreakford
