const rl = @import("raylib");
const cnst = @import("constants.zig");

pub const ControlType = enum {
    player,
    ai,
};

pub const Paddle = struct {
    controlType: ControlType,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
    speed: i32,
    ball_y: i32,
    initial_x: i32,
    initial_y: i32,
    score: i32 = 0,

    pub fn init(controlType: ControlType, x: i32, y: i32, width: i32, height: i32, speed: i32) Paddle {
        return Paddle{
            .controlType = controlType,
            .x = x,
            .y = y,
            .width = width,
            .height = height,
            .speed = speed,
            .ball_y = @divFloor(rl.getScreenHeight(), 2),
            .initial_x = x,
            .initial_y = y,
        };
    }

    pub fn draw(self: Paddle) void {
        const paddle_rect = rl.Rectangle{
            .x = @floatFromInt(self.x),
            .y = @floatFromInt(self.y),
            .width = @floatFromInt(self.width),
            .height = @floatFromInt(self.height),
        };
        rl.drawRectangleRounded(paddle_rect, cnst.paddle_roundness, 0, rl.Color.white);
    }

    pub fn update(self: *Paddle) void {
        switch (self.controlType) {
            ControlType.player => self.moveAsPlayer(),
            ControlType.ai => self.moveAsAi(),
        }
    }

    pub fn reset(self: *Paddle) void {
        self.x = self.initial_x;
        self.y = self.initial_y;
    }

    fn moveAsPlayer(self: *Paddle) void {
        if (rl.isKeyDown(rl.KeyboardKey.w) and self.y > 0) {
            self.y -= self.speed;
        }

        if (rl.isKeyDown(rl.KeyboardKey.s) and self.y + self.height < rl.getScreenHeight()) {
            self.y += self.speed;
        }
    }

    fn moveAsAi(self: *Paddle) void {
        if (self.y + @divFloor(self.height, 2) > self.ball_y) {
            self.y -= self.speed;
        } else if (self.y + @divFloor(self.height, 2) < self.ball_y) {
            self.y += self.speed;
        }
    }
};
