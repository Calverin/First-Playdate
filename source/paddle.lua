import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local dx = 0
local dy = 0
local speed = 0.5
local maxSpeed = 8
local rot

class("Paddle").extends(gfx.sprite)

function Paddle:init(x, y)
    local paddle = gfx.image.new("images/PaddleSprite")
    Paddle.super.init(self)
    self:setImage(paddle)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    Paddle.collisionResponse = "slide"
end

function Paddle:update()
    if (pd.buttonIsPressed(pd.kButtonDown)) then
        dy = math.min(maxSpeed, dy + speed)
	end
	if (pd.buttonIsPressed(pd.kButtonUp)) then
        dy = math.max(-maxSpeed, dy - speed)
	end
    if (pd.buttonIsPressed(pd.kButtonLeft)) then
        dx = math.max(-maxSpeed, dx - speed)
    end
    if (pd.buttonIsPressed(pd.kButtonRight)) then
        dx = math.min(maxSpeed, dx + speed)
    end
    rot = pd.getCrankPosition()
    --self:setRotation(rot)
    self:moveWithCollisions(self.x + dx, self.y + dy)
    dx *= 0.9
    dy *= 0.9
end