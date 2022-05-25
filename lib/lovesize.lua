--[[
    lovesize 1.0 by RicardoBusta
    https://github.com/RicardoBusta
    https://github.com/RicardoBusta/lovesize

    Adapted by Stilic for LOVEFUNK
]] local lw, lh = 800, 600 -- lovesize target size
local lx, ly = 0, 0 -- translation required to center the game area
local ls = 1 -- scale to fit the game screen to love screen
local lg = love.graphics

local lovesize = {}

-- Set lovesize with the desired width, height and options
function lovesize.set(w, h)
    lw = w or lw
    lh = h or lh
    lovesize.resize(lg.getWidth(), lg.getHeight())
end

-- Used to start the lovesize application
function lovesize.begin()
    -- Scissors will keep the game from rendering outside the specified screen. Clean the letterbox before this call.
    lg.push()
    lg.setScissor(lx, ly, lg.getWidth() - 2 * lx, lg.getHeight() - 2 * ly)
    lg.translate(lx, ly)
    lg.scale(ls, ls)
end

-- Used to finish the lovesize application
function lovesize.finish()
    lg.setScissor()
    lg.pop()
end

-- Used to calculate the values used by lovesize
function lovesize.resize(width, height)
    local sx = width / lw
    local sy = height / lh

    -- Check which size scales the most, and add letterbox space to it
    if sx > sy then
        ls = sy
        lx, ly = (width - lw * ls) / 2, 0
    else
        ls = sx
        lx, ly = 0, (height - lh * ls) / 2
    end
end

-- Transforms the x,y coordinates to the game world position
function lovesize.pos(x, y)
    local is = 1 / ls
    return math.floor((x - lx) * is), math.floor((y - ly) * is)
end

-- Checks if the coordinate is inside the screen
function lovesize.inside(x, y)
    return
        x >= lx and x < lg.getWidth() - lx and y >= ly and y < lg.getHeight() -
            ly
end

function lovesize.getWidth() return lw end

function lovesize.getHeight() return lh end

function lovesize.getDimensions() return lw, lh end

return lovesize
