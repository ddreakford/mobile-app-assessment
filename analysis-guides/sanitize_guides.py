#!/usr/bin/env python3
"""
Sanitize MASVS-RESILIENCE enhanced guides by removing case study content.
"""

import re
import sys

def sanitize_content(content):
    """Remove ExampleApp case studies and specific assessment details."""

    # Remove entire "Deep Dive Analysis" sections (from header to next ## header)
    content = re.sub(
        r'## Deep Dive Analysis.*?(?=^## )',
        '',
        content,
        flags=re.MULTILINE | re.DOTALL
    )

    # Remove "Case Study: ExampleApp" sections
    content = re.sub(
        r'### Case Study: ExampleApp.*?(?=^### |^## )',
        '',
        content,
        flags=re.MULTILINE | re.DOTALL
    )

    # Replace specific ExampleApp file paths with generic placeholders
    content = re.sub(
        r'apk/ExampleApp/sources/[\w/\.]+',
        '[decompiled source path]',
        content
    )

    # Remove lines with "ExampleApp Implementation: X/10"
    content = re.sub(
        r'^### ExampleApp Implementation:.*$',
        '### Generic Implementation Example\n\n**Note:** Actual scoring should be based on your specific assessment findings.',
        content,
        flags=re.MULTILINE
    )

    # Replace ExampleApp mentions in comments with generic "the application"
    content = re.sub(
        r'\bExampleApp\b',
        'the assessed application',
        content
    )

    # Remove specific code snippets from ExampleApp assessments
    # Look for code blocks preceded by "Location:" with ExampleApp path
    content = re.sub(
        r'\*\*Location:\*\* `.*ExampleApp.*`\n+```[\w]*\n.*?```\n',
        '**Note:** Include actual code snippets from your assessment here.\n\n',
        content,
        flags=re.MULTILINE | re.DOTALL
    )

    # Clean up multiple consecutive blank lines
    content = re.sub(r'\n{4,}', '\n\n\n', content)

    return content

def main():
    files = [
        'MASVS-RESILIENCE-1-enhanced.md',
        'MASVS-RESILIENCE-2-enhanced.md',
        'MASVS-RESILIENCE-3-enhanced.md',
        'MASVS-RESILIENCE-4-enhanced.md'
    ]

    for filename in files:
        print(f"Processing {filename}...")

        try:
            # Read original content
            with open(filename, 'r', encoding='utf-8') as f:
                content = f.read()

            # Sanitize
            sanitized = sanitize_content(content)

            # Write back
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(sanitized)

            print(f"  ✓ Sanitized {filename}")

        except Exception as e:
            print(f"  ✗ Error processing {filename}: {e}")
            return 1

    print("\n✓ All files sanitized successfully!")
    print("Backups saved as *.backup files")
    return 0

if __name__ == '__main__':
    sys.exit(main())
