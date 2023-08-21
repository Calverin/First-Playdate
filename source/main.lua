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
	bally:move()
	paddly:move()

	gfx.sprite.update()
end