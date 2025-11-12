# Task 7a: StackGuard Protection

## Objective
Test StackGuard (stack canary) protection and observe how it prevents buffer overflow exploits.

## What is StackGuard?

StackGuard places a "canary" value between buffer and return address:

```
[Buffer][Canary][Saved FP][Saved LR]
```

Before function returns:
- Check if canary is still intact
- If modified → abort program (stack smashing detected!)
- If intact → return normally

## Quick Start

### 1. Recompile with StackGuard
```bash
make
```

This compiles `stack-L1` **without** `-fno-stack-protector` flag.

### 2. Test with Exploit
```bash
./test_stackguard.sh
```

This runs the protected binary with the badfile from Task 2.

## Manual Testing

```bash
# Compile with StackGuard
gcc -DBUF_SIZE=100 -o stack-L1-protected -z execstack stack.c

# Run with exploit payload
./stack-L1-protected < ../task2/badfile
```

## Expected Results

**Without StackGuard (original):**
```
(shellcode executes or program crashes)
```

**With StackGuard:**
```
*** stack smashing detected ***: terminated
Aborted (core dumped)
```

## Why StackGuard Works

Buffer overflow overwrites memory including the canary:
```
[Shellcode + NOPs + Padding][Overwritten Canary][Fake Return Address]
                              ^
                              Canary corrupted!
```

Program detects corruption before using fake return address.

## Limitations

StackGuard can be bypassed by:
1. **Leaking canary value** (via format string bug)
2. **Jumping over canary** (exploit other vulnerabilities)
3. **Overwriting other data** (function pointers, etc.)

## Lab Report Requirements
- Screenshot showing "stack smashing detected" message
- Comparison with non-protected version
- Explanation of how StackGuard prevented the attack
- Discussion of StackGuard limitations
