local QBCore = exports['qb-core']:GetCoreObject()

local pings = {}
local afks = {}
local admins = Config.AllowedPermissions


local function GetPermission()
	for k,permise in pairs(admins) do
		print(k,v)
		print(QBCore.Functions.HasPermission())
		if permise == IsPlayerAceAllowed() then
			print('Test')
		end
	end
end

QBCore.Functions.CreateCallback('SA-Scoreboard:Server:CheckPerms', function(source, cb)
    cb('Ok')
end)

RegisterServerEvent("updatePings")
AddEventHandler("updatePings", function()
    for _, i in ipairs(GetPlayers()) do
		pings[tonumber(i)] = GetPlayerPing(i)
	end
	TriggerClientEvent("setPings", -1, pings)
end)


RegisterServerEvent("setAFK")
AddEventHandler("setAFK", function()
	afks[source] = "AFK -_-"
	TriggerClientEvent("setAFKs", -1, afks)
end)

RegisterServerEvent("setACTIVE")
AddEventHandler("setACTIVE", function()
	afks[source] = "Aktivní"
	TriggerClientEvent("setAFKs", -1, afks)
end)