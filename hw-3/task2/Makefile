.PHONY: all clean run-child run-parent compare

all: myprintenv_child myprintenv_parent

myprintenv_child: myprintenv_child.c
	gcc -o myprintenv_child myprintenv_child.c

myprintenv_parent: myprintenv_parent.c
	gcc -o myprintenv_parent myprintenv_parent.c

run-child: myprintenv_child
	./myprintenv_child > child_output.txt
	@echo "Child process output saved to child_output.txt"

run-parent: myprintenv_parent
	./myprintenv_parent > parent_output.txt
	@echo "Parent process output saved to parent_output.txt"

compare: run-child run-parent
	@echo "Comparing child and parent outputs:"
	diff child_output.txt parent_output.txt || true

clean:
	rm -f myprintenv_child myprintenv_parent child_output.txt parent_output.txt
