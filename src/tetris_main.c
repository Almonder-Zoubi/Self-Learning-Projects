#include <stdio.h>
#include <stdlib.h>
#include <ncurses.h>
#include <unistd.h>
#include "game_logic.h"
#include "renderer.h"
#include "input_handler.h"

#define DELAY 100

void setup_ncurses() {
    initscr();            // Start ncurses mode
    cbreak();             // Disable line buffering
    noecho();             // Don't echo pressed keys
    keypad(stdscr, TRUE); // Enable arrow keys
    curs_set(0);          // Hide the cursor
    timeout(DELAY);       // Set a delay for getch()
}

void cleanup_game() {
    endwin(); // End ncurses mode
}

int main() {
    setup_ncurses(); // Initialize ncurses

    GameState game_state;
    initialize_game(&game_state); // Initialize game state

    while (!game_state.gameOver) {
        render(&game_state);           // Render the game
        handle_input(&game_state);     // Handle user input
        update_game(&game_state);      // Update game state

        // Debugging output
        mvprintw(GRID_HEIGHT + 1, 0, "Debug: X=%d, Y=%d, gameOver=%d", 
            game_state.currentX, game_state.currentY, game_state.gameOver);
        refresh();

        usleep(100000); // Sleep for a short duration to control game speed
    }
    // Game over message
    mvprintw(GRID_HEIGHT + 2, 0, "Game Over! Press any key to exit...");
    refresh();
    getch(); // Wait for user input before exiting

    cleanup_game(); // Cleanup ncurses
    return 0;
}