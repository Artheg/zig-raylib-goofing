const raylib = @import("raylib");
const types = @import("types.zig");
const DialogueLine = types.DialogueLine;

pub const Level = struct { title: []u8, music: raylib.Music, dialogues: []types.DialogueLine };

pub fn loadLevels(data: types.Data) []Level {
    return {
        Level{ .title = "Level 1", .music = data.musicMap.LVL_01, .dialogues = {
            DialogueLine{
                .character = "____",
                .text = "_",
                .audio = data.musicMap.LVL_01,
            };
        } };
    };
}
