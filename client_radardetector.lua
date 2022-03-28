local ESX, vehiclePlate, beepWait, isNearRadar, distanceToRadar, radarRange = nil, nil, 2000, false, 0, 0

--[Radar Detector] Radar detection
CreateThread(function() GetConfig("VehicleAccessories", function(ResourceConfig)
	if ResourceConfig and ResourceConfig.ScriptEnabled then	

		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(100)
		end
	
		local function IsDrivingVehicle()
			if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then 
					return true
				else
					return false
				end
			else
				return false
			end
		end
		
		local function IsRunningRadar()
			if exports["wk_wars2x"]:IsEitherAntennaOn() and exports["wk_wars2x"]:GetDisplayState() and IsDrivingVehicle() then 
				--LogDebug(ResourceConfig.ScriptName, IsRunningRadar())
				return true
			else
				return false
			end
		end
		
		RegisterCallback("VehicleAccessories:Client:isRunningRadar", function()
			return IsRunningRadar(), GetEntityCoords(PlayerPedId())
		end)
		
		while ResourceConfig.ScriptEnabled do
			Citizen.Wait(3000)
			isNearRadar, distanceToRadar, radarRange = false, 0, 0
		
			while not IsRunningRadar() and IsDrivingVehicle() do				
				isNearRadar, distanceToRadar, radarRange = TriggerCallback("VehicleAccessories:Server:isNearRadar", GetEntityCoords(PlayerPedId()))
								
				if isNearRadar then
					Citizen.Wait(50)
				
					beepWait = math.clamp(((distanceToRadar * 2) / (radarRange - 100)), 0.35, 5.0) * 1000
					--LogDebug(ResourceConfig.ScriptName, distanceToRadar .. " " .. beepWait)					
				else
					Citizen.Wait(500)
				
					beepWait = 2000
				end	
			end
			
			while IsRunningRadar() and IsDrivingVehicle() do	
				Citizen.Wait(500)
				
				TriggerServerEvent('VehicleAccessories:Server:SendRadarLocation', GetEntityCoords(PlayerPedId()))
			end
		end
	
	else
		LogError("Could not get config for "..ResourceConfig.ScriptName.." or script is disabled")
	end	
end) end)

--[Radar Detector] Beep handler
CreateThread(function() GetConfig("VehicleAccessories", function(ResourceConfig)
	if ResourceConfig.ScriptEnabled then	
	
		local timer = beepWait
		
		while ResourceConfig.ScriptEnabled do
			if not isNearRadar then
				Citizen.Wait(1000)
				timer = beepWait
			else
				TriggerServerEvent("Server:SoundToRadius", NetworkGetNetworkIdFromEntity(PlayerPedId()), 5.0, "radarbeep", 0.05)
				
				timer = beepWait
				while timer > 0 do
					Citizen.Wait(timer/10)
					timer = timer - 100	

					if beepWait < timer - 100 then
						timer = beepWait
					end
				end
				
				timer = beepWait								
			end			
		end
	
	else
		LogError("Could not get config for "..ResourceConfig.ScriptName.." or script is disabled")
	end
end) end)