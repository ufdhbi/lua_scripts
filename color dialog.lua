local sampev = require "samp.events"

function sampev.onShowDialog(id, style, title, b1, b2, text)
    if title:find("MainMenu") then
        local result = {}
        for line in text:gmatch("[^\r\n]+") do
            table.insert(result, line)
            if line:find("вращение") then
                result[#result] = line:gsub("{......}", "{FF0000}")
            end
        end
        return {id, style, title, b1, b2, table.concat(result, "\n")}
    end
end
