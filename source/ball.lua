import "CoreLibs/sprites"

--import "paddle"

local pd <const> = playdate
local gfx <const> = pd.graphics

local dx = 0
local dy = 0
local speed = 1.000001

class("Ball").extends(gfx.sprite)

function Ball:init(x, y, dx, dy)
    local img = gfx.image.new("images/BallSprite")
    Ball.super.init(self)
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(2)
    self:setCollidesWithGroups(2)
    self.dx = dx
    self.dy = dy
end

function Ball:update()
    if self.y <= 2 or self.y >= 238  then
        self.dy = -self.dy
    end
    if self.x > 395 then
        self.dx = -self.dx
    end
    self.dx = self.dx * speed
    self.dy = self.dy * speed
    speed = speed * 1.000001
    self:moveWithCollisions(self.x + self.dx, self.y + self.dy)
end

function Ball:collisionResponse(other)
    if other:isa(PaddleSegment) then
        -- Bounce off the paddle_segment
        
        return "bounce"
    else
        return "overlap"
    end
end