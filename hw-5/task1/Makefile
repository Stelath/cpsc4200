# Task 1: Shellcode Testing Makefile

SEED_SHELLCODE = ../Labsetup/shellcode

all: call_shellcode codefile_64

# Compile call_shellcode with executable stack
call_shellcode: $(SEED_SHELLCODE)/call_shellcode.c
	gcc -z execstack -o call_shellcode $(SEED_SHELLCODE)/call_shellcode.c
	@echo "Compiled call_shellcode with executable stack"

# Generate shellcode binary from shellcode_delete.py
codefile_64: shellcode_delete.py
	./shellcode_delete.py
	@echo "Generated codefile_64 from shellcode_delete.py"

clean:
	rm -f call_shellcode codefile_64

.PHONY: all clean
