# Task 1: Shellcode Familiarization

## Objective
Modify ARM64 shellcode to execute custom commands (e.g., delete a file).

## Quick Start
```bash
cd task1
./test_shellcode.sh
```

## Modify Shellcode Command

Edit `../Labsetup/shellcode/shellcode_64.py` line 23:

**Original:**
```python
"/bin/ls -l; echo Hello 64; /bin/tail -n 4 /etc/passwd          *"
```

**Example modification (delete file):**
```python
"/bin/rm /tmp/testfile_task1.txt; echo 'File deleted!'         *"
```

**Critical:** Keep the `*` marker at the end and maintain **exact same length** (adjust spaces).

## How It Works

The shellcode executes:
```c
execve("/bin/bash", ["/bin/bash", "-c", "your_command"], NULL);
```

Using `/bin/bash -c` allows running any shell command.

## Alternative: Pre-Modified Version

```bash
./shellcode_delete.py
cp codefile_64 ../Labsetup/shellcode/
cd ../Labsetup/shellcode && ./a64.out
```

## Key Points
- **Position markers (`*`)**: Replaced with null bytes at runtime
- **Length constraint**: Binary code has hardcoded offsets
- **No null bytes**: Can't include `\x00` in command strings (for later tasks)

## Lab Report Requirements
- Modified shellcode code
- Screenshot of execution
- Explanation of command chosen
- Length verification method

## Cleanup
```bash
rm -f /tmp/testfile_task1.txt
cd ../Labsetup/shellcode && make clean
```
