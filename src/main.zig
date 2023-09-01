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
const audio = @import("sound.zig");
const KeyboardKey = raylib.KeyboardKey;

var x: i32 = 320;
var y: i32 = 240;

const Vector2 = raylib.Vector2;

var model: Model = std.mem.zeroes(Model);

pub fn main() !void {
    init_model();

    raylib.InitWindow(config.screen_width, config.screen_width, "__MF");
    raylib.SetWindowPosition(740, 850);

    raylib.InitAudioDevice();
    const resources = Resources{ .musicMap = audio.loadMusic(), .soundMap = audio.loadSounds() };

    raylib.PlayMusicStream(resources.musicMap.LVL_01);

    while (!raylib.WindowShouldClose()) {
        switch (model.status) {
            Status.PLAYING => gameplay.pre_render(&model, resources),
            else => noop(model.status),
        }

        raylib.UpdateMusicStream(resources.musicMap.LVL_01);
        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.BLACK);
        try switch (model.status) {
            Status.GAME_OVER => game_over.render(),
            Status.PLAYING => gameplay.render(model),
            Status.MENU => game_over.render(),
        };
        raylib.EndDrawing();
        model.changeStatus(Status.GAME_OVER);

        switch (model.status) {
            Status.PLAYING => gameplay.post_render(&model),
            else => noop(model.status),
        }
    }
    raylib.CloseWindow();
}

fn init_model() void {
    model.hp = config.max_hp;
    model.status = Status.PLAYING;

    var i: usize = 0;
    model.letters = std.mem.zeroes([config.letter_count]types.Letter);
    while (i < config.letter_count) : (i += 1) {
        model.letters[i] = std.mem.zeroes(types.Letter);
    }
    // https://www.youtube.com/watch?v=vHWiDx_l4V0
    utils.createRandomLetters(&model.letters[0..config.letter_count], utils.get_random());
}

fn noop(status: Status) void {
    std.debug.print("Status: {}\n", .{status});
}

fn switchGameState(status: Status) void {
    std.debug.print("Change status to: {}", .{status});
}
