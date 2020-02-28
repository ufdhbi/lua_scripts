script_author("SenVorS")
script_version("1.3")

local inicfg = require "inicfg"
local memory = require "memory"
local wp = require 'game.weapons'

local direction = "minHUD\\Settings.ini"
local set = inicfg.load({
	Position = {
		posX = 1006,
		posY = 124
	},
	Settings = {
		font = "COMIC SANS MS",
	}
}, direction)

local weapons_with_clip = {22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 37, 38, 41, 42}
local weapons_without_clip = {25, 33, 34, 35, 36, 39}
local no_shooting_weapons = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 40, 43, 44, 45, 46}

local change_position, chCursor, isSAMP = false
local font_for_render = {nil, nil}
local l_res_x, l_res_y = nil

function createFonts(y)
	for _, v in pairs(font_for_render) do
		if v ~= nil then v = nil end
	end

	local font_flag = require("moonloader").font_flag
	font_for_render[1] = renderCreateFont(set.Settings.font, y * 0.011, font_flag.BOLD + font_flag.BORDER) -- оружие и $
	font_for_render[2] = renderCreateFont(set.Settings.font, y * 0.01, 5) -- бары
end

local isSAMP = isSampLoaded()
function main()
	displayHud(false)
	local _, y = getScreenResolution()
	createFonts(y)

	if isSAMP then
		repeat
			wait(0)
		until isSampAvailable() and sampIsLocalPlayerSpawned()
		sampRegisterChatCommand("hud", function()
			change_position = true;
		end)
	end

	renderHUD()
	wait(-1)
end

function renderHUD()
	local render_off = false
	while true do
		displayHud(false)
		local render_spawn_condition = false
		if isSAMP then 
			render_spawn_condition = sampIsLocalPlayerSpawned() 
		else 
			render_spawn_condition = true
		end
		if render_spawn_condition then
			if testCheat("HUD") and not ((isSampfuncsConsoleActive() or sampIsChatInputActive()) or (render_off or change_position)) then 
				change_position = true
			end
			if sampGetChatDisplayMode() == 0 and isSAMP then 
				render_off = true
			else 
				render_off = false
			end
			
			if not render_off then
				if not change_position then
					if not isKeyDown(121) then
						local res_x, res_y = getScreenResolution()
						if (l_res_x ~= res_x and l_res_y ~= res_x) or (l_res_x == nil and l_res_y == nil) then
							l_res_x = res_x; l_res_y = res_y
							createFonts(res_y)
						end
						local money, ammo = getInfo()
						renderFontDrawText(font_for_render[1], money, set.Position.posX - res_x / 46, set.Position.posY + res_y / 14.7, 0xFFFFFFFF)
						if ammo ~= 0 then
							renderFontDrawText(font_for_render[1], ammo, set.Position.posX  - res_x / (res_x / (res_x / 170)) - res_x / 64, set.Position.posY + res_y / (res_y / (res_y / 11.7)), 0xFFFFFFFF)
						end
						
						drawBar(set.Position.posX - res_x/48, set.Position.posY, res_x / 10.2, res_y / 63, 0xBFDF0101, 0xBF610B0B, 3, font_for_render[2], getCharHealth(PLAYER_PED), res_x, res_y) -- 23
						drawBar(set.Position.posX - res_x/48, set.Position.posY + res_y / 60, res_x / 10.2, res_y / 59, 0xBF1E90FF, 0xBF4682B4, 3, font_for_render[2], getCharArmour(PLAYER_PED), res_x, res_y) -- 50
						drawBar(set.Position.posX - res_x/48, set.Position.posY + res_y / 28, res_x / 10.2, res_y / 61, 0xBFDDA0DD, 0xBFEE82EE, 3, font_for_render[2], getSprintLocalPlayer(), res_x, res_y) -- 77
						drawBar(set.Position.posX - res_x/48,set.Position.posY + res_y / 18.5, res_x / 10.2, res_y / 62, 0xBF98FB98, 0xBF90EE90, 3, font_for_render[2], getWaterLocalPlayer(), res_x, res_y) -- 104
					end
				else
					changeHudPosition(getInfo())
				end
			end
		end
		wait(0)
	end
end

function drawBar(posX, posY, sizeX, sizeY, color1, color2, border_thickness, font, value, res_x, res_y) -- Original: https://blast.hk/threads/13380/#post-136621
	renderDrawBoxWithBorder(posX, posY, sizeX, sizeY, color2, border_thickness, 0xFF000000)
	if value == getCharHealth(PLAYER_PED) or value == getCharArmour(PLAYER_PED) then
		if value < 100 then
	  		renderDrawBox(posX + border_thickness, posY + border_thickness, sizeX/100 * value - (border_thickness * 2), sizeY - (2 * border_thickness), color1)
		else
			renderDrawBox(posX + border_thickness, posY + border_thickness, sizeX/100 * (value/(value * 0.01)) - (border_thickness * 2), sizeY - (2 * border_thickness), color1)
		end
	elseif value == getSprintLocalPlayer() or value == getWaterLocalPlayer() then
		renderDrawBox(posX + border_thickness, posY + border_thickness, sizeX / 100 * value - (border_thickness * 2), sizeY - (2 * border_thickness), color1)
	end

	value = tostring(value)..""
	local text_height = renderGetFontDrawHeight(font)
	if not change_position then
		renderFontDrawText(font, value, set.Position.posX - res_x / 54 + 0.5, posY + (sizeY/2.2) - (text_height/2) - 0.5, 0xFFFFFFFF)
	else
		local mouse_pos_x, _ = getCursorPos()
		renderFontDrawText(font, value, mouse_pos_x - res_x / 54 + 0.5, posY + (sizeY/2) - (text_height/2) - 0.5, 0xFFFFFFFF)
	end
end

function getInfo()
	local ammo
	local money = getPlayerMoney(PLAYER_HANDLE)
	if money >= 1000 then
		money = string.format("$%s", moneyClasses(tostring(money)))
	else
		money = string.format("$%s", money)
	end
	local weapon = getCurrentCharWeapon(PLAYER_PED)
	local ammo = getAmmoInCharWeapon(PLAYER_PED, weapon)

	for _, v in pairs(weapons_with_clip) do
		if weapon == v then
			local ammoInClip = getAmmoInClip()
			ammo = string.format("%s / %d(%s)", wp.get_name(weapon), ammoInClip, (ammo - ammoInClip))
			break
		else
			for _, v in pairs(weapons_without_clip) do
				if weapon ~= v then
					ammo = ammo
					break
				end
			end
			for _, v in pairs(no_shooting_weapons) do
				if weapon == v then 
					ammo = "" 
				end
			end
		end
	end
	return money, ammo
end

function moneyClasses(a) -- Original: https://blast.hk/threads/13380/page-3#post-220949
    local b, e = ('%d'):format(a):gsub('^%-', '')
    local c = b:reverse():gsub('%d%d%d', '%1.')
    local d = c:reverse():gsub('^%.', '')
    return (e == 1 and '-' or '')..d
end

function getAmmoInClip() -- Original: https://blast.hk/threads/13380/post-127831
    local pointer = getCharPointer(playerPed)
    local weapon = getCurrentCharWeapon(playerPed)
    local slot = getWeapontypeSlot(weapon)
    local cweapon = pointer + 0x5A0
    local current_cweapon = cweapon + slot * 0x1C
    return memory.getuint32(current_cweapon + 0x8)
end

function getSprintLocalPlayer() -- Original: https://blast.hk/threads/13380/post-192584
	local float = memory.getfloat(0xB7CDB4)
	if float > 0 then
		return math.floor(float/31.47000244)
	else
		return 0
	end
end

function getWaterLocalPlayer() -- Original: https://blast.hk/threads/13380/post-192584
    local float = memory.getfloat(0xB7CDE0)
    return math.floor(float/39.97000244)
end

function changeHudPosition()
	local mouse_pos_x, mouse_pos_y, res_x, res_y

	if isSAMP then
		if not sampIsCursorActive() then sampSetCursorMode(2) end
	else
		showCursor(true, true)
	end
	repeat
		if isSAMP and sampGetCursorMode() ~= 2 then 
			sampSetCursorMode(2)
		end
		mouse_pos_x, mouse_pos_y = getCursorPos()
		res_x, res_y = getScreenResolution()
		local money, ammo = getInfo()
		renderFontDrawText(font_for_render[1], money, mouse_pos_x - res_x / 46, mouse_pos_y + (res_y / 14.7), 0xFFFFFFFF)
		if ammo ~= 0 then
			renderFontDrawText(font_for_render[1], ammo, mouse_pos_x - res_x / (res_x / (res_x / 170)) - res_x / 64, mouse_pos_y + res_y / (res_y / (res_y / 11.7)), 0xFFFFFFFF)
		end

		drawBar(mouse_pos_x - res_x/48, mouse_pos_y, res_x / 10.2, res_y / 63, 0xBFDF0101, 0xBF610B0B, 3, font_for_render[2], getCharHealth(PLAYER_PED), res_x, res_y) -- 23
		drawBar(mouse_pos_x - res_x/48, mouse_pos_y + res_y / 60, res_x / 10.2, res_y / 59, 0xBF1E90FF, 0xBF4682B4, 3, font_for_render[2], getCharArmour(PLAYER_PED), res_x, res_y) -- 50
		drawBar(mouse_pos_x - res_x/48, mouse_pos_y + res_y / 28, res_x / 10.2, res_y / 61, 0xBFDDA0DD, 0xBFEE82EE, 3, font_for_render[2], getSprintLocalPlayer(), res_x, res_y) -- 77
		drawBar(mouse_pos_x - res_x/48, mouse_pos_y + res_y / 18.5, res_x / 10.2, res_y / 62, 0xBF98FB98, 0xBF90EE90, 3, font_for_render[2], getWaterLocalPlayer(), res_x, res_y) -- 104
		wait(0)
	until isKeyJustPressed(2) or sampIsChatInputActive()

	if isSAMP then
		sampSetCursorMode(0)
	else
		showCursor(false, false)
	end
	set.Position.posX = mouse_pos_x
	set.Position.posY = mouse_pos_y
	inicfg.save(set, direction)
	change_position = false
	renderHUD()
end