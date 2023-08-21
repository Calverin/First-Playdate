import "dvd" -- DEMO
--local dvd = dvd(1, -1) -- DEMO
--for i = 1, 10 do -- DEMO
--	dvd[i] = dvd(math.random() * 2 - 1, math.random() * 2 - 1) -- DEMO
--end -- DEMO
local dvds = {dvd(1, 1)} -- DEMO

local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font) -- DEMO
end

local function updateGame()
	if playdate.buttonIsPressed(playdate.kButtonA) then
		dvds[#dvds + 1] = dvd(math.random() * 2 - 1, math.random() * 2 - 1)
	end
	--dvd:update() -- DEMO
	for i = 1, #dvds do -- DEMO
		dvds[i]:update() -- DEMO
	end -- DEMO
end

local function drawGame()
	gfx.clear() -- Clears the screen
	--dvd:draw() -- DEMO
	for i = 1, #dvds do -- DEMO
		dvds[i]:draw() -- DEMO
	end -- DEMO
end

loadGame()

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end