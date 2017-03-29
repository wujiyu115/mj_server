local utils = require "utils"

local CardType = {
    [0x10] = {min = 0x11, max = 0x19, chi = true},
    [0x20] = {min = 0x21, max = 0x29, chi = true},
    [0x30] = {min = 0x31, max = 0x39, chi = true},
    [0x40] = {min = 0x41, max = 0x47, chi = false},
    [0x50] = {min = 0x51, max = 0x58, chi = false},
}

local CardDefine = {
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, -- 万
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, -- 筒
    0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, -- 条
    0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, -- 东、南、西、北、中、发、白
    0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, -- 春夏秋冬梅兰竹菊
}

local M = {}

M.COLOR_WAN = 0x10
M.COLOR_TONG = 0x20
M.COLOR_TIAO = 0x30
M.COLOR_ZI = 0x40
M.COLOR_HUA = 0x50

-- 创建一幅牌,牌里存的不是牌本身，而是牌的序号
function M.create(zi, hua)
    local t = {}

    local num = 3*9

    if zi then
        num = num + 7
    end

    if hua then
        num = num + 8
    end

    for i=1,num do
        for _=1,4 do
            table.insert(t, i)
        end
    end

    return t
end

-- 洗牌
function M.shuffle(t)
    for i=#t,2,-1 do
        local tmp = t[i]
        local index = math.random(1, i - 1)
        t[i] = t[index]
        t[index] = tmp
    end
end

function M.can_peng(hand_cards, card)
    return hand_cards[card] >= 2
end

function M.can_angang(hand_cards, card)
    return hand_cards[card] == 4
end

function M.can_gang(hand_cards, card)
    return hand_cards[card] == 3
end

function M.can_chi(hand_cards, card1, card2)
    if not hand_cards[card1] or not hand_cards[card2] then
        return false
    end

    if hand_cards[card1] == 0 or  hand_cards[card2] == 0 then
        return false
    end

    local color1 = CardDefine[hand_cards[card1]] & 0xf0
    local color2 = CardDefine[hand_cards[card2]] & 0xf0

    if color1 ~= color2 then
        return false
    end

    -- 本种花色不能吃
    if not CardType[color1].chi then
        return false
    end

    return true
end

function M.can_left_chi(hand_cards, card)
    return M.can_chi(hand_cards, card + 1, card + 2)
end

function M.can_middle_chi(hand_cards, card)
    return M.can_chi(hand_cards, card - 1, card + 1)
end

function M.can_right_chi(hand_cards, card)
    return M.can_chi(hand_cards, card - 2, card - 1)
end

function M.test()
    local t = M.create()
    M.shuffle(t)
    utils.print(t)
end

return M
