CreateThread(function() GetConfig("VehicleAccessories", function(ResourceConfig)
	if ResourceConfig and ResourceConfig.ScriptEnabled then	
	
		local KBandLocations = ResourceConfig.KBandFakeLocations
		local KaBandLocations = {}
	
		local ESX = nil
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(100)
		end
		
		RegisterNetEvent('VehicleAccessories:Server:SendRadarLocation')
		AddEventHandler('VehicleAccessories:Server:SendRadarLocation', function(playerPosition)
			local _source = tonumber(source)
			local playerName = GetPlayerName(_source)
			
			KBandLocations[playerName] = playerPosition
			KaBandLocations[playerName] = playerPosition
		end)
		
		RegisterCallback("VehicleAccessories:Server:isNearRadar", function(playerPosition)	
			if ResourceConfig.KBandRange > 0 then
				for i, KBandLocation in pairs(KBandLocations) do				
					if KBandLocation ~= nil then
						local distance = math.abs(#(KBandLocation - playerPosition))
						if distance < ResourceConfig.KBandRange and distance > 0 then
							return true, distance, ResourceConfig.KBandRange
						end
					end
				end
			end
			
			if ResourceConfig.KaBandRange > 0 then
				for i, KaBandLocation in pairs(KaBandLocations) do
					if KaBandLocation ~= nil then
						local distance = math.abs(#(KaBandLocation - playerPosition))
						--LogDebug(ResourceConfig.ScriptName, KaBandLocation .. " - " .. playerPosition .. " = " .. distance)
						if distance < ResourceConfig.KaBandRange and distance > 0 then
							return true, distance, ResourceConfig.KaBandRange
						end
					end
				end
			end
			
			return false, 0
		end)
			
		while ResourceConfig.ScriptEnabled do	
			Citizen.Wait(5000)
			KBandLocations = ResourceConfig.KBandFakeLocations
			KaBandLocations = {}
			
			for _, playerId in ipairs(GetPlayers()) do
				local playerId = tonumber(playerId)
				local playerName = GetPlayerName(playerId)
				local isRunningRadar, playerPosition = TriggerCallback("VehicleAccessories:Client:isRunningRadar", playerId)

				if isRunningRadar then
					KBandLocations[playerName] = playerPosition
					KaBandLocations[playerName] = playerPosition
				else
					KBandLocations[playerName] = nil
					KaBandLocations[playerName] = nil
				end
			end			
		end
		
	else
		LogError("Could not get config for "..ResourceConfig.ScriptName.." or script is disabled")	
	end	
end) end)