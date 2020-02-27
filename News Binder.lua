script_name("News Binder")
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local inicfg = require 'inicfg'

local playerData = {}

function playerData:new(id)

    local data = {
        id = id,
        nickname = sampGetPlayerNickname(id),
        lvl = sampGetPlayerScore(id)
    }

    setmetatable(data, self)
    self.__index = self

    return data
end

imgui_window = {
    bEnable = imgui.ImBool(false),
	property = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove,
    style_dark = function()
        local style = imgui.GetStyle()
        local colors = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
        colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 0.90)
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
    end,
	colorTitle = imgui.ImVec4(0.86, 0.07, 0.23, 1.00),
	size = imgui.ImVec2(670, 300)
}


local data = {
    ["Собеседование"] = {
        "Вопрос 1",
        "Вопрос 2",
        "Вопрос 3",
    },
    ["Принять в организацию"] = {
        "Вопрос 1",
        "Вопрос 2",
        "Вопрос 3",
    },
    ["Уволить из организации"] = {
        "Вопрос 1",
        "Вопрос 2",
        "/uninvite *ID*",
    }
}

local data = inicfg.load(data)

local state = "main"

imgui_window.style_dark()

function imgui.OnDrawFrame()
	if imgui_window.bEnable then
		local sw, sh = getScreenResolution()
		imgui.Begin('##' .. thisScript().name, imgui_window.bEnable, imgui_window.property)
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("%s | %s"):format(thisScript().name, u8(state))).x) / 2);
        imgui.TextColored(imgui_window.colorTitle, ("%s | %s"):format(thisScript().name, u8(state)));
        imgui.Spacing()
        imgui.Spacing()
        if state == 'main' then
            for k, v in pairs(data) do
                if imgui.Button(u8(k), imgui.ImVec2(-1, 23)) then
                    state = k
                end
            end
        else
            for k, v in ipairs(data[state]) do
                if imgui.Button(u8(v), imgui.ImVec2(-1, 23)) then
                    sampSendChat(v:gsub("*ID*", target.id))
                end
            end
        end
		imgui.SetWindowPos('##' .. thisScript().name, imgui.ImVec2(sw/2 - imgui.GetWindowSize().x/2, sh/2 - imgui.GetWindowSize().y/2))
		imgui.SetWindowSize('##' .. thisScript().name, imgui.ImVec2(400, -1))
		imgui.End()
	end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    while true do
        wait(0)
        imgui.Process = imgui_window.bEnable.v
        local result, ped = getCharPlayerIsTargeting()
        if result and isKeyJustPressed(0x48) then
            local _, id = sampGetPlayerIdByCharHandle(ped)
            target = playerData:new(id)
            imgui_window.bEnable.v = true
        end
    end
end

function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if (wparam == 0x1B and imgui_window.bEnable.v) and not isPauseMenuActive() then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
                if state == 'main' then
                    imgui_window.bEnable.v = false
                else
                    state = 'main'
                end
            end
		end
    end
end

function imgui.cText(str)
    imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(str).x) / 2);
    imgui.Text(str);
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
        inicfg.save(data)
	end
end