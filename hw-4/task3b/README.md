# Task 3B: Using Ubuntu's Built-in Scheme

## Objective
Test the race condition attack with Ubuntu's built-in symlink protection enabled.

## Ubuntu's Protection Mechanism

Ubuntu includes a kernel-level protection against race condition attacks via symbolic links in world-writable sticky directories (like `/tmp`).

The protection works by:
1. Restricting who can follow symbolic links
2. Symlinks in `/tmp` cannot be followed if the follower and directory owner don't match the symlink owner
3. This prevents Set-UID programs from following attacker-controlled symlinks

## Setup

1. **Enable Ubuntu's protection**:
   ```bash
   sudo sysctl -w fs.protected_symlinks=1
   ```

2. **Verify the setting**:
   ```bash
   sysctl fs.protected_symlinks
   ```
   Should output: `fs.protected_symlinks = 1`

3. **Compile the programs**:
   ```bash
   make
   ```

4. **Make the shell script executable**:
   ```bash
   chmod +x target_process.sh
   ```

## Testing the Attack with Protection Enabled

1. **Run the attack** in one terminal:
   ```bash
   ./attack
   ```

2. **Run the target process** in another terminal:
   ```bash
   ./target_process.sh
   ```

3. **Observe**: The attack should FAIL

## Expected Observations

With protection enabled:
- The vulnerable program cannot follow the symbolic link `/tmp/XYZ`
- `access()` and `fopen()` will fail when `/tmp/XYZ` points to `/etc/passwd`
- The attack becomes ineffective
- The script will run indefinitely without modifying `/etc/passwd`

## How This Protection Works

The kernel checks:
1. Is the path in a world-writable sticky directory? (Yes, `/tmp`)
2. Is the path a symbolic link? (Yes, `/tmp/XYZ`)
3. Does the process following the link match the symlink owner? (No, root vs. regular user)
4. If not, block the operation

This prevents:
- Set-UID programs from following user-created symlinks in `/tmp`
- Race condition attacks that rely on symlink redirection
- Unauthorized access to protected files via symlink tricks

## Limitations of This Scheme

1. **Only protects sticky directories**:
   - Protection only applies to world-writable sticky directories
   - Doesn't protect `/var/tmp` if sticky bit is not set
   - Doesn't protect other world-writable locations

2. **Doesn't prevent all race conditions**:
   - Only addresses symlink-based attacks
   - Doesn't prevent races involving hard links
   - Doesn't prevent TOCTOU issues in other contexts

3. **Can break legitimate programs**:
   - Some legitimate uses of symlinks in `/tmp` may fail
   - Programs expecting to follow user-created symlinks won't work

4. **Bypass possibilities**:
   - If attacker can create files in non-sticky directories
   - If the vulnerable program uses paths outside `/tmp`
   - If hard links are used instead of symlinks

## Comparison with Task 3A

**Task 3A (Principle of Least Privilege)**:
- Fixes the program itself
- Works regardless of OS protections
- Prevents the vulnerability at the source
- More robust and portable

**Task 3B (OS-level Protection)**:
- Defense in depth
- Protects even poorly-written programs
- System-wide protection
- Can be disabled by administrator

## Cleanup

Stop the attack program with Ctrl-C and clean up:
```bash
sudo rm -f /tmp/XYZ /tmp/ABC
```

## Re-enabling Protection for Other Labs

After completing all tasks, re-enable the protection:
```bash
sudo sysctl -w fs.protected_symlinks=1
sudo sysctl -w fs.protected_regular=2
```
