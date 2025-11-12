# Task 7b: Non-Executable Stack Protection
# Compile call_shellcode WITHOUT -z execstack (NX enabled)

SEED = ../Labsetup/shellcode

all: call_shellcode_nx

call_shellcode_nx: $(SEED)/call_shellcode.c
	gcc -o call_shellcode_nx $(SEED)/call_shellcode.c
	@echo ""
	@echo "Compiled with non-executable stack (NX bit enabled)"
	@echo "To test: ./test_nx.sh"

clean:
	rm -f call_shellcode_nx
