local net = require "net"

local M = {}

function M:enter()
    net:connect("127.0.0.1", 8888)
end

function M:tick()

end

function M:leave()

end

return M
