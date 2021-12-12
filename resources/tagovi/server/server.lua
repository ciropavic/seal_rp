local staffTag = false
local staffTable = { 0 }
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--print(table.unpack(staffTable))

RegisterNetEvent('tagovi:staffTag')
AddEventHandler('tagovi:staffTag', function(br)
	local src = source
	if has_value(staffTable, src) then
		removebyKey(staffTable, src)
	else
		table.insert(staffTable, src)
	end
	TriggerClientEvent("sendStaff", -1, staffTable)
    if br then
        TriggerClientEvent('prodajoruzje:AdminChat', -1, "^1[ADMIN]", " ^7Admin "..GetPlayerName(src).." je na duznosti!")
    else
        TriggerClientEvent('prodajoruzje:AdminChat', -1, "^1[ADMIN]", " ^7Admin "..GetPlayerName(src).." je otisao s duznosti!")
    end
end)

function has_value (tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end

function removebyKey(tab, val)
    for i, v in ipairs (tab) do 
        if (v == val) then
          --tab[i] = nil
		  table.remove(tab, i)
        end
    end
end

AddEventHandler('playerDropped', function (reason)
    print("Player" .. GetPlayerName(source) .. "removed from staff table (Reason: " .. reason .. ")")
    removebyKey(staffTable, source)
end)

RegisterCommand("showTags", function(source, args, rawCommand)
    TriggerClientEvent("showTags", source)
end)