# Lab 5 — Encoding forensics

Name: <name> · Date: <date> · Tools: <Ubuntu guest / Git Bash / macOS / PowerShell>

## What I received
<how it looked in Excel, LibreOffice and the terminal — one line each>

## Diagnosis (made before the fix)
- file said: Non-ISO extended-ASCII text, with CRLF line terminators (evidence/file-before.txt)
- First 16 bytes: 4944 3bd4 e0ec e8eb e8ff 3bc8 ecff 3bce (evidence/hexdump-before.txt)
- Encoding: KZ-1048 (RK1048) - because it is a single-byte encoding where the byte `a3` is used (which corresponds to the Kazakh letter "Ә"), proving it is the Kazakh variant of Windows-1251.
- Line ending: CRLF - because the hex dump shows `0d 0a` at the end of the first line.
- BOM: no - because the first bytes are `4944` ("ID"), not a BOM signature like `EF BB BF`; in the fixed file I added it because Excel on Windows requires a BOM to correctly recognize UTF-8 automatically on double-click.
- Separator: `;` - because the hex dump shows `3b` right after "ID".

## Fix
<the command or scripts/fix.sh, in a code block>

## Verification
<file-after.txt summary; the screenshot evidence/opens-correctly.png>

## What did not work the first time
<at least one real thing>
