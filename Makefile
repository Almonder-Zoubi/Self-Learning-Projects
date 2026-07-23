CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LDFLAGS = -lncurses
SRC = src/tetris_main.c src/game_logic.c src/renderer.c src/input_handler.c
OBJ = $(SRC:.c=.o)
TARGET = tetris

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJ) $(TARGET)