--RadarDetector by Brentopc
--Version 0.9.2

CreateThread(function() GetConfig("RadarDetector", function(ResourceConfig)
	if ResourceConfig and ResourceConfig.ScriptEnabled then	
	
		local KBandLocations = ResourceConfig.KBandFakeLocations
		local KaBandLocations = {}
	
		local ESX = nil
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(100)
		end
		
		RegisterNetEvent('RadarDetector:Server:SendRadarLocation')
		AddEventHandler('RadarDetector:Server:SendRadarLocation', function(source, playerPosition)
			local _source = tonumber(source)
			local playerName = GetPlayerName(_source)
			
			KBandLocations[playerName] = playerPosition
			KaBandLocations[playerName] = playerPosition
		end)
		
		RegisterCallback("RadarDetector:Server:isNearRadar", function(source, playerPosition)
			local _source = tonumber(source)
			
			if ResourceConfig.KBandRange > 0 then
				local closestDistance = ResourceConfig.KBandRange
				
				for i, KBandLocation in pairs(KBandLocations) do				
					if KBandLocation ~= nil then						
						local distance = math.abs(#(KBandLocation - playerPosition))
						--LogDebug(ResourceConfig.ScriptName, KBandLocation .. " - " .. playerPosition .. " = " ..distance)
						if distance < closestDistance then
							closestDistance = distance
						end
					end
				end
				--LogDebug(ResourceConfig.ScriptName, "Is near radar, radar is " .. closestDistance .. " away")
				
				if closestDistance < ResourceConfig.KBandRange and closestDistance > 0 then
					return true, closestDistance, ResourceConfig.KBandRange
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
				local isRunningRadar, playerPosition = TriggerCallback("RadarDetector:Client:isRunningRadar", playerId)

				if isRunningRadar then
					KBandLocations[playerName] = playerPosition
					KaBandLocations[playerName] = playerPosition
				end
			end			
		end
		
	else
		LogError("Could not get config for "..ResourceConfig.ScriptName.." or script is disabled")	
	end	
	
end) end)