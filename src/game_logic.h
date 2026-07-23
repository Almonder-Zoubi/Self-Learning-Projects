#ifndef GAME_LOGIC_H
#define GAME_LOGIC_H

#define GRID_WIDTH 10
#define GRID_HEIGHT 20

typedef struct {
    int grid[GRID_HEIGHT][GRID_WIDTH];
    int currentTetromino[4][4]; // Placeholder for current tetromino shape
    int currentTetrominoType;
    int currentX;
    int currentY;
    int gameOver;
} GameState;

void initialize_game(GameState *state);
void update_game(GameState *state);
int check_collision(GameState *state, int offsetX, int offsetY);
void lock_tetromino(GameState *state);
void clear_lines(GameState *state);

#endif // GAME_LOGIC_H