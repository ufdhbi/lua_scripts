local events = require 'samp.events'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local inicfg = require 'inicfg'

local settings = {
    main = {
        delay = 500,
        enable = false,
    },
    forms = {
        ["/mute"] = true,
        ["/unmute"] = true,
        ["/kick"] = true,
        ["/jail"] = true,
        ["/unjail"] = true,
        ["/warn"] = true,
        ["/ban"] = true,
        ["/banip"] = true,
        ["/sban"] = true,
        ["/sethp"] = true,
        ["/spcar"] = true,
        ["/getip"] = true,
        ["/setskin"] = true,
        ["/weap"] = true,
        ["/pgetip"] = true,
        ["/givegun"] = true,
        ["/plveh"] = true,
        ["/trspawn"] = true,
        ["/removetune"] = true,
        ["/aparkcar"] = true,
        ["/skick"] = true,
        ["/jailoff"] = true,
        ["/muteoff"] = true,
        ["/warnoff"] = true,
        ["/unjailoff"] = true,
        ["/ao"] = true,
        ["/uval"] = true,
    }
}

settings = inicfg.load(settings)

function events.onServerMessage(clr, msg)
    if settings.main.enable and msg:find("%[A%] .*%[.*%]:.*") then
        for k, v in pairs(settings.forms) do
            if v then
                if msg:find(k) and not msg:find("/banoff") then
                    lua_thread.create(function()
                        wait(settings.main.delay)
                        sampSendChat(msg:match("%[A%] .*%[.*%]: (.*)"))
                    end)
                end
            end
        end
    end
end

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
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
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
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
    enable = imgui.ImBool(settings.main.enable),
    delay = imgui.ImInt(settings.main.delay)
}

function imgui.OnDrawFrame()
    local rx, ry = getScreenResolution()
    if buffers.window.v then
        imgui.SetNextWindowSize(imgui.ImVec2(400, 300))
        imgui.SetNextWindowPos(imgui.ImVec2(rx/2 - 200, ry/2 - 150))
		imgui.Begin("Admin form settings", buffers.window)
        imgui.BeginChild("Forms", imgui.ImVec2(120, -1), true)
            for k, v in pairs(settings.forms) do
                if v then
                    imgui.TextColored(imgui.ImVec4(0, 0.70, 0, 1), k)
                else
                    imgui.TextColored(imgui.ImVec4(0.70, 0, 0, 1), k)
                end
                if imgui.IsItemClicked() then
                    settings.forms[k] = not settings.forms[k]
                end
            end
        imgui.EndChild()
        imgui.SameLine()
        imgui.BeginGroup()
            if imgui.Checkbox(u8("�������� ������"), buffers.enable) then
                settings.main.enable = buffers.enable.v
            end
            imgui.TextDisabled(u8("�������� ����� ��������� �����"))
            imgui.PushItemWidth(120)
            if imgui.InputInt("##1", buffers.delay) then
                settings.main.delay = buffers.delay.v
            end
            imgui.PopItemWidth()
        imgui.EndGroup()
		imgui.End()
    end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("formset", function() buffers.window.v = not buffers.window.v end)
    while true do
        wait(0)
        imgui.Process = buffers.window.v
    end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
        inicfg.save(settings)
	end
end