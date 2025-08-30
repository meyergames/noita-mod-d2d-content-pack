ctq_perks = {
	{
		id = "CTQ_TIME_TRIAL",
		ui_name = "$perk_riskreward_time_trial_name",
		ui_description = "$perk_riskreward_time_trial_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_time_trial_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_time_trial.png",
		stackable = STACKABLE_NO, -- doesn't work for now (smth with the effect's internal variable tracking)
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_time_trial.xml" )
		end,
	},

	{
		id = "CTQ_RING_OF_LIFE",
		ui_name = "$perk_riskreward_ring_of_life_name",
		ui_description = "$perk_riskreward_ring_of_life_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ring_of_life_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ring_of_life.png",
		stackable = STACKABLE_NO,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_ring_of_life.xml" )
        end,
	},

--	{
--		id = "CTQ_STENDARI_ESSENCE",
--		ui_name = "Stendari Essence",
--		ui_description = "Fire heals you, but water damages you.",
--		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_stendari_essence_016.png",
--		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_stendari_essence.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = false,
--		usable_by_enemies = true,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_healing_fire.xml" )
--        end,
--	},

	{
		id = "CTQ_MASTER_OF_EXPLOSIONS",
		ui_name = "$perk_riskreward_master_of_explosions_name",
		ui_description = "$perk_riskreward_master_of_explosions_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_master_of_explosions_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_master_of_explosions.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
		remove_other_perks = { "PROTECTION_EXPLOSION" },
		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_master_of_explosions.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_master_of_explosions_boost",
			            } )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "mods/RiskRewardBundle/files/scripts/perks/effect_master_of_explosions_extra_durability_to_destroy.lua",
				execute_every_n_frame = "-1",
			} )	
        end,
	},

	{
		id = "CTQ_MASTER_OF_THUNDER",
		ui_name = "$perk_riskreward_master_of_thunder_name",
		ui_description = "$perk_riskreward_master_of_thunder_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_master_of_thunder_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_master_of_thunder.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
		remove_other_perks = { "PROTECTION_ELECTRICITY" },
		func = function( entity_perk_item, entity_who_picked, item_name )
           	LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_master_of_thunder.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_master_of_thunder_boost",
			            } )
        end,
        -- effects:
        -- > x1.33 fire rate and reload speed
        -- > x2.0 projectile speed
        -- > all projectiles deal +5 electric damage and electrocute enemies
        -- TODO: additionally, after the player was electrocuted, they gain a short (scaling with electrocution time) burst of...
        -- > x2.0 move speed
        -- > x1.5 fire rate and reload speed (from x1.33)
        -- > endless flight
	},

	{
		id = "CTQ_MASTER_OF_FIRE",
		ui_name = "$perk_riskreward_master_of_fire_name",
		ui_description = "$perk_riskreward_master_of_fire_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_master_of_fire_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_master_of_fire.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
		remove_other_perks = { "PROTECTION_FIRE" },
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_master_of_fire.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_master_of_fire_boost",
			            } )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "mods/RiskRewardBundle/files/scripts/perks/effect_master_of_fire_increased_damage.lua",
				execute_every_n_frame = "-1",
			} )	
        end,
        -- effects:
        -- > all projectiles deal +10 fire damage and ignite enemies
        -- > everyone takes more damage from fire
        -- > you take less damage from fire when low on health
        -- additionally, while the player is on fire...
        -- > x1.5 move speed (from x1.15)
        -- > slightly increased fire rate
        -- > deal x2.5 fire damage, x1.5 other damage
        -- > endless flight
        -- > burning damage taken spreads to enemies
	},

--	{
--		id = "CTQ_PANIC_MODE",
--		ui_name = "Panic Mode",
--		ui_description = "Upon taking heavy damage, gain a short burst of speed.",
--		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ringoflife_016.png",
--		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ringoflife.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = true,
--		usable_by_enemies = false,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_ringoflife.xml" )
--        end,
--        _remove = function( entity_id )
--            -- do nothing
--		end,
--	},

	{
		id = "CTQ_HUNT_CURSES",
		ui_name = "$perk_riskreward_hunt_curses_name",
		ui_description = "$perk_riskreward_hunt_curses_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_hunt_curses_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_hunt_curses.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_hunt_curses.xml" )
        end,
	},

	-- {
	-- 	id = "CTQ_LIFT_CURSES",
	-- 	ui_name = "$perk_riskreward_lift_curses_name",
	-- 	ui_description = "$perk_riskreward_lift_curses_desc",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_lift_curses_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_lift_curses.png",
    --     -- spawn_requires_flag = "apotheosis_card_unlocked_fire_lukki_spell",  --Requires Aesthete of Heat to be slain
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = true,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
	-- 		dofile_once( "data/scripts/lib/utilities.lua" )
    -- 		dofile_once( "mods/RiskRewardBundle/files/scripts/perks.lua" )

	-- 		for k,v in pairs( ctq_curses ) do
	-- 			if ( has_perk( v.id ) ) then
	-- 				remove_perk( v.id )
	-- 			end
	-- 		end

	-- 		-- LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_lifter.xml" )
    --     end,
	-- },

	-- {
	-- 	id = "CTQ_SET_IN_STONE",
	-- 	ui_name = "$perk_riskreward_set_in_stone_name",
	-- 	ui_description = "$perk_riskreward_set_in_stone_desc",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_set_in_stone_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_set_in_stone.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = true,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
			
	-- 		if reflecting then return end

	-- 	    local EZWand = dofile_once("mods/Apotheosis/lib/EZWand/EZWand.lua")
	-- 	    local wand = EZWand.GetHeldWand()
	-- 	    -- wand.castDelay = wand.castDelay * 0.5
	-- 	    -- wand.rechargeTime = wand.rechargeTime * 0.75
	-- 	    wand.manaMax = math.max( wand.manaMax * 2, 255 )
	-- 	    wand.manaChargeSpeed = math.max( wand.manaChargeSpeed * 2, 255 )
	-- 	    -- wand.spread = 0
	-- 	    wand:SetFrozen( true, true )
    --     end,
	-- },
}


























ctq_curses = {
	{
		id = "CTQ_CURSE_STENDARI",
		ui_name = "$perk_riskreward_curse_stendari_name",
		ui_description = "$perk_riskreward_curse_stendari_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_stendari_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_stendari.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_stendari.xml" )
        end,
	},

	{
		id = "CTQ_CURSE_REPEL_GOLD",
		ui_name = "$perk_riskreward_curse_repel_gold_name",
		ui_description = "$perk_riskreward_curse_repel_gold_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_repel_gold_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_repel_gold.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_repel_gold.xml" )
        end,
	},

	{
		id = "CTQ_CURSE_DIVINE_PRANK",
		ui_name = "$perk_riskreward_curse_divine_prank_name",
		ui_description = "$perk_riskreward_curse_divine_prank_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_divine_prank_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_divine_prank.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           	LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_divine_prank.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_divine_prank",
			            } )
        end,
	},

	-- {
	-- 	id = "CTQ_CURSE_LONELINESS",
	-- 	ui_name = "$perk_riskreward_curse_loneliness",
	-- 	ui_description = "$perk_riskreward_curse_loneliness_description",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_loneliness_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_loneliness_016.png",
	-- 	stackable = STACKABLE_NO,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	not_in_default_perk_pool = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --        LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_loneliness.xml" )
    --     end,
	-- },

	{
		id = "CTQ_CURSE_OVERHEATING",
		ui_name = "$perk_riskreward_curse_overheating_name",
		ui_description = "$perk_riskreward_curse_overheating_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_overheating_wands_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_overheating_wands.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_overheating_wands",
			            } )
        end,
	},

	{
		id = "CTQ_CURSE_NO_RHYTHM",
		ui_name = "$perk_riskreward_curse_no_rhythm_name",
		ui_description = "$perk_riskreward_curse_no_rhythm_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_no_rhythm_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_no_rhythm.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_no_rhythm",
			            } )
        end,
	},

	{
		id = "CTQ_CURSE_FLOOR_IS_LAVA",
		ui_name = "$perk_riskreward_curse_floor_is_lava_name",
		ui_description = "$perk_riskreward_curse_floor_is_lava_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_floor_is_lava_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_floor_is_lava.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           	LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_floor_is_lava.xml" )

           	-- BUG: no longer works after restarting the game
        end,
	},

	{
		id = "CTQ_CURSE_COMBUSTION",
		ui_name = "$perk_riskreward_curse_combustion_name",
		ui_description = "$perk_riskreward_curse_combustion_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_combustion_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_combustion.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_combustion.xml" )
        end,
	},

	{
		id = "CTQ_CURSE_FALL_DAMAGE",
		ui_name = "$perk_riskreward_curse_fall_damage_name",
		ui_description = "$perk_riskreward_curse_fall_damage_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_fall_damage_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_fall_damage.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_fall_damage.xml" )
        end,
	},

	-- fall damage

	-- {
	-- 	id = "CTQ_CURSE_SPORADIC_SPEEDBOOST",
	-- 	ui_name = "$perk_riskreward_curse_sporadic_speedboost",
	-- 	ui_description = "$perk_riskreward_curse_sporadic_speedboost_description",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_no_rhythm_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_curse_no_rhythm_016.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	not_in_default_perk_pool = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --        LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_curse_sporadic_speed.xml" )
    --     end,
	-- },
}

function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

function AddSettingFlag(name)
    ModSettingSet(name, true)
  --  ModSettingSetNextValue(name, true)
end

function RemoveSettingFlag(name)
    ModSettingRemove(name)
end

if ( perk_list ~= nil ) then
	for k, v in pairs( ctq_perks )do
		if HasSettingFlag( v.id .. "_disabled" ) then
			GamePrint( "Perk not added: " .. v.id )
		else
			table.insert( perk_list, v )
		end
	end
end

if ( perk_list ~= nil ) then
	for k, v in pairs( ctq_curses )do
		if HasSettingFlag( v.id .. "_disabled" ) then
			GamePrint( "Perk not added: " .. v.id )
		else
			table.insert( perk_list, v )
		end
	end
end
