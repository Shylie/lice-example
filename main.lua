local lice = require 'lib.lice'
local map
local canvas
local curZ

function love.load()
	love.window.setMode(640, 640, { fullscreen = false, resizable = false })

	local atlas = love.graphics.newImage('tiles.png')
	map = lice.new(9, 9, 9, atlas, 16, 16)

	for x = 1, 9 do
		for y = 1, 9 do
			for z = 1, 9, 1 do
				map:setLayerID(x, y, z, love.math.random(1, 2) == 1 and 1 or 5)
			end
		end
	end

	canvas = love.graphics.newCanvas(160, 160)
	canvas:setFilter("nearest", "nearest", 0)

	curZ = 1
end

function love.update(dt)
	canvas:renderTo(function()
		love.graphics.rectangle("fill", 0, 0, 160, 160)
		map:draw(80, 80, 9, 9, 1, 5, 5, math.floor(curZ))
	end)

	curZ = curZ + dt
	if curZ > 11 then
		curZ = curZ - 11
	end
end

function love.draw()
	love.graphics.draw(canvas, 0, 0, 0, 4, 4)
end