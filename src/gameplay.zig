const std = @import("std");

const config = @import("config.zig");
const types = @import("types.zig");
const utils = @import("utils.zig");
const Letter = types.Letter;
const Model = types.Model;
const Resources = types.Resources;

const raylib = @import("raylib");

var fba: std.heap.FixedBufferAllocator = undefined;
var letters: [config.max_letters]Letter = undefined;
var random: std.rand.Random = undefined;

pub fn init() void {
    var prng = std.rand.DefaultPrng.init(@intCast(std.time.nanoTimestamp()));
    random = prng.random();
    var buf: [8]u8 = undefined;
    fba = std.heap.FixedBufferAllocator.init(&buf); // allocators?
    var i: usize = 0;
    while (i < config.max_letters) : (i += 1) {
        letters[i] = std.mem.zeroes(types.Letter);
    }
    // https://www.youtube.com/watch?v=vHWiDx_l4V0
    utils.createRandomLetters(&letters[0..config.letter_count], random);
}

pub fn on_activated() void {}

pub fn on_deactivated() void {}

pub fn pre_render() void {}

pub fn render(model: Model, data: Resources) void {
    _ = data;
    fba.reset();
    std.debug.print("WTF?", .{});
    // raylib.DrawText(try raylib.TextFormat(fba.allocator(), "HP: {d}", .{model.hp}), 0, 0, config.font_size, raylib.WHITE);
    // for (&letters, 0..letters.len) |*letter, idx| {
    //     _ = idx;
    //     // std.debug.print("i {}", .{idx});
    //     if (letter.was_killed) continue;
    //     if (letter.position.x <= 0.0) {
    //         model.hp -= letter.damage;
    //         letter.was_killed = true; // TODO: other flag
    //     }
    //     if (model.hp <= 0) {
    //         model.status = types.Status.GAME_OVER;
    //         break;
    //     }
    //     letter.position.x -= letter.speed; // TODO: make safe
    //     if (raylib.IsKeyPressed(utils.letterToKey(letter.value[0]))) { // TODO: check if 'nearest'
    //         letter.was_killed = true;
    //         raylib.PlaySound(data.soundMap.PUNCH_2);
    //         break;
    //     }
    // }
    for (model.letters) |letter| {
        if (letter.was_killed) continue; // raylib.DrawText(&letter.value, letter.x, letter.y, font_size, raylib.WHITE);
        raylib.DrawTextEx(raylib.GetFontDefault(), &letter.value, letter.position, config.font_size, 0.0, raylib.WHITE);
    }
}

pub fn post_render() void {
    const task_complete = for (letters) |letter| {
        if (!letter.was_killed) break false;
    } else true;

    if (task_complete) {
        utils.createRandomLetters(&letters[0..config.letter_count], random);
    }
}
