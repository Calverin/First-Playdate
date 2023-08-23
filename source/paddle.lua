import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local vel
local speed = 0.5
local maxSpeed = 8
local rot = 0
local rotSpeed = 5
local end1
local end2

class("Paddle").extends(gfx.sprite)

function Paddle:init(x, y)
    local img = gfx.image.new("images/PaddleSprite") --gfx.image.new("")
    Paddle.super.init(self)
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(-32, -32, 128, 128)
    Paddle.collisionResponse = "overlap"
    self:setGroups(1)
    self:setCollidesWithGroups(1)
    self.vel = pd.geometry.vector2D.new(0, 0)
    self.end1 = pd.geometry.point.new(0, 0)
    self.end2 = pd.geometry.point.new(0, 0)
end

function Paddle:update()
    -- Moving the paddle
    if (pd.buttonIsPressed(pd.kButtonDown)) then
        self.vel.dy = math.min(maxSpeed, self.vel.dy + speed)
	end
	if (pd.buttonIsPressed(pd.kButtonUp)) then
        self.vel.dy = math.max(-maxSpeed, self.vel.dy - speed)
	end
    if (pd.buttonIsPressed(pd.kButtonLeft)) then
        self.vel.dx = math.max(-maxSpeed, self.vel.dx - speed)
    end
    if (pd.buttonIsPressed(pd.kButtonRight)) then
        self.vel.dx = math.min(maxSpeed, self.vel.dx + speed)
    end

    -- Rotating the paddle
    if (pd.isCrankDocked()) then
        rot += pd.buttonIsPressed(pd.kButtonA) and rotSpeed or pd.buttonIsPressed(pd.kButtonB) and -rotSpeed or 0
    else
        rot = pd.getCrankPosition() or 0
    end

    -- Updating the paddle
    self:setRotation(rot)
    self:moveWithCollisions(self.x + self.vel.dx, self.y + self.vel.dy)
    self.vel.dx *= 0.9
    self.vel.dy *= 0.9

    self.end1.x = self.x - 32 * math.cos(math.rad(rot) + math.pi / 2)
    self.end1.y = self.y - 32 * math.sin(math.rad(rot) + math.pi / 2)
    self.end2.x = self.x + 32 * math.cos(math.rad(rot) + math.pi / 2)
    self.end2.y = self.y + 32 * math.sin(math.rad(rot) + math.pi / 2)
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
    local collisionRect = pd.geometry.rect.new(0, 0, 16, 64) --self:getCollideRect()
    local polygon = collisionRect:toPolygon()
    local transform = pd.geometry.affineTransform.new()
    transform:translate(self.x - 8, self.y - 32)
	transform:rotate(rot, self.x - 8 + collisionRect.width / 2, self.y - 32 + collisionRect.height / 2)
	local rotatedPolygon = transform:transformedPolygon(polygon)
    return rotatedPolygon
end

function Paddle:checkLineCollision(other)
    local collisionPolygon = self:getFullCollisionRect()
    for i = 1, collisionPolygon:count() do
        -- Cycle through each line in the polygon
		local j = (i + 2) % (collisionPolygon:count()) + 1
        -- Get all colliding sprites and check if it is the ball
        local sprites = gfx.sprite.querySpritesAlongLine(collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
        --[[if sprites ~= nil and sprites[other] ~= nil then
            print("Collision! AHHAAHHHAHAHAHAHAHAHA")
        end]]
        if sprites == nil then return end
        for k = 1, #sprites do
            if sprites[k] == other then
                self:bounce(other, collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
                return true
            end
        end
    end
    return false
end

function Paddle:bounce(other, x1, y1, x2, y2)
    local bVel = pd.geometry.vector2D.new(other.vel.dx, other.vel.dy)
    local normal = pd.geometry.vector2D.new(y1 - y2, x2 - x1)
    --print(normal:magnitude())
    --if normal:magnitude() < 32 then
    --    if other:getCenterPoint():distanceToPoint(self.end1) < other:getCenterPoint():distanceToPoint(self.end2) then
    --        print(self.end1:unpack())
    --        other:moveTo(self.end1:unpack())
    --    else
    --        print(self.end2:unpack())
    --        other:moveTo(self.end2:unpack())
    --    end
    --    return
    --end
    normal:normalize()
    local dot = normal:dotProduct(bVel)
    local reflection = pd.geometry.vector2D.new(bVel.dx - 2 * dot * normal.x, bVel.dy - 2 * dot * normal.y)
    other.vel = reflection + pd.geometry.vector2D.new(self.vel.dx, self.vel.dy) * 0.5
    self.vel = (self.vel / 4) + bVel * 0.25
end