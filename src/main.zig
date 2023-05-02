const std = @import("std");

const raylib = @cImport({
    @cInclude("raylib.h");
});
var x: i32 = 320;
var y: i32 = 240;

var prng = std.rand.DefaultPrng.init(0);
const random = prng.random();

const Letter = struct { value: [2:0]u8, index: usize, x: i32, y: i32 };
const letter_count = 10;

const alphabet = "abcdefghijklmnopqrstuvwxyz";
pub fn main() !void {
    raylib.InitWindow(640, 480, "__MF");
    raylib.SetWindowPosition(960, 1200);

    const letters = createRandomLetters();
    for (letters) |letter| {
        std.debug.print("---\n", .{});
        std.debug.print("drawing letter {s}\n", .{letter.value});
    }
    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();

        for (letters) |letter| {
            raylib.DrawText(&letter.value, letter.x, letter.y, 26, raylib.BLACK);
        }
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}

fn createRandomLetters() [letter_count]Letter {
    var letters: [letter_count]Letter = undefined;
    for (0..letter_count) |i| {
        const letter_index: usize = random.uintAtMost(usize, alphabet.len);
        std.debug.print("RANDOM INDEX: {}\n", .{letter_index});

        const str = [2:0]u8{ alphabet[letter_index], 0 };
        std.debug.print("while str is {s}\n", .{str});
        // std.debug.print("str.len is {}\n", .{str.len});
        std.debug.print("i is {}\n", .{i});
        letters[i] = Letter{ .value = str, .index = letter_index, .x = 100, .y = 30 * @intCast(i32, i) };
    }
    return letters;
}
