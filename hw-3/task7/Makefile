.PHONY: all clean setup run-normal run-preload test-setuid

# Detect OS
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
    # macOS
    DYLIB = libmylib.dylib
    PRELOAD_VAR = DYLD_INSERT_LIBRARIES
    DYLIB_FLAGS = -dynamiclib
else
    # Linux
    DYLIB = libmylib.so.1.0.1
    PRELOAD_VAR = LD_PRELOAD
    DYLIB_FLAGS = -shared
endif

all: $(DYLIB) myprog

mylib.o: mylib.c
	gcc -fPIC -g -c mylib.c

$(DYLIB): mylib.o
	gcc $(DYLIB_FLAGS) -o $(DYLIB) mylib.o

myprog: myprog.c
	gcc -o myprog myprog.c

setup: all
	@echo "=== Task 7: LD_PRELOAD/DYLD_INSERT_LIBRARIES ==="
	@echo ""
	@echo "Platform: $(UNAME_S)"
	@echo "Library: $(DYLIB)"
	@echo "Environment variable: $(PRELOAD_VAR)"
	@echo ""
	@echo "Step 1: Run normally (should sleep for 1 second):"
	@echo "  make run-normal"
	@echo ""
	@echo "Step 2: Run with preloaded library (should print message):"
	@echo "  make run-preload"
	@echo ""
ifeq ($(UNAME_S),Darwin)
	@echo "macOS Note: System Integrity Protection (SIP) prevents DYLD_* variables"
	@echo "from affecting Set-UID programs. This is a security feature."
	@echo ""
	@echo "To test (won't work with Set-UID on modern macOS):"
	@echo "  sudo chown root myprog"
	@echo "  sudo chmod 4755 myprog"
	@echo "  make test-setuid"
else
	@echo "To make Set-UID and test:"
	@echo "  sudo chown root myprog"
	@echo "  sudo chmod 4755 myprog"
	@echo "  export $(PRELOAD_VAR)=./$(DYLIB)"
	@echo "  ./myprog"
endif

run-normal: myprog
	@echo "Running without preload..."
	./myprog

run-preload: all
	@echo "Running with $(PRELOAD_VAR)=$(DYLIB)..."
	$(PRELOAD_VAR)=./$(DYLIB) ./myprog

test-setuid: all
	@echo "Testing Set-UID program with preload..."
	@echo "Note: On macOS with SIP, this will NOT use the preloaded library"
	$(PRELOAD_VAR)=./$(DYLIB) ./myprog

clean:
	rm -f mylib.o $(DYLIB) libmylib.so.1.0.1 libmylib.dylib myprog
