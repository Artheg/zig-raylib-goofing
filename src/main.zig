const std = @import("std");

const raylib = @import("raylib");
const utils = @import("utils.zig");
const types = @import("types.zig");
const config = @import("config.zig");
const KeyboardKey = raylib.KeyboardKey;

var x: i32 = 320;
var y: i32 = 240;

const Status = enum { PLAYING, GAME_OVER, MENU };
const GameState = struct {
    hp: u8,
    status: Status,
    pub fn render() void {
        std.debug.print("RENDER", .{});
    }
};
const Vector2 = raylib.Vector2;

const letter_count = 15;

pub fn main() !void {
    var game_state = GameState{ .status = Status.PLAYING, .hp = 200 };

    var prng = std.rand.DefaultPrng.init(@intCast(u64, std.time.nanoTimestamp()));
    const random = prng.random();

    raylib.InitAudioDevice();
    raylib.InitWindow(config.screen_width, config.screen_width, "__MF");
    raylib.SetWindowPosition(740, 850);

    var i: usize = 0;
    var letters: [letter_count]types.Letter = undefined;
    while (i < letter_count) : (i += 1) {
        letters[i] = std.mem.zeroes(types.Letter);
    }
    var buf: [8]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf); // allocators?
    // https://www.youtube.com/watch?v=vHWiDx_l4V0
    utils.createRandomLetters(&letters, random);
    const punchSound = raylib.LoadSound("assets/sounds/punch_2.mp3");
    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();

        fba.reset();
        raylib.DrawText(try raylib.TextFormat(fba.allocator(), "HP: {d}", .{game_state.hp}), 0, 0, config.font_size, raylib.WHITE);

        if (game_state.status == Status.GAME_OVER) {
            raylib.ClearBackground(raylib.DARKBLUE);
            raylib.DrawText("GAME OVER", config.screen_width / 2, config.screen_height / 2, config.font_size, raylib.WHITE);
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
            if (raylib.IsKeyPressed(utils.letterToKey(letter.value[0]))) { // TODO: check if 'nearest'
                letter.was_killed = true;
                raylib.PlaySound(punchSound);
                break;
            }
        }

        for (&letters) |*letter| {
            if (letter.was_killed) continue;
            // raylib.DrawText(&letter.value, letter.x, letter.y, font_size, raylib.WHITE);
            raylib.DrawTextEx(raylib.GetFontDefault(), &letter.value, letter.position, config.font_size, 0.0, raylib.WHITE);
        }

        raylib.ClearBackground(raylib.DARKBLUE);
        raylib.EndDrawing();

        const task_complete = for (letters) |letter| {
            if (!letter.was_killed) break false;
        } else true;
        if (task_complete) {
            utils.createRandomLetters(&letters, random);
        }
    }
    raylib.CloseWindow();
}

fn switchGameState(status: Status) void {
    std.debug.print("Change status to: {}", .{status});
}
