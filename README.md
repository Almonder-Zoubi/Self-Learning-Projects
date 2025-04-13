# Tetris Game

This project is a simple implementation of the classic Tetris game in C. The game is designed to be played in a terminal window and utilizes the ncurses library for rendering graphics.

## Project Structure

```
Tetris_Game
├── src
│   ├── tetris_main.c       # Main function and game loop
│   ├── game_logic.c        # Core game logic (tetromino movement, collision detection, etc.)
│   ├── game_logic.h        # Header file for game_logic.c
│   ├── renderer.c          # Rendering functions for terminal graphics
│   ├── renderer.h          # Header file for renderer.c
│   ├── input_handler.c     # User input handling (keyboard events)
│   └── input_handler.h     # Header file for input_handler.c
├── Makefile                 # Build instructions
└── README.md                # Project documentation
```

## Features

- Playable Tetris game in a terminal environment.
- Control tetrominoes using arrow keys.
- Automatic line clearing when a line is filled.
- Game ends when tetrominoes reach the top of the grid.

## Building the Project

To build the project, navigate to the project directory and run the following command:

```
make
```

This will compile the source files and create an executable.

## Running the Game

After building the project, you can run the game using the following command:

```
./tetris
```

## Controls

- **Arrow Up**: Rotate tetromino
- **Arrow Down**: Move tetromino down
- **Arrow Left**: Move tetromino left
- **Arrow Right**: Move tetromino right
- **q**: Quit the game

## Dependencies

This project requires the ncurses library. Make sure to install it on your system before building the project.