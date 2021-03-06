Locales['hr'] = {
  -- Inventory
  ['cash'] = 'gotovina',
  ['inventory'] = 'inventory',
  ['use'] = 'use',
  ['give'] = 'give',
  ['remove'] = 'throw',
  ['return'] = 'vrati',
  ['give_to'] = 'give to',
  ['amount'] = 'kolicina',
  ['giveammo'] = 'daj metke',
  ['amountammo'] = 'kolicina municije',
  ['noammo'] = 'nemate dovoljno municije kod sebe!',
  ['gave_item'] = 'dali ste ~y~%sx~s~ ~b~%s~s~ igracu ~y~%s~s~',
  ['received_item'] = 'dobili ste ~y~%sx~s~ ~b~%s~s~ od ~b~%s~s~',
  ['gave_weapon'] = 'dali ste ~y~1x~s~ ~b~%s~s~ igracu ~y~%s~s~.',
  ['gave_weapon_ammo'] = 'dali ste ~y~1x~s~ ~b~%s~s~ sa ~o~%sx~s~ metaka igracu ~y~%s~s~.',
  ['gave_weapon_hasalready'] = '~y~%s~s~ vec ima ~y~%s~s~',
  ['received_weapon'] = 'dobili ste ~y~1x~s~ ~b~%s~s~ od ~b~%s~s~.',
  ['received_weapon_ammo'] = 'dobili ste ~y~1x~s~ ~b~%s~s~ sa ~o~%sx~s~ metaka od ~b~%s~s~.',
  ['received_weapon_hasalready'] = '~b~%s~s~ je pokusao vam dati ~y~%s~s~, ali vec imate jedan.',
  ['gave_ammo'] = 'dali ste ~o~%sx~s~ metaka igracu ~y~%s~s~.',
  ['received_ammo'] = 'dobili ste ~o~%sx~s~ metaka od ~b~%s~s~.',
  ['gave_money'] = 'dali ste ~g~$%s~s~ igracu ~y~%s~s~',
  ['received_money'] = 'dobili ste ~g~$%s~s~ od ~b~%s~s~',
  ['gave_account_money'] = 'dali ste ~g~$%s~s~ (%s) igracu ~y~%s~s~',
  ['received_account_money'] = 'dobili ste ~g~$%s~s~ (%s) od ~b~%s~s~',
  ['amount_invalid'] = 'netocna kolicina',
  ['players_nearby'] = 'nema igraca u blizini',
  ['ex_inv_lim'] = 'nije moguce, premasuje limit inventoryja za ~y~%s~s~',
  ['imp_invalid_quantity'] = 'nije moguce, netocna kolicina',
  ['imp_invalid_amount'] = 'nije moguce, netocna kolicina',
  ['invalid_amount'] = 'netocna kolicina',
  ['threw_standard'] = 'bacili ste ~y~%sx~s~ ~b~%s~s~',
  ['threw_money'] = 'bacili ste ~r~$%s~s~ ~b~gotovine~s~',
  ['threw_account'] = 'bacili ste ~r~$%s~s~ ~b~%s~s~',
  ['threw_weapon'] = 'bacili ste ~y~1x~s~ ~b~%s~s~',
  ['threw_weapon_ammo'] = 'bacili ste ~y~1x~s~ ~b~%s~s~ sa ~o~%sx~s~ metaka',
  -- Salary related
  ['received_salary'] = 'Primili ste placu: ~g~$%s~s~',
  ['received_help'] = 'Primili ste socijalnu pomoc: ~g~$%s~s~',
  ['company_nomoney'] = 'Kompanija u kojoj ste zaposleni nema novaca da vam isplati placu.',
  ['received_paycheck'] = 'Placa',
  ['bank'] = 'banka',
  ['black_money'] = 'prljav novac',
  
  ['paid_invoice'] = '~g~platili~s~ ste racun od ~r~$%s~s~',
  ['received_payment'] = '~g~primili~s~ ste uplatu od ~r~$%s~s~',
  ['player_not_online'] = 'igrac nije online',
  ['no_money'] = 'nemate dovoljno novca da platite ovaj racun',

  ['act_imp'] = 'radnja nemoguca',
  ['in_vehicle'] = 'ne mozete dati nista nekome u vozilu',
  ['cannot_pickup_room'] = 'nemate dovoljno mjesta u inventoryju za pokupiti ~y~%s~s~!',

  -- Commands
  ['setjob'] = 'dodijeli posao korisniku',
  ['id_param'] = 'ID igraca',
  ['setjob_param2'] = 'ID posla',
  ['setmafia'] = 'dodijeli mafiju korisniku',
  ['setmafia_param2'] = 'ID mafije',
  ['setmafia_param3'] = 'level mafije',
  ['load_ipl'] = 'load IPL',
  ['unload_ipl'] = 'unload IPL',
  ['play_anim'] = 'pokreni animaciju',
  ['play_emote'] = 'pokreni emote',
  ['spawn_car'] = 'spawn auto',
  ['spawn_car_param'] = 'ime auta',
  ['delete_vehicle'] = 'brise vozilo',
  ['spawn_object'] = 'spawn objekt',
  ['spawn_ped'] = 'spawn ped',
  ['spawn_ped_param'] = 'primjer a_m_m_hillbilly_01',
  ['givemoney'] = 'daj novac',
  ['setmoney'] = 'postavi novac igracu',
  ['money_type'] = 'vazece vrste novca: cash, bank, black',
  ['money_set'] = 'netko ~y~visoko rangiran~s~ vam je postavio ~g~$%s~s~ (%s)!',
  ['money_amount'] = 'kolicina novca',
  ['invalid_account'] = 'krivi racun',
  ['account'] = 'racun',
  ['giveaccountmoney'] = 'daj novac',
  ['invalid_item'] = 'krivi predmet',
  ['item'] = 'predmet',
  ['giveitem'] = 'daj predmet',
  ['weapon'] = 'oruzje',
  ['giveweapon'] = 'daj oruzje',
  ['disconnect'] = 'odspoji se sa servera',
  ['chat_clear'] = 'ocisti chat',
  ['chat_clear_all'] = 'ocisti chat svima',
  ['command_clearinventory'] = 'ocisti sve iz inventoryja',
  ['command_clearloadout'] = 'makni sva oruzja igracu',
  ['command_playerid_param'] = 'navedite ID igraca ili ostavite prazno za vas',
  -- Locale settings
  ['locale_digit_grouping_symbol'] = ',',
  ['locale_currency'] = '$%s',

  -- Weapons
  ['weapon_knife'] = 'knife',
  ['weapon_nightstick'] = 'nightstick',
  ['weapon_hammer'] = 'hammer',
  ['weapon_bat'] = 'bat',
  ['weapon_golfclub'] = 'golf club',
  ['weapon_crowbar'] = 'crow bar',
  ['weapon_pistol'] = 'pistol',
  ['weapon_pistol_mk2'] = 'pistol mk2',
  ['weapon_combatpistol'] = 'combat pistol',
  ['weapon_appistol'] = 'AP pistol',
  ['weapon_pistol50'] = 'pistol .50',
  ['weapon_microsmg'] = 'micro SMG',
  ['weapon_smg'] = 'SMG',
  ['weapon_assaultsmg'] = 'assault SMG',
  ['weapon_assaultrifle'] = 'assault rifle',
  ['weapon_carbinerifle'] = 'carbine rifle',
  ['weapon_advancedrifle'] = 'advanced rifle',
  ['weapon_mg'] = 'MG',
  ['weapon_combatmg'] = 'combat MG',
  ['weapon_pumpshotgun'] = 'pump shotgun',
  ['weapon_sawnoffshotgun'] = 'sawed off shotgun',
  ['weapon_assaultshotgun'] = 'assault shotgun',
  ['weapon_bullpupshotgun'] = 'bullpup shotgun',
  ['weapon_stungun'] = 'taser',
  ['weapon_sniperrifle'] = 'sniper rifle',
  ['weapon_heavysniper'] = 'heavy sniper',
  ['weapon_grenadelauncher'] = 'grenade launcher',
  ['weapon_rpg'] = 'rocket launcher',
  ['weapon_stinger'] = 'stinger',
  ['weapon_minigun'] = 'minigun',
  ['weapon_grenade'] = 'grenade',
  ['weapon_stickybomb'] = 'sticky bomb',
  ['weapon_smokegrenade'] = 'smoke grenade',
  ['weapon_bzgas'] = 'bz gas',
  ['weapon_molotov'] = 'molotov cocktail',
  ['weapon_fireextinguisher'] = 'fire extinguisher',
  ['weapon_petrolcan'] = 'jerrycan',
  ['weapon_digiscanner'] = 'digiscanner',
  ['weapon_ball'] = 'ball',
  ['weapon_snspistol'] = 'sns pistol',
  ['weapon_bottle'] = 'bottle',
  ['weapon_gusenberg'] = 'gusenberg sweeper',
  ['weapon_specialcarbine'] = 'special carbine',
  ['weapon_heavypistol'] = 'heavy pistol',
  ['weapon_bullpuprifle'] = 'bullpup rifle',
  ['weapon_dagger'] = 'dagger',
  ['weapon_vintagepistol'] = 'vintage pistol',
  ['weapon_firework'] = 'firework',
  ['weapon_musket'] = 'musket',
  ['weapon_heavyshotgun'] = 'heavy shotgun',
  ['weapon_marksmanrifle'] = 'marksman rifle',
  ['weapon_hominglauncher'] = 'homing launcher',
  ['weapon_proxmine'] = 'proximity mine',
  ['weapon_snowball'] = 'snow ball',
  ['weapon_flaregun'] = 'flaregun',
  ['weapon_garbagebag'] = 'garbage bag',
  ['weapon_handcuffs'] = 'handcuffs',
  ['weapon_combatpdw'] = 'combat pdw',
  ['weapon_marksmanpistol'] = 'marksman pistol',
  ['weapon_knuckle'] = 'knuckledusters',
  ['weapon_hatchet'] = 'hatchet',
  ['weapon_railgun'] = 'railgun',
  ['weapon_machete'] = 'machete',
  ['weapon_machinepistol'] = 'machine pistol',
  ['weapon_switchblade'] = 'switchblade',
  ['weapon_revolver'] = 'heavy revolver',
  ['weapon_dbshotgun'] = 'double barrel shotgun',
  ['weapon_compactrifle'] = 'compact rifle',
  ['weapon_autoshotgun'] = 'auto shotgun',
  ['weapon_battleaxe'] = 'battle axe',
  ['weapon_compactlauncher'] = 'compact launcher',
  ['weapon_minismg'] = 'mini smg',
  ['weapon_pipebomb'] = 'pipe bomb',
  ['weapon_poolcue'] = 'pool cue',
  ['weapon_wrench'] = 'pipe wrench',
  ['weapon_flashlight'] = 'flashlight',
  ['gadget_nightvision'] = 'night vision',
  ['gadget_parachute'] = 'parachute',
  ['weapon_flare'] = 'flare gun',
  ['weapon_doubleaction'] = 'double-Action Revolver',

  -- Weapon Components
  ['component_clip_default'] = 'default Grip',
  ['component_clip_extended'] = 'extended Grip',
  ['component_clip_drum'] = 'drum Magazine',
  ['component_clip_box'] = 'box Magazine',
  ['component_flashlight'] = 'flashlight',
  ['component_scope'] = 'scope',
  ['component_scope_advanced'] = 'advanced Scope',
  ['component_suppressor'] = 'suppressor',
  ['component_grip'] = 'grip',
  ['component_luxary_finish'] = 'luxary Weapon Finish',
}
