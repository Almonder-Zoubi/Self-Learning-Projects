BUILD_DIR = build

all:
	cmake -S . -B $(BUILD_DIR)
	cmake --build $(BUILD_DIR)

run: all
	open $(BUILD_DIR)/Tetris.app

clean:
	rm -rf $(BUILD_DIR)