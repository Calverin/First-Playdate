--[[ UNUSED
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
        -- Cycle through each line in the polygon
		local j = (i + 2) % (collisionPolygon:count()) + 1
        --gfx.drawLine(collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
        -- Get all colliding sprites and check if it is the ball
        local sprites = gfx.sprite.querySpritesAlongLine(collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
        if sprites == nil then return end
        for k = 1, #sprites do
            if sprites[k]:isa(Ball) then
                sprites[k].dx = sprites[k].dx * -1
                sprites[k].dy = sprites[k].dy * -1
            end
        end
    end
end]]