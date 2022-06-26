local title = {}

local gf
local logo

function title.enter()
    gf = paths.sprite(512, 40, "gfDanceTitle")
    gf:addByPrefix("dance", "gfDance", 24)
    gf:play("dance")
    _c.add(gf)

    logo = paths.sprite(-115, -100, "logoBumpin")
    logo:addByPrefix("bump", "logo bumpin", 24)
    logo:play("bump")
    _c.add(logo)
end

function title.update(dt)
    gf:update(dt)
    logo:update(dt)
end

function title.draw()
    gf:draw()
    logo:draw()
end

return title
