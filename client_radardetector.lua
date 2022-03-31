--RadarDetector by Brentopc
--Version 0.9.2

CreateThread(function() GetConfig("RadarDetector", function(ResourceConfig)
	if ResourceConfig and ResourceConfig.ScriptEnabled then	
	
		local ESX, vehiclePlate, beepWait, isNearRadar, distanceToRadar, radarRange = nil, nil, 2000, false, 0, 0
			
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(100)
		end
			
		local function IsRunningRadar()
			if exports["wk_wars2x"]:IsEitherAntennaOn() and exports["wk_wars2x"]:GetDisplayState() and IsDrivingVehicle() then 
				return true
			else
				return false
			end
		end
		
		RegisterCallback("RadarDetector:Client:isRunningRadar", function()
			if PlayerPedId() then
				return IsRunningRadar(), GetEntityCoords(PlayerPedId())
			else
				return false, nil
			end
		end)

		--[RadarDetector] Radar detection
		CreateThread(function()			
			
			while ResourceConfig.ScriptEnabled do
				Citizen.Wait(3000)
				isNearRadar, distanceToRadar, radarRange = false, 0, 0
			
				if PlayerPedId() then				
					while not IsRunningRadar() and IsDrivingVehicle() do				
						isNearRadar, distanceToRadar, radarRange = TriggerCallback("RadarDetector:Server:isNearRadar", GetEntityCoords(PlayerPedId()))
										
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
						
						TriggerServerEvent('RadarDetector:Server:SendRadarLocation', GetEntityCoords(PlayerPedId()))
					end
				end
			end
			
		end)
		
		--[RadarDetector] Beep handler
		CreateThread(function()
		
			local timer = beepWait
				
			while ResourceConfig.ScriptEnabled do
				if not IsRunningRadar() and IsDrivingVehicle() then
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
			end
				
		end)
	else
		LogError("Could not get config for "..ResourceConfig.ScriptName.." or script is disabled")
	end	
end) end)