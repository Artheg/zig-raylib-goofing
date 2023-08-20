const std = @import("std");
const raylib = @import("raylib");

pub const SoundMap = struct { PUNCH: raylib.Sound, PUNCH_2: raylib.Sound };
pub const MusicMap = struct { LVL_01: raylib.Music };

pub fn loadSounds() SoundMap {
    return .{ .PUNCH = raylib.LoadSound("assets/sounds/punch_2.mp3"), .PUNCH_2 = raylib.LoadSound("assets/sounds/punch.mp3") };
}

pub fn loadMusic() MusicMap {
    return .{ .LVL_01 = raylib.LoadMusicStream("assets/music/lvl_01.mp3") };
}
