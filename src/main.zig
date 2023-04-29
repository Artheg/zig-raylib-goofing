const std = @import("std");

const raylib = @cImport({
    @cInclude("raylib.h");
});
var x: i32 = 320;
var y: i32 = 240;
pub fn main() !void {
    std.debug.print("Hello world!\n {}", .{raylib});
    const alphabet = "abcdefghijklmnopqrstuvwxyz";
    raylib.InitWindow(640, 480, "__MF");

    while (!raylib.WindowShouldClose()) {
        // Look into DrawTextEx
        // match?
        // convert
        raylib.BeginDrawing();
        x += switch (raylib.GetKeyPressed()) {
            raylib.KEY_LEFT => -1,
            raylib.KEY_RIGHT => 1,
            else => 0,
        };
        y += switch (raylib.GetKeyPressed()) {
            raylib.KEY_UP => -1,
            raylib.KEY_DOWN => 1,
            else => 0,
        };
        raylib.DrawText(alphabet, x, y, 11, raylib.BLACK);
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
