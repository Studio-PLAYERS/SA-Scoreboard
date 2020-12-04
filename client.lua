afktime = 900 --set this to time in seconds before AFK status is set. Default: 900 (15 minutes)
-----------------------------------
local nui = false

players = {}
afks = {}
pings = {}

Citizen.CreateThread(function()
    --[[ If you want to change the key, go to https://docs.fivem.net/game-references/controls/ and change the '20' value below]]
    local key = 27 -- Change this to your key value
	local clientID = nil
	local serverID = nil
	local ping = nil

    nui = false

	TriggerServerEvent("updatePings")

    while true do
        Citizen.Wait(1)
        if IsControlPressed(0, key) then 
			TriggerServerEvent("updatePings")
            if not nui then
				local num = 1;
				players = {};
				ptable = GetPlayers()
				for _, i in ipairs(ptable) do
					clientID = i
					serverID = GetPlayerServerId(i)

					name = GetPlayerName(clientID)
					if pings[serverID] ~= nil and afks[serverID] ~= nil then
						ping = pings[serverID] .. "ms"
						if num == 1 then 
							table.insert(players, '<tr style=\"color: #fff"><td>' .. serverID .. ' </td><td style="text-align: center;">' .. name .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
							num = 2
						elseif num == 2 then
							table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' ..serverID .. '</td><td style="text-align: center;">' .. name.. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
							num = 3
						elseif num == 3 then 
							table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' .. serverID .. '</td><td style="text-align: center;">' .. name .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
							num = 4
						elseif num == 4 then 
							table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' .. serverID .. '</td><td style="text-align: center;">' .. name .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
							num = 1
						end 
					end
				end
                SendNUIMessage({ text = table.concat(players) })

                nui = true
                while nui do
					Citizen.Wait(1)
                    if(IsControlPressed(0, key) == false) then
                        nui = false
                        SendNUIMessage({
                            meta = 'close'
                        })
                        break
                    end
                end			
            end
        end
    end
end)

RegisterNetEvent("setPings")
AddEventHandler("setPings", function(p)
	pings = p
end)

RegisterNetEvent("setAFKs")
AddEventHandler("setAFKs", function(a)
	afks = a	
end)

Citizen.CreateThread(function()
	local AFK = false
	TriggerServerEvent("setACTIVE")
	while true do
		Wait(1000)
		currentPos = GetEntityCoords(PlayerPedId(), true)
		if currentPos == prevPos then
			if time > 0 then
				time = time - 1
			else
				if not AFK then
					TriggerServerEvent("setAFK")
					AFK = true
				end
			end
		else
			if AFK then
				TriggerServerEvent("setACTIVE")
				AFK = false
			end
			time = afktime
		end
		prevPos = currentPos
	end
end)

function GetPlayers()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end
