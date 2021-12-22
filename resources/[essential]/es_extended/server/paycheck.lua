ESX.StartPayCheck = function()

	function payCheck()
		local xPlayers = ESX.GetPlayers()
		if #xPlayers > 0 then
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer ~= -1 and xPlayer ~= nil then
					local job     = xPlayer.job.grade_name
					local job2    = xPlayer.job.name
					local salary  = 0

					--SetTimeout(5000, function()
					MySQL.Async.fetchAll("SELECT job_name, name, salary FROM job_grades", {}, function (result2)
						if result2 ~= nil then
							for i=1, #result2, 1 do
								if result2[i].job_name == job2 then
									if result2[i].name == job then
										salary = result2[i].salary
										if job == 'unemployed' then -- unemployed
											xPlayer.addAccountMoney('bank', salary)
											TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
										elseif Config.EnableSocietyPayouts then -- possibly a society
											TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
												if society ~= nil then -- verified society
													TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
														if account.money >= salary then -- does the society money to pay its employees?
															xPlayer.addAccountMoney('bank', salary)
															account.removeMoney(salary)
															account.save()
															TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
														else
															TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
														end
													end)
												else -- not a society
													xPlayer.addAccountMoney('bank', salary)
													TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
												end
											end)
										else -- generic job
											xPlayer.addAccountMoney('bank', salary)
											TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
										end
										--[[MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
											['@identifier'] = xPlayer.identifier
										}, function(result)
											if result[1] ~= nil then
												for i=1, #result, 1 do
													local id         = result[i].id
													local identifier = result[i].identifier
													local sender     = result[i].sender
													local targetType = result[i].target_type
													local target     = result[i].target
													local label      = result[i].label
													local amount     = result[i].amount
													local xTarget = ESX.GetPlayerFromIdentifier(sender)
													if targetType == 'player' then

														if xTarget ~= nil then

															if xPlayer.getMoney() >= amount then

																MySQL.Async.execute('DELETE from billing WHERE id = @id', {
																	['@id'] = id
																}, function(rowsChanged)
																	xPlayer.removeMoney(amount)
																	xTarget.addMoney(amount)
																	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
																	TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))
																end)

															elseif xPlayer.getBank() >= amount then

																MySQL.Async.execute('DELETE from billing WHERE id = @id', {
																	['@id'] = id
																}, function(rowsChanged)
																	xPlayer.removeAccountMoney('bank', amount)
																	xTarget.addAccountMoney('bank', amount)
																	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
																	TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))
																end)

															else
																TriggerClientEvent('esx:showNotification', xPlayer.source, _U('no_money'))
															end
														ESX.SavePlayer(xPlayer, function() 
														end)
														ESX.SavePlayer(xTarget, function() 
														end)
														else
															TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_not_online'))
														end

													else

														TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)

															if xPlayer.getMoney() >= amount then

																MySQL.Async.execute('DELETE from billing WHERE id = @id', {
																	['@id'] = id
																}, function(rowsChanged)
																	xPlayer.removeMoney(amount)
																	account.addMoney(amount)
																	account.save()
																	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
																	if xTarget ~= nil then
																		TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))
																	end
																end)

															elseif xPlayer.getBank() >= amount then

																MySQL.Async.execute('DELETE from billing WHERE id = @id', {
																	['@id'] = id
																}, function(rowsChanged)
																	xPlayer.removeAccountMoney('bank', amount)
																	account.addMoney(amount)
																	account.save()
																	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
																	if xTarget ~= nil then
																		TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))
																	end
																end)

															else
																TriggerClientEvent('esx:showNotification', xPlayer.source, _U('no_money'))
															end
														end)
													end
												end
											end
										end)]]
										break
									end
								end
							end
						end
					end)
					ESX.SavePlayer(xPlayer, function()
					end)
					--end)
					MySQL.Async.fetchAll("SELECT kredit, rata, brplaca, exp, level FROM users WHERE identifier = @iden", { ['@iden'] = xPlayer.identifier }, function (result6)
						if result6 ~= nil then
							local kredit = result6[1].kredit
							local rata = result6[1].rata
							local place = result6[1].brplaca
							local exper = tonumber(result6[1].exp)
							local level = tonumber(result6[1].level)
							exper = exper+1
							if exper >= level*4 then
								exper = 0
								level = level+1
								TriggerClientEvent('esx:showNotification', xPlayer.source, "LEVEL UP! Prešli ste na level "..level)
							else
								TriggerClientEvent('esx:showNotification', xPlayer.source, "Fali vam još "..((level*4)-exper).." sati do levela "..(level+1))
							end
							
							if kredit > 0 then
								if kredit > rata then
									xPlayer.removeAccountMoney('bank', rata)
									kredit = kredit-rata
									MySQL.Async.execute("UPDATE users SET kredit=@kr WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@kr'] = kredit})
									local tekste = "Platili ste ratu kredita od $"..rata.."! Za vratit vam je ostalo jos $"..kredit.."."
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Banka',
									'Kredit',
									tekste,
									'CHAR_BANK_MAZE', 9)
								else
									xPlayer.removeAccountMoney('bank', kredit)
									kredit = 0
									MySQL.Async.execute("UPDATE users SET kredit=0, rata=0 WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier})
									TriggerClientEvent('esx:showNotification', xPlayer.source, "[Banka] Otplatili ste kredit!")
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Banka',
									'Kredit',
									'Otplatili ste kredit!',
									'CHAR_BANK_MAZE', 9)
								end
							end
							place = place+1
							MySQL.Async.execute("UPDATE users SET brplaca=@brpl, exp=@exp, level=@lvl WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@brpl'] = place, ['@exp'] = exper, ['@lvl'] = level})
						end
					end)
				end
			end
		end

		SetTimeout(Config.PaycheckInterval, payCheck)

	end

	SetTimeout(Config.PaycheckInterval, payCheck)

end