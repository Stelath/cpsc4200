CC = gcc
CFLAGS = -Wall

all: vulp_original vulp_fixed attack

vulp_original: vulp_original.c
	$(CC) $(CFLAGS) vulp_original.c -o vulp_original
	sudo chown root vulp_original
	sudo chmod 4755 vulp_original

vulp_fixed: vulp_fixed.c
	$(CC) $(CFLAGS) vulp_fixed.c -o vulp_fixed
	sudo chown root vulp_fixed
	sudo chmod 4755 vulp_fixed

attack: attack.c
	$(CC) $(CFLAGS) attack.c -o attack

clean:
	rm -f vulp_original vulp_fixed attack

.PHONY: all clean
