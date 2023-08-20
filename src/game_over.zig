const raylib = @import("raylib");
const config = @import("config.zig");

pub fn render() void {
    raylib.ClearBackground(raylib.DARKBLUE);
    raylib.DrawText("GAME OVER", config.screen_width / 2, config.screen_height / 2, config.font_size, raylib.WHITE);
}
