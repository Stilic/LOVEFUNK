local Note = (require "game.sprite"):extend()

Note.swagWidth = 160 * 0.7
Note.directions = {"left", "down", "up", "right"}
Note.colors = {"purple", "blue", "green", "red"}
Note.safeZoneOffset = (10 / 60) * 1000

function Note:new(strumTime, noteData, prevNote, sustainNote, preload)
    Note.super.new(self, 50, -2000)

    if prevNote == nil then prevNote = self end
    self.prevNote = prevNote
    if sustainNote == nil then sustainNote = false end
    self.isSustainNote = sustainNote
    if preload == nil then preload = true end

    self.strumTime = strumTime
    self.noteData = noteData

    self.mustPress = false
    self.canBeHit = false
    self.wasGoodHit = false

    if preload then
        local path = "NOTE_assets"
        self:load(paths.image(path), paths.xml("images/" .. path))
        self:loadStuff()
    end

    local size = 0.7
    self.sizeX, self.sizeY = size, size
end

function Note:loadStuff()
    if self.noteData == 0 then
        if self.isSustainNote then
            self:addByPrefix("holdend", "pruple end hold")
            self:addByPrefix("hold", "purple hold piece")
        else
            self:addByPrefix("scroll", "purple")
        end
    elseif self.noteData == 1 then
        if self.isSustainNote then
            self:addByPrefix("holdend", "blue hold end")
            self:addByPrefix("hold", "blue hold piece")
        else
            self:addByPrefix("scroll", "blue")
        end
    elseif self.noteData == 2 then
        if self.isSustainNote then
            self:addByPrefix("holdend", "green hold end")
            self:addByPrefix("hold", "green hold piece")
        else
            self:addByPrefix("scroll", "green")
        end
    else
        if self.isSustainNote then
            self:addByPrefix("holdend", "red hold end")
            self:addByPrefix("hold", "red hold piece")
        else
            self:addByPrefix("scroll", "red")
        end
    end

    if self.isSustainNote then
        self.alpha = 0.6
        self:play("holdend")

        if self.prevNote.isSustainNote then
            self:play("hold")
            self.prevNote.sizeY = self.prevNote.sizeY *
                                      (music.period / 100 * 1.5 *
                                          play.song.speed)
        end
    else
        self:play("scroll")
    end
end

function Note:update(dt)
    Note.super.update(self, dt)

    local time = music:getTime()
    if self.mustPress then
        self.canBeHit = self.strumTime > time - Note.safeZoneOffset and
                            self.strumTime < time + Note.safeZoneOffset * 0.5
    else
        self.canBeHit = false

        if (self.strumTime <= time) then self.wasGoodHit = true end
    end
end

return Note
