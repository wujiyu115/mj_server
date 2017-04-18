-- @Author: wujiyu
-- @Date:   2017-04-16 23:40:31
-- @Last Modified by:   wujiyu
-- @Last Modified time: 2017-04-17 00:15:28
package.path = "../../lualib/?.lua;"..package.path

local utils = require "utils"
local mjlib = require "mjlib"
local hulib = require "hulib"
local gui_hulib = require "huguilib"


local M = {}

function M.check_hu(t, laizi)
    local has_laizi = false
    local count = 0
    for i,v in ipairs(t) do
        if i == laizi and v ~= 0 then
            has_laizi = true
        end
        count = count + v
    end
    if count%3 ~= 2 then
        print(string.format("card count:%s", count))
        return false
    end
    return has_laizi and gui_hulib.get_hu_info(t, nil, laizi) or hulib.get_hu_info(t)
end

function M.check_ting(t, laizi)
    local ting = {}
    local count = 0
    local hand_tmp = {}
    for i,v in ipairs(t) do
        count = count + v
        hand_tmp[i] = v
    end
    if count%3 ~= 1 then
        return ting
    end
    for card = 1,34 do
        if laizi ~= card then
            hand_tmp[card] = hand_tmp[card] + 1
            local can_hu = M.check_hu(hand_tmp, laizi)
            if can_hu then
                utils.print_array(hand_tmp)
                table.insert(ting, card)
            end
            hand_tmp[card] = hand_tmp[card] - 1
        end
    end
    return ting
end



local function test_ting()
    -- local t = {
    --     0,0,0,   0,0,2,   0,0,0,
    --     0,0,0,   2,0,0,   0,0,0,
    --     0,0,0,   1,2,2,   0,0,0,
    --     0,0,0,0, 0,0,2}
    local t = {
        0,0,0,   0,0,0,   0,0,0,
        0,0,1,   1,2,1,   0,0,0,
        0,0,0,   2,2,2,   0,0,0,
        0,0,0,0, 0,1,1}
    local ting = M.check_ting(t, laizi)
    utils.print(ting)

end

local laizi = 32
local function test_hu()
        -- local t = {
    --     0,0,0,   0,0,2,   0,0,0,
    --     0,0,0,   2,0,0,   0,0,0,
    --     0,0,0,   1,2,2,   0,0,0,
    --     0,0,0,0, 0,0,2}
    local t = {
            0,0,0, 0,0,0, 0,0,1,
            1,0,1, 1,2,1, 0,0,0,
            0,0,0, 2,2,2, 0,0,0,
            0,0,0,0,1,0,0,}
    print(M.check_hu(t, laizi))
    -- print(gui_hulib.get_hu_info(t, nil, laizi))

end

test_hu()


return M