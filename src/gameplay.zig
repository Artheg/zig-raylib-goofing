const std = @import("std");

const config = @import("config.zig");
const types = @import("types.zig");
const utils = @import("utils.zig");
const Letter = types.Letter;
const Status = types.Status;
const Model = types.Model;
const Resources = types.Resources;

const raylib = @import("raylib");

var buf: [8]u8 = undefined;
var fba: std.heap.FixedBufferAllocator = std.heap.FixedBufferAllocator.init(&buf);

pub fn on_activated() void {}

pub fn on_deactivated() void {}

pub fn pre_render(model: *Model, resources: Resources) void {
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
            letter.was_killed = true;
            raylib.PlaySound(resources.soundMap.PUNCH_2);
            break;
        }
    }
}

pub fn render(model: Model) !void {
    fba.reset();
    raylib.DrawText(try raylib.TextFormat(fba.allocator(), "HP: {d}", .{model.hp}), 0, 0, config.font_size, raylib.WHITE);
    for (model.letters) |letter| {
        if (letter.was_killed) continue;
        raylib.DrawTextEx(raylib.GetFontDefault(), &letter.value, letter.position, config.font_size, 0.0, raylib.WHITE);
    }
}

pub fn post_render(model: *Model) void {
    const letters = &model.letters;
    const task_complete = for (letters) |letter| {
        if (!letter.was_killed) break false;
    } else true;

    if (task_complete) {
        // model.status = Status.GAME_OVER;
        utils.createRandomLetters(&letters[0..config.letter_count], utils.get_random());
    }
}
