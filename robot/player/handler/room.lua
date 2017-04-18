local skynet = require "skynet"
local utils = require "utils"

local M = {}

function M.create_table(fd, msg)
    print(fd, name, msg)
    if msg.errmsg then
        return
    end

    utils.print(msg)
end

function M.join_table()

end

return M
