local db = require "db"

local M = {}

M.__index = M

function M.create(...)
    local o = {}
    setmetatable(o, M)

    M.init(o, ...)
    return o
end

function M:init(fd, account)
    self.fd = fd
    self.account = account
    self.status = "load from db"

    print(self.fd, self.account, self.status)
end

function M:load_from_db()
    local obj = db:load_player(self.account)
    self._db = obj
end

return M
