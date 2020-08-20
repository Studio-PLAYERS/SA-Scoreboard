pings = {}
afks = {}

RegisterServerEvent("updatePings")
AddEventHandler("updatePings", function()
    for _, i in ipairs(GetPlayers()) do
		pings[tonumber(i)] = GetPlayerPing(i)
	end
	TriggerClientEvent("setPings", -1, pings)
end)


RegisterServerEvent("setAFK")
AddEventHandler("setAFK", function()
	afks[source] = "AFK"
	TriggerClientEvent("setAFKs", -1, afks)
end)

RegisterServerEvent("setACTIVE")
AddEventHandler("setACTIVE", function()
	afks[source] = "Active"
	TriggerClientEvent("setAFKs", -1, afks)
end)