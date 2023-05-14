const std = @import("std");

const raylib = @import("raylib");
const KeyboardKey = raylib.KeyboardKey;

var x: i32 = 320;
var y: i32 = 240;

const Status = enum { PLAYING, GAME_OVER, MENU };
const GameState = struct { hp: u8, status: Status };
const Vector2 = raylib.Vector2;

const Letter = struct { value: [2:0]u8, index: u8, position: Vector2, was_pressed: bool, damage: u8 };
const letter_count = 15;
const font_size = 25;
const screen_width = 640;
const screen_height = 480;

const alphabet = "abcdefghijklmnopqrstuvwxyz";
pub fn main() !void {
    var game_state = GameState{ .status = Status.PLAYING, .hp = 20 };

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

        if (game_state.status == Status.GAME_OVER) {
            raylib.ClearBackground(raylib.DARKBLUE);
            raylib.DrawText("GAME OVER", screen_width / 2, screen_height / 2, font_size, raylib.WHITE);
            raylib.EndDrawing();
            continue;
        }

        for (&letters) |*letter| {
            if (letter.was_pressed) continue;
            if (letter.position.x <= 0.0) {
                game_state.hp -= letter.damage;
                letter.was_pressed = true; // TODO: other flag
            }
            if (game_state.hp <= 0) {
                game_state.status = Status.GAME_OVER;
                break;
            }
            letter.position.x -= 0.11; // TODO: make safe
            if (raylib.IsKeyPressed(letterToKey(letter.value[0]))) {
                letter.was_pressed = true;
                break;
            }
        }

        for (&letters) |*letter| {
            if (letter.was_pressed) continue;
            // raylib.DrawText(&letter.value, letter.x, letter.y, font_size, raylib.WHITE);
            raylib.DrawTextEx(raylib.GetFontDefault(), &letter.value, letter.position, font_size, 0.0, raylib.WHITE);
        }

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
        letter_struct.was_pressed = false;
        letter_struct.damage = 1;
        letter_struct.position.x = screen_width - @intToFloat(f32, font_size);
        letter_struct.position.y = @intToFloat(f32, i * font_size);
    }
}

fn letterToKey(letter: u8) KeyboardKey {
    var result = letter;
    if (result >= 'a' and result <= 'z') {
        result -= 32;
    }
    return @intToEnum(KeyboardKey, result);
}
