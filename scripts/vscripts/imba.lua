-- Dota IMBA version 6.84.1

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = false       -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 60.0             	-- How long should we let people select their hero?
PRE_GAME_TIME = 90.0                   	-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 300.0                -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 2                     	-- How much gold should players get per tick?
GOLD_TICK_TIME = 0.8                    -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1134.0       -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = false     -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = true              	-- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
										-- NOTE: This won't reveal particle effects for everyone. You need to create vision dummies for that.

USE_STANDARD_DOTA_BOT_THINKING = false 	-- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = false       -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = true -- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false               -- Should the game end after a certain number of kills?
--KILLS_TO_END_GAME_FOR_TEAM = 50       -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = false          -- Should we allow heroes to have custom levels?
MAX_LEVEL = 25                        	-- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = false            -- Should we use custom XP values to level up heroes, or the default Dota numbers?

Testing = true
OutOfWorldVector = Vector(11000, 11000, -200)

if not Testing then
  statcollection.addStats({
    modID = "3c618932c8379fe1284bc14438f76c89"
  })
end

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if GameMode == nil then
	GameMode = class({})
end

function GameMode:PostLoadPrecache()
	print("[IMBA] Performing Post-Load precache")

	PrecacheUnitByNameAsync("npc_precache_everything", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
	print("[IMBA] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
	print("[IMBA] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in.
]]
function GameMode:OnHeroInGame(hero)
	print("[IMBA] Hero spawned in game for first time -- " .. hero:GetUnitName())

	if not self.greetPlayers then
		-- At this point a player now has a hero spawned in your map.
		
	    local firstLine = ColorIt("Welcome to ", "green") .. ColorIt("Dota IMBA! ", "orange") .. ColorIt("v6.84.1", "blue");
		-- Send the first greeting in 4 secs.
		Timers:CreateTimer(4, function()
	        GameRules:SendCustomMessage(firstLine, 0, 0)
		end)

		self.greetPlayers = true
	end

	-- Store a reference to the player handle inside this hero handle.
	hero.player = PlayerResource:GetPlayer(hero:GetPlayerID())
	-- Store the player's name inside this hero handle.
	hero.playerName = PlayerResource:GetPlayerName(hero:GetPlayerID())
	-- Store this hero handle in this table.
	table.insert(self.vPlayers, hero)

	-- Show a popup with game instructions.
    ShowGenericPopupToPlayer(hero.player, "#barebones_instructions_title", "#barebones_instructions_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )

	-- This line for example will set the starting gold of every hero to 625 unreliable gold
	hero:SetGold(625, false)

	-- These lines will create an item and add it to the player, effectively ensuring they start with the item
	--local item = CreateItem("item_example_item", hero, hero)
	--hero:AddItem(item)

	if Testing then
		Say(nil, "Testing is on.", false)
		hero:SetGold(50000, false)
		local item_1 = CreateItem("item_imba_diffusal_blade", hero, hero)
		local item_2 = CreateItem("item_imba_manta", hero, hero)
		local item_3 = CreateItem("item_imba_blink", hero, hero)
		local item_4 = CreateItem("item_imba_travel_boots", hero, hero)
		local item_5 = CreateItem("item_imba_ultimate_scepter", hero, hero)
		hero:AddItem(item_1)
		hero:AddItem(item_2)
		hero:AddItem(item_3)
		hero:AddItem(item_4)
		hero:AddItem(item_5)
	end
end

--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
	print("[IMBA] The game has officially begun")

	-- Makes all non-T1 structures invulnerable
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name ~= "dota_goodguys_tower1_top" and name ~= "dota_goodguys_tower1_mid" and name ~= "dota_goodguys_tower1_bot"
			and name ~= "dota_badguys_tower1_top" and name ~= "dota_badguys_tower1_mid" and name ~= "dota_badguys_tower1_bot" then
				v:AddNewModifier(nil, nil, "modifier_invulnerable", {})
			end
		end
end

function GameMode:PlayerSay( keys )
	--local ply = keys.ply
	--local hero = ply:GetAssignedHero()
	--local txt = keys.text

	--if keys.teamOnly then
		-- This text was team-only.
	--end

	--if txt == nil or txt == "" then
	--	return
	--end

  -- At this point we have valid text from a player.
	--print("P" .. ply .. " wrote: " .. keys.text)
end

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	print('[IMBA] Player Disconnected ' .. tostring(keys.userid))
	PrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	print("[IMBA] GameRules State Changed")
	PrintTable(keys)

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
	elseif newState == DOTA_GAMERULES_STATE_INIT then
		Timers:RemoveTimer("alljointimer")
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		local et = 6
		if self.bSeenWaitForPlayers then
			et = .01
		end
		Timers:CreateTimer("alljointimer", {
			useGameTime = true,
			endTime = et,
			callback = function()
				if PlayerResource:HaveAllPlayersJoined() then
					GameMode:PostLoadPrecache()
					GameMode:OnAllPlayersLoaded()
					return
				end
				return 1
			end})
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameMode:OnGameInProgress()
	end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	-- Reaper's Scythe buyback clean-up
	if npc:IsRealHero() then
		npc:SetBuyBackDisabledByReapersScythe(false)
	end
	
	-- First hero spawn function call
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		GameMode:OnHeroInGame(npc)
	end

	-- Creep bounty adjustment
	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() then
		local gold_bounty = npc:GetGoldBounty()
		local xp_bounty = npc:GetDeathXP()

		npc:SetDeathXP(math.floor( xp_bounty * 1.3 ))
		npc:SetMaximumGoldBounty(math.floor( gold_bounty * 1.4 ))
		npc:SetMinimumGoldBounty(math.floor( gold_bounty * 1.3 ))
	end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
--	print("[IMBA] Entity Hurt")
--	PrintTable(keys)
--	local attacker = EntIndexToHScript(keys.entindex_attacker)
--	local victim = EntIndexToHScript(keys.entindex_killed)
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
--	print ( '[IMBA] OnItemPurchased' )
--	PrintTable(keys)

--	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
--	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
--	local player = PlayerResource:GetPlayer(keys.PlayerID)
--	local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)

end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
--	print ( '[IMBA] OnItemPurchased' )
--	PrintTable(keys)

	-- The playerID of the hero who is buying something
--	local plyID = keys.PlayerID
--	if not plyID then return end

	-- The name of the item purchased
--	local itemName = keys.itemname

	-- The cost of the item purchased
--	local itemcost = keys.itemcost

end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
--	print('[IMBA] AbilityUsed')
--	PrintTable(keys)

--	local player = EntIndexToHScript(keys.PlayerID)
--	local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
--	print('[IMBA] OnNonPlayerUsedAbility')
--	PrintTable(keys)

--	local abilityname = keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
--	print('[IMBA] OnPlayerChangedName')
--	PrintTable(keys)

--	local newName = keys.newname
--	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
--	print ('[IMBA] OnPlayerLearnedAbility')
--	PrintTable(keys)

--	local player = EntIndexToHScript(keys.player)
--	local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
--	print ('[IMBA] OnAbilityChannelFinished')
--	PrintTable(keys)

--	local abilityname = keys.abilityname
--	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
--	print ('[IMBA] OnPlayerLevelUp')
--	PrintTable(keys)

--	local player = EntIndexToHScript(keys.player)
--	local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
--	print ('[IMBA] OnLastHit')
--	PrintTable(keys)

--	local isFirstBlood = keys.FirstBlood == 1
--	local isHeroKill = keys.HeroKill == 1
--	local isTowerKill = keys.TowerKill == 1
--	local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
--	print ('[IMBA] OnTreeCut')
--	PrintTable(keys)

--	local treeX = keys.tree_x
--	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
--	print ('[IMBA] OnRuneActivated')
--	PrintTable(keys)

--	local player = PlayerResource:GetPlayer(keys.PlayerID)
--	local rune = keys.rune

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
--	print ('[IMBA] OnPlayerTakeTowerDamage')
--	PrintTable(keys)

--	local player = PlayerResource:GetPlayer(keys.PlayerID)
--	local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
--	print ('[IMBA] OnPlayerPickHero')
--	PrintTable(keys)

--	local heroClass = keys.hero
--	local heroEntity = EntIndexToHScript(keys.heroindex)
--	local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
	print ('[IMBA] OnTeamKillCredit')
	PrintTable(keys)

	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	local numKills = keys.herokills
	local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	--print( '[IMBA] OnEntityKilled Called' )
	--PrintTable( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	-- Sets the game winner if an ancient is destroyed
	if killedUnit:GetName() == "npc_dota_badguys_fort" then
		GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
	elseif killedUnit:GetName() == "npc_dota_goodguys_fort" then
		GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
	end

	if killedUnit:IsRealHero() then
		print ("KILLED: " .. killedUnit:GetName() .. " -- KILLER: " .. killerEntity:GetName())
		if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
			self.nRadiantKills = self.nRadiantKills + 1
			if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			end
			-- Hero kill and assist bounty
			if killerEntity:IsHero() then
				local allies = FindUnitsInRadius(killerEntity:GetTeam(), killedUnit:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
				local killer_bounty = 100 + killedUnit:GetLevel() * 10
				local assist_bounty
				if #allies == 1 then
					assist_bounty = 140 + killedUnit:GetLevel() * 7
				elseif #allies == 2 then
					assist_bounty = 110 + killedUnit:GetLevel() * 6
				elseif #allies == 3 then
					assist_bounty = 90 + killedUnit:GetLevel() * 5
				elseif #allies == 4 then
					assist_bounty = 70 + killedUnit:GetLevel() * 4
				else
					assist_bounty = 60 + killedUnit:GetLevel() * 3
				end

				killerEntity:ModifyGold(killer_bounty, true, 0)
				for _,ally in pairs(allies) do
					ally:ModifyGold(assist_bounty, true, 0)
				end
			end

		elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and killerEntity:GetTeam() == DOTA_TEAM_BADGUYS then
			self.nDireKills = self.nDireKills + 1
			if END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
			end

			-- Hero kill and assist bounty
			if killerEntity:IsHero() then
				local allies = FindUnitsInRadius(killerEntity:GetTeam(), killedUnit:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
				local killer_bounty = 100 + killedUnit:GetLevel() * 10
				local assist_bounty
				if #allies == 1 then
					assist_bounty = 140 + killedUnit:GetLevel() * 7
				elseif #allies == 2 then
					assist_bounty = 110 + killedUnit:GetLevel() * 6
				elseif #allies == 3 then
					assist_bounty = 90 + killedUnit:GetLevel() * 5
				elseif #allies == 4 then
					assist_bounty = 70 + killedUnit:GetLevel() * 4
				else
					assist_bounty = 60 + killedUnit:GetLevel() * 3
				end

				killerEntity:ModifyGold(killer_bounty, true, 0)
				for _,ally in pairs(allies) do
					ally:ModifyGold(assist_bounty, true, 0)
				end
			end
		end

		if SHOW_KILLS_ON_TOPBAR then
			GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
			GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )
		end
	end

	-- Reaper's Scythe death timer increase
	if killedUnit.scythe_added_respawn then
		killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime() + killedUnit.scythe_added_respawn)
	end

	-- Tower invulnerability removal
	if killedUnit:GetName() == "npc_dota_goodguys_tower1_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower2_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower1_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower2_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower1_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower2_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower2_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower3_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower2_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower3_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower2_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower3_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower3_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_melee_rax_top" or name == "npc_dota_goodguys_range_rax_top" or name == "npc_dota_goodguys_tower4" or name == "npc_dota_goodguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower3_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_melee_rax_mid" or name == "npc_dota_goodguys_range_rax_mid" or name == "npc_dota_goodguys_tower4" or name == "npc_dota_goodguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower3_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_melee_rax_bot" or name == "npc_dota_goodguys_range_rax_bot" or name == "npc_dota_goodguys_tower4" or name == "npc_dota_goodguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower4" then
		local other_t4_killed = true
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower4" then
				other_t4_killed = false
			end
		end
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_fort" and other_t4_killed then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower1_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower2_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower1_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower2_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower1_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower2_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower2_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower3_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower2_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower3_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower2_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower3_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower3_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_melee_rax_top" or name == "npc_dota_badguys_range_rax_top" or name == "npc_dota_badguys_tower4" or name == "npc_dota_badguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower3_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_melee_rax_mid" or name == "npc_dota_badguys_range_rax_mid" or name == "npc_dota_badguys_tower4" or name == "npc_dota_badguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower3_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_melee_rax_bot" or name == "npc_dota_badguys_range_rax_bot" or name == "npc_dota_badguys_tower4" or name == "npc_dota_badguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower4" then
		local other_t4_killed = true
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower4" then
				other_t4_killed = false
			end
		end
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_fort" and other_t4_killed then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	end
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	print('[IMBA] Starting to load Barebones gamemode...')

	-- Setup rules
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	print('[IMBA] GameRules set')

	InitLogFile( "log/barebones.txt","")

	-- Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.  If you are interested in the other events, you can uncomment the
	-- ListenToGameEvent line and add a function to handle the event
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
	--ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
	--ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
	--ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
	--ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
	--ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
	--ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
	--ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
	--ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", 0 )

	Convars:RegisterCommand('player_say', function(...)
		local arg = {...}
		table.remove(arg,1)
		local sayType = arg[1]
		table.remove(arg,1)

		local cmdPlayer = Convars:GetCommandClient()
		keys = {}
		keys.ply = cmdPlayer
		keys.teamOnly = false
		keys.text = table.concat(arg, " ")

		if (sayType == 4) then
			-- Student messages
		elseif (sayType == 3) then
			-- Coach messages
		elseif (sayType == 2) then
			-- Team only
			keys.teamOnly = true
			-- Call your player_say function here like
			self:PlayerSay(keys)
		else
			-- All chat
			-- Call your player_say function here like
			self:PlayerSay(keys)
		end
	end, 'player say', 0)

	-- Fill server with fake clients
	-- Fake clients don't use the default bot AI for buying items or moving down lanes and are sometimes necessary for debugging
	Convars:RegisterCommand('fake', function()
		-- Check if the server ran it
		if not Convars:GetCommandClient() then
			-- Create fake Players
			SendToServerConsole('dota_create_fake_clients')

			Timers:CreateTimer('assign_fakes', {
				useGameTime = false,
				endTime = Time(),
				callback = function(barebones, args)
					local userID = 20
					for i=0, 9 do
						userID = userID + 1
						-- Check if this player is a fake one
						if PlayerResource:IsFakeClient(i) then
							-- Grab player instance
							local ply = PlayerResource:GetPlayer(i)
							-- Make sure we actually found a player instance
							if ply then
								CreateHeroForPlayer('npc_dota_hero_axe', ply)
								self:OnConnectFull({
									userid = userID,
									index = ply:entindex()-1
								})

								ply:GetAssignedHero():SetControllableByPlayer(0, true)
							end
						end
					end
				end})
		end
	end, 'Connects and assigns fake Players.', 0)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.vUserIds = {}
	self.vSteamIds = {}
	self.vBots = {}
	self.vBroadcasters = {}

	self.vPlayers = {}
	self.vRadiant = {}
	self.vDire = {}

	self.nRadiantKills = 0
	self.nDireKills = 0

	self.bSeenWaitForPlayers = false

	if RECOMMENDED_BUILDS_DISABLED then
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_SHOP_SUGGESTEDITEMS, false )
	end

	print('[IMBA] Done loading Barebones gamemode!\n\n')
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

		self:OnFirstPlayerLoaded()
	end
end

-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function GameMode:PlayerConnect(keys)
	print('[IMBA] PlayerConnect')
	PrintTable(keys)

	if keys.bot == 1 then
		-- This user is a Bot, so add it to the bots table
		self.vBots[keys.userid] = 1
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	print ('[IMBA] OnConnectFull')
	PrintTable(keys)
	GameMode:CaptureGameMode()

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Update the user ID table with this user
	self.vUserIds[keys.userid] = ply

	-- Update the Steam ID table
	self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply

	-- If the player is a broadcaster flag it in the Broadcasters table
	if PlayerResource:IsBroadcaster(playerID) then
		self.vBroadcasters[keys.userid] = 1
		return
	end
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
	print( '******* Example Console Command ***************' )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			-- Do something here for the player who called this command
			PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
		end
	end
	print( '*********************************************' )
end
