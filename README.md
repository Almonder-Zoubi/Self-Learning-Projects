# Tetris Game

This project is a simple implementation of the classic Tetris game in C. It now builds as a native macOS windowed app using Cocoa instead of a terminal ncurses UI.

## Project Structure

```
Tetris_Game
├── src
│   ├── game_logic.c        # Core game logic (tetromino movement, collision detection, etc.)
│   ├── game_logic.h        # Header file for game_logic.c
│   ├── tetris_app.m        # Cocoa window, rendering, and input handling
│   ├── renderer.c          # Legacy terminal renderer
│   ├── renderer.h          # Legacy terminal renderer header
│   ├── input_handler.c     # Legacy terminal input handler
│   └── input_handler.h     # Legacy terminal input handler header
├── Makefile                # Build instructions and app bundle packaging
└── README.md               # Project documentation
```

## Features

- Playable Tetris game in a native macOS window.
- Control tetrominoes using arrow keys.
- Each tetromino uses its own color, with rounded block rendering instead of plain `#` characters.
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
make run
```

The build creates a `Tetris.app` bundle in the project root. You can open it from Finder or drag it to the Desktop or Dock like a normal macOS app.

## Controls

- **Arrow Up** or **Space**: Rotate tetromino
- **Arrow Down**: Move tetromino down
- **Arrow Left**: Move tetromino left
- **Arrow Right**: Move tetromino right
- **R**: Restart after game over
- **Q** or **Esc**: Quit the game

## Dependencies

This project now uses the macOS Cocoa frameworks that ship with Xcode command-line tools.