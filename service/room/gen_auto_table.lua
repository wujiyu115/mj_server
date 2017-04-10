package.path = "../../lualib/?.lua;"..package.path

local auto_tbl = require "auto_table"
local utils = require "utils"
local mjlib = require "mjlib"

local tested_tbl = {}

local function test_hu_tbl(tbl)
    for _=1,4 do
        if math.random(1,5) <= 1 then
            while(true) do
                local index = math.random(1,9)
                if tbl[index] <= 1 then
                    tbl[index] = tbl[index] + 3
                    break
                end
            end
        else
            while(true) do
                local index = math.random(1, 7)
                if tbl[index] < 4 and tbl[index + 1] < 4 and tbl[index + 2] < 4 then
                    tbl[index] = tbl[index] + 1
                    tbl[index + 1] = tbl[index + 1] + 1
                    tbl[index + 2] = tbl[index + 2] + 1
                    break
                end
            end
        end
    end

    local num = 0
    for i=1,9 do
        num = num * 10 + tbl[i]
    end

    if tested_tbl[num] then
        return true
    end

    local ret = mjlib.get_hu_info(tbl)
    tested_tbl[num] = ret
    return ret
end

local function dump_auto_tbl()
    local str = utils.table_2_str(auto_tbl)

    str = "return "..str
    local file = io.open("./auto_table.lua", "w");
    file:write(str)
    file:close()
end

local function main()
    local base_tbl = {}
    for _=1,33 do
        table.insert(base_tbl,0)
    end

    table.insert(base_tbl,2)

    local tbl = {}
    for _=1,34 do
        table.insert(tbl,0)
    end

    local start = os.time()
    math.randomseed(os.time())
    local count = 10000*10000
    local fail_count = 0
    local percent = 0
    for i=1,count do
        for i=1,34 do
            tbl[i] = base_tbl[i]
        end

        if not test_hu_tbl(tbl) then
            fail_count = fail_count + 1
        end
        if i % (100*10000) == 0 then
            percent = percent + 1
            print("完成"..percent.."%")
        end
    end
    print("测试",count/10000,"万次,耗时",os.time() - start,"秒")
    print("失败次数:", fail_count)
    dump_auto_tbl()
end

main()
