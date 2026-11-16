# Lab 5 - Encoding forensics

Name: Barat Alimkhan - Date: 16.11.2026 - Tools: Ubuntu guest / PowerShell

## What I received
- Excel: Russian names were readable, but Kazakh characters were replaced with incorrect symbols (for example, "J" instead of "Ә").
- LibreOffice: The default import character set was detected as Windows-1251, which displayed the Kazakh characters incorrectly.
- Terminal: The `cat` command output showed unreadable replacement symbols (question marks) because the terminal expects UTF-8.

## Diagnosis (made before the fix)
- file said: Non-ISO extended-ASCII text, with CRLF line terminators (evidence/file-before.txt)
- First 16 bytes: 4944 3bd4 e0ec e8eb e8ff 3bc8 ecff 3bce (evidence/hexdump-before.txt)
- Encoding: KZ-1048 (RK1048) - because it is a single-byte encoding where the byte `a3` is used (which corresponds to the Kazakh letter "Ә"), proving it is the Kazakh variant of Windows-1251.
- Line ending: CRLF - because the hex dump shows `0d 0a` at the end of the first line.
- BOM: no - because the first bytes are `4944` ("ID"), not a BOM signature like `EF BB BF`; in the fixed file I added it because Excel on Windows requires a BOM to correctly recognize UTF-8 automatically on double-click.
- Separator: `;` - because the hex dump shows `3b` right after "ID".

## Fix
```bash
#!/bin/sh


in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv


iconv -f RK1048 -t UTF-8 "$in" > "$out"




printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
```

## Verification
file now reports: Unicode text, UTF-8 (with BOM) text, with CRLF line terminators [evidence/file-after.txt](evidence/file-after.txt).

The hex dump confirms the new file starts with the efbb bf BOM signature.

The screenshot [evidence/opens-correctly.png](evidence/opens-correctly.png) shows that the fixed file opens perfectly in Excel, LibreOffice Calc, and the Linux terminal, with all Kazakh and Russian characters displaying correctly.

## What did not work the first time
When I tried to download the fixed file to my Windows host using the scp command, I received a "No such file or directory" error. The issue was that I had not created the evidence folder on my local Windows machine before running the command. I resolved this by running mkdir evidence in PowerShell, and then the scp command executed successfully.
