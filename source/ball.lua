import "CoreLibs/sprites"

--import "paddle"

local pd <const> = playdate
local gfx <const> = pd.graphics

local vel
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
    self.vel = pd.geometry.vector2D.new(dx, dy)
end

function Ball:update()
    if self.y <= 5 or self.y >= 235  then
        self.vel.dy = -self.vel.dy
    end
    if self.x <= 5 or self.x >= 395 then
        self.vel.dx = -self.vel.dx
    end
    --self.vel.dx = self.vel.dx * speed
    --self.vel.dy = self.vel.dy * speed
    --speed = speed * 1.000001
    if self.vel.dx > maxSpeed then
        self.vel.dx = maxSpeed
    end
    if self.vel.dy > maxSpeed then
        self.vel.dy = maxSpeed
    end
    self:moveWithCollisions(self.x + self.vel.dx, self.y + self.vel.dy)
end

function Ball:collisionResponse(other)
    if other:isa(Paddle) then
        -- Bounce off the paddle_segment
        --local vx = math.cos(other:getPaddleRot()) * 2
        --local vy = math.sin(other:getPaddleRot()) * 2
        --print(vx, vy)
        --self.vel.dx = vx
        --self.vel.dy = vy
        if collisionCooldown <= 0 then
            if other:checkLineCollision(self) then
                collisionCooldown = 20
            end
        else
            collisionCooldown -= 1
        end
        return "overlap"
    else
        return "overlap"
    end
end