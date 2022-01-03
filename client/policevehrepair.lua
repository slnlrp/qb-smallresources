local policeVehicleRepairerLocation = vector3(431.39, -1021.21, 28.83)
local nearDefault = false

local function isNear(pos1, pos2, distMustBe)
    local diff = pos2 - pos1
    local dist = (diff.x * diff.x) + (diff.y * diff.y)

    return (dist < (distMustBe * distMustBe))
end

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextOutline()
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        --local factor = (string.len(text)) / 370
		--DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 100)
      end
  end

function isAuthorizedVehicle(vehicle)
    -- local model = vehicleModelName.lower()
    if GetVehicleClass(vehicle) == 18 then
        return true
    else
        return false
    end
end

Citizen.CreateThread(function()

    while true do
        local plyPed = PlayerPedId()
        local Player = QBCore.Functions.GetPlayerData()

        if IsPedInAnyVehicle(plyPed, false) and Player.job.name == 'police' then
            local plyPos = GetEntityCoords(plyPed)
            nearDefault = isNear(plyPos, policeVehicleRepairerLocation, 5)
            local plyVeh = GetVehiclePedIsIn(plyPed, false)
            --local vehicleModelName = GetDisplayNameFromVehicleModel(GetEntityModel(plyVeh))

            if nearDefault and isAuthorizedVehicle(plyVeh) then
                DrawMarker(2, policeVehicleRepairerLocation.x, policeVehicleRepairerLocation.y,
                policeVehicleRepairerLocation.z + 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 222, false, false, false, true, false, false, false)
                DrawText3D(policeVehicleRepairerLocation.x, policeVehicleRepairerLocation.y,
                    policeVehicleRepairerLocation.z + 0.5, "[Press ~p~E~w~ - Repair Police Vehicle]")
                if IsControlJustReleased(1, 38) then
                    SetVehicleFixed(plyVeh)
                    SetVehicleDirtLevel(plyVeh, 0.0)
                    SetVehiclePetrolTankHealth(plyVeh, 4000.0)
                    TriggerEvent('veh.randomDegredation',10,plyVeh,3)
                end
            else
                Wait(1000)
            end
        end

        Citizen.Wait(1)
    end

end)

