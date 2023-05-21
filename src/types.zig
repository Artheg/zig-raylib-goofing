const raylib = @import("raylib");

pub const Letter = struct { value: [2:0]u8, index: u8, position: raylib.Vector2, was_killed: bool, damage: u8, speed: f32, is_dead: bool };
