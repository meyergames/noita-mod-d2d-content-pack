d2d_perks = {
	{
		id = "D2D_TIME_TRIAL",
		ui_name = "$perk_riskreward_time_trial_name",
		ui_description = "$perk_riskreward_time_trial_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/time_trial_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/time_trial.png",
		stackable = STACKABLE_NO, -- doesn't work for now (smth with the effect's internal variable tracking)
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_time_trial.xml" )
		end,
	},

	-- {
	-- 	id = "D2D_RING_OF_LIFE",
	-- 	ui_name = "$perk_riskreward_ring_of_life_name",
	-- 	ui_description = "$perk_riskreward_ring_of_life_desc",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/ring_of_life_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/ring_of_life.png",
	-- 	stackable = STACKABLE_NO,
	-- 	one_off_effect = true,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --         LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_ring_of_life.xml" )
    --     end,
	-- },

	{
		id = "D2D_EVOLVING_WANDS",
		ui_name = "$perk_riskreward_evolving_wands_name",
		ui_description = "$perk_riskreward_evolving_wands_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/evolving_wands_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/evolving_wands.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "mods/RiskRewardBundle/files/scripts/perks/effect_evolving_wands_update.lua",
				execute_every_n_frame = "60",
			} )
        end,
	},

	{
		id = "D2D_MASTER_OF_EXPLOSIONS",
		ui_name = "$perk_riskreward_master_of_explosions_name",
		ui_description = "$perk_riskreward_master_of_explosions_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/master_of_explosions_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/master_of_explosions.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
		-- remove_other_perks = { "PROTECTION_EXPLOSION" },
		func = function( entity_perk_item, entity_who_picked, item_name )
			local immunity_effect_id = GameGetGameEffect( entity_who_picked, "PROTECTION_EXPLOSION" )
			if immunity_effect_id ~= nil then
				EntityRemoveComponent( entity_who_picked, immunity_effect_id )
			end

            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
            { 
	            extra_modifier = "d2d_master_of_explosions_boost",
            } )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "mods/RiskRewardBundle/files/scripts/perks/effect_master_of_explosions_extra_durability_to_destroy.lua",
				execute_every_n_frame = "-1",
			} )
        end,
	},

	{
		id = "D2D_MASTER_OF_THUNDER",
		ui_name = "$perk_riskreward_master_of_thunder_name",
		ui_description = "$perk_riskreward_master_of_thunder_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/master_of_thunder_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/master_of_thunder.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
		-- remove_other_perks = { "PROTECTION_ELECTRICITY" },
		func = function( entity_perk_item, entity_who_picked, item_name )
			local immunity_effect_id = GameGetGameEffect( entity_who_picked, "PROTECTION_ELECTRICITY" )
			if immunity_effect_id ~= nil then
				EntityRemoveComponent( entity_who_picked, immunity_effect_id )
			end

           	LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_master_of_thunder.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
            { 
	            extra_modifier = "d2d_master_of_thunder_boost",
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
		id = "D2D_MASTER_OF_FIRE",
		ui_name = "$perk_riskreward_master_of_fire_name",
		ui_description = "$perk_riskreward_master_of_fire_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/master_of_fire_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/master_of_fire.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
		-- remove_other_perks = { "PROTECTION_FIRE" },
		func = function( entity_perk_item, entity_who_picked, item_name )
			local immunity_effect_id = GameGetGameEffect( entity_who_picked, "PROTECTION_FIRE" )
			if immunity_effect_id ~= nil then
				EntityRemoveComponent( entity_who_picked, immunity_effect_id )
			end

            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_master_of_fire.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
            { 
	            extra_modifier = "d2d_master_of_fire_boost",
            } )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "mods/RiskRewardBundle/files/scripts/perks/effect_master_of_fire_increased_damage.lua",
				execute_every_n_frame = "-1",
			} )	
        end,
        -- effects:
        -- > all projectiles deal +5 fire damage and ignite enemies
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
--		id = "D2D_PANIC_MODE",
--		ui_name = "Panic Mode",
--		ui_description = "Upon taking heavy damage, gain a short burst of speed.",
--		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/ringoflife_016.png",
--		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/ringoflife.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = true,
--		usable_by_enemies = false,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_ringoflife.xml" )
--        end,
--        _remove = function( entity_id )
--            -- do nothing
--		end,
--	},

	{
		id = "D2D_HUNT_CURSES",
		ui_name = "$perk_riskreward_hunt_curses_name",
		ui_description = "$perk_riskreward_hunt_curses_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/hunt_curses_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/hunt_curses.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_hunt_curses.xml" )
        end,
	},

	-- {
	-- 	id = "D2D_HOMEBODY_WANDS",
	-- 	ui_name = "Homebody",
	-- 	ui_description = "Wands are much stronger in their home biome.",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/homebody_wands_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/homebody_wands.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
	-- 		-- LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_consume_local.xml" )
	-- 		-- EntityAddComponent2( entity_who_picked, "LuaComponent", 
	-- 		-- { 
	-- 		-- 	script_interacting = "mods/RiskRewardBundle/files/scripts/perks/effect_consume_local_interacting.lua",
	-- 		-- 	execute_every_n_frame = -1,
	-- 		-- } )
	-- 		EntityAddComponent2( entity_who_picked, "LuaComponent", 
	-- 		{ 
	-- 			script_shot = "mods/RiskRewardBundle/files/scripts/perks/effect_homebodies_shot.lua",
	-- 			execute_every_n_frame = -1,
	-- 		} )	
    --     end,
	-- },

	-- {
	-- 	id = "D2D_LIFT_CURSES",
	-- 	ui_name = "$perk_riskreward_lift_curses_name",
	-- 	ui_description = "$perk_riskreward_lift_curses_desc",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/lift_curses_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/lift_curses.png",
    --     -- spawn_requires_flag = "apotheosis_card_unlocked_fire_lukki_spell",  --Requires Aesthete of Heat to be slain
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = true,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
	-- 		dofile_once( "data/scripts/lib/utilities.lua" )
    -- 		dofile_once( "mods/RiskRewardBundle/files/scripts/perks.lua" )

	-- 		for k,v in pairs( d2d_curses ) do
	-- 			if ( has_perk( v.id ) ) then
	-- 				remove_perk( v.id )
	-- 			end
	-- 		end

	-- 		-- LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_curse_lifter.xml" )
    --     end,
	-- },

	-- {
	-- 	id = "D2D_SET_IN_STONE",
	-- 	ui_name = "$perk_riskreward_set_in_stone_name",
	-- 	ui_description = "$perk_riskreward_set_in_stone_desc",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/set_in_stone_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/set_in_stone.png",
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


























d2d_curses = {
	{
		id = "D2D_CURSE_STENDARI",
		ui_name = "$perk_riskreward_curse_stendari_name",
		ui_description = "$perk_riskreward_curse_stendari_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/stendari_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/stendari.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/curses/effect_curse_stendari.xml" )
        end,
	},

	{
		id = "D2D_CURSE_REPEL_GOLD",
		ui_name = "$perk_riskreward_curse_repel_gold_name",
		ui_description = "$perk_riskreward_curse_repel_gold_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/repel_gold_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/repel_gold.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/curses/effect_curse_repel_gold.xml" )
        end,
	},

	{
		id = "D2D_CURSE_DIVINE_PRANK",
		ui_name = "$perk_riskreward_curse_divine_prank_name",
		ui_description = "$perk_riskreward_curse_divine_prank_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/divine_prank_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/divine_prank.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           	LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/curses/effect_curse_divine_prank.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "d2d_divine_prank",
			            } )
        end,
	},

	-- {
	-- 	id = "D2D_CURSE_LONELINESS",
	-- 	ui_name = "$perk_riskreward_curse_loneliness",
	-- 	ui_description = "$perk_riskreward_curse_loneliness_description",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/loneliness_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/loneliness_016.png",
	-- 	stackable = STACKABLE_NO,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	not_in_default_perk_pool = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --        LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_curse_loneliness.xml" )
    --     end,
	-- },

	{
		id = "D2D_CURSE_OVERHEATING",
		ui_name = "$perk_riskreward_curse_overheating_name",
		ui_description = "$perk_riskreward_curse_overheating_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/overheating_wands_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/overheating_wands.png",
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
				            extra_modifier = "d2d_overheating_wands",
			            } )
        end,
	},

	{
		id = "D2D_CURSE_NO_RHYTHM",
		ui_name = "$perk_riskreward_curse_no_rhythm_name",
		ui_description = "$perk_riskreward_curse_no_rhythm_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/no_rhythm_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/no_rhythm.png",
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
				            extra_modifier = "d2d_no_rhythm",
			            } )
        end,
	},

	{
		id = "D2D_CURSE_FLOOR_IS_LAVA",
		ui_name = "$perk_riskreward_curse_floor_is_lava_name",
		ui_description = "$perk_riskreward_curse_floor_is_lava_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/floor_is_lava_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/floor_is_lava.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           	LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/curses/effect_curse_floor_is_lava.xml" )

           	-- BUG: no longer works after restarting the game
        end,
	},

	{
		id = "D2D_CURSE_COMBUSTION",
		ui_name = "$perk_riskreward_curse_combustion_name",
		ui_description = "$perk_riskreward_curse_combustion_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/combustion_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/combustion.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/curses/effect_curse_combustion.xml" )
        end,
	},

	{
		id = "D2D_CURSE_FALL_DAMAGE",
		ui_name = "$perk_riskreward_curse_fall_damage_name",
		ui_description = "$perk_riskreward_curse_fall_damage_desc",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/fall_damage_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/curses/fall_damage.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/curses/effect_curse_fall_damage.xml" )
        end,
	},

	-- fall damage

	-- {
	-- 	id = "D2D_CURSE_SPORADIC_SPEEDBOOST",
	-- 	ui_name = "$perk_riskreward_curse_sporadic_speedboost",
	-- 	ui_description = "$perk_riskreward_curse_sporadic_speedboost_description",
	-- 	ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/no_rhythm_016.png",
	-- 	perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/no_rhythm_016.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	not_in_default_perk_pool = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --        LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/perks/effect_curse_sporadic_speed.xml" )
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
	for k, v in pairs( d2d_perks )do
		if HasSettingFlag( v.id .. "_disabled" ) then
			-- GamePrint( "Perk not added: " .. v.id )
		else
			table.insert( perk_list, v )
		end
	end
end

if ( perk_list ~= nil ) then
	for k, v in pairs( d2d_curses )do
		if HasSettingFlag( v.id .. "_disabled" ) then
			-- GamePrint( "Perk not added: " .. v.id )
		else
			table.insert( perk_list, v )
		end
	end
end
