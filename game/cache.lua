local cache = {objects = {}, images = {}}

function cache.add(obj)
    table.insert(cache.objects, obj)
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
    for _, o in ipairs(cache.objects) do
        if o.release then o:release() end
    end
    cache.objects = {}
    for _, i in ipairs(cache.images) do i:release() end
    cache.images = {}
end

return cache
