local Sprite = require "game.sprite"
local Note = require "game.note"

local StrumNote = Sprite:extend()

function StrumNote:new(x, y, data, player)
    StrumNote.super.new(self, x, y)
    self.data = data
    self.player = player

    local path = "NOTE_assets"
    self:load(paths.image(path), paths.xml("images/" .. path))

    local dir = Note.directions[data + 1]
    self:addByPrefix("static", "arrow" .. string.upper(dir))
    self:addByPrefix("pressed", dir .. " press", 24, false)
    self:addByPrefix("confirm", dir .. " confirm", 24, false)

    local ox, oy = -6, 23
    if data == 0 then
        ox = ox + 5
        oy = oy - 3
    elseif data == 1 then
        ox = ox + 5
        ox = ox + 7
    elseif data == 2 then
        ox = ox + 12
    elseif data == 3 then
        ox = ox + 3
    end
    self:addOffset("confirm", ox, oy)

    local size = 0.7
    self.sizeX, self.sizeY = size, size
end

function StrumNote:postAddedToGroup()
    self:play("static")
    self.x = self.x + Note.swagWidth * self.data
    self.x = self.x + 50
    self.x = self.x + (lovesize.getWidth() / 2) * self.player
    return self
end

function StrumNote:play(anim, force)
    StrumNote.super.play(self, anim, force)
    self.centerOffsets = anim == "confirm"
end

return StrumNote
