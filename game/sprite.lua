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

    local index = 0
    local add = function(f)
        index = index + 1
        anim.frames[index] = {
            quad = love.graphics.newQuad(f.x, f.y, f.width, f.height,
                                         self.width, self.height),
            data = f
        }
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

    self.frames[name] = anim
end

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

    local data = parseXml(desc)
    local index = 0
    for _, e in ipairs(data) do
        if e.tag == "SubTexture" then
            local name = string.sub(e.attr["name"], 1, -5)
            if not self.xmlData[name] then self.xmlData[name] = {} end
            index = index + 1
            self.xmlData[name][index] = {
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
            }
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

function Sprite:play(anim, force)
    local resetTimer = false

    if not self.curAnim or anim ~= self.curAnim.name then
        self.curAnim = self.frames[anim]
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
    if self.curAnim then
        local frame = self.curAnim.frames[math.floor(self.time)]

        local ox
        local oy

        local mult = 2.5 / 5

        if frame.data.offset.width == 0 then
            ox = math.floor(frame.data.width / 2 - frame.data.width * mult)
        else
            ox = math.floor(frame.data.offset.width / 2 -
                                frame.data.offset.width * mult) +
                     frame.data.offset.x
        end
        if frame.data.offset.height == 0 then
            oy = math.floor(frame.data.height / 2 - frame.data.height * mult)
        else
            oy = math.floor(frame.data.offset.height / 2 -
                                frame.data.offset.height * mult) +
                     frame.data.offset.y
        end

        love.graphics.draw(self.image, frame.quad, self.x, self.y,
                           self.orientation, self.sizeX, self.sizeY,
                           ox + self.offsetX, oy + self.offsetY, self.shearX,
                           self.shearY)
    end
end

return Sprite
