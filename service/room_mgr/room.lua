local M = {}

M.__index = M

function M.create(id)
    local o = {
        id = id,
        addr = Skynet.newservice("room", id)
    }

    setmetatable(o, M)
    return o
end


return M
