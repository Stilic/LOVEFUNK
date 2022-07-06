local StrumNote = require "game.strumnote"
local Group = require "game.group"

local play = {}

local playerStrums

function play.enter()
    playerStrums = Group()
    _c.add(playerStrums)
    for i = 1, 4, 1 do
        playerStrums:add(StrumNote(42, 50, i - 1, 0):postAddedToGroup())
    end
end

function play.update(dt) playerStrums:call("update", dt)
if love.keyboard.isDown("space") then
    playerStrums:call("play", "confirm", true)
end
end

function play.draw() playerStrums:call("draw") end

return play
