.PHONY: all clean setup test-system test-execve demo

# Detect OS
UNAME_S := $(shell uname -s)

all: catall catall_execve

catall: catall.c
	gcc -o catall catall.c

catall_execve: catall_execve.c
	gcc -o catall_execve catall_execve.c

setup: all
	@echo "=== Task 8: system() vs execve() ==="
	@echo ""
	@echo "Platform: $(UNAME_S)"
ifeq ($(UNAME_S),Darwin)
	@echo ""
	@echo "macOS Note: System Integrity Protection (SIP) prevents Set-UID programs"
	@echo "from running with full privileges on system binaries. For learning purposes,"
	@echo "you can still observe the behavior differences between system() and execve()."
	@echo ""
	@echo "To test basic functionality:"
	@echo "  make demo"
	@echo ""
	@echo "To make Set-UID (limited effectiveness on macOS):"
	@echo "  sudo chown root catall catall_execve"
	@echo "  sudo chmod 4755 catall catall_execve"
	@echo ""
	@echo "Attack test (demonstrate shell injection with system()):"
	@echo "  ./catall '/etc/passwd; echo INJECTED'"
	@echo "  ./catall_execve '/etc/passwd; echo INJECTED'"
else
	@echo ""
	@echo "To make Set-UID programs:"
	@echo "  sudo chown root catall catall_execve"
	@echo "  sudo chmod 4755 catall catall_execve"
	@echo ""
	@echo "Test with system():"
	@echo "  ./catall /etc/passwd"
	@echo ""
	@echo "Test with execve():"
	@echo "  ./catall_execve /etc/passwd"
	@echo ""
	@echo "Attack test (shell injection):"
	@echo "  ./catall '/etc/passwd; echo HACKED'"
endif

demo: all
	@echo ""
	@echo "=== Testing system() (vulnerable to injection) ==="
	./catall /etc/passwd
	@echo ""
	@echo "=== Testing system() with injection attempt ==="
	@echo "Command: ./catall '/etc/passwd; echo SHELL_INJECTION_WORKS'"
	-./catall '/etc/passwd; echo SHELL_INJECTION_WORKS'
	@echo ""
	@echo "=== Testing execve() (NOT vulnerable) ==="
	@echo "Command: ./catall_execve '/etc/passwd; echo SHELL_INJECTION_WORKS'"
	-./catall_execve '/etc/passwd; echo SHELL_INJECTION_WORKS'
	@echo ""
	@echo "Notice: system() executes the shell command (injection works)"
	@echo "        execve() treats it as a literal filename (injection fails)"

test-system: catall
	./catall /etc/passwd

test-execve: catall_execve
	./catall_execve /etc/passwd

clean:
	rm -f catall catall_execve
