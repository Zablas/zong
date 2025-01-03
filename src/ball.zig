const rl = @import("raylib");
const cnst = @import("constants.zig");
const Paddle = @import("paddle.zig").Paddle;

pub const Ball = struct {
    x: i32,
    y: i32,
    radius: i32,
    speed_x: i32,
    speed_y: i32,
    player: *Paddle,
    ai: *Paddle,

    pub fn init(x: i32, y: i32, radius: i32, speed_x: i32, speed_y: i32, player: *Paddle, ai: *Paddle) Ball {
        var ball = Ball{
            .x = x,
            .y = y,
            .radius = radius,
            .speed_x = speed_x,
            .speed_y = speed_y,
            .player = player,
            .ai = ai,
        };
        ball.reset();
        return ball;
    }

    pub fn draw(self: Ball) void {
        rl.drawCircle(self.x, self.y, @floatFromInt(self.radius), cnst.yellow);
    }

    pub fn move(self: *Ball) void {
        self.x += self.speed_x;
        self.y += self.speed_y;

        if (self.y + self.radius >= rl.getScreenHeight() or self.y - self.radius <= 0) {
            self.speed_y *= -1;
        } else if (self.x + self.radius >= rl.getScreenWidth() or self.x - self.radius <= 0) {
            self.speed_x *= -1;
        }

        if (self.x + self.radius >= rl.getScreenWidth()) {
            self.reset();
            self.player.score += 1;
        } else if (self.x - self.radius <= 0) {
            self.reset();
            self.ai.score += 1;
        }
    }

    fn reset(self: *Ball) void {
        self.x = @divFloor(rl.getScreenWidth(), 2);
        self.y = @divFloor(rl.getScreenHeight(), 2);

        const directions = [2]i32{ -1, 1 };
        self.speed_x *= directions[@intCast(rl.getRandomValue(0, 1))];
        self.speed_y *= directions[@intCast(rl.getRandomValue(0, 1))];

        self.player.reset();
        self.ai.reset();
    }
};
