.PHONY: all clean setup test

# Detect OS
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
    TARGET = cap_leak_macos
    SOURCE = cap_leak_macos.c
else
    TARGET = cap_leak
    SOURCE = cap_leak.c
endif

all: $(TARGET)

cap_leak: cap_leak.c
	gcc -o cap_leak cap_leak.c

cap_leak_macos: cap_leak_macos.c
	gcc -o cap_leak_macos cap_leak_macos.c
	@echo ""
	@echo "Built macOS version (uses /tmp/zzz instead of /etc/zzz)"
	@echo "Run 'make setup' for instructions"

setup: all
	@echo "=== Task 9: Capability Leaking ==="
	@echo ""
	@echo "Platform: $(UNAME_S)"
ifeq ($(UNAME_S),Darwin)
	@echo ""
	@echo "macOS Note: Using cap_leak_macos which uses /tmp/zzz"
	@echo ""
	@echo "Setup steps:"
	@echo "1. Create a test file:"
	@echo "   touch /tmp/zzz"
	@echo ""
	@echo "2. Run the program:"
	@echo "   ./cap_leak_macos"
	@echo ""
	@echo "3. In the shell that opens, use the fd number shown to write:"
	@echo "   echo 'capability leaked!' >&N"
	@echo "   cat /tmp/zzz"
	@echo ""
	@echo "The file descriptor remains open even after setuid() drops privileges!"
else
	@echo ""
	@echo "Setup steps:"
	@echo "1. Create /etc/zzz file:"
	@echo "   sudo touch /etc/zzz"
	@echo "   sudo chmod 0644 /etc/zzz"
	@echo ""
	@echo "2. Make cap_leak a Set-UID program:"
	@echo "   sudo chown root cap_leak"
	@echo "   sudo chmod 4755 cap_leak"
	@echo ""
	@echo "3. Run the program:"
	@echo "   ./cap_leak"
	@echo ""
	@echo "4. In the shell that opens, try:"
	@echo "   echo 'exploit' >&3"
	@echo "   (replace 3 with the fd number printed)"
endif

test: all
	@echo ""
	@echo "=== Demonstrating capability leak (without Set-UID) ==="
	@echo "Creating test file..."
	@touch /tmp/zzz_test
	@chmod 0644 /tmp/zzz_test
	@echo ""
	@echo "This demonstrates the concept even without Set-UID privileges."
	@echo "The program opens a file, drops privileges, then spawns a shell."
	@echo "The file descriptor remains open and usable in the shell."
	@echo ""
	@echo "Note: Modify cap_leak.c to open /tmp/zzz_test for this demo,"
	@echo "      or manually test with: ./cap_leak"

clean:
	rm -f cap_leak cap_leak_macos
	rm -f /tmp/zzz_test
