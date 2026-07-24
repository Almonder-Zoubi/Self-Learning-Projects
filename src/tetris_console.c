#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef _WIN32
#include <conio.h>
#include <windows.h>
#endif

#include "game_logic.h"

enum {
    KEY_NONE = 0,
    KEY_LEFT = 1001,
    KEY_RIGHT = 1002,
    KEY_DOWN = 1003,
    KEY_UP = 1004,
    KEY_SPACE = 32,
    KEY_ESCAPE = 27,
    KEY_RESTART = 'r',
    KEY_QUIT = 'q'
};

typedef enum {
    LOOP_RESTART = 0,
    LOOP_QUIT = 1
} LoopResult;

static void RotateTetrominoClockwise(int tetromino[4][4]) {
    int temp[4][4];
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            temp[x][3 - y] = tetromino[y][x];
        }
    }
    memcpy(tetromino, temp, sizeof(temp));
}

static int GetCellValue(const GameState *state, int row, int column) {
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            if (state->currentTetromino[y][x]) {
                int pieceRow = state->currentY + y;
                int pieceColumn = state->currentX + x;
                if (pieceRow == row && pieceColumn == column) {
                    return state->currentTetrominoType + 1;
                }
            }
        }
    }

    return state->grid[row][column];
}

static void TryMove(GameState *state, int deltaX, int deltaY) {
    if (!check_collision(state, deltaX, deltaY)) {
        state->currentX += deltaX;
        state->currentY += deltaY;
    }
}

static void TryRotate(GameState *state) {
    int originalTetromino[4][4];
    int originalX = state->currentX;

    memcpy(originalTetromino, state->currentTetromino, sizeof(originalTetromino));
    RotateTetrominoClockwise(state->currentTetromino);

    const int kicks[] = {0, -1, 1, -2, 2};
    for (int i = 0; i < 5; i++) {
        state->currentX = originalX + kicks[i];
        if (!check_collision(state, 0, 0)) {
            return;
        }
    }

    state->currentX = originalX;
    memcpy(state->currentTetromino, originalTetromino, sizeof(originalTetromino));
}

#ifdef _WIN32
static void HideCursor(void) {
    HANDLE consoleHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_CURSOR_INFO cursorInfo;

    if (GetConsoleCursorInfo(consoleHandle, &cursorInfo)) {
        cursorInfo.bVisible = FALSE;
        SetConsoleCursorInfo(consoleHandle, &cursorInfo);
    }
}

static void ShowCursor(void) {
    HANDLE consoleHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_CURSOR_INFO cursorInfo;

    if (GetConsoleCursorInfo(consoleHandle, &cursorInfo)) {
        cursorInfo.bVisible = TRUE;
        SetConsoleCursorInfo(consoleHandle, &cursorInfo);
    }
}

static void ResetCursor(void) {
    HANDLE consoleHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    COORD homePosition = {0, 0};
    SetConsoleCursorPosition(consoleHandle, homePosition);
}

static void ClearConsole(void) {
    HANDLE consoleHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo;
    DWORD writtenCells = 0;
    DWORD consoleCells;
    COORD homePosition = {0, 0};

    if (!GetConsoleScreenBufferInfo(consoleHandle, &bufferInfo)) {
        return;
    }

    consoleCells = (DWORD)bufferInfo.dwSize.X * (DWORD)bufferInfo.dwSize.Y;
    FillConsoleOutputCharacterA(consoleHandle, ' ', consoleCells, homePosition, &writtenCells);
    FillConsoleOutputAttribute(consoleHandle, bufferInfo.wAttributes, consoleCells, homePosition, &writtenCells);
    SetConsoleCursorPosition(consoleHandle, homePosition);
}

static int ReadKey(void) {
    int ch;

    if (!_kbhit()) {
        return KEY_NONE;
    }

    ch = _getch();
    if (ch == 0 || ch == 224) {
        ch = _getch();
        switch (ch) {
            case 72:
                return KEY_UP;
            case 80:
                return KEY_DOWN;
            case 75:
                return KEY_LEFT;
            case 77:
                return KEY_RIGHT;
            default:
                return KEY_NONE;
        }
    }

    return ch;
}

static void SleepMs(unsigned int milliseconds) {
    Sleep(milliseconds);
}
#endif

static void RenderGame(const GameState *state, int showGameOver) {
    char borderLine[GRID_WIDTH * 2 + 3];

#ifdef _WIN32
    ClearConsole();
#else
    printf("\033[H\033[J");
#endif

    printf("Tetris\n");
    printf("Score: %d\n", state->score);
    printf("Controls: Arrow keys move, Space rotates, R restarts, Q quits\n\n");

    memset(borderLine, '-', GRID_WIDTH * 2);
    borderLine[0] = '+';
    borderLine[GRID_WIDTH * 2 + 1] = '+';
    borderLine[GRID_WIDTH * 2 + 2] = '\0';
    printf("%s\n", borderLine);

    for (int y = 0; y < GRID_HEIGHT; y++) {
        putchar('|');
        for (int x = 0; x < GRID_WIDTH; x++) {
            if (GetCellValue(state, y, x) > 0) {
                fputs("[]", stdout);
            } else {
                fputs("  ", stdout);
            }
        }
        printf("|\n");
    }

    printf("%s\n", borderLine);

    if (showGameOver) {
        printf("Game Over. Press R to restart or Q to quit.\n");
    }

    fflush(stdout);
}

static LoopResult RunGameLoop(void) {
    GameState state;
    const unsigned int dropIntervalMs = 450;
    unsigned long long lastDropTick;
    int needsRender = 1;

    initialize_game(&state);
    lastDropTick = GetTickCount64();

    while (!state.gameOver) {
        int key = ReadKey();

        if (key == KEY_LEFT) {
            TryMove(&state, -1, 0);
            needsRender = 1;
        } else if (key == KEY_RIGHT) {
            TryMove(&state, 1, 0);
            needsRender = 1;
        } else if (key == KEY_DOWN) {
            update_game(&state);
            lastDropTick = GetTickCount64();
            needsRender = 1;
        } else if (key == KEY_UP || key == KEY_SPACE) {
            TryRotate(&state);
            needsRender = 1;
        } else if (key == KEY_QUIT || key == KEY_ESCAPE) {
            return LOOP_QUIT;
        }

        if (GetTickCount64() - lastDropTick >= dropIntervalMs) {
            update_game(&state);
            lastDropTick = GetTickCount64();
            needsRender = 1;
        }

        if (needsRender) {
            RenderGame(&state, 0);
            needsRender = 0;
        }

        SleepMs(15);
    }

    RenderGame(&state, 1);

    for (;;) {
        int key = ReadKey();
        if (key == KEY_RESTART) {
            return LOOP_RESTART;
        }
        if (key == KEY_QUIT || key == KEY_ESCAPE) {
            return LOOP_QUIT;
        }
        SleepMs(15);
    }
}

int main(void) {
#ifdef _WIN32
    HideCursor();
    SetConsoleTitleA("Tetris");
#endif

    srand((unsigned)time(NULL));

    for (;;) {
        LoopResult result = RunGameLoop();
        if (result == LOOP_QUIT) {
            break;
        }
    }

#ifdef _WIN32
    ShowCursor();
    ResetCursor();
#endif
    return 0;
}