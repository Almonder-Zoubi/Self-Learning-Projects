#import <Cocoa/Cocoa.h>
#include <time.h>
#include <string.h>
#include "game_logic.h"

static const CGFloat kCellSize = 30.0;
static const CGFloat kBoardPadding = 28.0;
static const NSTimeInterval kDropInterval = 0.45;

static NSColor *TetrominoColor(int tetrominoType) {
    switch (tetrominoType) {
        case 0: return [NSColor colorWithCalibratedRed:0.20 green:0.80 blue:0.95 alpha:1.0];
        case 1: return [NSColor colorWithCalibratedRed:0.82 green:0.35 blue:0.95 alpha:1.0];
        case 2: return [NSColor colorWithCalibratedRed:0.98 green:0.82 blue:0.18 alpha:1.0];
        case 3: return [NSColor colorWithCalibratedRed:0.22 green:0.82 blue:0.48 alpha:1.0];
        case 4: return [NSColor colorWithCalibratedRed:0.92 green:0.30 blue:0.26 alpha:1.0];
        case 5: return [NSColor colorWithCalibratedRed:0.30 green:0.50 blue:0.98 alpha:1.0];
        case 6: return [NSColor colorWithCalibratedRed:0.98 green:0.56 blue:0.18 alpha:1.0];
        default: return [NSColor lightGrayColor];
    }
}

static void RotateTetrominoClockwise(int tetromino[4][4]) {
    int temp[4][4];
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            temp[x][3 - y] = tetromino[y][x];
        }
    }
    memcpy(tetromino, temp, sizeof(temp));
}

@interface TetrisView : NSView
@end

@implementation TetrisView {
    GameState _gameState;
    NSTimer *_timer;
    BOOL _didGameOver;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setWantsLayer:YES];
        [self startNewGame];
    }
    return self;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (void)startNewGame {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    initialize_game(&_gameState);
    _didGameOver = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:kDropInterval
                                              target:self
                                            selector:@selector(advanceGame)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self setNeedsDisplay:YES];
}

- (void)advanceGame {
    if (_gameState.gameOver) {
        if (_timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
        if (!_didGameOver) {
            _didGameOver = YES;
            [self setNeedsDisplay:YES];
        }
        return;
    }

    update_game(&_gameState);
    [self setNeedsDisplay:YES];

    if (_gameState.gameOver && _timer != nil) {
        [_timer invalidate];
        _timer = nil;
        _didGameOver = YES;
    }
}

- (void)attemptMoveByX:(int)deltaX y:(int)deltaY {
    if (_gameState.gameOver) {
        return;
    }
    if (!check_collision(&_gameState, deltaX, deltaY)) {
        _gameState.currentX += deltaX;
        _gameState.currentY += deltaY;
        [self setNeedsDisplay:YES];
    }
}

- (void)attemptRotate {
    if (_gameState.gameOver) {
        return;
    }

    int originalTetromino[4][4];
    int originalX = _gameState.currentX;
    memcpy(originalTetromino, _gameState.currentTetromino, sizeof(originalTetromino));
    RotateTetrominoClockwise(_gameState.currentTetromino);

    const int kicks[] = {0, -1, 1, -2, 2};
    for (int i = 0; i < 5; i++) {
        _gameState.currentX = originalX + kicks[i];
        if (!check_collision(&_gameState, 0, 0)) {
            [self setNeedsDisplay:YES];
            return;
        }
    }

    _gameState.currentX = originalX;
    memcpy(_gameState.currentTetromino, originalTetromino, sizeof(originalTetromino));
}

- (void)drawBlockAtColumn:(int)column row:(int)row color:(NSColor *)color inBoardRect:(NSRect)boardRect {
    CGFloat x = boardRect.origin.x + column * kCellSize;
    CGFloat y = boardRect.origin.y + (GRID_HEIGHT - 1 - row) * kCellSize;
    NSRect cellRect = NSMakeRect(x + 1.5, y + 1.5, kCellSize - 3.0, kCellSize - 3.0);

    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellRect xRadius:6.0 yRadius:6.0];
    [color setFill];
    [path fill];

    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.28] setStroke];
    [path setLineWidth:1.0];
    [path stroke];
}

- (void)drawPieceAtColumn:(int)column row:(int)row color:(NSColor *)color inBoardRect:(NSRect)boardRect {
    [self drawBlockAtColumn:column row:row color:color inBoardRect:boardRect];
}

- (void)drawText:(NSString *)text atPoint:(NSPoint)point fontSize:(CGFloat)fontSize color:(NSColor *)color {
    NSDictionary *attributes = @{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:fontSize],
        NSForegroundColorAttributeName: color
    };
    [text drawAtPoint:point withAttributes:attributes];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect bounds = self.bounds;
    NSGradient *background = [[NSGradient alloc] initWithColors:@[
        [NSColor colorWithCalibratedRed:0.07 green:0.09 blue:0.15 alpha:1.0],
        [NSColor colorWithCalibratedRed:0.11 green:0.14 blue:0.23 alpha:1.0]
    ]];
    [background drawInRect:bounds angle:90.0];

    CGFloat boardWidth = GRID_WIDTH * kCellSize;
    CGFloat boardHeight = GRID_HEIGHT * kCellSize;
    CGFloat boardOriginX = kBoardPadding;
    CGFloat boardOriginY = (NSHeight(bounds) - boardHeight) / 2.0;
    NSRect boardRect = NSMakeRect(boardOriginX, boardOriginY, boardWidth, boardHeight);

    NSBezierPath *boardPath = [NSBezierPath bezierPathWithRoundedRect:boardRect xRadius:12.0 yRadius:12.0];
    [[NSColor colorWithCalibratedWhite:0.03 alpha:0.65] setFill];
    [boardPath fill];
    [[NSColor colorWithCalibratedWhite:1.0 alpha:0.14] setStroke];
    [boardPath setLineWidth:2.0];
    [boardPath stroke];

    for (int y = 0; y < GRID_HEIGHT; y++) {
        for (int x = 0; x < GRID_WIDTH; x++) {
            int cellValue = _gameState.grid[y][x];
            if (cellValue > 0) {
                [self drawBlockAtColumn:x row:y color:TetrominoColor(cellValue - 1) inBoardRect:boardRect];
            }
        }
    }

    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            if (_gameState.currentTetromino[y][x]) {
                int boardColumn = _gameState.currentX + x;
                int boardRow = _gameState.currentY + y;
                if (boardColumn >= 0 && boardColumn < GRID_WIDTH && boardRow >= 0 && boardRow < GRID_HEIGHT) {
                    [self drawPieceAtColumn:boardColumn row:boardRow color:TetrominoColor(_gameState.currentTetrominoType) inBoardRect:boardRect];
                }
            }
        }
    }

    CGFloat panelX = NSMaxX(boardRect) + 24.0;
    [self drawText:@"Tetris" atPoint:NSMakePoint(panelX, NSMaxY(bounds) - 72.0) fontSize:34.0 color:[NSColor whiteColor]];
    [self drawText:@"Arrow keys: move" atPoint:NSMakePoint(panelX, NSMaxY(bounds) - 120.0) fontSize:15.0 color:[NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [self drawText:@"Space: rotate" atPoint:NSMakePoint(panelX, NSMaxY(bounds) - 144.0) fontSize:15.0 color:[NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [self drawText:@"R: restart" atPoint:NSMakePoint(panelX, NSMaxY(bounds) - 168.0) fontSize:15.0 color:[NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];
    [self drawText:@"Q or Esc: quit" atPoint:NSMakePoint(panelX, NSMaxY(bounds) - 192.0) fontSize:15.0 color:[NSColor colorWithCalibratedWhite:0.88 alpha:1.0]];

    if (_gameState.gameOver) {
        NSRect overlayRect = NSInsetRect(boardRect, 18.0, boardHeight * 0.30);
        NSBezierPath *overlayPath = [NSBezierPath bezierPathWithRoundedRect:overlayRect xRadius:16.0 yRadius:16.0];
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.72] setFill];
        [overlayPath fill];

        NSString *message = @"Game Over";
        NSSize messageSize = [message sizeWithAttributes:@{ NSFontAttributeName: [NSFont boldSystemFontOfSize:28.0] }];
        CGFloat messageX = NSMidX(overlayRect) - messageSize.width / 2.0;
        CGFloat messageY = NSMidY(overlayRect) + 6.0;
        [self drawText:message atPoint:NSMakePoint(messageX, messageY) fontSize:28.0 color:[NSColor whiteColor]];
        [self drawText:@"Press R to restart" atPoint:NSMakePoint(NSMidX(overlayRect) - 74.0, NSMidY(overlayRect) - 28.0) fontSize:15.0 color:[NSColor colorWithCalibratedWhite:0.92 alpha:1.0]];
    }
}

- (void)keyDown:(NSEvent *)event {
    switch (event.keyCode) {
        case 123: // left arrow
            [self attemptMoveByX:-1 y:0];
            break;
        case 124: // right arrow
            [self attemptMoveByX:1 y:0];
            break;
        case 125: // down arrow
            [self advanceGame];
            break;
        case 126: // up arrow
        case 49:  // space
            [self attemptRotate];
            break;
        case 53:  // escape
            [NSApp terminate:self];
            break;
        default: {
            NSString *characters = [event charactersIgnoringModifiers].lowercaseString;
            if ([characters isEqualToString:@"q"]) {
                [NSApp terminate:self];
            } else if ([characters isEqualToString:@"r"]) {
                [self startNewGame];
            } else {
                [super keyDown:event];
            }
            break;
        }
    }
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        (void)argc;
        (void)argv;
        srand((unsigned)time(NULL));

        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

        NSRect windowRect = NSMakeRect(0, 0, 760, 680);
        NSWindow *window = [[NSWindow alloc] initWithContentRect:windowRect
                                                       styleMask:(NSWindowStyleMaskTitled |
                                                                  NSWindowStyleMaskClosable |
                                                                  NSWindowStyleMaskMiniaturizable |
                                                                  NSWindowStyleMaskResizable)
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
        [window setTitle:@"Tetris"];
        [window center];
        [window makeKeyAndOrderFront:nil];

        TetrisView *view = [[TetrisView alloc] initWithFrame:window.contentView.bounds];
        [view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
        [window setContentView:view];
        [window makeFirstResponder:view];
        [NSApp activateIgnoringOtherApps:YES];
        [NSApp run];
    }
    return 0;
}
