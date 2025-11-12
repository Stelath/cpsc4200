# Task 1: Shellcode Familiarization

## Objective
Modify ARM64 shellcode to execute custom commands (delete a file) and understand how shellcode works.

## Quick Start
```bash
cd task1
./test_shellcode.sh
```

This will:
1. Create a test file
2. Generate shellcode from `shellcode_delete.py`
3. Compile `call_shellcode` test harness
4. Execute the shellcode
5. Verify the file was deleted

## Modifying Shellcode

The shellcode is in `shellcode_delete.py`. To change the command:

**Edit line 15:**
```python
"/bin/rm /tmp/testfile_task1.txt; echo 'File deleted!'         *"
```

**Rules:**
- Keep the `*` marker at the end
- Maintain **exact same length** (add/remove spaces as needed)
- Current length: 67 characters including the `*`

**Examples:**

Delete different file:
```python
"/bin/rm /tmp/myfile.txt; echo 'Deleted myfile'                *"
```

Create a file:
```python
"/bin/bash -c 'echo PWNED > /tmp/pwned.txt'; echo 'Created!'   *"
```

Display info:
```python
"/bin/whoami; /bin/id; echo 'System info displayed'            *"
```

## How Shellcode Works

The shellcode executes:
```c
execve("/bin/bash", ["/bin/bash", "-c", "your_command"], NULL);
```

### Components:
1. **Binary machine code**: ARM64 instructions to set up execve syscall
2. **Command strings**: `/bin/bash`, `-c`, and your command
3. **Placeholders**: Replaced with actual string addresses at runtime
4. **Position markers (`*`)**: Replaced with null bytes during execution

## Manual Build

```bash
# Generate shellcode
./shellcode_delete.py

# Compile test harness
make

# Run
./call_shellcode
```

## Alternative: Test Original Shellcode

To test the unmodified shellcode from Labsetup:
```bash
cd ../Labsetup/shellcode
./shellcode_64.py
make
./a64.out
```

## Lab Report Requirements
- Modified `shellcode_delete.py` code
- Screenshot of execution showing file deletion
- Explanation of command chosen
- Discussion of how you maintained string length

## Cleanup
```bash
make clean
rm -f /tmp/testfile_task1.txt
```
