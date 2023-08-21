import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local dx = 0
local dy = 0
local rot = 0

class("Paddle").extends(gfx.sprite)

function Paddle:init(x, y)
    local paddle = gfx.image.new('images/PaddleSprite')
    Paddle.super.init(self)
    self:setImage(paddle)
    self:moveTo(x, y)
    self:setCollideRect(-8, 0, 10, 64)
    self.__name = "Paddle"
end

function Paddle:move()
    if (pd.buttonIsPressed(pd.kButtonDown)) then
		if self.y > 212 then
			self:moveTo(self.x, 212)
		else
			self:moveBy(0, 5)
		end
	end
	if (pd.buttonIsPressed(pd.kButtonUp)) then
		if self.y < 20 then
			self:moveTo(self.x, 20)
		else
			self:moveBy(0, -5)
		end
	end
end