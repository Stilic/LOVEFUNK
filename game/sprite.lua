local Object = require "lib.classic"

local Sprite = Object:extend()

function Sprite:new(x, y)
    self.x = x or 0
    self.y = y or 0

    self.width = 0
    self.height = 0
    self.orientation = 0
    self.sizeX = 1
    self.sizeY = 1
    self.offsetX = 0
    self.offsetY = 0
    self.shearX = 0
    self.shearY = 0

    self.xmlData = {}
    self.frames = {}

    self.time = 1
    self.finished = true
    self.paused = false
end

function Sprite:load(image, desc)
    self.image = image
    self.width = image:getWidth()
    self.height = image:getHeight()

    self.xmlData = {}
    self.frames = {}

    local data = xml.parse(desc)
    for _, e in ipairs(data) do
        if e.tag == "SubTexture" then
            local name = string.sub(e.attr["name"], 1, -5)
            if not self.xmlData[name] then self.xmlData[name] = {} end
            table.insert(self.xmlData[name], {
                x = tonumber(e.attr["x"]),
                y = tonumber(e.attr["y"]),
                width = tonumber(e.attr["width"]),
                height = tonumber(e.attr["height"]),
                offset = {
                    x = tonumber(e.attr["frameX"]) or 0,
                    y = tonumber(e.attr["frameY"]) or 0,
                    width = tonumber(e.attr["frameWidth"]) or 0,
                    height = tonumber(e.attr["frameHeight"]) or 0
                }
            })
        end
    end

    return self
end

function Sprite:addByPrefix(name, prefix, framerate, loop)
    if framerate == nil then framerate = 30 end
    if loop == nil then loop = true end

    local anim = {
        prefix = prefix,
        framerate = framerate,
        loop = loop,
        quads = {}
    }
    for _, f in ipairs(self.xmlData[prefix]) do
        table.insert(anim.quads, love.graphics
                         .newQuad(f.x, f.y, f.width, f.height, self.width,
                                  self.height))
    end
    self.frames[name] = anim

    return self
end

function Sprite:play(anim, force)
    if not self.curAnim or anim ~= self.curAnim.name then
        self.curAnim = self.frames[anim]
        self.curName = anim
        self.finished = false
        self.paused = false
    elseif self.curAnim and force then
        self.time = 1
        self.finished = false
        self.paused = false
    end

    return self
end

function Sprite:stop()
    self.curAnim = nil
    return self
end

function Sprite:pause()
    self.paused = true
    return self
end

function Sprite:resume()
    self.paused = false
    return self
end

function Sprite:update(dt)
    if self.curAnim and not self.finished and not self.paused then
        self.time = self.time + self.curAnim.framerate * dt
        if self.time > #self.curAnim.quads then
            if self.curAnim.loop then
                self.time = 1
            else
                self.time = #self.curAnim.quads
                self.finished = true
            end
        end
    end
end

function Sprite:draw()
    if self.curAnim then
        local anim = self.frames[self.curName]
        local spriteNum = math.floor(self.time)

        local data = self.xmlData[anim.prefix][spriteNum]
        local width
        local height

        if data.offset.width == 0 then
            width = math.floor(data.width / 2)
        else
            width = math.floor(data.offset.width / 2) + data.offset.x
        end
        if data.offset.height == 0 then
            height = math.floor(data.height / 2)
        else
            height = math.floor(data.offset.height / 2) + data.offset.y
        end

        love.graphics.draw(self.image, anim.quads[spriteNum], self.x, self.y,
                           self.orientation, self.sizeX, self.sizeY,
                           width + self.offsetX, height + self.offsetY,
                           self.shearX, self.shearY)
    end
end

return Sprite
