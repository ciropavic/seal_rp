AddEventHandler('gameEventTriggered', function (name, data)
    if name == "CEventNetworkEntityDamage" then
        local victim = data[1]
        local attacker = data[2]
        local victimDied = data[6]
        local weaponHash = data[7]
        local isMeleeDamage = data[12]
        local vehicleDamageTypeFlag = data[13]

        if victim ~= nil and attacker ~= nil then
            if victimDied == 1 then
                -- victim died

                -- vehicle destroyed
                if IsEntityAVehicle(victim) then
                    VehicleDestroyed(victim, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
                -- other entity died
                else
                    -- victim is a ped
                    if IsEntityAPed(victim) then
                        if IsEntityAVehicle(attacker) then
                            PedKilledByVehicle(victim, attacker)
                        elseif IsEntityAPed(attacker)then
                            if IsPedAPlayer(attacker) then
                                local player = NetworkGetPlayerIndexFromPed(attacker)
                                PedKilledByPlayer(victim, player, weaponHash, isMeleeDamage)
                            else
                                PedKilledByPed(victim, attacker, weaponHash, isMeleeDamage)
                            end
                        else
                            PedDied(victim, attacker, weaponHash, isMeleeDamage)
                        end
                        if victim == PlayerPedId() then
                            PlayerDied(victim, attacker, weaponHash, isMeleeDamage)
                        end
                    -- victim is not a ped
                    else
                        EntityKilled(victim, attacker, weaponHash, isMeleeDamage)
                    end
                end
            else
                -- only damaged
                if not IsEntityAVehicle(victim) then
                    EntityDamaged(victim, attacker, weaponHash, isMeleeDamage)
                else
                    VehicleDamaged(victim, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
                end
            end
        end
    end
end)

local eventName = "baseevents"

--[[ <summary>
/// Event gets triggered whenever a vehicle is destroyed.
/// </summary>
/// <param name="vehicle">The vehicle that got destroyed.</param>
/// <param name="attacker">The attacker handle of what destroyed the vehicle.</param>
/// <param name="weaponHash">The weapon hash that was used to destroy the vehicle.</param>
/// <param name="isMeleeDamage">True if the damage dealt was using any melee weapon (including unarmed).</param>
/// <param name="vehicleDamageTypeFlag">Vehicle damage type flag, 93 is vehicle tires damaged, others unknown.</param>]]
function VehicleDestroyed(vehicle, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
    TriggerEvent(eventName..":VehicleDestroyed", vehicle, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
end

--[[ <summary>
/// Event gets triggered whenever a ped was killed by a vehicle without a driver.
/// </summary>
/// <param name="ped">Ped that got killed.</param>
/// <param name="vehicle">Vehicle that was used to kill the ped.</param>]]
function PedKilledByVehicle(ped, vehicle)
    TriggerEvent(eventName..":PedKilledByVehicle", ped, vehicle)
end

--[[ <summary>
/// Event gets triggered whenever a ped is killed by a player.
/// </summary>
/// <param name="ped">The ped that got killed.</param>
/// <param name="player">The player that killed the ped.</param>
/// <param name="weaponHash">The weapon hash used to kill the ped.</param>
/// <param name="isMeleeDamage">True if the ped was killed with a melee weapon (including unarmed).</param>]]
function PedKilledByPlayer(ped, player, weaponHash, isMeleeDamage)
    TriggerEvent(eventName..":PedKilledByPlayer", ped, player, weaponHash, isMeleeDamage)
end

--[[ <summary>
/// Event gets triggered whenever a ped is killed by another (non-player) ped.
/// </summary>
/// <param name="ped">Ped that got killed.</param>
/// <param name="attackerPed">Ped that killed the victim ped.</param>
/// <param name="weaponHash">Weapon hash used to kill the ped.</param>
/// <param name="isMeleeDamage">True if the ped was killed using a melee weapon (including unarmed).</param>]]
function PedKilledByPed(ped, attackerPed, weaponHash, isMeleeDamage)
    TriggerEvent(eventName..":PedKilledByPed", ped, attackerPed, weaponHash, isMeleeDamage)
end

--[[ <summary>
/// Event gets triggered whenever a ped died, but only if the other (more detailed) events weren't triggered.
/// </summary>
/// <param name="ped">The ped that died.</param>
/// <param name="attacker">The attacker (can be the same as the ped that died).</param>
/// <param name="weaponHash">Weapon hash used to kill the ped.</param>
/// <param name="isMeleeDamage">True whenever the ped was killed using a melee weapon (including unarmed).</param>]]
function PedDied(ped, attacker, weaponHash, isMeleeDamage)
    TriggerEvent(eventName..":PedDied", ped, attacker, weaponHash, isMeleeDamage)
end

--[[ <summary>
/// Event gets triggered whenever a player died
/// </summary>
/// <param name="ped">The ped that died.</param>
/// <param name="attacker">The attacker (can be the same as the ped that died).</param>
/// <param name="weaponHash">Weapon hash used to kill the ped.</param>
/// <param name="isMeleeDamage">True whenever the ped was killed using a melee weapon (including unarmed).</param>]]
function PlayerDied(ped, attacker, weaponHash, isMeleeDamage)
    TriggerEvent(eventName..":onPlayerDied", ped, attacker, weaponHash, isMeleeDamage)
end

--[[ <summary>
/// Gets triggered whenever an entity died, that's not a vehicle, or a ped.
/// </summary>
/// <param name="entity">Entity that was killed/destroyed.</param>
/// <param name="attacker">The attacker that destroyed/killed the entity.</param>
/// <param name="weaponHash">The weapon hash used to kill/destroy the entity.</param>
/// <param name="isMeleeDamage">True whenever the entity was killed/destroyed with a melee weapon.</param>]]
function EntityKilled(entity, attacker, weaponHash, isMeleeDamage)
    TriggerEvent(eventName..":EntityKilled", entity, attacker, weaponHash, isMeleeDamage)
end

--[[ <summary>
/// Event gets triggered whenever a vehicle is damaged, but not destroyed.
/// </summary>
/// <param name="vehicle">Vehicle that got damaged.</param>
/// <param name="attacker">Attacker that damaged the vehicle.</param>
/// <param name="weaponHash">Weapon hash used to damage the vehicle.</param>
/// <param name="isMeleeDamage">True whenever the vehicle was damaged using a melee weapon (including unarmed).</param>
/// <param name="vehicleDamageTypeFlag">Vehicle damage type flag, 93 is vehicle tire damage, others are unknown.</param>]]
function VehicleDamaged(vehicle, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
    TriggerEvent(eventName..":VehicleDamaged", vehicle, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
end

--[[ <summary>
/// Event gets triggered whenever an entity is damaged but hasn't died from the damage.
/// </summary>
/// <param name="entity">Entity that got damaged.</param>
/// <param name="attacker">The attacker that damaged the entity.</param>
/// <param name="weaponHash">The weapon hash used to damage the entity.</param>
/// <param name="isMeleeDamage">True if the damage was done using a melee weapon (including unarmed).</param>]]
function EntityDamaged(entity, attacker, weaponHash, isMeleeDamage)
    TriggerEvent(eventName..":EntityDamaged", entity, attacker, weaponHash, isMeleeDamage)
end