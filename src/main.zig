const std = @import("std");

const raylib = @cImport({
    @cInclude("raylib.h");
});
var x: i32 = 320;
var y: i32 = 240;

// const Alphabet = struct {
//     letters: *const [26]u8,
//     pub fn getRandomLetter(self: Alphabet) u8 {
//         const msTimestamp: i64 = std.time.milliTimestamp();
//         const rand = std.rand.DefaultPrng.init(@as(u64, msTimestamp));
//         const letterIndex = rand.next_u32() % 26;
//         return self.letters[letterIndex];
//     }
// };

pub fn main() !void {
    // std.debug.print("Hello world!\n {}", .{raylib});
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });

    const alphabet = "abcdefghijklmnopqrstuvwxyz";
    // std.debug.print("letter: {}\n", .{alphabet.getRandomLetter()});
    raylib.InitWindow(640, 480, "__MF");

    const random = prng.random();
    const index: usize = random.intRangeAtMost(usize, 0, alphabet.len);
    const str = [1]u8{alphabet[index]};
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
        // std.debug.print("{s}\n", .{.{alphabet[index]}});
        raylib.DrawText(&str, x, y, 16, raylib.BLACK);
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
