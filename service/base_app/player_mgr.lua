local M = {}

function M:init()
    self.player_tbl = {}
end

function M:get_by_account(account)
    return self.player_tbl[account]
end

function M:add(obj)
    print(obj.account)
    self.player_tbl[obj.account] = obj
end

function M:remove(obj)
    self.player_tbl[obj.account] = nil
end

return M


