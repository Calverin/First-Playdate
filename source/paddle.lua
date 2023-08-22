import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local dx = 0
local dy = 0
local speed = 0.5
local maxSpeed = 8
local rot = 0
local rotSpeed = 5

class("Paddle").extends(gfx.sprite)

function Paddle:init(x, y)
    local img = gfx.image.new("images/PaddleSprite") --gfx.image.new("")
    Paddle.super.init(self)
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, 64, 64)
    Paddle.collisionResponse = "overlap"
    self:setGroups(1)
    self:setCollidesWithGroups(1)
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

    --[[ Updating the segments
    local segmentWidth = 8
    for i = 1, 8 do
        segments[i]:moveTo(self.x + segmentWidth * (i - 4.5) * math.cos(math.rad(rot) + math.pi / 2), self.y + segmentWidth * (i - 4.5) * math.sin(math.rad(rot) + math.pi / 2))
    end ]]
end

function Paddle:getRot()
    return math.rad(rot) - math.pi / 2
end

function Paddle:getFullCollisionRect() -- Returns a polygon of the paddle's collision rect rotated to the paddle's rotation
    local collisionRect = pd.geometry.rect.new(0, 0, 8, 64) --self:getCollideRect()
    local polygon = collisionRect:toPolygon()
    local transform = pd.geometry.affineTransform.new()
    transform:translate(self.x - 4, self.y - 32)
	transform:rotate(rot, self.x - 4 + collisionRect.width / 2, self.y - 32 + collisionRect.height / 2)
	local rotatedPolygon = transform:transformedPolygon(polygon)
    return rotatedPolygon
end

function Paddle:checkLineCollision(other)
    local collisionPolygon = self:getFullCollisionRect()
    for i = 1, collisionPolygon:count() do
        -- Cycle through each line in the polygon
		local j = (i + 2) % (collisionPolygon:count()) + 1
        -- Get all colliding sprites and check if it is the ball
        local sprites = gfx.sprite.querySpriteInfoAlongLine(collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
        --[[if sprites ~= nil and sprites[other] ~= nil then
            print("Collision! AHHAAHHHAHAHAHAHAHAHA")
        end]]
        if sprites == nil then return end
        for k = 1, #sprites do
            if sprites[k].sprite == other then
                self:bounce(other, sprites[k].entryPoint, collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
                return true
            end
        end
    end
    return false
end

function Paddle:bounce(other, intersection, x1, y1, x2, y2)
    local normY = x2 - x1
    local normX = y1 - y2
    local normLength = math.sqrt((normX * normX) + (normY * normY))
    normX /= normLength
    normY /= normLength

    local bx = other.x + other.dx - intersection.x
    local by = other.y + other.dy - intersection.y
    local dot = (bx * normX) + (by * normY)

    local dotNormX = dot * normX
    local dotNormY = dot * normY

    --other.dx += 2 * dotNormX
    --other.dy += 2 * dotNormY
    other.dx = bx + (dotNormX)
    other.dy = by + (dotNormY)
end