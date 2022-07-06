local Object = require "lib.classic"

local Group = Object:extend()

function Group:new() self.members = {} end

function Group:add(obj)
    table.insert(self.members, obj)
    return self
end

function Group:remove(obj)
    for i, o in ipairs(self.members) do
        if o == obj then
            table.remove(self.members, i)
            break
        end
    end
    return self
end

function Group:clear()
    self.members = {}
    collectgarbage()
    return self
end

function Group:call(func, ...)
    for _, o in ipairs(self.members) do
        if o[func] then o[func](o, ...) end
    end
    return self
end

return Group
