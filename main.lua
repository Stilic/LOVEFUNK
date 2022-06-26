-- global libraries
lovesize = require "lib.lovesize"
xml = require "lib.xml"

-- game libraries
Sprite = require "game.sprite"
paths = require "game.paths"

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end


local spr
-- love callbacks
function love.load()
    lovesize.set(love.graphics.getDimensions())
    spr = paths.sprite(0, 0, "logoBumpin")
    spr:addByPrefix("bump", "logo bumpin", 24, true)
    spr:play("bump")
end

function love.resize(width, height) lovesize.resize(width, height) end

function love.update(dt) spr:update(dt) end

function love.draw()
    lovesize.begin()
    spr:draw()
    lovesize.finish()
end
