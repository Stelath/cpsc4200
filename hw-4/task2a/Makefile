CC = gcc
CFLAGS = -Wall

all: vulp

vulp: vulp.c
	$(CC) $(CFLAGS) vulp.c -o vulp
	sudo chown root vulp
	sudo chmod 4755 vulp

clean:
	rm -f vulp

.PHONY: all clean
