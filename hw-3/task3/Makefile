.PHONY: all clean run

all: myenv

myenv: myenv.c
	gcc -o myenv myenv.c

run: myenv
	@echo "Running myenv..."
	./myenv

clean:
	rm -f myenv
