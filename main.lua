lovesize = require "lib.lovesize"
lovebpm = require "lib.lovebpm"

_c = require "game.cache"
paths = require "game.paths"

-- function dump(o)
--     if type(o) == 'table' then
--         local s = '{ '
--         for k, v in pairs(o) do
--             if type(k) ~= 'number' then k = '"' .. k .. '"' end
--             s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
--         end
--         return s .. '} '
--     else
--         return tostring(o)
--     end
-- end

input = (require "lib.baton").new({
    controls = {
        left = {"key:left", "key:a", "axis:leftx-", "button:dpleft"},
        right = {"key:right", "key:d", "axis:leftx+", "button:dpright"},
        up = {"key:up", "key:w", "axis:lefty-", "button:dpup"},
        down = {"key:down", "key:s", "axis:lefty+", "button:dpdown"},
        action = {"key:space", "button:x"},
        accept = {"key:return", "button:start", "button:a"},
        back = {"key:escape", "key:backspace", "button:b"}
    },
    joystick = love.joystick.getJoysticks()[1]
})

-- local title = require "game.states.title"
play = require "game.states.play"
local curState

function callState(func, ...) if curState[func] then curState[func](...) end end

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

    switchState(play)
    -- music:play()
end

function love.resize(width, height) lovesize.resize(width, height) end

function love.update(dt)
    dt = math.min(dt, 1 / 60)
    music:update()
    input:update()
    callState("update", dt)
end

function love.draw()
    lovesize.begin()
    callState("draw")
    lovesize.finish()
end
