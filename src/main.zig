const std = @import("std");

const raylib = @import("raylib");
var x: i32 = 320;
var y: i32 = 240;

const Letter = struct { value: [1:0]u8, index: u8, x: i32, y: i32 };
const letter_count = 15;
const font_size = 15;

const alphabet = "abcdefghijklmnopqrstuvwxyz";
pub fn main() !void {
    var prng = std.rand.DefaultPrng.init(@intCast(u64, std.time.nanoTimestamp()));
    const random = prng.random();

    raylib.InitWindow(640, 480, "__MF");
    raylib.SetWindowPosition(960, 1200);

    var letters = createRandomLetters(random);
    for (letters) |letter| {
        std.debug.print("---\n", .{});
        std.debug.print("drawing letter {s}\n", .{letter.value});
        for (letter.value) |char| {
            std.debug.print("u8: {}", .{char});
        }
    }
    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();

        for (letters) |letter| {
            raylib.DrawText(&letter.value, letter.x, letter.y, font_size, raylib.BLACK);
        }
        raylib.ClearBackground(raylib.WHITE);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}

fn createRandomLetters(random: std.rand.Random) [letter_count]Letter {
    var letters: [letter_count]Letter = undefined;
    for (0..letter_count) |i| {
        const letter_index = random.uintAtMost(u8, alphabet.len - 1);
        std.debug.print("RANDOM INDEX: {}\n", .{letter_index});

        const str = [1:0]u8{alphabet[letter_index]};
        std.debug.print("while str is {s}\n", .{str});
        // std.debug.print("str.len is {}\n", .{str.len});
        std.debug.print("i is {}\n", .{i});
        letters[i] = Letter{ .value = str, .index = letter_index, .x = 100, .y = 30 * @intCast(i32, i) };
    }
    return letters;
}
