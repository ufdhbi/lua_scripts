script_name('DrawTextDrawID')
function main() 
	if not isSampfuncsLoaded() or not isSampLoaded() then return end 
	while not isSampAvailable() do wait(100) end 
	local font = renderCreateFont("Arial", 8, 5)
	sampRegisterChatCommand("DrawTD", show)  
	while true do 
	wait(0)
		if toggle then 
			for a = 0, 2304	do
				if sampTextdrawIsExists(a) then 
					x, y = sampTextdrawGetPos(a)
					x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y) 
					renderFontDrawText(font, a, x1, y1, 0xFFBEBEBE)
				end
			end
		end
	end
end

function show()
toggle = not toggle
end