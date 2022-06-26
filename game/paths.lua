local paths = {}

function paths.get(key) return "assets/" .. key end

function paths.file(key)
    local contents = love.filesystem.read(paths.get(key))
    return contents
end

function paths.image(key)
    return _c.newImage(paths.get("images/" .. key .. ".png"))
end

function paths.xml(key) return paths.file(key .. ".xml") end

function paths.sprite(x, y, key)
    return Sprite(x, y):load(paths.image(key), paths.xml("images/" .. key))
end

function paths.musicPath(key) return paths.get("music/" .. key .. ".ogg") end

function paths.music(key, cache)
    if cache == nil then cache = true end
    local music = love.audio.newSource(paths.musicPath(key), "stream")
    if cache then _c.add(music) end
    return music
end

function paths.soundPath(key) return paths.get("sounds/" .. key .. ".ogg") end

function paths.sound(key, cache)
    if cache == nil then cache = true end
    local sound = love.audio.newSource(paths.sound(key), "static")
    if cache then _c.add(sound) end
    return sound
end

return paths
