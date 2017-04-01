local socket = require "socket"

local M = {}

function M:connect(ip, port)
    self.fd = socket.open(ip, port)
end

return M
