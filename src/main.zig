const std = @import("std");

const raylib = @cImport({
    @cInclude("raylib.h");
});
pub fn main() !void {
    std.debug.print("Hello world!\n {}", .{raylib});

    raylib.InitWindow(640, 480, "__MF");

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
