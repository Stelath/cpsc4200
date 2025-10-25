.PHONY: all clean run

all: system_env

system_env: system_env.c
	gcc -o system_env system_env.c

run: system_env
	@echo "Running system_env..."
	./system_env

clean:
	rm -f system_env
