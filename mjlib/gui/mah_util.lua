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
        return false
    end
    return has_laizi and gui_hulib.get_hu_info(t, nil, laizi) or hulib.get_hu_info(t)
end

function M.check_ting(t, laizi)
    local count = 0
    local hand_cards_tmp = {}
    for i,v in ipairs(t) do
        count = count + v
        hand_cards_tmp[i] = v
    end
    if count%3 ~= 1 then
        return false
    end
    for card = 1,34 do
        hand_cards_tmp[card] = hand_cards_tmp[card] + 1
        local can_hu = M.check_hu(hand_cards_tmp, laizi)
        if can_hu then
            print("听牌", card)
        end
        hand_cards_tmp[card] = hand_cards_tmp[card] - 1
    end
end

local function test_one()
    -- 6万6万6万4筒4筒4筒4条4条5条5条6条6条发发
    local laizi = 34
    -- local t = {
    --     0,0,0,   0,0,2,   0,0,0,
    --     0,0,0,   2,0,0,   0,0,0,
    --     0,0,0,   1,2,2,   0,0,0,
    --     0,0,0,0, 0,0,2}

    local t = {
        0,0,0,   0,0,0,   0,0,0,
        0,0,1,   1,2,1,   0,0,0,
        0,0,0,   2,2,2,   0,0,0,
        0,0,0,0, 0,2,0}
    -- print(M.check_hu(t, laizi))
    print(M.check_ting(t, laizi))

end

test_one()


return M