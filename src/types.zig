const raylib = @import("raylib");
const sound = @import("sound.zig");
const config = @import("config.zig");

pub const Status = enum { PLAYING, GAME_OVER, MENU };
pub const GameState = struct {
    hp: u8,
    status: Status,
};

pub const DialogueLine = struct { character: [:0]u8, text: [:0]u8, audio: raylib.Music };

pub const Model = struct { hp: u8, status: Status, letters: [config.letter_count]Letter };

pub const Resources = struct { musicMap: sound.MusicMap, soundMap: sound.SoundMap };

pub const Letter = struct { value: [2:0]u8, index: u8, position: raylib.Vector2, was_killed: bool, damage: u8, speed: f32, is_dead: bool };
