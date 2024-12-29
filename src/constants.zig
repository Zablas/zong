const rl = @import("raylib");

pub const screen_width = 1280;
pub const screen_height = 800;

pub const paddle_width = 25;
pub const paddle_height = 120;
pub const paddle_speed = 6;
pub const paddle_roundness = 0.8;

pub const ball_speed_x = 7;
pub const ball_speed_y = 7;
pub const ball_radius = 20;

pub const text_font_size = 80;
pub const text_y = 20;

pub const green = rl.Color{ .r = 38, .g = 185, .b = 154, .a = 255 };
pub const dark_green = rl.Color{ .r = 20, .g = 160, .b = 133, .a = 255 };
pub const light_green = rl.Color{ .r = 129, .g = 204, .b = 184, .a = 255 };
pub const yellow = rl.Color{ .r = 243, .g = 213, .b = 91, .a = 255 };

pub const cosmetic_sphere_radius = 150;
