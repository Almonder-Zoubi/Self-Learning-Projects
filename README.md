# Tetris Game

This project is a simple implementation of the classic Tetris game in C. It now builds in a cross-platform way:

- macOS builds a native Cocoa app bundle.
- Windows builds a console executable.

The shared game logic stays in C, so only the platform-specific entry point changes between operating systems.

## What You Need

- macOS: Xcode Command Line Tools or Xcode
- Windows: Visual Studio Build Tools or Visual Studio with C++ desktop support
- CMake 3.20 or newer

## One-Step Build

Run the script for your platform from the project root:

- macOS: `./build.sh`
- Windows: `build.bat`

Each script configures the project, builds it, and launches the game.

## Manual CMake Commands

If you prefer terminal commands, use these instead:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

On macOS, the app bundle is created at `build/Tetris.app`. On Windows, the executable is created under `build/Release/` for Visual Studio generators or directly under `build/` for single-config generators.

## Controls

- Arrow keys: move the piece
- Space: rotate
- Down arrow: soft drop
- R: restart after game over
- Q or Esc: quit

## Project Structure

```
.
├── CMakeLists.txt
├── Makefile
├── build.sh
├── build.bat
└── src
	├── game_logic.c
	├── game_logic.h
	├── tetris_app.m
	└── tetris_console.c
```

The old ncurses terminal files are still present for reference, but the new build uses CMake and the platform-specific entry points above.