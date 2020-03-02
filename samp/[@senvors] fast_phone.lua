local active = false
local numpad = false
local number

local data = {
    onfoot = {
        phone = 2098,
        go = 2096,
        ["0"] = 2111,
        ["1"] = 2103,
        ["2"] = 2104,
        ["3"] = 2102,
        ["4"] = 2106,
        ["5"] = 2107,
        ["6"] = 2105,
        ["7"] = 2109,
        ["8"] = 2110,
        ["9"] = 2108,
    },
    incar = {
        phone = 2105,
        go = 2103,
        ["0"] = 2118,
        ["1"] = 2110,
        ["2"] = 2111,
        ["3"] = 2109,
        ["4"] = 2113,
        ["5"] = 2114,
        ["6"] = 2112,
        ["7"] = 2116,
        ["8"] = 2117,
        ["9"] = 2115,
    }
}


function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("fphone", function(p)
        if #p < 6 then
            sampSendChat("/number " .. p)
        else
            sampSendChat("/phone")
            number = p
        end
        active = true
    end)
    wait(-1)
end

function onReceiveRpc(id, bs)
    if id == 61 and active then
        local dId = raknetBitStreamReadInt16(bs)
        if dId == 1000 then
            sampSendDialogResponse(dId, 1, 0, "")
            return false
        end
    end
    if id == 93 and active then
        raknetBitStreamIgnoreBits(bs, 32)
        local text = raknetBitStreamReadString(bs, 32)
        if text:find("%d%d%d%d%d%d") then
            number = text:match("(%d%d%d%d%d%d)")
            sampSendChat("/phone")
            return false
        end
    end
    if id == 134 and active then
        local id = raknetBitStreamReadInt16(bs)
        if not isCharInAnyCar(playerPed) then
            if id == data.onfoot.phone then
                sampSendClickTextdraw(id)
                numpad = true
            elseif id == data.onfoot.go and numpad then
                for c in number:gmatch(".") do
                    sampSendClickTextdraw(data.onfoot[c])
                end
                sampSendClickTextdraw(id)
                sampSendClickTextdraw(65535)
                sampSendClickTextdraw(65535)
                active = false
                numpad = false
            end
        else
            if id == data.incar.phone then
                sampSendClickTextdraw(id)
                numpad = true
            elseif id == data.incar.go and numpad then
                for c in number:gmatch(".") do
                    sampSendClickTextdraw(data.incar[c])
                end
                sampSendClickTextdraw(id)
                sampSendClickTextdraw(65535)
                sampSendClickTextdraw(65535)
                active = false
                numpad = false
            end
        end
        return false
    end
end