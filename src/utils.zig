const raylib = @import("raylib");
const std = @import("std");
const types = @import("types.zig");
const config = @import("config.zig");

pub fn createRandomLetters(letters: *[]const types.Letter, random: std.rand.Random) void {
    for (letters, 0..letters.len) |*letter_struct, i| {
        const letter_index = random.uintAtMost(u8, config.alphabet.len - 1);
        const str = [2:0]u8{ config.alphabet[letter_index], 0 };
        letter_struct.value = str;
        letter_struct.index = letter_index;
        letter_struct.was_killed = false;
        letter_struct.damage = 1;
        letter_struct.position.x = config.screen_width - @intToFloat(f32, config.font_size);
        letter_struct.position.y = @intToFloat(f32, i * config.font_size);
        letter_struct.speed = random.float(f32) * 0.01;
    }
}

pub fn letterToKey(letter: u8) raylib.KeyboardKey {
    var result = letter;
    if (result >= 'a' and result <= 'z') {
        result -= 32;
    }
    return @intToEnum(raylib.KeyboardKey, result);
}
