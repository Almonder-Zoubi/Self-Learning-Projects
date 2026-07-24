cmake_minimum_required(VERSION 3.20)

project(Tetris LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

if(APPLE)
    enable_language(OBJC)
    set_source_files_properties(src/tetris_app.m PROPERTIES COMPILE_FLAGS "-fobjc-arc")
endif()

set(TETRIS_COMMON_SOURCES
    src/game_logic.c
)

if(APPLE)
    add_executable(Tetris MACOSX_BUNDLE
        ${TETRIS_COMMON_SOURCES}
        src/tetris_app.m
    )
    target_link_libraries(Tetris PRIVATE "-framework Cocoa")
    set_target_properties(Tetris PROPERTIES
        MACOSX_BUNDLE TRUE
        OUTPUT_NAME "Tetris"
    )
elseif(WIN32)
    add_executable(Tetris
        ${TETRIS_COMMON_SOURCES}
        src/tetris_console.c
    )
    target_compile_definitions(Tetris PRIVATE _CRT_SECURE_NO_WARNINGS)
else()
    message(FATAL_ERROR "This project currently supports macOS and Windows only.")
endif()

target_include_directories(Tetris PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

if(MSVC)
    target_compile_options(Tetris PRIVATE /W4)
else()
    target_compile_options(Tetris PRIVATE -Wall -Wextra)
endif()