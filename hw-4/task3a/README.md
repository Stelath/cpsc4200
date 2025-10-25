# Task 3A: Applying the Principle of Least Privilege

## Objective
Fix the race condition vulnerability by applying the Principle of Least Privilege using `seteuid()`.

## The Problem
The original vulnerable program runs with root privilege (effective UID = 0) but uses `access()` to check the real user's permissions. This creates a time window between check and use.

## The Solution
Use `seteuid()` to temporarily drop root privilege before both the check and the file operation:

1. Get the real user ID with `getuid()`
2. Drop privilege with `seteuid(real_uid)` before `access()`
3. Perform file operations with the real user's privileges
4. The race condition becomes harmless because `fopen()` also runs with real user privileges

## Setup

1. **Compile both programs**:
   ```bash
   make
   ```

## Testing the Original Vulnerable Program

1. **Run the attack** in one terminal:
   ```bash
   ./attack
   ```

2. **Run the vulnerable program** in another terminal:
   ```bash
   while true; do echo "test:U6aMy0wojraho:0:0:test:/root:/bin/bash" | ./vulp_original; done
   ```

3. This should eventually succeed in modifying `/etc/passwd`

## Testing the Fixed Program

1. **Clean up from previous test**:
   ```bash
   sudo sed -i '/^test:/d' /etc/passwd
   sudo rm -f /tmp/XYZ /tmp/ABC
   ```

2. **Run the attack** in one terminal:
   ```bash
   ./attack
   ```

3. **Run the fixed program** in another terminal:
   ```bash
   chmod +x target_process.sh
   ./target_process.sh
   ```

4. **Observe**: The attack should FAIL because:
   - Both `access()` and `fopen()` run with the real user's privilege
   - Even if the symlink points to `/etc/passwd`, the real user cannot write to it
   - The race condition exists but is now harmless

## Key Differences

### Original Program
- `access()` checks real UID permissions ✓
- `fopen()` runs with effective UID (root) ✗
- Race condition is exploitable

### Fixed Program
- `seteuid(real_uid)` drops privilege
- `access()` checks real UID permissions ✓
- `fopen()` runs with real UID ✓
- Race condition is harmless

## Expected Results

When testing the fixed program:
- The attack script will run indefinitely without success
- `/etc/passwd` will not be modified
- Even though `/tmp/XYZ` may point to `/etc/passwd` during execution, the program cannot write to it

## Cleanup
```bash
sudo sed -i '/^test:/d' /etc/passwd
sudo rm -f /tmp/XYZ /tmp/ABC
```

## Explanation

The Principle of Least Privilege states: "A program should run with the minimum privileges necessary to complete its task."

In the fixed version:
- Root privilege is only used to set up the Set-UID bit
- During execution, privilege is dropped to the real user's level
- File operations are performed with the user's actual permissions
- Even if an attacker wins the race condition, they can only write to files they already have permission to write to
