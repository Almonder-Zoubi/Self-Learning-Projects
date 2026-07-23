#include <ncurses.h>
#include <string.h>
#include "input_handler.h"

void rotate_tetromino(GameState *state) {
    int temp[4][4];
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            temp[x][3 - y] = state->currentTetromino[y][x];
        }
    }
    memcpy(state->currentTetromino, temp, sizeof(state->currentTetromino));
}

void handle_input(GameState *state) {
    int ch = getch();
    switch (ch) {
        case KEY_LEFT:
            if (!check_collision(state, -1, 0)) state->currentX--;
            break;
        case KEY_RIGHT:
            if (!check_collision(state, 1, 0)) state->currentX++;
            break;
        case KEY_DOWN:
            if (!check_collision(state, 0, 1)) state->currentY++;
            break;
        case ' ':
            rotate_tetromino(state);
            break;
    }
}