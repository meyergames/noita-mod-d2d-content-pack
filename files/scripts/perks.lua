d2d_perks = {

	{
		id = "D2D_TIME_TRIAL",
		ui_name = "$perk_d2d_time_trial_name",
		ui_description = "$perk_d2d_time_trial_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/time_trial_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/time_trial.png",
		stackable = STACKABLE_NO, -- doesn't work for now (smth with the effect's internal variable tracking)
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_time_trial.xml" )
		end,
	},

	-- {
	-- 	id = "D2D_BALLOON_HEART",
	-- 	ui_name = "$perk_d2d_balloon_heart_name",
	-- 	ui_description = "$perk_d2d_balloon_heart_desc",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/balloon_heart_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/balloon_heart.png",
	-- 	stackable = STACKABLE_YES, -- doesn't work for now (smth with the effect's internal variable tracking)
	-- 	one_off_effect = true,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
	-- 		local x,y = EntityGetTransform( entity_who_picked )
    --         LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/balloon_heart.xml" )

    --         dofile_once( "data/scripts/lib/utilities.lua" )
	-- 		local lua_comp_id = EntityAddComponent2( entity_who_picked, "LuaComponent", {
    --     		script_damage_received="mods/D2DContentPack/files/scripts/perks/effect_balloon_heart_on_damage_received.lua",
    --     		execute_every_n_frame=-1,
	-- 		})
	-- 		set_internal_int( entity_who_picked, "balloon_heart_lua_comp_id", lua_comp_id )
	-- 	end,
	-- },

	-- {
	-- 	id = "D2D_RING_OF_LIFE",
	-- 	ui_name = "$perk_d2d_ring_of_life_name",
	-- 	ui_description = "$perk_d2d_ring_of_life_desc",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ring_of_life_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ring_of_life.png",
	-- 	stackable = STACKABLE_NO,
	-- 	one_off_effect = true,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --         LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_ring_of_life.xml" )
    --     end,
	-- },

	{
		id = "D2D_EVOLVING_WANDS",
		ui_name = "$perk_d2d_evolving_wands_name",
		ui_description = "$perk_d2d_evolving_wands_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/evolving_wands_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/evolving_wands.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_evolving_wands_update.lua",
					execute_every_n_frame = "60",
				} )
			end
        end,
	},

	{
		id = "D2D_WANDSMITH",
		ui_name = "$perk_d2d_wandsmith_name",
		ui_description = "$perk_d2d_wandsmith_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/wandsmith_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/wandsmith.png",
		stackable = STACKABLE_NO, -- doesn't work for now (smth with the effect's internal variable tracking)
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_perk_item )
    		EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer.xml", x, y - 20 )
		end,
	},

	{
		id = "D2D_MASTER_OF_EXPLOSIONS",
		ui_name = "$perk_d2d_master_of_explosions_name",
		ui_description = "$perk_d2d_master_of_explosions_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/master_of_explosions_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/master_of_explosions.png",
		stackable = STACKABLE_NO,
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
				script_shot = "mods/D2DContentPack/files/scripts/perks/effect_master_of_explosions_shot.lua",
				execute_every_n_frame = "-1",
			} )
        end,
	},

	{
		id = "D2D_MASTER_OF_LIGHTNING",
		ui_name = "$perk_d2d_master_of_lightning_name",
		ui_description = "$perk_d2d_master_of_lightning_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/master_of_lightning_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/master_of_lightning.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = true,
		-- remove_other_perks = { "PROTECTION_ELECTRICITY" },
		func = function( entity_perk_item, entity_who_picked, item_name )
			local immunity_effect_id = GameGetGameEffect( entity_who_picked, "PROTECTION_ELECTRICITY" )
			if immunity_effect_id ~= nil then
				EntityRemoveComponent( entity_who_picked, immunity_effect_id )
			end

           	LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_master_of_lightning.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
            { 
	            extra_modifier = "d2d_master_of_lightning_boost",
            } )
        end,
        -- effects:
        -- > x1.33 fire rate and reload speed
        -- > x2.0 projectile speed
        -- > all projectiles deal +5 electric damage and electrocute enemies
        -- after the player was electrocuted, they gain a short (scaling with electrocution time) burst of...
        -- > x2.0 move speed
        -- > x1.5 fire rate and reload speed (from x1.33)
        -- > increased mana charge speed
        -- > endless flight
	},

	{
		id = "D2D_MASTER_OF_FIRE",
		ui_name = "$perk_d2d_master_of_fire_name",
		ui_description = "$perk_d2d_master_of_fire_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/master_of_fire_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/master_of_fire.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = true,
		-- remove_other_perks = { "PROTECTION_FIRE" },
		func = function( entity_perk_item, entity_who_picked, item_name )
			local immunity_effect_id = GameGetGameEffect( entity_who_picked, "PROTECTION_FIRE" )
			if immunity_effect_id ~= nil then
				EntityRemoveComponent( entity_who_picked, immunity_effect_id )
			end

            LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_master_of_fire.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
            { 
	            extra_modifier = "d2d_master_of_fire_boost",
            } )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "mods/D2DContentPack/files/scripts/perks/effect_master_of_fire_increased_damage.lua",
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
--		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ringoflife_016.png",
--		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ringoflife.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = true,
--		usable_by_enemies = false,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_ringoflife.xml" )
--        end,
--        _remove = function( entity_id )
--            -- do nothing
--		end,
--	},

	{
		id = "D2D_BORROWED_TIME",
		ui_name = "$perk_d2d_borrowed_time_name",
		ui_description = "$perk_d2d_borrowed_time_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/borrowed_time_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/borrowed_time.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_damage_received = "mods/D2DContentPack/files/scripts/perks/effect_borrowed_time_damage_incoming.lua",
				execute_every_n_frame = "-1",
			} )
        end,
	},

	{
		id = "D2D_HUNT_CURSES",
		ui_name = "$perk_d2d_hunt_curses_name",
		ui_description = "$perk_d2d_hunt_curses_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/hunt_curses_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/hunt_curses.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_hunt_curses.xml" )
        end,
	},

	{
		id = "D2D_BLESSINGS_AND_CURSE",
		ui_name = "$perk_d2d_blessings_and_curse_name",
		ui_description = "$perk_d2d_blessings_and_curse_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/blessings_and_curse_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/blessings_and_curse.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_perk_item )

			-- temporarily set perk destroy chance to 0, until player leaves HM
			local value_to_cache = GlobalsGetValue( "TEMPLE_PERK_DESTROY_CHANCE", 100 )
			-- local biome_name = BiomeMapGetName( x, y )
			set_internal_int( get_player(), "blurse_cached_perk_destroy_chance", tonumber( value_to_cache ) )
			-- addNewInternalVariable( get_player(), "blurse_init_biome", "value_string", biome_name )

			GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", 0 )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags="perk_component",
				script_source_file="mods/D2DContentPack/files/scripts/perks/effect_blessings_and_curse_revert.lua",
				execute_every_n_frame="3",
				remove_after_executed="1",
			} )

            local nearby_perks = EntityGetInRadiusWithTag( x, y, 50, "perk" )
            if nearby_perks then
            	dofile_once( "data/scripts/perks/perk.lua" )
				for _,perk_id in ipairs( nearby_perks ) do
					local vscomps = EntityGetComponentIncludingDisabled( perk_id, "VariableStorageComponent" )
					local has_pdro = false
					for _,vscomp in ipairs( vscomps ) do
						local var_name = ComponentGetValue2( vscomp, "name" )
						if var_name == "perk_dont_remove_others" then
							has_pdro = true
							ComponentSetValue2( vscomp, "value_bool", true )
						end
					end
					if not has_pdro then
						addNewInternalVariable( perk_id, "perk_dont_remove_others", "value_bool", true )
					end
				end
			end

			-- spawn a random extra perk
			perk_spawn_random( x, y, true )

			-- apply a random curse
			apply_random_curse( get_player() )
		end,
	},


	-- {
	-- 	id = "D2D_HOMEBODY_WANDS",
	-- 	ui_name = "Homebody",
	-- 	ui_description = "Wands are much stronger in their home biome.",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/homebody_wands_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/homebody_wands.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
	-- 		-- LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_consume_local.xml" )
	-- 		-- EntityAddComponent2( entity_who_picked, "LuaComponent", 
	-- 		-- { 
	-- 		-- 	script_interacting = "mods/D2DContentPack/files/scripts/perks/effect_consume_local_interacting.lua",
	-- 		-- 	execute_every_n_frame = -1,
	-- 		-- } )
	-- 		EntityAddComponent2( entity_who_picked, "LuaComponent", 
	-- 		{ 
	-- 			script_shot = "mods/D2DContentPack/files/scripts/perks/effect_homebodies_shot.lua",
	-- 			execute_every_n_frame = -1,
	-- 		} )	
    --     end,
	-- },

	-- {
	-- 	id = "D2D_LIFT_CURSES",
	-- 	ui_name = "$perk_d2d_lift_curses_name",
	-- 	ui_description = "$perk_d2d_lift_curses_desc",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/lift_curses_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/lift_curses.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = true,
	-- 	usable_by_enemies = false,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
	-- 		dofile_once( "data/scripts/lib/utilities.lua" )
    -- 		dofile_once( "mods/D2DContentPack/files/scripts/perks.lua" )

	-- 		for k,v in pairs( d2d_curses ) do
	-- 			if ( has_perk( v.id ) ) then
	-- 				remove_perk( v.id )
	-- 			end
	-- 		end

	-- 		-- LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_curse_lifter.xml" )
    --     end,
	-- },

	-- {
	-- 	id = "D2D_SET_IN_STONE",
	-- 	ui_name = "$perk_d2d_set_in_stone_name",
	-- 	ui_description = "$perk_d2d_set_in_stone_desc",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/set_in_stone_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/set_in_stone.png",
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













local d2d_apoth_perks = nil
if ModIsEnabled( "Apotheosis" ) then
	d2d_apoth_perks = {
		{
			id = "D2D_FAIRY_FRIEND",
			ui_name = "$perk_d2d_fairy_friend_name",
			ui_description = "$perk_d2d_fairy_friend_desc",
			ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/fairy_friend_016.png",
			perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/fairy_friend.png",
			stackable = STACKABLE_NO,
			one_off_effect = false,
			usable_by_enemies = false,
			func = function( entity_perk_item, entity_who_picked, item_name )
		        EntityAddComponent( entity_who_picked, "LuaComponent",
		        {
		            script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_fairy_friend_update.lua",
		            execute_every_n_frame = "20",
		        } )
	            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
	            { 
		            extra_modifier = "d2d_fairy_friend",
	            } )
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					script_damage_about_to_be_received = "mods/D2DContentPack/files/scripts/perks/effect_fairy_friend_damage_incoming.lua",
					execute_every_n_frame = "-1",
				} )

	            -- local gdcomp = EntityGetComponentIncludingDisabled( entity_who_picked, "GenomeDataComponent" )
				-- ComponentSetValue2( gdcomp, "herd_id", StringToHerdId( "ghost_fairy" ) )
				-- GamePrint( "You now belong to the herd of fairies!" )
	        end,
		},

		{
			id = "D2D_FELINE_AFFECTION",
			ui_name = "$perk_d2d_feline_affection_name",
			ui_description = "$perk_d2d_feline_affection_desc",
			ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/feline_affection_016.png",
			perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/feline_affection.png",
			stackable = STACKABLE_YES,
			max_in_perk_pool = 4,
			stackable_maximum = 4,
			one_off_effect = false,
			usable_by_enemies = false,
			func = function( entity_perk_item, entity_who_picked, item_name )
				-- no direct function
				local x, y = EntityGetTransform( get_player() )
				GamePlaySound( "mods/Apotheosis/mocreeps_audio.bank", "mocreeps_audio/kittycat/voc_attack_purr_01", x, y )

				dofile_once( "data/scripts/lib/utilities.lua" )
				if get_perk_pickup_count( "D2D_FELINE_AFFECTION" ) == 1 then
			        EntityAddComponent( entity_who_picked, "LuaComponent",
			        {
			            script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_feline_affection_update.lua",
			            execute_every_n_frame = "20",
			        } )
			    end
				-- okay maybe a little function
	        end,
		},

		{
			id = "D2D_CAT_RADAR",
			ui_name = "$perk_d2d_cat_radar_name",
			ui_description = "$perk_d2d_cat_radar_desc",
			ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/cat_radar_016.png",
			perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/cat_radar.png",
			stackable = STACKABLE_NO,
			one_off_effect = false,
			usable_by_enemies = false,
			not_in_default_perk_pool = true,
			func = function( entity_perk_item, entity_who_picked, item_name )
				LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_cat_radar.xml" )
	        end,
		}
	}
end

























d2d_curses = {
	{
		id = "D2D_CURSE_STENDARI",
		ui_name = "$perk_d2d_curse_stendari_name",
		ui_description = "$perk_d2d_curse_stendari_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/stendari_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/stendari.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_stendari.xml" )
        end,
	},

	{
		id = "D2D_CURSE_REPEL_GOLD",
		ui_name = "$perk_d2d_curse_repel_gold_name",
		ui_description = "$perk_d2d_curse_repel_gold_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/repel_gold_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/repel_gold.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_repel_gold.xml" )
        end,
	},

	{
		id = "D2D_CURSE_DIVINE_PRANK",
		ui_name = "$perk_d2d_curse_divine_prank_name",
		ui_description = "$perk_d2d_curse_divine_prank_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/divine_prank_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/divine_prank.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )
			
    		-- var_int_add( owner, "pranks_looming", 1 )
    		dofile_once( "data/scripts/lib/utilities.lua" )
			if get_perk_pickup_count( "D2D_CURSE_DIVINE_PRANK" ) == 1 then
		        EntityAddComponent( entity_who_picked, "LuaComponent",
		        {
		            script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_curse_divine_prank_update.lua",
		            execute_every_n_frame = "60",
		        } )
	            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
	            { 
		            extra_modifier = "d2d_divine_prank",
	            } )
	        end
        end,
	},

	-- {
	-- 	id = "D2D_CURSE_LONELINESS",
	-- 	ui_name = "$perk_d2d_curse_loneliness",
	-- 	ui_description = "$perk_d2d_curse_loneliness_description",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/loneliness_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/loneliness_016.png",
	-- 	stackable = STACKABLE_NO,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	not_in_default_perk_pool = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --        LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_curse_loneliness.xml" )
    --     end,
	-- },

	{
		id = "D2D_CURSE_OVERHEATING",
		ui_name = "$perk_d2d_curse_overheating_name",
		ui_description = "$perk_d2d_curse_overheating_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/overheating_wands_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/overheating_wands.png",
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
		ui_name = "$perk_d2d_curse_no_rhythm_name",
		ui_description = "$perk_d2d_curse_no_rhythm_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/no_rhythm_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/no_rhythm.png",
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
		ui_name = "$perk_d2d_curse_floor_is_lava_name",
		ui_description = "$perk_d2d_curse_floor_is_lava_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/floor_is_lava_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/floor_is_lava.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

           	LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_floor_is_lava.xml" )

           	-- BUG: no longer works after restarting the game
        end,
	},

	{
		id = "D2D_CURSE_COMBUSTION",
		ui_name = "$perk_d2d_curse_combustion_name",
		ui_description = "$perk_d2d_curse_combustion_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/combustion_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/combustion.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_combustion.xml" )
        end,
	},

	{
		id = "D2D_CURSE_FALL_DAMAGE",
		ui_name = "$perk_d2d_curse_fall_damage_name",
		ui_description = "$perk_d2d_curse_fall_damage_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/fall_damage_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/fall_damage.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_fall_damage.xml" )
        end,
	},

	-- fall damage

	-- {
	-- 	id = "D2D_CURSE_SPORADIC_SPEEDBOOST",
	-- 	ui_name = "$perk_d2d_curse_sporadic_speedboost",
	-- 	ui_description = "$perk_d2d_curse_sporadic_speedboost_description",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/no_rhythm_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/no_rhythm_016.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	not_in_default_perk_pool = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
    --        LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_curse_sporadic_speed.xml" )
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

-- add perks
if ( perk_list ~= nil ) then
	for k, v in pairs( d2d_perks )do
		if HasSettingFlag( v.id .. "_disabled" ) then
			-- GamePrint( "Perk not added: " .. v.id )
		else
			table.insert( perk_list, v )
		end
	end
end

-- add perks that require Apotheosis
if ModIsEnabled( "Apotheosis" ) then
	if ( perk_list ~= nil ) then
		for k, v in pairs( d2d_apoth_perks )do
			if HasSettingFlag( v.id .. "_disabled" ) then
				-- GamePrint( "Perk not added: " .. v.id )
			else
				table.insert( perk_list, v )
			end
		end
	end
end

-- add curses 
if ( perk_list ~= nil ) then
	for k, v in pairs( d2d_curses )do
		if HasSettingFlag( v.id .. "_disabled" ) then
			-- GamePrint( "Perk not added: " .. v.id )
		else
			table.insert( perk_list, v )
		end
	end
end
