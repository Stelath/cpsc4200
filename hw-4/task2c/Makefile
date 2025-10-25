CC = gcc
CFLAGS = -Wall

all: vulp attack_improved

vulp: vulp.c
	$(CC) $(CFLAGS) vulp.c -o vulp
	sudo chown root vulp
	sudo chmod 4755 vulp

attack_improved: attack_improved.c
	$(CC) $(CFLAGS) attack_improved.c -o attack_improved

clean:
	rm -f vulp attack_improved

.PHONY: all clean
