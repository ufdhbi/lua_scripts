local menu = {}

function menu:create()
    local data = {
        position = {x = 75, y = 240},
        size = {x = 165, y = 410},
        color_menu = {main = 0xFF14141F, border = 0xFF111111},
        border_size = 3,
        render = {font = "Comic Sans MS", size = 9, flags = 5, color = {default = 0xFFCCCCCC, select = 0xFFDC143C}},
        padding = 7,
        line = 20,
        commands = {
          -- команда, true - переносить на новую строку / false - не переносить
            {"/MENU", false},
            {"/GPS", true},
            {"/INVENT", true},
            {"/PHONE", false},
            {"/NUMBER", false},
            {"/PHH", false},
            {"/VR", false},
            {"/FAM", false},
            {"/FAMMENU", false},
            {"/OPENBOX", false},
            {"/REPORT", false},
            {"/HELP", false},
            {"/EAT", false},
            {"/SPRUNK", false},
            {"/QUEST", false},
            {"/ANIMS", false},
            {"/PAY", false},
            {"/TRADE", false},
            {"/FINDIHOUSE", false},
            {"/FINDIBIZ", false},
            {"/SHOWPASS", false},
            {"/CARPASS", false},
            {"/HOUSE", false},
            {"/REPCAR", false},
            {"/FILLCAR", false},
        },
        active = false
    }
    local font = renderCreateFont(data.render.font, data.render.size, data.render.flags)

    local function mouseInArea2d(x1, y1, x2, y2)
        local mx, my = getCursorPos()
        return mx >= x1 and mx <= x2 and my >= y1 and my <= y2
    end

    local function button(x, y, text, select)
        renderFontDrawText(font, text, data.padding + x, y + data.padding, mouseInArea2d(x + data.padding, y + data.padding, x + renderGetFontDrawTextLength(font, text), y + renderGetFontDrawHeight(font) + data.padding) and data.render.color.select or data.render.color.default)
        return data.padding + x, data.padding + y, renderGetFontDrawHeight(font) + data.padding, renderGetFontDrawTextLength(font, text) + data.padding
    end

    function data:draw()
        if isKeyDown(0x11) and not sampIsChatInputActive() and not sampIsDialogActive() then
            sampToggleCursor(true)
            data.active = true
            renderDrawBoxWithBorder(
                data.position.x,
                data.position.y,
                data.size.x,
                data.size.y,
                data.color_menu.main,
                data.border_size,
                data.color_menu.border
            )
            local rx, ry = data.position.x + data.padding, data.position.y + data.padding
            for i, cmd in ipairs(data.commands) do
                local x, y, h, w = button(rx, ry, cmd[1])
                if isKeyJustPressed(0x01) and mouseInArea2d(x, y, x + w, y + h) then
                    sampProcessChatInput(cmd[1])
                elseif isKeyJustPressed(0x02) and mouseInArea2d(x, y, x + w, y + h) then
                    sampSetChatInputEnabled(true)
                    sampSetChatInputText(cmd[1] .. " ")
                end
                ----------
                if data.commands[i + 1] ~= nil then
                    if not data.commands[i + 1][2] then
                        rx, ry = x + w, ry
                    else
                        rx, ry = data.position.x + data.padding, ry + data.line
                    end
                end
            end
        end
        if wasKeyReleased(0x11) and data.acitve then sampToggleCursor(false) data.active = false end
    end

    return data
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end
    local main_menu = menu:create()
    while true do
        wait(0)
        main_menu:draw()
    end
end