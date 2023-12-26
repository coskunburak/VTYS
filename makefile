CC = g++
CFLAGS = -std=c++17 -I "C:\Program Files\PostgreSQL\15\include"
LDFLAGS = -L "C:\Program Files\PostgreSQL\15\lib" -lpq
SRC_DIR = src
BUILD_DIR = lib
BIN_DIR = bin

all: build link run

build:
	$(CC) $(CFLAGS) -c $(SRC_DIR)/main.cpp -o $(BUILD_DIR)/main.o

link:
	$(CC) $(CFLAGS) $(BUILD_DIR)/main.o -o $(BIN_DIR)/main.exe $(LDFLAGS)

run:
	./$(BIN_DIR)/main.exe