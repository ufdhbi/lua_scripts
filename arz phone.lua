local events = require 'samp.events'
local enable = false

function events.onShowTextDraw(id, data)
    if enable then
        if id == 2096 or id == 2138 then
            sampSendClickTextdraw(id)
        end
        return false
    end
end

function events.onShowDialog(id)
    if enable then
        if id == 1000 then
            sampSendDialogResponse(id, 1, 0, "")
        end
        if id == 966 then
            sampSendDialogResponse(id, 1, 10, "")
        end
        if id == 0 then
            sampSendClickTextdraw(65535)
            sampSendClickTextdraw(65535)
            enable = false
            return true
        end
        return false
    end
end



function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("sphone", function()
        enable = true
        sampSendChat("/phone")
    end)
    wait(-1)
end