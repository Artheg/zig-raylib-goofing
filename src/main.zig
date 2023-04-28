const std = @import("std");

const raylib = @cImport({
    @cInclude("raylib.h");
});
var x: f32 = 320;
var y: f32 = 240;
pub fn main() !void {
    std.debug.print("Hello world!\n {}", .{raylib});
    const alphabet = "abcdefghijklmnopqrstuvwxyz";
    raylib.InitWindow(640, 480, "__MF");

    while (!raylib.WindowShouldClose()) {
        // Look into DrawTextEx
        // match?
        // convert
        raylib.BeginDrawing();
        if (raylib.IsKeyDown(raylib.KEY_LEFT)) {
            x -= 1;
        }
        if (raylib.IsKeyDown(raylib.KEY_RIGHT)) {
            x += 1;
        }
        if (raylib.IsKeyDown(raylib.KEY_UP)) {
            y -= 1;
        }
        if (raylib.IsKeyDown(raylib.KEY_DOWN)) {
            y += 1;
        }
        raylib.DrawText(alphabet, x, y, 11, raylib.BLACK);
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
