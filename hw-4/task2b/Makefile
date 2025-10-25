CC = gcc
CFLAGS = -Wall

all: vulp attack

vulp: vulp.c
	$(CC) $(CFLAGS) vulp.c -o vulp
	sudo chown root vulp
	sudo chmod 4755 vulp

attack: attack.c
	$(CC) $(CFLAGS) attack.c -o attack

clean:
	rm -f vulp attack

.PHONY: all clean
