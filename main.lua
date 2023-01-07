local lice = require('lib.lice.lice')
local map
local canvas
local curZ

function love.load()
	love.window.setMode(640, 640, { fullscreen = false, resizable = false })

	local atlas = love.graphics.newImage('tiles.png')
	map = lice.new(9, 9, 9, atlas, 32, 32)

	for x = 1, 9 do
		for y = 1, 9 do
			for z = 1, 9, 1 do
				map:setTile(x, y, z, z % 2 == 0 and 1 or 9)
			end
		end
	end

	canvas = love.graphics.newCanvas(320, 320)
	canvas:setFilter("nearest", "nearest", 0)

	curZ = -1
end

function love.update(dt)
	canvas:renderTo(function()
		love.graphics.rectangle("fill", 0, 0, 320, 320)
		map:draw(160, 160, 5, 5, 5, 5, 5, math.floor(curZ))
	end)

	curZ = curZ + 2 * dt
	if curZ > 12 then
		curZ = -1
	end
end

function love.draw()
	love.graphics.draw(canvas, 0, 0, 0, 2, 2)
end