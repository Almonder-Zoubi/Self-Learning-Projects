#include <ncurses.h>
#include "renderer.h"

void render(GameState *state) {
    clear(); // Clear the screen

    // Draw the border
    for (int y = 0; y <= GRID_HEIGHT; y++) {
        mvprintw(y, 0, "|"); // Left border
        mvprintw(y, GRID_WIDTH + 1, "|"); // Right border
    }
    for (int x = 0; x <= GRID_WIDTH + 1; x++) {
        mvprintw(GRID_HEIGHT, x, "-"); // Bottom border
    }

    // Render the grid
    for (int y = 0; y < GRID_HEIGHT; y++) {
        for (int x = 0; x < GRID_WIDTH; x++) {
            if (state->grid[y][x]) {
                mvprintw(y, x + 1, "#"); // Draw filled cells (shifted by 1 for the border)
            }
        }
    }

    // Render the current tetromino
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            if (state->currentTetromino[y][x]) {
                mvprintw(state->currentY + y, state->currentX + x + 1, "O"); // Draw the tetromino (shifted by 1 for the border)
            }
        }
    }

    refresh(); // Refresh the screen to show changes
}