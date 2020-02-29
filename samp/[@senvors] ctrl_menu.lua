local menu = {}

function menu:create()
    local data = {
        position = {x = 5, y = 300},
        size = {x = 50, y = 300},
        color_menu = {main = 0xFF111111, border = 0xFF111111},
        border_size = 1,
        render = {font = "Arial", size = 11, flags = 5, color = {default = 0xFFCCCCCC, select = 0xFFDC143C}},
        padding = 2,
        commands = {
            "/mm",
            "/loh",
            "/sms"
        }
    }
    local font = renderCreateFont(data.render.font, data.render.size, data.render.flags)

    local function mouseInArea2d(x1, y1, x2, y2)
        local mx, my = getCursorPos()
        return mx >= x1 and mx <= x2 and my >= y1 and my <= y2
    end

    local function button(x, y, text, select)
        renderFontDrawText(font, text, data.padding + x, data.padding + y, mouseInArea2d(x, y, x + renderGetFontDrawTextLength(font, text) + data.padding, y + renderGetFontDrawHeight(font) + data.padding) and data.render.color.select or data.render.color.default)
        return data.padding + x, data.padding + y, renderGetFontDrawHeight(font) + data.padding, renderGetFontDrawTextLength(font, text) + data.padding
    end

    function data:draw()
        if isKeyDown(0x11) and not sampIsChatInputActive() and not sampIsDialogActive() then
            sampToggleCursor(true)
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
                local x, y, h, w = button(rx, ry, cmd)
                if isKeyJustPressed(0x01) and mouseInArea2d(x, y, x + w, y + h) then
                    sampProcessChatInput(cmd)
                elseif isKeyJustPressed(0x02) and mouseInArea2d(x, y, x + w, y + h) then
                    sampSetChatInputEnabled(true)
                    sampSetChatInputText(cmd .. " ")
                end
                ----------
                if data.commands[i + 1] ~= nil then
                    if data.padding * 4 + x + w + renderGetFontDrawTextLength(font, data.commands[i + 1]) <= data.size.x then
                        rx, ry = data.padding * 2 + x + w, ry
                    else
                        rx, ry = data.position.x + data.padding, ry + 15
                    end
                end
            end
        end
        if wasKeyReleased(0x11) then sampToggleCursor(false) end
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