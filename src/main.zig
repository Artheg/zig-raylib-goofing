const std = @import("std");

const raylib = @import("raylib");
const KeyboardKey = raylib.KeyboardKey;

var x: i32 = 320;
var y: i32 = 240;

const Letter = struct { value: [2:0]u8, index: u8, x: i32, y: i32, was_pressed: bool };
const letter_count = 15;
const font_size = 25;
const screen_width = 640;
const screen_height = 480;

const alphabet = "abcdefghijklmnopqrstuvwxyz";
pub fn main() !void {
    var prng = std.rand.DefaultPrng.init(@intCast(u64, std.time.nanoTimestamp()));
    const random = prng.random();

    raylib.InitWindow(640, 480, "__MF");
    raylib.SetWindowPosition(960, 1200);

    var i: usize = 0;
    var letters: [letter_count]Letter = undefined;
    while (i < letter_count) : (i += 1) {
        letters[i] = std.mem.zeroes(Letter);
    }
    createRandomLetters(&letters, random);
    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();

        for (&letters) |*letter| {
            if (letter.was_pressed) continue;
            if (raylib.IsKeyPressed(letterToKey(letter.value[0]))) {
                letter.was_pressed = true;
                break;
            }
        }

        for (letters) |letter| if (!letter.was_pressed) raylib.DrawText(&letter.value, letter.x, letter.y, font_size, raylib.WHITE);

        raylib.ClearBackground(raylib.DARKBLUE);
        raylib.EndDrawing();

        const task_complete = for (letters) |letter| {
            if (!letter.was_pressed) break false;
        } else true;
        if (task_complete) {
            createRandomLetters(&letters, random);
        }
    }
    raylib.CloseWindow();
}

fn createRandomLetters(letters: *[letter_count]Letter, random: std.rand.Random) void {
    for (0..letters.len) |i| {
        const letter_index = random.uintAtMost(u8, alphabet.len - 1);
        const str = [2:0]u8{ alphabet[letter_index], 0 };
        const letter_struct = &letters[i];
        letter_struct.value = str;
        letter_struct.index = letter_index;
        letter_struct.x = (screen_width - font_size) / 2;
        letter_struct.y = font_size * @intCast(i32, i);
        letter_struct.was_pressed = false;
    }
}

fn letterToKey(letter: u8) KeyboardKey {
    var result = letter;
    if (result >= 'a' and result <= 'z') {
        result -= 32;
    }
    return @intToEnum(KeyboardKey, result);
}
