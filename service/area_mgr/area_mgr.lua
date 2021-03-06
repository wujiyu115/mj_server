local area_list = require "area_list"

local M = {}

function M:init()
    self.area_tbl = {}
end

function M:create_area_by_list()
    for _,v in ipairs(area_list) do
        --skynet.error("创建游戏赛场 "..v.name)
        local addr = skynet.newservice(v.service, v.id)
        self.area_tbl[v.id] = {addr = addr}
    end
end

function M:get_area(id)
end

function M:create_area(service, id)
    local addr = skynet.newservice(service, id)
    self.area_tbl[id] = {addr = addr}
end

return M
