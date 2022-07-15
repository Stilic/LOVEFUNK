local parseJson = (require "lib.json").decode
local Sprite = require "game.sprite"

local paths = {}

function paths.get(key) return "assets/" .. key end

function paths.file(key)
    local contents = love.filesystem.read(paths.get(key))
    return contents
end

function paths.image(key)
    return _c.newImage(paths.get("images/" .. key .. ".png"))
end

function paths.json(key) return paths.file("data/" .. key .. ".json") end

function paths.parseJson(key) return parseJson(paths.json(key)) end

function paths.xml(key) return paths.file(key .. ".xml") end

function paths.sprite(x, y, key)
    return Sprite(x, y):load(paths.image(key), paths.xml("images/" .. key))
end

function paths.soundPath(key, prefix)
    return paths.get((prefix or "sounds") .. "/" .. key .. ".ogg")
end

function paths.sound(key, cache, mode, prefix)
    if cache == nil then cache = true end

    local sound = love.audio.newSource(paths.soundPath(key, prefix), mode or "static")
    if cache then _c.add(sound) end

    return sound
end

function paths.musicPath(key) return paths.soundPath(key, "music") end

function paths.music(key, cache, mode) return paths.sound(key, cache, mode, "music") end

return paths
