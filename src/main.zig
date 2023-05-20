const std = @import("std");

const raylib = @import("raylib");
const KeyboardKey = raylib.KeyboardKey;

var x: i32 = 320;
var y: i32 = 240;

const Status = enum { PLAYING, GAME_OVER, MENU };
const GameState = struct { hp: u8, status: Status };
const Vector2 = raylib.Vector2;

const Letter = struct { value: [2:0]u8, index: u8, position: Vector2, was_killed: bool, damage: u8, speed: f32, is_dead: bool };
const letter_count = 15;
const font_size = 25; // TODO: font_size must be relative to aspect ratio
const screen_width = 1280;
const screen_height = 720;

const alphabet = "abcdefghijklmnopqrstuvwxyz";
pub fn main() !void {
    var game_state = GameState{ .status = Status.PLAYING, .hp = 200 };

    var prng = std.rand.DefaultPrng.init(@intCast(u64, std.time.nanoTimestamp()));
    const random = prng.random();

    raylib.InitAudioDevice();
    raylib.InitWindow(screen_width, screen_width, "__MF");
    raylib.SetWindowPosition(740, 850);

    var i: usize = 0;
    var letters: [letter_count]Letter = undefined;
    while (i < letter_count) : (i += 1) {
        letters[i] = std.mem.zeroes(Letter);
    }
    var buf: [8]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf); // allocators?
    // https://www.youtube.com/watch?v=vHWiDx_l4V0
    createRandomLetters(&letters, random);
    const punchSound = raylib.LoadSound("assets/sounds/punch_2.mp3");
    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();

        fba.reset();
        raylib.DrawText(try raylib.TextFormat(fba.allocator(), "HP: {d}", .{game_state.hp}), 0, 0, font_size, raylib.WHITE);

        if (game_state.status == Status.GAME_OVER) {
            raylib.ClearBackground(raylib.DARKBLUE);
            raylib.DrawText("GAME OVER", screen_width / 2, screen_height / 2, font_size, raylib.WHITE);
            raylib.EndDrawing();
            continue;
        }

        for (&letters) |*letter| {
            if (letter.was_killed) continue;
            if (letter.position.x <= 0.0) {
                game_state.hp -= letter.damage;
                letter.was_killed = true; // TODO: other flag
            }
            if (game_state.hp <= 0) {
                game_state.status = Status.GAME_OVER;
                break;
            }
            letter.position.x -= letter.speed; // TODO: make safe
            if (raylib.IsKeyPressed(letterToKey(letter.value[0]))) { // TODO: check if 'nearest'
                letter.was_killed = true;
                raylib.PlaySound(punchSound);
                break;
            }
        }

        for (&letters) |*letter| {
            if (letter.was_killed) continue;
            // raylib.DrawText(&letter.value, letter.x, letter.y, font_size, raylib.WHITE);
            raylib.DrawTextEx(raylib.GetFontDefault(), &letter.value, letter.position, font_size, 0.0, raylib.WHITE);
        }

        raylib.ClearBackground(raylib.DARKBLUE);
        raylib.EndDrawing();

        const task_complete = for (letters) |letter| {
            if (!letter.was_killed) break false;
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
        letter_struct.was_killed = false;
        letter_struct.damage = 1;
        letter_struct.position.x = screen_width - @intToFloat(f32, font_size);
        letter_struct.position.y = @intToFloat(f32, i * font_size);
        letter_struct.speed = random.float(f32) * 0.01;
    }
}

fn letterToKey(letter: u8) KeyboardKey {
    var result = letter;
    if (result >= 'a' and result <= 'z') {
        result -= 32;
    }
    return @intToEnum(KeyboardKey, result);
}
