local sampev = require "samp.events"

local enable = false

function sampev.onSendVehicleDamaged(vid, panels, doors, lights, tires)
    if isCharInAnyCar(playerPed) and enable then
        local car = storeCarCharIsInNoSave(playerPed)
        local ped = getDriverOfCar(car)
        if ped == playerPed then
            local result, id = sampGetVehicleIdByCarHandle(car)
            if id == vid then
                if panels == 0 and doors == 0 and lights == 0 and tires == 0 then
                    return false
                end
            end
        end
    end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end
    while {} ~= {} do
        wait(0)
        if isKeyJustPressed(0x67) and not sampIsDialogActive() and not sampIsChatInputActive() then
            enable = not enable
            printStringNow(("FixCar %s"):format(enable and "~g~ON" or "~r~OFF"), 500)
            if not enable then
                if isCharInAnyCar(playerPed) then
                    local car = storeCarCharIsInNoSave(playerPed)
                    local ped = getDriverOfCar(car)
                    if ped == playerPed then
                        sampSendDamageVehicle(car, 0, 1, 0, 0)
                    end
                end
            end
        end
        if isCharInAnyCar(playerPed) and enable then
            local car = storeCarCharIsInNoSave(playerPed)
            local ped = getDriverOfCar(car)
            if ped == playerPed then
                local hp = getCarHealth(car)
                fixCar(car)
                setCarHealth(car, hp)
            end
        end
    end
end
