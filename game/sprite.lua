local Object = require "lib.classic"
local parseXml = (require "lib.xml").parse

local Sprite = Object:extend()

local function addAnim(self, name, prefix, indices, framerate, loop)
    if framerate == nil then framerate = 30 end
    if loop == nil then loop = true end

    local anim = {
        prefix = prefix,
        framerate = framerate,
        loop = loop,
        frames = {}
    }

    local add = function(f)
        table.insert(anim.frames, {
            quad = love.graphics.newQuad(f.x, f.y, f.width, f.height,
                                         self.width, self.height),
            data = f
        })
    end

    if not indices then
        for _, f in ipairs(self.xmlData[prefix]) do add(f) end
    else
        for _, i in ipairs(indices) do
            local f = self.xmlData[prefix][i + 1]
            if not f then f = self.xmlData[prefix][i - 1] end
            add(f)
        end
    end

    self.anims[name] = anim
    self.lastAnimAdded = anim
end

function Sprite:new(x, y)
    self.x = x or 0
    self.y = y or 0

    self.width = 0
    self.height = 0
    self.orientation = 0
    self.color = {255, 255, 255}
    self.alpha = 1
    self.sizeX = 1
    self.sizeY = 1
    self.animOffsets = {}
    self.offsetX = 0
    self.offsetY = 0
    self.shearX = 0
    self.shearY = 0

    self.xmlData = {}
    self.anims = {}

    self.time = 1
    self.finished = true
    self.paused = false
end

function Sprite:load(image, desc)
    self.image = image
    self.width = image:getWidth()
    self.height = image:getHeight()

    self.xmlData = {}
    self.anims = {}

    local data = parseXml(desc)
    for _, e in ipairs(data) do
        if e.tag == "SubTexture" then
            local d = {
                x = tonumber(e.attr["x"]),
                y = tonumber(e.attr["y"]),
                width = tonumber(e.attr["width"]),
                height = tonumber(e.attr["height"])
            }

            local ox = tonumber(e.attr["frameX"]) or 0
            local oy = tonumber(e.attr["frameY"]) or 0
            local ow = tonumber(e.attr["frameWidth"]) or 0
            local oh = tonumber(e.attr["frameHeight"]) or 0
            if ox ~= 0 or oy ~= 0 or ow ~= 0 or oh ~= 0 then
                d.offset = {x = ox, y = oy, width = ow, height = oh}
            end

            local name = string.sub(e.attr["name"], 1, -5)
            if not self.xmlData[name] then self.xmlData[name] = {} end
            table.insert(self.xmlData[name], d)
        end
    end

    return self
end

function Sprite:addByPrefix(name, prefix, framerate, loop)
    addAnim(self, name, prefix, nil, framerate, loop)
    return self
end

function Sprite:addByIndices(name, prefix, indices, framerate, loop)
    addAnim(self, name, prefix, indices, framerate, loop)
    return self
end

function Sprite:addOffset(anim, x, y)
    x = x or 0
    y = y or 0

    self.animOffsets[anim] = {x, y}

    return self
end

function Sprite:play(anim, force)
    local resetTimer = false

    if not self.curAnim or anim ~= self.curName then
        self.curAnim = self.anims[anim]
        self.curName = anim
        resetTimer = true
    end

    if force or resetTimer then
        self.time = 1
        self.finished = false
    end

    return self
end

function Sprite:stop()
    self.curAnim = nil
    self.timer = 1
    self.finished = true
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
        if self.time > #self.curAnim.frames then
            if self.curAnim.loop then
                self.time = 1
            else
                self.time = #self.curAnim.frames
                self.finished = true
            end
        end
    end
end

function Sprite:draw()
    if self.alpha <= 0 then return end

    local frame
    if self.curAnim then
        frame = self.curAnim.frames[math.floor(self.time)]
    else
        frame = self.lastAnimAdded.frames[1]
    end

    local x, y = self.x, self.y
    local ox, oy = 0, 0

    if frame.data.offset then
        local mult = 2.5 / 5

        if frame.data.offset and frame.data.offset.width == 0 then
            ox = math.floor(frame.data.width / 2 - frame.data.width * mult)
        else
            ox = math.floor(frame.data.offset.width / 2 -
                                frame.data.offset.width * mult) +
                     frame.data.offset.x
        end

        if frame.data.offset and frame.data.offset.height == 0 then
            oy = math.floor(frame.data.height / 2 - frame.data.height * mult)
        else
            oy = math.floor(frame.data.offset.height / 2 -
                                frame.data.offset.height * mult) +
                     frame.data.offset.y
        end
    end

    local customOffset = self.animOffsets[self.curName]
    if customOffset then
        ox = ox + customOffset[1]
        oy = oy + customOffset[2]
    end

    local oldColor
    local setColor = (self.color[1] ~= 255 or self.color[2] ~= 255 or
                         self.color[3] ~= 255) or
                         (self.alpha > 0 and self.alpha > 1)
    if setColor then
        r, g, b = love.graphics.getColor()
        oldColor = {r, g, b}

        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
                               self.alpha)
    end
    love.graphics.draw(self.image, frame.quad, x, y, self.orientation,
                       self.sizeX, self.sizeY, ox + self.offsetX,
                       oy + self.offsetY, self.shearX, self.shearY)
    if setColor then
        love.graphics.setColor(oldColor[1], oldColor[2], oldColor[3])
    end
end

return Sprite
