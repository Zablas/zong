const std = @import("std");
const rl = @import("raylib");
const cnst = @import("constants.zig");
const bl = @import("ball.zig");
const pd = @import("paddle.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Starting Zong!\n", .{});

    rl.initWindow(cnst.screen_width, cnst.screen_height, "Zong");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    var player = pd.Paddle.init(
        pd.ControlType.player,
        10,
        cnst.screen_height / 2 - cnst.paddle_height / 2,
        cnst.paddle_width,
        cnst.paddle_height,
        cnst.paddle_speed,
    );
    var ai = pd.Paddle.init(
        pd.ControlType.ai,
        cnst.screen_width - cnst.paddle_width - 10,
        cnst.screen_height / 2 - cnst.paddle_height / 2,
        cnst.paddle_width,
        cnst.paddle_height,
        cnst.paddle_speed,
    );
    var ball = bl.Ball.init(
        cnst.screen_width / 2,
        cnst.screen_height / 2,
        cnst.ball_radius,
        cnst.ball_speed_x,
        cnst.ball_speed_y,
        &player,
        &ai,
    );

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(cnst.dark_green);
        rl.drawRectangle(cnst.screen_width / 2, 0, cnst.screen_width / 2, cnst.screen_height, cnst.green);
        rl.drawCircle(cnst.screen_width / 2, cnst.screen_height / 2, cnst.cosmetic_sphere_radius, cnst.light_green);
        rl.drawLine(cnst.screen_width / 2, 0, cnst.screen_width / 2, cnst.screen_height, rl.Color.white);

        ball.draw();
        ball.move();

        player.draw();
        player.update();

        ai.ball_y = ball.y;
        ai.draw();
        ai.update();

        const ball_coords = rl.Vector2{
            .x = @floatFromInt(ball.x),
            .y = @floatFromInt(ball.y),
        };
        const player_rect = rl.Rectangle{
            .x = @floatFromInt(player.x),
            .y = @floatFromInt(player.y),
            .width = @floatFromInt(player.width),
            .height = @floatFromInt(player.height),
        };
        const ai_rect = rl.Rectangle{
            .x = @floatFromInt(ai.x),
            .y = @floatFromInt(ai.y),
            .width = @floatFromInt(ai.width),
            .height = @floatFromInt(ai.height),
        };

        if (rl.checkCollisionCircleRec(ball_coords, @floatFromInt(ball.radius), player_rect)) {
            ball.speed_x *= -1;
        } else if (rl.checkCollisionCircleRec(ball_coords, @floatFromInt(ball.radius), ai_rect)) {
            ball.speed_x *= -1;
        }

        rl.drawText(rl.textFormat("%i", .{player.score}), cnst.screen_width / 4 - 20, cnst.text_y, cnst.text_font_size, rl.Color.white);
        rl.drawText(rl.textFormat("%i", .{ai.score}), 3 * cnst.screen_width / 4 - 20, cnst.text_y, cnst.text_font_size, rl.Color.white);
    }
}
