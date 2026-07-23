#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "game_logic.h"

// Tetromino shape 4X4 matrix
const int TETROMINOES[7][4][4] = {
    {{0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0, 0, 0}}, // I
    {{0, 1, 0, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}, // T
    {{1, 1, 0, 0}, {1, 1, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}, // O
    {{0, 1, 1, 0}, {1, 1, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}, // S
    {{1, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}, // Z
    {{1, 0, 0, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}, // J
    {{0, 0, 1, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}  // L
};

void initialize_game(GameState *state) {
    memset(state->grid, 0, sizeof(state->grid)); // Clear the grid
    state->gameOver = 0; // Ensure gameOver is set to 0
    state->currentTetrominoType = rand() % 7;
    memcpy(state->currentTetromino, TETROMINOES[state->currentTetrominoType], sizeof(state->currentTetromino)); // Initialize the first tetromino
    state->currentX = GRID_WIDTH / 2 - 2; // Center the tetromino
    state->currentY = 0;

    // Check for initial collision
    if (check_collision(state, 0, 0)) {
        state->gameOver = 1; // End the game if the initial placement collides
    }
}

int check_collision(GameState *state, int offsetX, int offsetY) {
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            if (state->currentTetromino[y][x]) {
                int newX = state->currentX + x + offsetX;
                int newY = state->currentY + y + offsetY;
                if (newX < 0 || newX >= GRID_WIDTH || newY >= GRID_HEIGHT || 
                    (newY >= 0 && state->grid[newY][newX])) {
                    return 1; // Collision detected
                }
            }
        }
    }
    return 0; // No collision
}

void lock_tetromino(GameState *state) {
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            if (state->currentTetromino[y][x]) {
                int gridX = state->currentX + x;
                int gridY = state->currentY + y;
                if (gridX >= 0 && gridX < GRID_WIDTH && gridY >= 0 && gridY < GRID_HEIGHT) {
                    state->grid[gridY][gridX] = state->currentTetrominoType + 1; // Lock the tetromino into the grid
                }
            }
        }
    }
}

void clear_lines(GameState *state) {
    for (int y = GRID_HEIGHT - 1; y >= 0; y--) {
        int full = 1;
        for (int x = 0; x < GRID_WIDTH; x++) {
            if (!state->grid[y][x]) {
                full = 0; // Row is not full
                break;
            }
        }

        if (full) {
            // Shift all rows above down
            for (int row = y; row > 0; row--) {
                memcpy(state->grid[row], state->grid[row - 1], sizeof(state->grid[row]));
            }
            // Clear the top row
            memset(state->grid[0], 0, sizeof(state->grid[0]));

            // Check the same row again (it now contains the row above)
            y++;
        }
    }
}

void update_game(GameState *state) {
    if (!check_collision(state, 0, 1)) {
        // No collision, move the tetromino down
        state->currentY++;
    } else {
        // Collision detected, lock the tetromino and clear lines
        lock_tetromino(state);
        clear_lines(state);

        // Spawn a new tetromino
    state->currentTetrominoType = rand() % 7;
    memcpy(state->currentTetromino, TETROMINOES[state->currentTetrominoType], sizeof(state->currentTetromino));
        state->currentX = GRID_WIDTH / 2 - 2;
        state->currentY = 0;

        // Check if the new tetromino collides immediately (game over)
        if (check_collision(state, 0, 0)) {
            state->gameOver = 1;
        }
    }
}