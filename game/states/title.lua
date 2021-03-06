local title = {}

local gf
local logo
local start

local danceRight = false

function title.enter()
    gf = paths.sprite(512, 40, "gfDanceTitle")
    gf:addByIndices("danceLeft", "gfDance",
                    {30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 24,
                    false)
    gf:addByIndices("danceRight", "gfDance", {
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
    }, 24, false)
    _c.add(gf)

    logo = paths.sprite(-115, -100, "logoBumpin")
    logo:addByPrefix("bump", "logo bumpin", 24, false)
    _c.add(logo)

    start = paths.sprite(100, 576, "titleEnter")
    start:addByPrefix("idle", "Press Enter to Begin", 24)
    start:addByPrefix("press", "ENTER PRESSED", 24)
    start:play("idle")
    _c.add(start)
end

function title.update(dt)
    gf:update(dt)
    logo:update(dt)
    start:update(dt)
end

function title.draw()
    gf:draw()
    logo:draw()
    start:draw()
end

function title.beat()
    logo:play("bump", true)

    danceRight = not danceRight
    if danceRight then
        gf:play("danceRight")
    else
        gf:play("danceLeft")
    end
end

return title
