local sampev = require "samp.events"

function sampev.onSetPlayerFightingStyle(id, style)
    local myId = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    if id == myId then
        print("—ервер пыталс€ установить вам стиль бо€ " .. style)
        return {id, 15}
    end
end
