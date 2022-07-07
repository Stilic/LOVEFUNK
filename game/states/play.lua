local Note = require "game.note"
local StrumNote = require "game.strumnote"
local Group = require "game.group"

local play = {}

local playerStrums

function play.enter()
    playerStrums = Group()
    _c.add(playerStrums)
    for i = 1, 4, 1 do
        playerStrums:add(StrumNote(42, 40, i - 1, 0):postAddedToGroup())
    end
end

function play.update(dt)
    playerStrums:call("update", dt)
    for i, s in ipairs(playerStrums.members) do
        if love.keyboard.isDown(Note.directions[i]) then s:play("confirm") else s:play("static") end
    end
end

function play.draw() playerStrums:call("draw") end

return play
