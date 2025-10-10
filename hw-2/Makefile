# Makefile for DerivePrivateKey.c
# Uses Homebrew's OpenSSL installation

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGET = DeriveKey
SOURCE = DerivePrivateKey.c

# OpenSSL paths using Homebrew
OPENSSL_PREFIX = $(shell brew --prefix openssl@3)
INCLUDES = -I$(OPENSSL_PREFIX)/include
LDFLAGS = -L$(OPENSSL_PREFIX)/lib
LIBS = -lcrypto

# Default target
all: $(TARGET)

# Build the executable
$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) $(INCLUDES) -o $(TARGET) $(SOURCE) $(LDFLAGS) $(LIBS)

# Clean up build artifacts
clean:
	rm -f $(TARGET)

# Rebuild everything
rebuild: clean all

# Run the program
run: $(TARGET)
	./$(TARGET)

# Show OpenSSL installation path (for debugging)
show-openssl:
	@echo "OpenSSL prefix: $(OPENSSL_PREFIX)"
	@echo "Include path: $(OPENSSL_PREFIX)/include"
	@echo "Library path: $(OPENSSL_PREFIX)/lib"

# Phony targets (not files)
.PHONY: all clean rebuild run show-openssl