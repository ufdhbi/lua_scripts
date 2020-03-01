local menu = {}

function menu:create()
    local self = {
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
        }
    }
    local font = renderCreateFont(self.render.font, self.render.size, self.render.flags)

    local function mouseInArea2d(x1, y1, x2, y2)
        local mx, my = getCursorPos()
        return mx >= x1 and mx <= x2 and my >= y1 and my <= y2
    end

    local function button(x, y, text, select)
        renderFontDrawText(font, text, self.padding + x, y + self.padding, mouseInArea2d(x + self.padding, y + self.padding, x + renderGetFontDrawTextLength(font, text), y + renderGetFontDrawHeight(font) + self.padding) and self.render.color.select or self.render.color.default)
        return self.padding + x, self.padding + y, renderGetFontDrawHeight(font) + self.padding, renderGetFontDrawTextLength(font, text) + self.padding
    end

    function self:draw()
        if isKeyDown(0x11) and not sampIsChatInputActive() and not sampIsDialogActive() then
            sampToggleCursor(true)
            renderDrawBoxWithBorder(
                self.position.x,
                self.position.y,
                self.size.x,
                self.size.y,
                self.color_menu.main,
                self.border_size,
                self.color_menu.border
            )
            local rx, ry = self.position.x + self.padding, self.position.y + self.padding
            for i, cmd in ipairs(self.commands) do
                local x, y, h, w = button(rx, ry, cmd[1])
                if isKeyJustPressed(0x01) and mouseInArea2d(x, y, x + w, y + h) then
                    sampProcessChatInput(cmd[1])
                elseif isKeyJustPressed(0x02) and mouseInArea2d(x, y, x + w, y + h) then
                    sampSetChatInputEnabled(true)
                    sampSetChatInputText(cmd[1] .. " ")
                end
                ----------
                if self.commands[i + 1] ~= nil then
                    if not self.commands[i + 1][2] then
                        rx, ry = x + w, ry
                    else
                        rx, ry = self.position.x + self.padding, ry + self.line
                    end
                end
            end
        end
        if wasKeyReleased(0x11) then sampToggleCursor(false) end
    end
    return self
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