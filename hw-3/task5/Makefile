.PHONY: all clean run setup

all: printenv_setuid

printenv_setuid: printenv_setuid.c
	gcc -o printenv_setuid printenv_setuid.c

setup: printenv_setuid
	@echo "To make this a Set-UID program, run:"
	@echo "  sudo chown root printenv_setuid"
	@echo "  sudo chmod 4755 printenv_setuid"
	@echo ""
	@echo "Then test with:"
	@echo "  export PATH=/test:\$$PATH"
	@echo "  export LD_LIBRARY_PATH=/test"
	@echo "  export MY_CUSTOM_VAR=test123"
	@echo "  ./printenv_setuid"

run: printenv_setuid
	./printenv_setuid

clean:
	rm -f printenv_setuid
