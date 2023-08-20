const std = @import("std");

const raylib = @import("raylib");

const gameplay = @import("gameplay.zig");
const game_over = @import("game_over.zig");

const utils = @import("utils.zig");

const types = @import("types.zig");
const Status = types.Status;
const Letter = types.Letter;
const Resources = types.Resources;
const Model = types.Model;

const config = @import("config.zig");
const sound = @import("sound.zig");
const KeyboardKey = raylib.KeyboardKey;

var x: i32 = 320;
var y: i32 = 240;

const Vector2 = raylib.Vector2;

var model: Model = std.mem.zeroes(Model);

pub fn main() !void {
    gameplay.init();
    init_model();

    raylib.InitWindow(config.screen_width, config.screen_width, "__MF");
    raylib.SetWindowPosition(740, 850);

    raylib.InitAudioDevice();
    const resources = Resources{ .musicMap = sound.loadMusic(), .soundMap = sound.loadSounds() };

    raylib.PlayMusicStream(resources.musicMap.LVL_01);

    while (!raylib.WindowShouldClose()) {
        update_model();
        switch (model.status) {
            Status.PLAYING => gameplay.pre_render(),
            else => noop(model.status),
        }

        raylib.BeginDrawing();
        // gameplay.render();
        raylib.ClearBackground(raylib.BLACK);
        switch (model.status) {
            Status.GAME_OVER => game_over.render(),
            Status.PLAYING => gameplay.render(model, resources),
            Status.MENU => game_over.render(),
        }
        raylib.EndDrawing();

        switch (model.status) {
            Status.PLAYING => gameplay.post_render(),
            else => noop(model.status),
        }
    }
    raylib.CloseWindow();
}

fn init_model() void {
    model.hp = 200;
    model.status = Status.PLAYING;
    var prng = std.rand.DefaultPrng.init(@intCast(std.time.nanoTimestamp()));
    var random = prng.random();
    var i: usize = 0;
    model.letters = std.mem.zeroes([config.letter_count]types.Letter);
    while (i < config.letter_count) : (i += 1) {
        model.letters[i] = std.mem.zeroes(types.Letter);
    }
    // https://www.youtube.com/watch?v=vHWiDx_l4V0
    utils.createRandomLetters(&model.letters[0..config.letter_count], random);
}

fn update_model() void {
    const letters = &model.letters;
    for (letters) |*letter| {
        // std.debug.print("i {}", .{idx});
        if (letter.was_killed) continue;
        if (letter.position.x <= 0.0) {
            model.hp -= letter.damage;
            letter.was_killed = true; // TODO: other flag
        }
        if (model.hp <= 0) {
            model.status = Status.GAME_OVER;
            break;
        }

        letter.position.x -= letter.speed;
        if (raylib.IsKeyPressed(utils.letterToKey(letter.value[0]))) { // TODO: check if 'nearest'
            // letter.was_killed = true;
            // raylib.PlaySound(data.soundMap.PUNCH_2);
            break;
        }
    }
}

fn noop(status: Status) void {
    std.debug.print("Status: {}", .{status});
}

fn switchGameState(status: Status) void {
    std.debug.print("Change status to: {}", .{status});
}
