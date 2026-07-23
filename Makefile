APP_NAME = Tetris
APP_DIR = $(APP_NAME).app
APP_EXEC = $(APP_DIR)/Contents/MacOS/$(APP_NAME)
INFO_PLIST = $(APP_DIR)/Contents/Info.plist

CC = clang
CFLAGS_C = -Wall -Wextra -std=c99
CFLAGS_OBJC = -Wall -Wextra -fobjc-arc
FRAMEWORKS = -framework Cocoa
SRC = src/game_logic.c src/tetris_app.m
OBJ = $(SRC:.c=.o)
OBJ := $(OBJ:.m=.o)

all: $(APP_DIR)

$(APP_DIR): $(APP_EXEC) $(INFO_PLIST)
	@mkdir -p $(APP_DIR)/Contents/Resources

$(APP_EXEC): $(OBJ)
	@mkdir -p $(APP_DIR)/Contents/MacOS
	$(CC) $(OBJ) -o $@ $(FRAMEWORKS)

$(INFO_PLIST):
	@mkdir -p $(APP_DIR)/Contents
	@printf '%s\n' '<?xml version="1.0" encoding="UTF-8"?>' > $@
	@printf '%s\n' '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $@
	@printf '%s\n' '<plist version="1.0">' >> $@
	@printf '%s\n' '<dict>' >> $@
	@printf '%s\n' '  <key>CFBundleName</key>' >> $@
	@printf '%s\n' '  <string>$(APP_NAME)</string>' >> $@
	@printf '%s\n' '  <key>CFBundleDisplayName</key>' >> $@
	@printf '%s\n' '  <string>$(APP_NAME)</string>' >> $@
	@printf '%s\n' '  <key>CFBundleExecutable</key>' >> $@
	@printf '%s\n' '  <string>$(APP_NAME)</string>' >> $@
	@printf '%s\n' '  <key>CFBundleIdentifier</key>' >> $@
	@printf '%s\n' '  <string>com.selflearningprojects.tetris</string>' >> $@
	@printf '%s\n' '  <key>CFBundlePackageType</key>' >> $@
	@printf '%s\n' '  <string>APPL</string>' >> $@
	@printf '%s\n' '  <key>CFBundleShortVersionString</key>' >> $@
	@printf '%s\n' '  <string>1.0</string>' >> $@
	@printf '%s\n' '  <key>CFBundleVersion</key>' >> $@
	@printf '%s\n' '  <string>1</string>' >> $@
	@printf '%s\n' '</dict>' >> $@
	@printf '%s\n' '</plist>' >> $@

%.o: %.c
	$(CC) $(CFLAGS_C) -c -o $@ $<

%.o: %.m
	$(CC) $(CFLAGS_OBJC) -c -o $@ $<

run: $(APP_DIR)
	open $(APP_DIR)

clean:
	rm -rf $(OBJ) $(APP_DIR)