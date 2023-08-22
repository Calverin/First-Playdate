import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("PaddleSegment").extends(gfx.sprite)

local paddle = nil

function PaddleSegment:init(x, y, p)
    local img = gfx.image.new("")
    PaddleSegment.super.init(self)
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, 8, 8)
    self:setGroups(2)
    self:setCollidesWithGroups(2)
    PaddleSegment.collisionResponse = "slide"
    self.paddle = p
end

function PaddleSegment:getPaddleRot()
    return self.paddle:getRotation()
end

function PaddleSegment:checkLineCollision(other)
    local collisionPolygon = self.paddle:getFullCollisionRect()
    for i = 1, collisionPolygon:count() do
        print(collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y)
    end
end