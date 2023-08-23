-- Imports
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "ball"
import "paddle"

-- Constants
local pd <const> = playdate
local gfx <const> = pd.graphics

local bally, paddly

local function init()
	-- Ball
	bally = Ball(200, 120, 2, 2)
	bally:add()
	-- Paddle
	paddly = Paddle(32, 120)
	paddly:add()

	-- Background
	local backgroundImage = gfx.image.new("images/Background")
    assert(backgroundImage)
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            -- x,y,width,height is the updated area in sprite-local coordinates
            -- The clip rect is already set to this area, so we don't need to set it ourselves
            backgroundImage:draw(0, 0)
        end
    )
end

init()

function pd.update()
	gfx.sprite.update()
	-- Testing paddle lines
	--local collisionPolygon = paddly:getFullCollisionRect()
    --for i = 1, collisionPolygon:count() do
	--	local j = (i + 2) % (collisionPolygon:count()) + 1
    --    gfx.drawLine(collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
    --end
end

function pd.debugDraw()
	local collisionPolygon = paddly:getFullCollisionRect()
    for i = 1, collisionPolygon:count() do
        -- Cycle through each line in the polygon
		local j = (i + 2) % (collisionPolygon:count()) + 1
		gfx.drawLine(collisionPolygon:getPointAt(i).x, collisionPolygon:getPointAt(i).y, collisionPolygon:getPointAt(j).x, collisionPolygon:getPointAt(j).y)
    end
	gfx.drawCircleAtPoint(paddly.end1.x, paddly.end1.y, 5)
	gfx.drawCircleAtPoint(paddly.end2.x, paddly.end2.y, 5)
end