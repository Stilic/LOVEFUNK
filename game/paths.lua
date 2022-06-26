local paths = {}

function paths.get(key) return "assets/" .. key end

function paths.file(key)
    local contents = love.filesystem.read(paths.get(key))
    return contents
end

function paths.image(key)
    return love.graphics.newImage(paths.get("images/" .. key .. ".png"))
end

function paths.xml(key) return paths.file(key .. ".xml") end

function paths.sprite(x, y, key)
    return Sprite(x, y):load(paths.image(key), paths.xml("images/" .. key))
end

return paths
