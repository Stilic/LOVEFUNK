local cache = {objects = {}, images = {}}

do
    local mt = {__mode = "kv"}
    setmetatable(cache.objects, mt)
    setmetatable(cache.images, mt)
end

function cache.add(obj)
    cache.objects[#cache.objects + 1] = obj
    return obj
end

function cache.newImage(path)
    local image = cache.images[path]
    if not image then
        image = love.graphics.newImage(path)
        cache.images[path] = image
    end
    return image
end

function cache.clear()
    for _, o in ipairs(cache.objects) do if o.release then o:release() end end
    cache.objects = {}

    for _, i in ipairs(cache.images) do i:release() end
    cache.images = {}

    collectgarbage()
end

return cache
