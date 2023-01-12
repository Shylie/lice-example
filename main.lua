local lice = require 'lib.lice'

local MAP_X = 25
local MAP_Y = 25

---@type Lice
local map
local canvas

local function setupMap()
	for x = 1, MAP_X do
		for y = 1, MAP_Y do
			if love.math.random(1, 5) == 1 then
				map:setLayerID(x, y, 1, 5)
				map:setLayerID(x, y, 2, nil)
				map:setLayerID(x, y, 3, nil)
			elseif love.math.random(1, 5) > 3 then
				map:setLayerID(x, y, 1, 1)

				if love.math.random(1, 3) == 1 then
					map:setLayerID(x, y, 2, 2)

					if love.math.random(1, 10) == 1 then
						map:setLayerID(x, y, 3, 66)
					else
						map:setLayerID(x, y, 3, nil)
					end
				else
					map:setLayerID(x, y, 2, 21)

					map:setLayerID(x, y, 3, nil)
				end
			else
				map:setLayerID(x, y, 1, 42)

				if love.math.random(1, 7) == 1 then
					map:setLayerID(x, y, 2, 66)

					if love.math.random(1, 3) == 1 then
						map:setLayerID(x, y, 3, 66)
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

local function setTopZ(tx, ty, id, layerOffset)
	layerOffset = layerOffset or 0
	local layerCount = 0
	local z = map:getSizeZ()
	while layerCount == 0 and z > 0 do
		layerCount = map:getLayerCount(tx, ty, z)
		z = z - 1
	end

	map:setLayerID(tx, ty, z + 1, id, map:getLayerCount(tx, ty, z + 1) + layerOffset)
end

function love.load()
	love.window.setMode(960, 960, { fullscreen = false, resizable = false })

	local atlas = love.graphics.newImage('tiles.png')
	map = lice.new(MAP_X, MAP_Y, 3, atlas, 16, 17)

	canvas = love.graphics.newCanvas(320, 320)
	canvas:setFilter("nearest", "nearest", 0)

	setupMap()
end

function love.update(dt)
	canvas:renderTo(function()
		love.graphics.rectangle("fill", 0, 0, 320, 320)
		map:draw(160, 160, MAP_X, MAP_Y, 3, math.ceil(MAP_X / 2), math.ceil(MAP_Y / 2), 2)
	end)
end

function love.draw()
	love.graphics.draw(canvas, 0, 0, 0, 3, 3)
end

function love.keypressed(key, scancode, isRepeat)
	if key == "space" and not isRepeat then
		setupMap()
	end
end

function love.mousemoved(x, y, dx, dy, isTouch)
	local otx, oty = map:toTilemap((x - dx) / 3 - 160, (y - dy) / 3 - 160)
	otx, oty = otx + math.ceil(MAP_X / 2), oty + math.ceil(MAP_Y / 2)
	local tx, ty = map:toTilemap(x / 3 - 160, y / 3 - 160)
	tx, ty = tx + math.ceil(MAP_X / 2), ty + math.ceil(MAP_Y / 2)

	setTopZ(otx, oty, nil)
	setTopZ(tx, ty, 195, 1)
end