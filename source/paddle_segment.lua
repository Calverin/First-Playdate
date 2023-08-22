import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("PaddleSegment").extends(gfx.sprite)

function PaddleSegment:init(x, y)
    local img = gfx.image.new("images/PaddleSegment")
    PaddleSegment.super.init(self)
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, 8, 8)
    self:setGroups(2)
    self:setCollidesWithGroups(2)
    PaddleSegment.collisionResponse = "slide"
end