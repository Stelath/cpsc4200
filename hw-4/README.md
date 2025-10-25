# SEED Labs - Race Condition Vulnerability Lab

This lab explores race condition vulnerabilities in privileged programs and various protection mechanisms.

## Overview

A race condition occurs when multiple processes access and manipulate the same data concurrently, and the outcome depends on the particular order in which the access takes place. This lab demonstrates how to exploit race conditions in Set-UID programs and how to defend against such attacks.

## Lab Structure

Each task is organized in its own folder with complete code, Makefiles, and instructions:

### [Task 1: Choosing Our Target](task1/)
Verify that the magic password works by manually adding a test entry to `/etc/passwd`.

**Key Learning**: Understanding password file structure and the magic password mechanism.

### [Task 2A: Simulating a Slow Machine](task2a/)
Exploit the race condition with an artificial 10-second delay in the vulnerable program.

**Key Learning**: Manual exploitation of the time window between check and use.

### [Task 2B: The Real Attack](task2b/)
Launch a real race condition attack without artificial delays using concurrent processes.

**Key Learning**: Probabilistic attacks and the challenge of timing exploitation.

### [Task 2C: An Improved Attack Method](task2c/)
Use atomic operations (`renameat2`) to avoid race conditions in the attack program itself.

**Key Learning**: The irony of race conditions in attack programs and atomic operations.

### [Task 3A: Applying the Principle of Least Privilege](task3a/)
Fix the vulnerability using `seteuid()` to drop privileges appropriately.

**Key Learning**: Proper privilege management and the Principle of Least Privilege.

### [Task 3B: Using Ubuntu's Built-in Scheme](task3b/)
Test the attack against Ubuntu's kernel-level symlink protection.

**Key Learning**: OS-level protections, defense in depth, and their limitations.

## Environment Setup

### Prerequisites
- Ubuntu 20.04 (or SEED VM)
- GCC compiler
- Root/sudo access

### Disable Protection for Attack Tasks

Before starting Tasks 2A, 2B, or 2C, disable Ubuntu's protection:

```bash
sudo sysctl -w fs.protected_symlinks=0
sudo sysctl -w fs.protected_regular=0
```

### Re-enable Protection for Task 3B

```bash
sudo sysctl -w fs.protected_symlinks=1
```

## Important Safety Notes

### Backup Your System
Before starting any attack tasks:

```bash
sudo cp /etc/passwd /etc/passwd.backup
```

If you accidentally damage `/etc/passwd`, restore it:

```bash
sudo cp /etc/passwd.backup /etc/passwd
```

### VM Snapshots
Consider taking a VM snapshot before starting the lab. Some race conditions in the kernel could potentially corrupt `/etc/passwd`.

### Cleanup After Each Task
After completing each task, clean up:

```bash
# Remove test user from passwd file
sudo sed -i '/^test:/d' /etc/passwd

# Remove symbolic links
sudo rm -f /tmp/XYZ /tmp/ABC
```

## Quick Start Guide

1. **Navigate to a task folder**:
   ```bash
   cd hw-4/task2a
   ```

2. **Read the README**:
   ```bash
   cat README.md
   ```

3. **Compile the code**:
   ```bash
   make
   ```

4. **Follow the task-specific instructions**

5. **Clean up**:
   ```bash
   make clean
   ```

## Learning Objectives

After completing this lab, you should understand:

1. **Race Condition Vulnerability**:
   - Time-of-check to time-of-use (TOCTOU) problems
   - The window between `access()` and `fopen()`
   - How symbolic links can be exploited

2. **Attack Techniques**:
   - Probabilistic attacks with concurrent processes
   - Using symbolic links for redirection
   - Atomic operations to avoid race conditions in attack code

3. **Countermeasures**:
   - Principle of Least Privilege with `seteuid()`
   - Kernel-level symlink protection
   - Proper privilege management in Set-UID programs

4. **Security Principles**:
   - Defense in depth
   - Least privilege
   - Secure coding practices for privileged programs

## Task Progression

Follow the tasks in order:

```
Task 1: Manual verification
   ↓
Task 2A: Simulated attack (10 sec delay)
   ↓
Task 2B: Real attack (no delay)
   ↓
Task 2C: Improved attack (atomic operations)
   ↓
Task 3A: Countermeasure - Privilege dropping
   ↓
Task 3B: Countermeasure - OS protection
```

## Common Issues and Solutions

### Issue: `/tmp/XYZ` owned by root
**Solution**: The attack program has a race condition (fixed in Task 2C). Delete the file:
```bash
sudo rm /tmp/XYZ
```

### Issue: Attack not succeeding after 10 minutes
**Solution**:
- Verify protections are disabled
- Check that vulp is Set-UID root: `ls -l vulp` should show `-rwsr-xr-x`
- Try Task 2C's improved method

### Issue: Permission denied when creating Set-UID program
**Solution**: Use `sudo` when running make:
```bash
make  # This internally uses sudo for chown/chmod
```

### Issue: Cannot log back in after modifying `/etc/passwd`
**Solution**: Boot into recovery mode and restore from backup:
```bash
cp /etc/passwd.backup /etc/passwd
```

## File Structure

```
hw-4/
├── README.md                    (This file)
├── Race_Condition.pdf          (Original lab document)
├── task1/
│   └── README.md
├── task2a/
│   ├── vulp.c
│   ├── Makefile
│   └── README.md
├── task2b/
│   ├── vulp.c
│   ├── attack.c
│   ├── target_process.sh
│   ├── Makefile
│   └── README.md
├── task2c/
│   ├── vulp.c
│   ├── attack_improved.c
│   ├── target_process.sh
│   ├── Makefile
│   └── README.md
├── task3a/
│   ├── vulp_original.c
│   ├── vulp_fixed.c
│   ├── attack.c
│   ├── target_process.sh
│   ├── Makefile
│   └── README.md
└── task3b/
    ├── vulp.c
    ├── attack.c
    ├── target_process.sh
    ├── Makefile
    └── README.md
```

## Resources

- **SEED Book**: Computer & Internet Security: A Hands-on Approach (Chapter 7)
- **SEED Website**: https://www.handsonsecurity.net
- **Related Labs**: Dirty COW, Meltdown, Spectre

## Lab Report Guidelines

Your lab report should include:

1. **Screenshots** of successful attacks and countermeasures
2. **Code snippets** with explanations (not just attachments)
3. **Observations** about timing, success rates, and behavior
4. **Analysis** of why countermeasures work or don't work
5. **Answers** to questions posed in each task

## License

Original lab created by Wenliang Du.
Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

## Academic Integrity

This lab is for educational purposes in authorized security courses. Use the techniques learned here only in controlled environments with proper authorization.
