const std = @import("std");

const raylib = @cImport({
    @cInclude("raylib.h");
});
var x: i32 = 320;
var y: i32 = 240;

const Alphabet = struct {
    letters: *const [26]u8,
    pub fn getRandomLetter(self: Alphabet) u8 {
        const index = std.rand.limitRangeBiased(usize, 1, self.letters.len);
        std.debug.print("printing random letter\n", .{});
        return self.letters[index];
    }
};

pub fn main() !void {
    // std.debug.print("Hello world!\n {}", .{raylib});
    const alphabet = Alphabet{ .letters = "abcdefghijklmnopqrstuvwxyz" };
    std.debug.print("letter: {}\n", .{alphabet.getRandomLetter()});
    raylib.InitWindow(640, 480, "__MF");

    while (!raylib.WindowShouldClose()) {
        // Look into DrawTextEx
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
        // raylib.DrawText(alphabet.getRandomLetter(), x, y, 11, raylib.BLACK);
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
