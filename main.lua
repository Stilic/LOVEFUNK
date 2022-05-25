-- global libraries
lovesize = require "lib.lovesize"

-- game objects

-- love callbacks
function love.load() lovesize.set(love.graphics.getDimensions()) end

function love.resize(width, height) lovesize.resize(width, height) end

function love.draw()
    lovesize.begin()

    love.graphics.print("sex is great", 50, 50)

    lovesize.finish()
end
