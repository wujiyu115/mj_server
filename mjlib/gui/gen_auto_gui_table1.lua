package.path = "../../lualib/?.lua;"..package.path

local utils = require "utils"
local mjlib = require "mjlib"
local hulib = require "hulib"

local no_gui_table = {}
local one_gui_table = {}
local three_gui_table = {}
local four_gui_table = {}

local no_gui_eye_table = {}
local one_gui_eye_table = {}
local three_gui_eye_table = {}
local four_gui_eye_table = {}

local function add_2_table(t, tbl, eye_tbl)
    local n = 0
    local c = 0
    for i=1,9 do
        n = n*10 + t[i]
        c = c + t[i]
    end

    if c%3 == 0 then
        tbl[n] = true
    else
        eye_tbl = true
    end
end

local function parse_table(t)
    local tbl = {}
    for i=1,9 do
        local n = t[i]
        if n > 0 then
            t[i] = n - 1
            add_2_table(t, no_gui_table, no_gui_eye_table)
            t[i] = n
        end
    end
end

local total_count=0
local hu_count=0
local fail_count=0
local tested_tbl = {}

local function check_hu(t)
    total_count = total_count + 1
    
    for i=1,34 do
        if t[i] > 4 then
            fail_count = fail_count + 1
            return
        end
    end

    local num = 0
    for i=1,18 do
        num = num * 10 + t[i]
    end

    if tested_tbl[num] then
--        return
    end

    tested_tbl[num] = true

    if not hulib.get_hu_info(t, nil, 19) then
        --print("测试失败")
        --utils.print_array(t)
        fail_count = fail_count + 1
    else
        hu_count = hu_count + 1
    end
end

local function test_hu_sub(t, num)
    -- 9 + 7 + 9 + 7
    for j=1,32 do
        if j<= 18 then
            t[j] = t[j] + 3
        elseif j <= 25 then
            local index = j - 18
            t[index] = t[index] + 1
            t[index + 1] = t[index + 1] + 1
            t[index + 2] = t[index + 2] + 1
        else
            local index = j - 25
            t[index] = t[index] + 1
            t[index + 1] = t[index + 1] + 1
            t[index + 2] = t[index + 2] + 1
        end

        if num == 4 then
            check_hu(t)
       else
            test_hu_sub(t, num + 1)
        end

        if j<= 18 then
            t[j] = t[j] - 3
        elseif j <= 25 then
            local index = j - 18
            t[index] = t[index] - 1
            t[index + 1] = t[index + 1] - 1
            t[index + 2] = t[index + 2] - 1
        else
            local index = j - 25
            t[index] = t[index] - 1
            t[index + 1] = t[index + 1] - 1
            t[index + 2] = t[index + 2] - 1
        end
    end
end

local function gen_auto_gui_table()
    local t = {}
    for i=1,34 do
        table.insert(t,0)
    end

    test_hu_sub(t, 1)
    utils.dump_table_2_file(no_gui_table, "./no_gui_table.lua")
    utils.dump_table_2_file(no_gui_eye_table, "./no_gui_eye_table.lua")

    print("总数", total_count)
    print("胡", hu_count)
    print("失败", fail_count)
 
    local no_gui_count = 0
    for _,_ in pairs(no_gui_table) do
        no_gui_count = no_gui_count + 1
    end

    local
    for _,_ in pairs(no_gui_eye_table) do

    end
end

local function main()
    gen_auto_gui_table()
end

main()
