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

const Letter = struct { value: *const [1:0]u8, index: usize, x: i32, y: i32 };

pub fn main() !void {
    // std.debug.print("Hello world!\n {}", .{raylib});

    const alphabet = "abcdefghijklmnopqrstuvwxyz";
    raylib.InitWindow(640, 480, "__MF");
    raylib.SetWindowPosition(960, 1200);

    const now = @intCast(u64, std.time.nanoTimestamp());
    var prng = std.rand.DefaultPrng.init(now);
    var letters: [10]Letter = undefined;
    for (0..10) |i| {
        const random = prng.random();
        const letter_index: usize = random.uintAtMost(usize, alphabet.len);
        std.debug.print("RANDOM INDEX: {}\n", .{letter_index});

        const str = [1:0]u8{alphabet[letter_index]};
        std.debug.print("while str is {s}\n", .{str});
        std.debug.print("str.len is {}\n", .{str.len});
        letters[i] = Letter{ .value = &str, .index = letter_index, .x = 100, .y = 30 * @intCast(i32, i) };
    }
    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        // x += switch (raylib.GetKeyPressed()) {
        //     raylib.KEY_LEFT => -1,
        //     raylib.KEY_RIGHT => 1,
        //     else => 0,
        // };
        // y += switch (raylib.GetKeyPressed()) {
        //     raylib.KEY_UP => -1,
        //     raylib.KEY_DOWN => 1,
        //     else => 0,
        // };

        for (letters) |letter| {
            std.debug.print("---\n", .{});
            std.debug.print("drawing letter {s}\n", .{letter.value});
            raylib.DrawText(&alphabet[letter.index], letter.x, letter.y, 26, raylib.BLACK);
        }
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
