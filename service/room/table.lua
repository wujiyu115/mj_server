-- 桌子类
local M = {}

M.__index = M

function M.new(...)
    local o = {}
    setmetatable(o, M)

    M.init(...)

    return o
end

function M:init(id)
    self.id = id
    self.player_array = {}
end

function M:add(player)
    table.insert(self.player_array, player)
end

function M:remove(player)
    for i,v in ipairs(self.player_array) do
        if v.id == player.id then
            table.remove(self.player_array, i)
            break
        end
    end
end

return M
