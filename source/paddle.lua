import "CoreLibs/sprites"

import "paddle_segment"

local pd <const> = playdate
local gfx <const> = pd.graphics

local dx = 0
local dy = 0
local speed = 0.5
local maxSpeed = 8
local rot = 0
local rotSpeed = 5
local segments = {}

class("Paddle").extends(gfx.sprite)

function Paddle:init(x, y)
    local img = gfx.image.new("")--gfx.image.new("images/PaddleSprite")
    Paddle.super.init(self)
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, 8, 64)
    Paddle.collisionResponse = "slide"
    self:setGroups(1)
    self:setCollidesWithGroups(1)
    
    -- Creating the segments
    for i = 1, 8 do
        segments[i] = PaddleSegment(0, 0, self) -- Passes in the paddle to the segment
        segments[i]:add()
    end
end

function Paddle:update()
    -- Moving the paddle
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

    -- Rotating the paddle
    if (pd.isCrankDocked()) then
        rot += pd.buttonIsPressed(pd.kButtonA) and rotSpeed or pd.buttonIsPressed(pd.kButtonB) and -rotSpeed or 0
    else
        rot = pd.getCrankPosition() or 0
    end

    -- Updating the paddle
    self:setRotation(rot)
    self:moveWithCollisions(self.x + dx, self.y + dy)
    dx *= 0.9
    dy *= 0.9

    -- Updating the segments
    local segmentWidth = 8
    for i = 1, 8 do
        segments[i]:moveTo(self.x + segmentWidth * (i - 4.5) * math.cos(math.rad(rot) + math.pi / 2), self.y + segmentWidth * (i - 4.5) * math.sin(math.rad(rot) + math.pi / 2))
    end
end

function Paddle:getRot()
    return math.rad(rot) - math.pi / 2
end

function Paddle:getFullCollisionRect() -- Returns a polygon of the paddle's collision rect rotated to the paddle's rotation
    local collisionRect = self:getCollideRect()
    local polygon = collisionRect:toPolygon()
    local transform = pd.geometry.affineTransform.new()
    transform:translate(self.x, self.y - 32)
	transform:rotate(rot, self.x + collisionRect.width / 2, self.y - 32 + collisionRect.height / 2)
	local rotatedPolygon = transform:transformedPolygon(polygon)
    return rotatedPolygon
end