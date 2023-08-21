import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local dx = 0
local dy = 0
local speed = 1.000001

class("Ball").extends(gfx.sprite)

function Ball:init(x, y, dx, dy)
    local ball = gfx.image.new('images/BallSprite')
    Ball.super.init(self)
    self:setImage(ball)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self.dx = dx
    self.dy = dy
    self.__name = "Ball"
end

function Ball:move()
    self:moveBy(self.dx, self.dy)
    if self.y <= 2 or self.y >= 238  then
        self.dy = -self.dy
    end
    if #self:overlappingSprites() > 0 or self.x > 395 then
        self.dx = -self.dx
    end
    self.dx = self.dx * speed
    self.dy = self.dy * speed
    speed = speed * 1.000001
end