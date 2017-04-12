package.path = "../../lualib/?.lua;"..package.path
local utils = require "utils"
local no_gui_table = require "no_gui_table"
local no_gui_eye_table = require "no_gui_eye_table"
local one_gui_table = require "one_gui_table"
local one_gui_eye_table = require "one_gui_eye_table"
local two_gui_table = require "two_gui_table"
local two_gui_eye_table = require "two_gui_eye_table"
local three_gui_table = require "three_gui_table"
local three_gui_eye_table = require "three_gui_eye_table"
local four_gui_table = require "four_gui_table"
local four_gui_eye_table = require "four_gui_eye_table"

local no_gui_feng_table = require "no_gui_feng_table"
local no_gui_feng_eye_table = require "no_gui_feng_eye_table"
local one_gui_feng_table = require "one_gui_feng_table"
local one_gui_feng_eye_table = require "one_gui_feng_eye_table"
local two_gui_feng_table = require "two_gui_feng_table"
local two_gui_feng_eye_table = require "two_gui_feng_eye_table"
local three_gui_feng_table = require "three_gui_feng_table"
local three_gui_feng_eye_table = require "three_gui_feng_eye_table"
local four_gui_feng_table = require "four_gui_feng_table"
local four_gui_feng_eye_table = require "four_gui_feng_eye_table"

local mjlib = require "mjlib"

local split_table = {
    {min = 1,  max = 9,  chi = true},
    {min = 10, max = 18, chi = true}
    {min = 19, max = 27, chi = true}
    {min = 28, max = 34, chi = false}
}

local check_table = {
    [0] = {no_gui_table,    no_gui_eye_table},
    [1] = {one_gui_table,   one_gui_eye_table},
    [2] = {two_gui_table,   two_gui_eye_table},
    [3] = {three_gui_table, three_gui_eye_table},
    [4] = {four_gui_table,  four_gui_eye_table},
}

local check_feng_table = {
    [0] = {no_gui_feng_table,   no_gui_feng_eye_table},
    [1] = {one_gui_feng_table,  one_gui_feng_eye_table},
    [2] = {two_gui_feng_table,  two_gui_feng_eye_table},
    [3] = {three_gui_feng_table,three_gui_feng_eye_table},
    [4] = {four_gui_feng_table, four_gui_feng_eye_table},
}

local M = {}

function M.check_7dui(hand_cards, waves)
    if #waves > 0 then return false end

    for _,c in ipairs(hand_cards) do
        if c % 2 ~= 0 then
            return false
        end
    end

    return true
end

function M.check_pengpeng()

end

function M.get_hu_info(hand_cards, waves, gui_index)
    local hand_cards_tmp = {}
    for i,v in ipairs(hand_cards) do
        hand_cards_tmp[i] = v
    end

    local gui_num = hand_cards_tmp[gui_index]
    hand_cards_tmp[gui_index] = 0

    local tbl = M.split_info(hand_cards_tmp, gui_num)

    -- 检查完美匹配
    return true
end

function M.check_table(key, num, gui_num, chi)
    if not chi then

    end
end

-- 根据花色切分
function M.split_info(t, gui_num)
    for _,v in ipairs(check_table) do
        local key = 0
        local num = 0
        for i=v.min,v.max do
            key = key*10 + t[i]
            num = num + t[i]
        end

        local t = {}
        for i=0, gui_num do
           
        end
    end
end

function M.deal_perfect(hand_cards_tmp, info)
    for i=1,3 do
        M.deal_perfect_sub(hand_cards_tmp, info, i)
    end
end

function M.deal_perfect_sub(hand_cards_tmp, info, i)
    local list = {}
    local tbl = {}
    for i = cfg.min, cfg.max do
        repeat
            local count = cards[i]
            if count > 0 then
                table.insert(tbl, count)
            else
                if #tbl == 0 then
                    break
                end

               table.insert(list, tbl)
               tbl = {}
            end
        until(true)
    end

    for i,v in ipairs(list) do
        if M.check_wave(list) then
            list[i] = false
        else
            if info.laizi_num <= 0 then
                return false
            end
        end
    end

    return true
end

function M.check_color_chi(cards, cfg, info)
    local tbl = {}
    for i = cfg.min, cfg.max do
        repeat
            local count = cards[i]
            if count > 0 then
                table.insert(tbl, count)
            else
                if #tbl == 0 then
                    break
                end

                if not M.check_sub(tbl, info) then
                    return false
                end
                tbl = {}
            end
        until(true)
    end

    return true
end

function M.check_sub(tbl, info)
    local count = 0
    for _,v in ipairs(tbl) do
        count = count + v
    end
    local yu = (count % 3)

    if yu == 1 then
        return false
    elseif yu == 2 then
        if info.eye then
            return false
        end

        return M.check_wave_and_eye(tbl)
    end

    return M.check_wave(tbl)
end

function M.check_wave(tbl)
    local num = 0
    for _,c in ipairs(tbl) do
        num = num * 10 + c
    end

    if wave_table[num] then
        return true
    end

    -- wave_table[num] = true
    return false
end

-- 检查是否匹配3*n + 2
function M.check_wave_and_eye(tbl)
    if #tbl == 1 then
        return true
    end

    local num = 0
    for _,c in ipairs(tbl) do
        num = num * 10 + c
    end

    if wave_table_eye[num] then
        return true
    end

    local len = #tbl
    -- 拆出可能的眼位，再判断
    for i,v in ipairs(tbl) do
        repeat
            if v < 2 then
                break
            end

            local tmp_tbl_1 = {}
            local tmp_tbl_2 = {}
            for ii,vv in ipairs(tbl) do
                table.insert(tmp_tbl_1, vv)
            end

            if v > 2 then
                tmp_tbl_1[i] = v - 2
            else
                if i == 1 then
                    table.remove(tmp_tbl_1, 1)
                elseif i == len then
                    table.remove(tmp_tbl_1)
                else
                    for ii = i + 1, len do
                        table.insert(tmp_tbl_2, tbl[ii])
                    end
                    tmp_tbl_1[i] = nil
                end
            end

            if not M.check_wave(tmp_tbl_1) then
                break
            end

            if next(tmp_tbl_2) then
                if not M.check_wave(tmp_tbl_2) then
                    break
                end
            end

            return true
        until(true)
    end

    return false
end

return M
