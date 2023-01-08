local lice = require 'lib.lice'
---@type Lice
local map
local canvas
local wasDown

local function setupMap()
	for x = 1, 9 do
		for y = 1, 9 do
			if love.math.random(1, 10) == 1 then
				map:setLayerID(x, y, 1, 5)
				map:setLayerID(x, y, 2, nil)
				map:setLayerID(x, y, 3, nil)
			elseif love.math.random(1, 5) > 3 then
				map:setLayerID(x, y, 1, 1)

				if love.math.random(1, 3) == 1 then
					map:setLayerID(x, y, 2, 2)

					if love.math.random(1, 10) == 1 then
						map:setLayerID(x, y, 3, 42)
					else
						map:setLayerID(x, y, 3, nil)
					end
				else
					map:setLayerID(x, y, 2, 13)

					map:setLayerID(x, y, 3, nil)
				end
			else
				map:setLayerID(x, y, 1, 26)

				if love.math.random(1, 7) == 1 then
					map:setLayerID(x, y, 2, 42)

					if love.math.random(1, 3) == 1 then
						map:setLayerID(x, y, 3, 42)
					else
						map:setLayerID(x, y, 3, nil)
					end
				else
					map:setLayerID(x, y, 2, nil)
					map:setLayerID(x, y, 3, nil)
				end
			end
		end
	end
end

function love.load()
	love.window.setMode(640, 640, { fullscreen = false, resizable = false })

	local atlas = love.graphics.newImage('tiles.png')
	map = lice.new(9, 9, 3, atlas, 16, 17)

	setupMap()

	canvas = love.graphics.newCanvas(160, 160)
	canvas:setFilter("nearest", "nearest", 0)
end

function love.update(dt)
	local isDown = love.keyboard.isDown("space")
	if isDown and not wasDown then
		setupMap()
	end
	wasDown = isDown

	canvas:renderTo(function()
		love.graphics.rectangle("fill", 0, 0, 160, 160)
		map:draw(80, 80, 9, 9, 3, 5, 5, 2)
	end)
end

function love.draw()
	love.graphics.draw(canvas, 0, 0, 0, 4, 4)
end