# Task 7a: StackGuard Protection
# Compile stack.c WITH stack protection (remove -fno-stack-protector)

SEED = ../Labsetup/server-code

all: stack-L1-protected

stack-L1-protected: $(SEED)/stack.c
	gcc -DBUF_SIZE=100 -DSHOW_FP -o stack-L1-protected \
		-z execstack \
		$(SEED)/stack.c
	@echo ""
	@echo "Compiled with StackGuard protection enabled"
	@echo "To test: ./test_stackguard.sh"

clean:
	rm -f stack-L1-protected
