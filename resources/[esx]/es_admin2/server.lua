TriggerEvent("es:addGroup", "mod", "user", function(group) end)
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PermLvl = 0
local Mutan = {}
-- Modify if you want, btw the _admin_ needs to be able to target the group and it will work
local groupsRequired = {
	slay = "mod",
	noclip = "admin",
	fix = "admin",
	clean = "admin",
	crash = "owner",
	freeze = "mod",
	bring = "mod",
	["goto"] = "mod",
	slap = "mod",
	slay = "mod",
	kick = "mod"
}

local banned = ""
local bannedTable = {}

function loadBans()
	banned = LoadResourceFile(GetCurrentResourceName(), "bans.json") or ""
	if banned ~= "" then
		bannedTable = json.decode(banned)
	else
		bannedTable = {}
	end
end

RegisterCommand("refresh_bans", function()
	loadBans()
end, true)

function loadExistingPlayers()
	TriggerEvent("es:getPlayers", function(curPlayers)
		for k,v in pairs(curPlayers)do
			TriggerClientEvent("es_admin:setGroup", v.get('source'), v.get('group'))
		end
	end)
end

loadExistingPlayers()

function removeBan(id)
	bannedTable[id] = nil
	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

ESX.RegisterServerCallback('es_admin:DohvatiIgrace', function(source, cb)
	local igraci = {}
	for _, playerId in ipairs(GetPlayers()) do
		local name = GetPlayerName(playerId)
		table.insert(igraci, {ID = playerId, Ime = Sanitize(name)})
	end
	cb(igraci)
end)

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

function isBanned(id)
	if bannedTable[id] ~= nil then
		if bannedTable[id].expire < os.time() then
			removeBan(id)
			return false
		else
			return bannedTable[id]
		end
	else
		return false
	end
end

function permBanUser(bannedBy, id)
	bannedTable[id] = {
		banner = bannedBy,
		reason = "Zauvijek banan sa servera",
		expire = 0
	}

	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

function banUser(expireSeconds, bannedBy, id, re)
	bannedTable[id] = {
		banner = bannedBy,
		reason = re,
		expire = (os.time() + expireSeconds)
	}

	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

AddEventHandler('playerConnecting', function(user, set)
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		local banData = isBanned(v)
		if banData ~= false then
			set("Banan zbog: " .. banData.reason .. "\nIstice: " .. (os.date("%c", banData.expire)))
			CancelEvent()
			break
		end
	end
end)

AddEventHandler('es:incorrectAmountOfArguments', function(source, wantedArguments, passedArguments, user, command)
	if(source == 0)then
		print("Argument count mismatch (passed " .. passedArguments .. ", wanted " .. wantedArguments .. ")")
	else
		TriggerClientEvent('chat:addMessage', source, {
			args = {"^1SYSTEM", "Netocan broj agrumenata! (" .. passedArguments .. " upisano, " .. requiredArguments .. " trazeno)"}
		})
	end
end)

RegisterServerEvent('report:Mutan')
AddEventHandler('report:Mutan', function(id, mi)
	Mutan[id] = mi
end)

RegisterServerEvent('es_admin:all')
AddEventHandler('es_admin:all', function(type)
	local Source = source
	TriggerEvent("DajMiPermLevel", Source)
	Wait(600)
	if PermLvl == 69 then
		TriggerEvent('es:getPlayerFromId', source, function(user)
			TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
				if available or user.getGroup() == "superadmin" then
					if type == "slay_all" then TriggerClientEvent('es_admin:quick', -1, 'slay') end
					if type == "bring_all" then TriggerClientEvent('es_admin:quick', -1, 'bring', Source) end
					if type == "slap_all" then TriggerClientEvent('es_admin:quick', -1, 'slap') end
				else
					TriggerClientEvent('chat:addMessage', Source, {
						args = {"^1SYSTEM", "Nemate ovlasti!"}
					})
				end
			end)
		end)
	else
		TriggerClientEvent('chat:addMessage', Source, {
			args = {"^1SYSTEM", "Vlasnik potreban za ovo!"}
		})
	end
end)

RegisterServerEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(id, type)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:getPlayerFromId', id, function(target)
			TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
				TriggerEvent('es:canGroupTarget', user.getGroup(), target.getGroup(), function(canTarget)
					if canTarget and available then
						local cord = GetEntityCoords(GetPlayerPed(id))
						local corda = GetEntityCoords(GetPlayerPed(Source))
						if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "noclip" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "freeze" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "crash" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "bring" then TriggerClientEvent('es_admin:quick', id, type, Source, corda) end
						if type == "goto" then TriggerClientEvent('es_admin:quick', Source, type, id, cord) end
						if type == "slap" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "kick" then DropPlayer(id, 'Kikan od es_admin GUI') end

						if type == "ban" then
							local id
							local ip
							for k,v in ipairs(GetPlayerIdentifiers(source))do
								if string.sub(v, 1, string.len("steam:")) == "steam:" then
									permBanUser(user.identifier, v)
								elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
									permBanUser(user.identifier, v)
								end
							end

							DropPlayer(id, GetConvar("es_admin_banreason", "Banani ste sa servera"))
						end
					else
						if not available then
							TriggerClientEvent('chat:addMessage', Source, {
								args = {"^1SYSTEM", "Nemate ovlasti[grupa]!"}
							})
						else
							TriggerClientEvent('chat:addMessage', Source, {
								args = {"^1SYSTEM", "Nemate ovlasti!"}
							})
						end
					end
				end)
			end)
		end)
	end)
end)

AddEventHandler('es:playerLoaded', function(Source, user)
	TriggerClientEvent('es_admin:setGroup', Source, user.getGroup())
end)

RegisterNetEvent('VratiPermLevel')
AddEventHandler('VratiPermLevel', function(perm)
	PermLvl = perm
end)

RegisterServerEvent('es_admin:set')
AddEventHandler('es_admin:set', function(t, USER, GROUP)
	local Source = source
	TriggerEvent("DajMiPermLevel", Source)
	Wait(600)
	if PermLvl == 69 then
	TriggerEvent('es:getPlayerFromId', Source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
			if t == "group" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', source, {
						args = {"^1SYSTEM", "Igrac nije pronadjen"}
					})
				else
					TriggerEvent("es:getAllGroups", function(groups)
						if(groups[GROUP])then
							TriggerEvent("es:setPlayerData", USER, "group", GROUP, function(response, success)
								TriggerClientEvent('es_admin:setGroup', USER, GROUP)
								TriggerClientEvent('chat:addMessage', USER, {
									args = {"^1KONZOLA", "Grupa igracu ^2^*" .. GetPlayerName(tonumber(USER)) .. "^r^0 je postavljena na ^2^*" .. GROUP}
								})
							end)
						else
							TriggerClientEvent('chat:addMessage', Source, {
								args = {"^1SYSTEM", "Grupa nije pronadjena"}
							})
						end
					end)
				end
			elseif t == "level" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', Source, {
						args = {"^1SYSTEM", "Igrac nije pronadjen"}
					})
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent("es:setPlayerData", USER, "permission_level", GROUP, function(response, success)
							if(true)then
								TriggerClientEvent('chat:addMessage', USER, {
									args = {"^1KONZOLA", "Level permisije igracu ^2" .. GetPlayerName(tonumber(USER)) .. "^0 je postavljen na ^2 " .. tostring(GROUP)}
								})
							end
						end)
						
						TriggerClientEvent('es_admin:setPerm', USER)

						TriggerClientEvent('chat:addMessage', Source, {
							args = {"^1SYSTEM", "Level permisije igracu ^2" .. GetPlayerName(tonumber(USER)) .. "^0 je postavljen na ^2 " .. tostring(GROUP)}
						})
					else
						TriggerClientEvent('chat:addMessage', Source, {
							args = {"^1SYSTEM", "Krivi broj!"}
						})
					end
				end
			elseif t == "money" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', Source, {
						args = {"^1SYSTEM", "Igrac nije pronadjen"}
					})
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setMoney(GROUP)
						end)
					else
						TriggerClientEvent('chat:addMessage', Source, {
							args = {"^1SYSTEM", "Krivi broj!"}
						})
					end
				end
			elseif t == "bank" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', Source, {
						args = {"^1SYSTEM", "Igrac nije pronadjen"}
					})
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setBankBalance(GROUP)
							TriggerEvent("bank:balance", USER)
						end)
					else
						TriggerClientEvent('chat:addMessage', Source, {
							args = {"^1SYSTEM", "Krivi broj!"}
						})
					end
				end
			end
			else
				TriggerClientEvent('chat:addMessage', Source, {
					args = {"^1SYSTEM", "Superadmin potreban za ovo!"}
				})
			end
		end)
	end)
	else
		TriggerClientEvent('chat:addMessage', Source, {
			args = {"^1SYSTEM", "Vlasnik potreban za ovo!"}
		})
	end
end)

RegisterCommand('setadmin', function(source, args, raw)
	local player = tonumber(args[1])
	local level = tonumber(args[2])
	if args[1] then
		if (player and GetPlayerName(player)) then
			if level then
				local Source = source
				TriggerEvent("DajMiPermLevel", Source)
				Wait(100)
				if PermLvl == 69 then
					TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
						RconPrint(response)
			
						TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
						TriggerClientEvent('chat:addMessage', -1, {
							args = {"^1KONZOLA", "Level permisije igracu ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 je postavljen na ^2 " .. args[2]}
						})
					end)
				end
			else
				RconPrint("Krivi broj!\n")
			end
		else
			RconPrint("Igrac nije u igri\n")
		end
	else
		RconPrint("Koristi: setadmin [user-id] [permission-level]\n")
	end
end, true)

RegisterCommand('setgroup', function(source, args, raw)
	local player = tonumber(args[1])
	local group = args[2]
	if args[1] then
		if (player and GetPlayerName(player)) then
			TriggerEvent("es:getAllGroups", function(groups)

				if(groups[args[2]])then
					local Source = source
					TriggerEvent("DajMiPermLevel", Source)
					Wait(100)
					if PermLvl == 69 then
						TriggerEvent("es:getPlayerFromId", player, function(user)
							ExecuteCommand('remove_principal identifier.' .. user.getIdentifier() .. " group." .. user.getGroup())

							TriggerEvent("es:setPlayerData", player, "group", args[2], function(response, success)
								TriggerClientEvent('es:setPlayerDecorator', player, 'group', tonumber(group), true)
								TriggerClientEvent('chat:addMessage', -1, {
									args = {"^1KONZOLA", "Grupa igracu ^2^*" .. GetPlayerName(player) .. "^r^0 je postavljena na ^2^*" .. group}
								})

								ExecuteCommand('add_principal identifier.' .. user.getIdentifier() .. " group." .. user.getGroup())
							end)
						end)
					end
				else
					RconPrint("Ova grupa ne postoji.\n")
				end
			end)
		else
			RconPrint("Igrac nije u igri\n")
		end
	else
		RconPrint("Koristi: setgroup [user-id] [group]\n")
	end
end, true)

RegisterCommand('giverole', function(source, args, raw)
	local player = tonumber(args[1])
	local role = table.concat(args, " ", 2)
	if args[1] then
		if (player and GetPlayerName(player)) then
			if args[2] then
				TriggerEvent("es:getPlayerFromId", player, function(user)
					user.giveRole(role)
					TriggerClientEvent('chat:addMessage', user.get('source'), {
						args = {"^1SYSTEM", "Dobili ste ulogu: ^2" .. role}
					})
				end)
			else
				RconPrint("Koristi: giverole [user-id] [uloga]\n")
			end
		else
			RconPrint("Igrac nije u igri\n")
		end
	else
		RconPrint("Koristi: giverole [user-id] [uloga]\n")
	end
end, true)

RegisterCommand('removerole', function(source, args, raw)
	local player = tonumber(args[1])
	local role = table.concat(args, " ", 2)
	if args[1] then
		if (player and GetPlayerName(player)) then
			if args[2] then
				TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(user)
					user.removeRole(role)
					TriggerClientEvent('chat:addMessage', user.get('source'), {
						args = {"^1SYSTEM", "Obrisani ste iz uloge: ^2" .. role}
					})
				end)
			else
				RconPrint("Koristi: removerole [user-id] [uloga]\n")
			end
		else
			RconPrint("Igrac nije u igri\n")
		end
	else
		RconPrint("Koristi: removerole [user-id] [uloga]\n")
	end
end, true)

-- Default commands
TriggerEvent('es:addCommand', 'admin', function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {
		args = {"^1SYSTEM", "Level: ^*^2 " .. tostring(user.get('permission_level'))}
	})
	TriggerClientEvent('chat:addMessage', source, {
		args = {"^1SYSTEM", "Grupa: ^*^2 " .. user.getGroup()}
	})
end, {help = "Pokazuje koji ste level admina i koja ste grupa"})
---test
TriggerEvent('es:addGroupCommand', 'viewname', "admin", function(source, args, user)
    TriggerClientEvent("es_admin:viewname", source)
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Nemate ovlasti!")
end)
--test
-- Report to admins
TriggerEvent('es:addCommand', 'report', function(source, args, user)
	if Mutan[source] == nil or Mutan[source] == 0 then
		if args[1] ~= nil then
		TriggerClientEvent('chat:addMessage', source, {
			args = {"^1REPORT", " (^2" .. GetPlayerName(source) .. " | " .. source .. "^0) " .. table.concat(args, " ")}
		})

		TriggerEvent("es:getPlayers", function(pl)
			for k,v in pairs(pl) do
				TriggerEvent("es:getPlayerFromId", k, function(user)
					if(user.getPermissions() > 0 and k ~= source)then
						TriggerClientEvent('chat:addMessage', k, {
							args = {"^1REPORT", " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " ")}
						})
					end
				end)
			end
		end)
		else
			TriggerClientEvent('chat:addMessage', source, {
				args = {"^1SYSTEM", " /report [Tekst]"}
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Morate pricekati jos "..Mutan[source].." minuta do unmutea!" } })
	end
end, {help = "Prijavite igraca ili problem", params = {{name = "report", help = "Sta zelite report"}}})

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:noclip", source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Upali ili ugasi noclip"})

TriggerEvent('es:addGroupCommand', 'fix', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:fix", source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Popravak vozila"})

TriggerEvent('es:addGroupCommand', 'clean', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:clean", source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Ciscenje vozila"})

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				local reason = args
				table.remove(reason, 1)
				if(#reason == 0)then
					reason = "Kickan: Izbaceni ste sa servera"
				else
					reason = "Kickan: " .. table.concat(reason, " ")
				end

				TriggerClientEvent('chat:addMessage', -1, {
					args = {"^1SYSTEM", "Igrac ^2" .. GetPlayerName(player) .. "^0 je izbacen sa servera(^2" .. reason .. "^0)"}
				})
				DropPlayer(player, reason)
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Kickanje igraca sa razlogom ili bez navedenog razloga", params = {{name = "userid", help = "ID igraca"}, {name = "reason", help = "Razlog zasto ste kickali igraca"}}})

-- Announcing
TriggerEvent('es:addGroupCommand', 'announce', "admin", function(source, args, user)
	if args[1] ~= nil then
	TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-bullhorn"></i> {0}:<br> {1}</div>',
        args = {"OBAVIJEST", table.concat(args, " ")}
    })
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", " /announce [Poruka]"} })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Objavite nesta cijelome serveru", params = {{name = "announcement", help = "Poruka koju ocete objaviti"}}})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end

				TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

				local state = "odmrznut"
				if(frozen[player])then
					state = "zamrznut"
				end

				TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "Vi ste " .. state .. " od admina ^2" .. GetPlayerName(source)} })
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Igrac ^2" .. GetPlayerName(player) .. "^0 je " .. state} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Zamrzni ili odmrzni igraca", params = {{name = "userid", help = "ID igraca"}}})

-- Bring
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				local kord = GetEntityCoords(GetPlayerPed(source))
				TriggerClientEvent('es_admin:teleportUser', target.get('source'), kord.x, kord.y, kord.z)

				TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "Portani ste do admina ^2" .. GetPlayerName(source)} })
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Igrac ^2" .. GetPlayerName(player) .. "^0 je portan do vas"} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Port igraca do vas", params = {{name = "userid", help = "ID igraca"}}})

-- Slap
TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:slap', player)

				TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "Slapani ste od ^2" .. GetPlayerName(source)} })
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Igrac ^2" .. GetPlayerName(player) .. "^0 je slapan"} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Slap igraca", params = {{name = "userid", help = "ID igraca"}}})

-- Goto
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(target)then
					local kord = GetEntityCoords(GetPlayerPed(tonumber(args[1])))
					TriggerClientEvent('es_admin:teleportUser', source, kord.x, kord.y, kord.z)

					TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "Do vas se portao admin ^2" .. GetPlayerName(source)} })
					TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Portani ste do igraca ^2" .. GetPlayerName(player) .. ""} })
				end
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Port do igraca", params = {{name = "userid", help = "ID igraca"}}})

-- Slay a player
TriggerEvent('es:addGroupCommand', 'slay', "admin", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:kill', player)

				TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "Ubijeni ste od ^2" .. GetPlayerName(source)} })
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Igrac ^2" .. GetPlayerName(player) .. "^0 je ubijen."} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Ubijte igraca", params = {{name = "userid", help = "ID igraca"}}})

-- Crashing
TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local Source = source
			TriggerEvent("DajMiPermLevel", Source)
			Wait(100)
			if PermLvl == 69 then
				local player = tonumber(args[1])

				-- User permission check
				TriggerEvent("es:getPlayerFromId", player, function(target)

					TriggerClientEvent('es_admin:crash', player)

					TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Igrac ^2" .. GetPlayerName(player) .. "^0 je crashan."} })
				end)
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Krivi ID igraca"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Nemate ovlasti!"} })
end, {help = "Crash igraca, nemam pojma cemu to jos postoji", params = {{name = "userid", help = "ID igraca"}}})

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

loadBans()
