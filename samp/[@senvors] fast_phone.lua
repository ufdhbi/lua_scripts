local active, numpad, number

local data = {
    onfoot = {
        phone = 2099, go = 2097, ["0"] = 2112,
        ["1"] = 2105, ["2"] = 2103, ["3"] = 2104,
        ["4"] = 2108, ["5"] = 2106, ["6"] = 2107,
        ["7"] = 2111, ["8"] = 2109, ["9"] = 2110,
    },
    incar = {
        phone = 2105, go = 2103, ["0"] = 2118,
        ["1"] = 2110, ["2"] = 2111, ["3"] = 2109,
        ["4"] = 2113, ["5"] = 2114, ["6"] = 2112,
        ["7"] = 2116, ["8"] = 2117, ["9"] = 2115,
    }
}


function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("fphone", function(p)
        sampSendChat("/phone")
        number = p
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
        if id == (isCharInAnyCar(playerPed) and data.incar.phone or data.onfoot.phone) then
            sampSendClickTextdraw(id)
            numpad = true
        elseif id == (isCharInAnyCar(playerPed) and data.incar.go or data.onfoot.go) and numpad then
            for c in number:gmatch(".") do
                sampSendClickTextdraw(isCharInAnyCar(playerPed) and data.incar[c] or data.onfoot[c])
            end
            sampSendClickTextdraw(id)
            sampSendClickTextdraw(65535)
            sampSendClickTextdraw(65535)
            active = false
            numpad = false
        end
        return false
    end
end