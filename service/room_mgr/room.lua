local skynet = require "skynet"

local M = {}

M.__index = M

function M.create(info)
    local o = {
        id = info.id,
        addr = skynet.newservice(info.service, info.id)
    }

    setmetatable(o, M)
    return o
end

return M
