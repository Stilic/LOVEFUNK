local Note = require "game.note"

local StrumNote = (require "game.sprite"):extend()

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

    local ox, oy = 32, 32
    if data == 0 then
        ox = ox + 3
        oy = oy + 3
    elseif data == 1 then
        ox = ox + 9
        oy = oy + 9
    elseif data == 2 then
        ox = ox + 7
        oy = oy + 6
    elseif data == 3 then
        ox = ox + 2
        oy = oy + 5
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

return StrumNote
