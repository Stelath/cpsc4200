# Task 7b: Non-Executable Stack Protection

## Objective
Test non-executable stack (NX bit) protection and observe how it prevents shellcode execution.

## What is Non-Executable Stack?

Modern CPUs support marking memory pages as non-executable (NX bit / DEP):
- Stack is marked as **data only** (no execute permission)
- Attempting to execute code from stack → segmentation fault
- Prevents injected shellcode from running

## Quick Start

### 1. Compile call_shellcode Without Executable Stack
```bash
cd ../Labsetup/shellcode
make clean
```

Edit Makefile to remove `-z execstack`, then:
```bash
make
```

OR use the Makefile in this task:
```bash
cd ../../task7b
make
```

### 2. Test Shellcode
```bash
./test_nx.sh
```

## Manual Testing

```bash
# Compile WITHOUT -z execstack (stack is non-executable by default)
gcc -o call_shellcode_nx call_shellcode.c

# Try to run shellcode
./call_shellcode_nx
```

## Expected Results

**With `-z execstack` (executable stack):**
```
Hello 64
(shellcode executes successfully)
```

**Without `-z execstack` (non-executable stack / NX enabled):**
```
Segmentation fault (core dumped)
```

## Why NX Works

Even though buffer overflow succeeds and control is redirected to shellcode:
```
1. Buffer overflow overwrites return address ✓
2. Function returns to shellcode address ✓
3. CPU attempts to execute from stack ✗
4. Stack is marked non-executable → Segmentation fault
```

## Bypassing NX: Return-to-libc

NX doesn't prevent all attacks. Attackers can use **return-to-libc**:
- Don't inject shellcode
- Instead, jump to existing code in libraries
- Chain together function calls (ROP - Return-Oriented Programming)

Example:
```
Instead of: Jump to shellcode
Use: Jump to system() with argument "/bin/sh"
```

## Lab Report Requirements
- Screenshot showing segmentation fault with NX enabled
- Comparison with executable stack version
- Explanation of how NX prevented shellcode execution
- Discussion of bypass techniques (return-to-libc)
