script_name("Admin Checker")
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local events = require 'samp.events'

local admins = {}

local imgui_window = {
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

imgui_window.style_dark()

function imgui.OnDrawFrame()
	if imgui_window.bEnable then
		local sw, sh = getScreenResolution()
		imgui.Begin('##' .. thisScript().name, imgui_window.bEnable, imgui_window.property)
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8(("%s [����� ������: %s]"):format(thisScript().name, #getOnlineAdmins()))).x) / 2);
        imgui.TextColored(imgui_window.colorTitle, u8(("%s [����� ������: %s]"):format(thisScript().name, #getOnlineAdmins())));
		imgui.NewLine()
		imgui.Columns(2, _, false)
		imgui.SetColumnWidth(-1, 180)
		imgui.Text("Nickname[ID]")
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 30)
		imgui.Text(u8("LVL"))
		imgui.NextColumn()
		imgui.Separator()
		for _, admin in ipairs(getOnlineAdmins()) do
			imgui.SetColumnWidth(-1, 180)
			imgui.TextColored(imgui.ImVec4(getColor(admin[3])), u8('%s[%s]'):format(admin[1], admin[3]))
			if imgui.IsItemClicked(1) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/sms ' .. admin[3] .. " ")
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(450.0)
				imgui.TextColored(imgui.ImVec4(getColor(admin[3])), u8("%s\n�������: %s"):format(admin[1], sampGetPlayerScore(admin[3])))
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.NextColumn()
			imgui.SetColumnWidth(-1, 30)
			imgui.Text(tostring(admin[2]))
		end
		imgui.Columns(1)
		imgui.NewLine()
		imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.15), u8('����� � �������'))
		if imgui.IsItemClicked() then
			os.execute("start https://vk.me/gfrtgf")
		end
		imgui.SetWindowPos('##' .. thisScript().name, imgui.ImVec2(sw/2 - imgui.GetWindowSize().x/2, sh/2 - imgui.GetWindowSize().y/2))
		imgui.SetWindowSize('##' .. thisScript().name, imgui.ImVec2(250, -1))
		imgui.End()
	end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
	sampRegisterChatCommand("checkadm", function() imgui_window.bEnable.v = not imgui_window.bEnable.v end)
	for line in io.lines("moonloader//admins.txt") do
		local nickname, lvl = line:match("(.+) (.+)")
		table.insert(admins, {nickname, lvl})
	end
    while {} ~= {} do
		wait(0)
		imgui.Process = imgui_window.bEnable.v
    end
end

function getOnlineAdmins()
	local result = {}
	for i = 0, 1004 do
		if sampIsPlayerConnected(i) then
			for _, admin in ipairs(admins) do
				if admin[1]:find(sampGetPlayerNickname(i)) then
					table.insert(result, {admin[1], admin[2], i})
				end
			end
		end
	end
	return result
end

function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if (wparam == 0x1B and imgui_window.bEnable.v) and not isPauseMenuActive() then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
                imgui_window.bEnable.v = false
            end
		end
    end
end

function getColor(id)
	playerColor = sampGetPlayerColor(id)
	a, r, g, b = explode_argb(playerColor)
	return r/255, g/255, b/255, 1
end

function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end