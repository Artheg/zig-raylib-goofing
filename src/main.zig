const std = @import("std");

const raylib = @cImport({
    @cInclude("raylib.h");
});
pub fn main() !void {
    std.debug.print("Hello world!\n {}", .{raylib});
    const alphabet = "abcdefghijklmnopqrstuvwxyz";
    raylib.InitWindow(640, 480, "__MF");

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        raylib.DrawText(alphabet, 320, 240, 11, raylib.BLACK);
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
