# Tetris Game

This project is a simple implementation of the classic Tetris game in C. It now builds in a cross-platform way:

- macOS builds a native Cocoa app bundle.
- Windows builds a console executable.

The shared game logic stays in C, so only the platform-specific entry point changes between operating systems.

## If You Received This Folder

You do not need to edit any code.

What you need is:

- macOS: install Xcode Command Line Tools or Xcode, plus CMake 3.20 or newer
- Windows: install Visual Studio Build Tools or Visual Studio with C++ desktop support, plus CMake 3.20 or newer

Then run the one-step launcher for your system from the project folder:

- macOS: double-click `build.sh` in Finder, or open Terminal and run `./build.sh`
- Windows: double-click `build.bat` in File Explorer, or open Command Prompt / PowerShell and run `build.bat`

That will configure the project, build it, and open the game.

## What You Need

- macOS: Xcode Command Line Tools or Xcode
- Windows: Visual Studio Build Tools or Visual Studio with C++ desktop support
- CMake 3.20 or newer

## One-Step Build

Run the script for your platform from the project root.

Where to type it:

- macOS: open the Terminal app, then type the command in the Terminal window after you `cd` into the project folder.
- Windows: open Command Prompt or PowerShell, then type the command after you `cd` into the project folder.

Exact commands:

- macOS: `./build.sh`
- Windows: `build.bat`

Each script configures the project, builds it, and launches the game.

If you are only sending the folder to someone else, send the whole folder as-is. They only need the tools listed above; they do not need to create a Makefile or change any source files.

## How To Play

The game opens in a window on macOS and in a console window on Windows.

Controls:

- Left and Right arrows: move the piece
- Down arrow: drop faster
- Up arrow or Space: rotate
- R: restart after game over
- Q or Esc: quit

Goal:

- Fill rows completely to clear them and earn points.
- The game ends when pieces stack to the top.

## Manual CMake Commands

If you prefer terminal commands, use these instead:

Where to type them:

- macOS: Terminal
- Windows: Command Prompt or PowerShell

First, go to the folder that contains this README file. Replace the path below with the actual folder on your machine.

macOS example:

```bash
cd /Users/yourname/Downloads/Self-Learning-Projects-Tetris-Game-C
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

Windows example:

```bat
cd C:\Users\yourname\Downloads\Self-Learning-Projects-Tetris-Game-C
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

## Notes For Sharing

- The repository already includes the build files needed to compile the game.
- The person who receives the folder only needs the platform tools and CMake.
- On macOS, the game launches as `build/Tetris.app`.
- On Windows, the game launches as `build/Release/Tetris.exe` or `build/Tetris.exe`, depending on the generator.
- If they open the folder in Finder or File Explorer, they can run the launcher script directly without creating any files.

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