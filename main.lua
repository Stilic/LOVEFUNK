lovesize = require "lib.lovesize"
lovebpm = require "lib.lovebpm"

_c = require "game.cache"
paths = require "game.paths"

local music

local title = require "game.states.title"

local curState

function callState(func, ...)
    if curState[func] then curState[func](...) end
end

function switchState(state)
    curState = state
    _c.clear()
    callState("enter")
end

function love.load()
    lovesize.set(love.graphics.getDimensions())
    music = lovebpm.newTrack():load(paths.musicPath("freakyMenu")):setBPM(102)
                :setLooping(true)
                :on("beat", function(n) callState("beat", n) end)
    switchState(title)
    music:play()
end

function love.resize(width, height) lovesize.resize(width, height) end

function love.update(dt)
    dt = math.min(dt, 1 / 60)
    music:update(dt)
    callState("update", dt)
end

function love.draw()
    lovesize.begin()
    callState("draw")
    lovesize.finish()
end
