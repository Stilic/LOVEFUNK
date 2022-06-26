-- global libraries
lovesize = require "lib.lovesize"
xml = require "lib.xml"

-- game libraries
Sprite = require "game.sprite"
paths = require "game.paths"

-- game objects
local spr

-- love callbacks
function love.load()
    lovesize.set(love.graphics.getDimensions())

    spr = paths.sprite(-115, -100, "logoBumpin")
    spr:addByPrefix("bump", "logo bumpin", 24, false)
    spr:play("bump")
end

function love.resize(width, height) lovesize.resize(width, height) end

function love.update(dt)
    spr:update(dt)
    if love.keyboard.isDown("space") then spr:play("bump", true) end
end

function love.draw()
    lovesize.begin()
    spr:draw()
    lovesize.finish()
end
