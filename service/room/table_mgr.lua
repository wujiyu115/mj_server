-- 桌子管理器

local M = {}

function M:init()
    self.table_tbl = {}
end

function M:get(id)
    return self.table_tbl[id]
end

function M:add(table)
    self.table_tbl[table.id] = table
end

function M:remove(table)
    self.table_tbl[table.id] = nil
end

return M
