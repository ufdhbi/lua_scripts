local events = require "samp.events"
local imgui = require "imgui"
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
local inicfg = require "inicfg"

local settings = {
    position = {x = 0, y = 0},
    size = {x = 0, y = 0}
}

settings = inicfg.load(settings)

local data = {
    ids = {},
    messages = {}
}

local msg = {false}

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(5, 5)
    style.WindowRounding = 3.0
    style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
    style.GrabRounding = 3.0

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 0.80)
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
    colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()

buffers = {
    window = imgui.ImBool(false),
    set = false,
    settting = false,
    input1 = imgui.ImBuffer(16)
}

function imgui.OnDrawFrame()
    if buffers.window.v then
        if not buffers.set then
            imgui.SetNextWindowPos(imgui.ImVec2(settings.position.x, settings.position.y))
            imgui.SetNextWindowSize(imgui.ImVec2(settings.size.x, settings.size.y))
            buffers.set = true
        end
        imgui.Begin("Chat Reader", buffers.window)
        if buffers.settings then
            if imgui.Button("CHAT", imgui.ImVec2(55, 23)) then
                buffers.settings = false
            end
            imgui.TextDisabled(u8("Список ID:"))
            if msg[1] then
                imgui.SameLine()
                imgui.TextColored(msg[2], u8(msg[3]))
            end
            for k, v in ipairs(data.ids) do
                if sampIsPlayerConnected(v) then
                    imgui.TextColored(getColor(sampGetPlayerColor(v)), ("%s[%s]"):format(sampGetPlayerNickname(v), v))
                    if imgui.IsItemClicked() then
                        table.remove(data.ids, k)
                        lua_thread.create(
                            function()
                                msg = {true, imgui.ImVec4(0, 0.8, 0, 1), "Указанный ID удален!", 500}
                                wait(msg[4])
                                msg = {false}
                            end
                        )
                    end
                else
                    table.remove(data.ids, k)
                    lua_thread.create(
                        function()
                            msg = {
                                true,
                                imgui.ImVec4(0.8, 0, 0, 1),
                                "Игрок с ID " .. v .. " отключился и был удален из списка",
                                2000
                            }
                            wait(msg[4])
                            msg = {false}
                        end
                    )
                end
            end
        else
            imgui.PushItemWidth(30)
            imgui.InputText("##input", buffers.input1)
            imgui.PopItemWidth()
            imgui.SameLine()
            if imgui.Button("ADD ID", imgui.ImVec2(55, 23)) then
                local id = buffers.input1.v:match("(%d+)")
                if tonumber(id) ~= nil then
                    if sampIsPlayerConnected(tonumber(id)) then
                        local add = true
                        for k, v in ipairs(data.ids) do
                            if v == tonumber(id) then
                                add = false
                            end
                        end
                        if add then
                            table.insert(data.ids, tonumber(id))
                            lua_thread.create(
                                function()
                                    msg = {
                                        true,
                                        imgui.ImVec4(0, 0.8, 0, 1),
                                        ("%s[%s] успешно добавлен!"):format(
                                            sampGetPlayerNickname(tonumber(id)),
                                            tonumber(id)
                                        ),
                                        500
                                    }
                                    wait(msg[4])
                                    msg = {false}
                                end
                            )
                        else
                            lua_thread.create(
                                function()
                                    msg = {true, imgui.ImVec4(0.8, 0, 0, 1), "Указанный игрок уже есть в списке!", 500}
                                    wait(msg[4])
                                    msg = {false}
                                end
                            )
                        end
                    else
                        lua_thread.create(
                            function()
                                msg = {true, imgui.ImVec4(0.8, 0, 0, 1), "Указанный игрок не подключен к серверу!", 500}
                                wait(msg[4])
                                msg = {false}
                            end
                        )
                    end
                else
                    lua_thread.create(
                        function()
                            msg = {true, imgui.ImVec4(0.8, 0, 0, 1), "Неправильно указан ID!", 500}
                            wait(msg[4])
                            msg = {false}
                        end
                    )
                end
            end
            imgui.SameLine()
            if imgui.Button("CLEAR", imgui.ImVec2(55, 23)) then
                data.messages = {}
            end
            imgui.SameLine()
            if imgui.Button("CHAT", imgui.ImVec2(55, 23)) then
                buffers.settings = false
            end
            imgui.SameLine()
            if imgui.Button("IDS", imgui.ImVec2(55, 23)) then
                buffers.settings = true
            end
            if msg[1] then
                imgui.SameLine()
                imgui.TextColored(msg[2], u8(msg[3]))
            end
            imgui.Separator()
            for k, v in ipairs(data.messages) do
                imgui.TextColored(getColor(v[2]), u8(v[1]))
            end
            settings.position.x, settings.position.y = imgui.GetWindowPos().x, imgui.GetWindowPos().y
            settings.size.x, settings.size.y = imgui.GetWindowSize().x, imgui.GetWindowSize().y
        end
        imgui.End()
    end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end
    while true do
        wait(0)
        imgui.Process = buffers.window.v
        if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(0x60) then
            buffers.window.v = not buffers.window.v
        end
    end
end

function onScriptTerminate(script, quitGame)
    if script == thisScript() then
        inicfg.save(settings)
    end
end

local triggers = {
    "%[Транспорт%] NICK говорит:.+",
    "NICK говорит по телефону:.+",
    "%{BB9CD2%}Чихание. %(%( NICK %)%)",
    "NICK шепчет:.+",
    "%{BB9CD2%}NICK чихнул"
}

function events.onServerMessage(clr, msg)
    for _, v in ipairs(triggers) do
        if msg:find(v) then
            local nick = msg:match(v:gsub("NICK", "(.+)"))
            if nick ~= nil then
                for i = 0, 500 do
                    if sampIsPlayerConnected(i) then
                        if nick == sampGetPlayerNickname(i) then
                            for _, v in ipairs(data.ids) do
                                if v == i then
                                    table.insert(data.messages, msg:gsub("{......}", ""), clr)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function events.onPlayerChatBubble(id, color, dist, dur, text)
    for k, v in ipairs(data.ids) do
        if id == v then
            table.insert(data.messages, {("%s[%s]: %s"):format(sampGetPlayerNickname(id), id, text), color})
        end
    end
end

function getColor(color)
    a, r, g, b = explode_argb(color)
    return imgui.ImVec4(r / 255, g / 255, b / 255, 1)
end

function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end
