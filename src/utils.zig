const raylib = @import("raylib");
const std = @import("std");
const types = @import("types.zig");
const config = @import("config.zig");

pub fn createRandomLetters(letters: *const *[config.letter_count]types.Letter, random: std.rand.Random) void {
    var i: usize = 0;
    while (i < letters.*.len) : (i += 1) {
        const alphabet_index = random.uintAtMost(u8, config.alphabet.len - 1);
        const str = [2:0]u8{ config.alphabet[alphabet_index], 0 };
        const letter_struct = &letters.*[i];
        letter_struct.value = str;
        letter_struct.index = alphabet_index;
        letter_struct.was_killed = false;
        letter_struct.damage = 1;
        const font_size: f32 = @floatFromInt(config.font_size);
        letter_struct.position.x = config.screen_width - font_size;
        const pos_y: f32 = @floatFromInt(i * config.font_size);
        letter_struct.position.y = pos_y;
        letter_struct.speed = random.float(f32) * 0.01;
    }
}

pub fn letterToKey(letter: u8) raylib.KeyboardKey {
    var result = letter;
    if (result >= 'a' and result <= 'z') {
        result -= 32;
    }
    return @enumFromInt(result);
}
