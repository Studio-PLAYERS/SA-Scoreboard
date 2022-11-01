local QBCore = exports['qb-core']:GetCoreObject()
local afktime = Config.AFK --set this to time in seconds before AFK status is set. Default: 900 (15 minutes)
local OpenKey = Config.OpenKey
local showIDS = Config.ShowIDforALL
local admins = Config.AllowedPermissions
-----------------------------------
local nui = false

local players = {}
local afks = {}
local pings = {}

------------------------------------
-- Lokální funkce
------------------------------------

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetPlayers()
    local players = {}
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPos()
	local currentPos = GetEntityCoords(PlayerPedId(), true)
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

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

	coords = coords or GetEntityCoords(PlayerPedId())
    distance = distance or  5.0

    for i = 1, #players do
        local player = players[i]
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end


----------------------------------------------
--Commands
----------------------------------------------

if Config.Toggle then
	RegisterCommand('oScoreBoard', function()
		if not nui then
			TriggerServerEvent("updatePings")
			local num = 1;
			local players = {};
			local ptable = GetPlayers()
			--local permissions = GetPermission()
			Wait(100)
			for _, i in ipairs(ptable) do
				local clientID = i
				local serverID = GetPlayerServerId(clientID)
				local name = GetPlayerName(clientID)
				if pings[serverID] ~= nil and afks[serverID] ~= nil then
					local ping = pings[serverID] .. "ms"
					if num == 1 then 
						--table.insert(players, '<tr style=\"color: #fff"><td>' .. serverID .. ' </td><td style="text-align: center;">' .. name .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						table.insert(players, '<tr style=\"color: #fff"><td>' .. serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 2
					elseif num == 2 then
						--table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' .. serverID .. '</td><td style="text-align: center;">' .. name .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' ..serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 3
					elseif num == 3 then 
						table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' ..serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 4
					elseif num == 4 then 
						table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' ..serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 1
					end 
				end
				SendNUIMessage({ 
					action = 'open',
					text = table.concat(players)
				})
				nui = true
				--[[ if showIDS then
					ShowIDS()
				end ]]
			end
		else
            SendNUIMessage({
				action = 'close'
            })
			nui = false
		end
	end, false)

	RegisterKeyMapping('oScoreBoard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
else
	RegisterCommand('+ScoreBoard', function()
		if not nui then
			TriggerServerEvent("updatePings")
			local num = 1;
			local players = {};
			local ptable = GetPlayers()
			--local permissions = GetPermission()
			Wait(100)
			for _, i in ipairs(ptable) do
				local clientID = i
				local serverID = GetPlayerServerId(clientID)
				local name = GetPlayerName(clientID)
				if pings[serverID] ~= nil and afks[serverID] ~= nil then
					local ping = pings[serverID] .. "ms"
					if num == 1 then 
						--table.insert(players, '<tr style=\"color: #fff"><td>' .. serverID .. ' </td><td style="text-align: center;">' .. name .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						table.insert(players, '<tr style=\"color: #fff"><td>' .. serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 2
					elseif num == 2 then
						--table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' .. serverID .. '</td><td style="text-align: center;">' .. name .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' ..serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 3
					elseif num == 3 then 
						table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' ..serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 4
					elseif num == 4 then 
						table.insert(players, '<tr style=\"color: #fff"><td class="spaceme">' ..serverID .. '</td><td style="text-align: center;">' .. ping ..  '</td><td style="text-align: center;">' .. afks[serverID] .. '</td></tr>')
						num = 1
					end 
				end
				SendNUIMessage({ 
					action = 'open',
					text = table.concat(players)
				})
				nui = true
				--[[ if showIDS then
					ShowIDS()
				end ]]
			end
		end
	end, false)

	RegisterCommand('-ScoreBoard', function()
		if not nui then return end
		SendNUIMessage({
			action = 'close'
		})
		nui = false
	end, false)

	RegisterKeyMapping('+ScoreBoard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
end

---------------------------------------
-- Events
---------------------------------------

RegisterNetEvent("setPings")
AddEventHandler("setPings", function(p)
	pings = p
end)

RegisterNetEvent("setAFKs")
AddEventHandler("setAFKs", function(a)
	afks = a	
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  local header = Config.HeaderIMG
  local footer = Config.Footer
  SendNUIMessage({
	action = 'update',
	header = header,
	footer = footer
  })
end)

---------------------------------------
-- Threads
---------------------------------------

CreateThread(function()
	local AFK = false
	TriggerServerEvent("setACTIVE")
	while true do
		Wait(1000)
		GetPos()
	end
end)

CreateThread(function()
	while true do
		local loop = 100
		if nui then
			for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
				local playerId = GetPlayerServerId(player)
				local playerPed = GetPlayerPed(player)
				local playerCoords = GetEntityCoords(playerPed)
				if showIDS then --if Config.ShowIDforALL or playerOptin[playerId].optin then
					loop = 0
					DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, '['..playerId..']')
				end
			end
		end
		Wait(loop)
	end
end)
