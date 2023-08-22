import "CoreLibs/sprites"

--import "paddle"

local pd <const> = playdate
local gfx <const> = pd.graphics

local dx = 0
local dy = 0
local speed = 1.000001
local maxSpeed = 16
local collisionCooldown = 0

class("Ball").extends(gfx.sprite)

function Ball:init(x, y, dx, dy)
    local img = gfx.image.new("images/BallSprite")
    Ball.super.init(self)
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(1)
    self:setCollidesWithGroups(1)
    self.dx = dx
    self.dy = dy
end

function Ball:update()
    if self.y <= 5 or self.y >= 235  then
        self.dy = -self.dy
    end
    if self.x <= 5 or self.x >= 395 then
        self.dx = -self.dx
    end
    --self.dx = self.dx * speed
    --self.dy = self.dy * speed
    --speed = speed * 1.000001
    if self.dx > maxSpeed then
        self.dx = maxSpeed
    end
    if self.dy > maxSpeed then
        self.dy = maxSpeed
    end
    self:moveWithCollisions(self.x + self.dx, self.y + self.dy)
end

function Ball:collisionResponse(other)
    if other:isa(Paddle) then
        -- Bounce off the paddle_segment
        --local vx = math.cos(other:getPaddleRot()) * 2
        --local vy = math.sin(other:getPaddleRot()) * 2
        --print(vx, vy)
        --self.dx = vx
        --self.dy = vy
        if collisionCooldown <= 0 then
            if other:checkLineCollision(self) then
                collisionCooldown = 10
            end
        else
            collisionCooldown -= 1
        end
        return "overlap"
    else
        return "overlap"
    end
end