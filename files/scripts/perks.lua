d2d_perks = {

	{
		id = "D2D_RING_OF_RETURNING",
		ui_name = "$perk_d2d_ring_of_returning_name",
		ui_description = "$perk_d2d_ring_of_returning_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ring_of_returning_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ring_of_returning.png",
		stackable = STACKABLE_YES,
		-- max_in_perk_pool = 3,
		-- stackable_maximum = 3,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local px, py = EntityGetTransform( entity_who_picked )
    		EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/ring_of_returning.xml", px, py )
        end,
	},

	{
		id = "D2D_TIME_TRIAL",
		ui_name = "$perk_d2d_time_trial_name",
		ui_description = "$perk_d2d_time_trial_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/time_trial_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/time_trial.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- only give the perk when the player has yet to enter The Vault,
			-- since the Laboratory has no temple statue and is not present in PWs.
			-- 
			-- TODO: check for heart_fullhp_temple.xml instead of temple_statue_01.xml,
			-- to make it work for the Laboratory on the main path.
			local x, y = EntityGetTransform( entity_perk_item )

			local biome_name = BiomeMapGetName( x, y )
			local is_in_valid_biome = string.find( biome_name, "holy" ) or string.find( biome_name, "EMPTY" )
			if y < 9250 and is_in_valid_biome then
	            LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_time_trial.xml" )
	        else
				-- briefly set perk destroy chance to 0, so other perks remain
				-- (code copied from D2D_BLESSINGS_AND_CURSE)
				local value_to_cache = GlobalsGetValue( "TEMPLE_PERK_DESTROY_CHANCE", 100 )
				set_internal_int( get_player(), "blurse_cached_perk_destroy_chance", tonumber( value_to_cache ) )
				GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", 0 )
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags="perk_component",
					script_source_file="mods/D2DContentPack/files/scripts/perks/effect_blessings_and_curse_revert.lua",
					execute_every_n_frame="3",
					remove_after_executed="1",
				} )
				
				perk_spawn_random( x, y, false )
	        	GamePrintImportant( "This perk has been rerolled", "Time Trial only works when picked up from a Holy Mountain." )
	        end
		end,
	},

	{
		id = "D2D_WARP_RUSH",
		ui_name = "$perk_d2d_warp_rush_name",
		ui_description = "$perk_d2d_warp_rush_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/warp_rush_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/warp_rush.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
        -- spawn_requires_flag	= "d2d_time_trial_bronze",
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
            	LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_warp_rush.xml" )

            	dofile_once( "data/scripts/lib/utilities.lua" )
				multiply_move_speed( entity_who_picked, "d2d_warp_rush", 1.0 )
        	end
		end,
		func_remove = function( entity_who_picked )
			local effect_id = get_child_with_name( entity_who_picked, "effect_warp_rush.xml" )
			if effect_id and effect_id ~= 0 then
				EntityKill( effect_id )
			end
		end
	},

	{
		id = "D2D_GLASS_HEART",
		ui_name = "$perk_d2d_glass_heart_name",
		ui_description = "$perk_d2d_glass_heart_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/glass_heart_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/glass_heart.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if reflecting then return end
			dofile_once( "data/scripts/lib/utilities.lua" )

			-- register the current y position to disqualify nearby hearts
			local x, y = EntityGetTransform( entity_who_picked )
        	set_internal_float( entity_who_picked, "d2d_glass_heart_start_y", y )

	        -- add a damage_received script, if it doesn't exist already
		    if not has_lua( entity_who_picked, "d2d_glass_heart" ) then
		        EntityAddComponent( entity_who_picked, "LuaComponent",
		        {
					_tags = "perk_component,d2d_glass_heart",
		            script_damage_received = "mods/D2DContentPack/files/scripts/perks/effect_glass_heart_on_damage_received.lua",
		            execute_every_n_frame = "-1",
		        })

		        local p_dcomp = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
		        local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
		        ComponentSetValue2( p_dcomp, "max_hp", p_max_hp * 0.75 )

            	-- exclude nearby hearts from being valid for completion
            	local nearby_drillables = EntityGetInRadiusWithTag( x, y, 600, "drillable" )
            	if nearby_drillables and #nearby_drillables > 0 then
	            	for i,drillable in ipairs( nearby_drillables ) do
	            		EntityAddTag( drillable, "d2d_glass_heart_disqualified" )
	            	end
	            end
		    end

			-- add a UI component, if it doesn't exist already
			local ui_icon_id = get_child_with_name( entity_who_picked, "effect_glass_heart.xml" )
			if not ui_icon_id then
            	LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_glass_heart.xml" )
			end
		end,
		func_remove = function( entity_who_picked )
			remove_lua( entity_who_picked, "d2d_glass_heart" )
	        local ui_icon_id = get_child_with_name( entity_who_picked, "effect_glass_heart.xml" )
	        if ui_icon_id then
	            EntityKill( ui_icon_id )
	        end
		end,
	},

	{
		id = "D2D_GLASS_FIST",
		ui_name = "$perk_d2d_glass_fist_name",
		ui_description = "$perk_d2d_glass_fist_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/glass_fist_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/glass_fist.png",
		stackable = STACKABLE_YES,
		-- max_in_perk_pool = 3,
		-- stackable_maximum = 3,
		one_off_effect = false,
		usable_by_enemies = true,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
        	set_internal_bool( entity_who_picked, "d2d_glass_fist_boost_enabled", true )
			local ui_icon_id = get_child_with_name( entity_who_picked, "glass_fist_overhead_icon.xml" )
			if not ui_icon_id then
            	LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/status_effects/glass_fist_overhead_icon.xml" )
			end

			if get_perk_pickup_count( "D2D_GLASS_FIST" ) == 1 then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags="perk_component,d2d_perk_glass_fist",
					script_shot="mods/D2DContentPack/files/scripts/perks/effect_glass_fist_on_shot.lua",
					execute_every_n_frame="-1",
				} )
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags="perk_component,d2d_perk_glass_fist",
					script_damage_received="mods/D2DContentPack/files/scripts/perks/effect_glass_fist_on_damage_received.lua",
					execute_every_n_frame="-1",
				} )
			end
        end,
        func_remove = function( entity_who_picked )
        	remove_lua( entity_who_picked, "d2d_perk_glass_fist" )
        end
	},

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
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- local x,y = EntityGetTransform( entity_perk_item )
    		-- EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer.xml", x, y - 20 )
		end,
	},

	{
		id = "D2D_PERKSMITH",
		ui_name = "$perk_d2d_perksmith_name",
		ui_description = "$perk_d2d_perksmith_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/perksmith_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/perksmith.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- local x,y = EntityGetTransform( entity_perk_item )
    		-- EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer.xml", x, y - 20 )
		end,
	},

	{
		id = "D2D_SPELL_COURIER",
		ui_name = "$perk_d2d_spell_courier_name",
		ui_description = "$perk_d2d_spell_courier_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/spell_courier_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/spell_courier.png",
		stackable = STACKABLE_NO,
		-- max_in_perk_pool = 3,
		-- stackable_maximum = 3,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local nearby_shop_items = EntityGetWithTag( "card_action" )
			if nearby_shop_items then
				for i,item_id in ipairs( nearby_shop_items ) do
					local iccomp = EntityGetComponentIncludingDisabled( item_id, "ItemCostComponent" )
					if iccomp then
						EntityAddComponent2( item_id, "LuaComponent", {
							script_item_picked_up="mods/D2DContentPack/files/scripts/perks/effect_spell_courier_item_bought.lua",
							execute_every_n_frame=-1,
						})
					end
				end
			end

			perk_pickup_event( "RAT" )
			add_rattiness_level( entity_who_picked )
        end,
	},

	{
		id = "D2D_ALLY_PROTECTION",
		ui_name = "$perk_d2d_ally_protection_name",
		ui_description = "$perk_d2d_ally_protection_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ally_protection_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/ally_protection.png",
		stackable = STACKABLE_NO,
		-- max_in_perk_pool = 3,
		-- stackable_maximum = 3,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags="perk_component",
				script_source_file="mods/D2DContentPack/files/scripts/perks/effect_ally_protection_update.lua",
				execute_every_n_frame="15",
			} )
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
				_tags = "perk_component,d2d_master_of_bombs",
	            extra_modifier = "d2d_master_of_explosions_boost",
            } )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component,d2d_master_of_bombs",
				script_shot = "mods/D2DContentPack/files/scripts/perks/effect_master_of_explosions_shot.lua",
				execute_every_n_frame = "-1",
			} )
        end,
		func_remove = function( entity_who_picked )
			remove_lua( entity_who_picked, "d2d_master_of_bombs" )
			remove_shoteffect( entity_who_picked, "d2d_master_of_bombs" )
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
				_tags = "perk_component,d2d_master_of_lightning",
	            extra_modifier = "d2d_master_of_lightning_boost",
            } )
        end,
		func_remove = function( entity_who_picked )
			remove_lua( entity_who_picked, "d2d_master_of_lightning" )
			remove_shoteffect( entity_who_picked, "d2d_master_of_lightning" )
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
				_tags="perk_component,d2d_master_of_fire",
	            extra_modifier = "d2d_master_of_fire_boost",
            } )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				_tags="perk_component,d2d_master_of_fire",
				script_shot = "mods/D2DContentPack/files/scripts/perks/effect_master_of_fire_increased_damage.lua",
				execute_every_n_frame = "-1",
			} )	
        end,
		func_remove = function( entity_who_picked )
			remove_lua( entity_who_picked, "d2d_master_of_fire" )
			remove_shoteffect( entity_who_picked, "d2d_master_of_fire" )
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

	-- {
	-- 	id = "D2D_PANIC_BUTTON",
	-- 	ui_name = "Panic Button",
	-- 	ui_description = "Upon taking damage, gain a short burst of move speed.",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/panic_button_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/panic_button.png",
	-- 	stackable = STACKABLE_YES,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name )
	-- 		EntityAddComponent( entity_who_picked, "LuaComponent", 
	-- 		{ 
	-- 			_tags="perk_component,d2d_panic_button",
	-- 			script_damage_received = "mods/D2DContentPack/files/scripts/perks/effect_panic_button_on_damage.lua",
	-- 			execute_every_n_frame = "-1",
	-- 		} )	
	-- 		EntityAddComponent( entity_who_picked, "LuaComponent", 
	-- 		{ 
	-- 			_tags="perk_component,d2d_panic_button",
	-- 			script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_panic_button_update.lua",
	-- 			execute_every_n_frame = "3",
	-- 		} )
    --    	end,
	-- 	func_remove = function( entity_who_picked )
	-- 		remove_lua( entity_who_picked, "d2d_panic_button" )
	-- 	end,
	-- },

	{
		id = "D2D_BORROWED_TIME",
		ui_name = "$perk_d2d_borrowed_time_name",
		ui_description = "$perk_d2d_borrowed_time_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/borrowed_time_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/borrowed_time.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if pickup_count <= 1 then
				EntityAddComponent( entity_who_picked, "LuaComponent",
				{ 
					_tags="perk_component,d2d_perk_borrowed_time",
					script_damage_received = "mods/D2DContentPack/files/scripts/perks/effect_borrowed_time_damage_incoming.lua",
					execute_every_n_frame = "-1",
				} )
			end

			-- REWORK IN PROGRESS
			-- EntityAddComponent( entity_who_picked, "LuaComponent", 
			-- { 
			-- 	script_damage_about_to_be_received = "mods/D2DContentPack/files/scripts/perks/effect_borrowed_time_on_damage_incoming.lua",
			-- 	execute_every_n_frame = "-1",
			-- } )
        end,
        func_remove = function( entity_who_picked )
        	dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
        	remove_lua( entity_who_picked, "d2d_perk_borrowed_time" )
        end
	},

	-- {
	-- 	id = "D2D_JUGGERNAUT",
	-- 	ui_name = "$perk_d2d_juggernaut_name",
	-- 	ui_description = "$perk_d2d_juggernaut_desc",
	-- 	ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/juggernaut_016.png",
	-- 	perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/juggernaut.png",
	-- 	stackable = STACKABLE_NO,
	-- 	one_off_effect = false,
	-- 	usable_by_enemies = false,
	-- 	not_in_default_perk_pool = true,
	-- 	func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
	-- 		-- WORK IN PROGRESS
	-- 		if reflecting then return end

	-- 		-- LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_heal_block.xml" )
	-- 		if pickup_count <= 1 then
	-- 			EntityAddComponent2( entity_who_picked, "LuaComponent", 
	-- 			{
	-- 				_tags = "perk_component,d2d_perk_juggernaut",
	-- 				script_damage_about_to_be_received = "mods/D2DContentPack/files/scripts/perks/effect_juggernaut_on_damage_incoming.lua",
	-- 				execute_every_n_frame = -1,
	-- 			} )
	-- 		end
    --     end,
    --     func_remove = function( entity_who_picked )
    --     	dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
    --     	remove_lua( entity_who_picked, "d2d_perk_juggernaut" )
    --     end
	-- },

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

			-- briefly set perk destroy chance to 0, so other perks remain
			local value_to_cache = GlobalsGetValue( "TEMPLE_PERK_DESTROY_CHANCE", 100 )
			set_internal_int( get_player(), "blurse_cached_perk_destroy_chance", tonumber( value_to_cache ) )
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

	{
		id = "D2D_HUNT_CURSES",
		ui_name = "$perk_d2d_hunt_curses_name",
		ui_description = "$perk_d2d_hunt_curses_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/hunt_curses_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/hunt_curses.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/effect_hunt_curses.xml" )
        end,
	},

	{
		id = "D2D_LIFT_CURSES",
		ui_name = "$perk_d2d_lift_curses_name",
		ui_description = "$perk_d2d_lift_curses_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/lift_curses_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/lift_curses.png",
		stackable = STACKABLE_NO,
		one_off_effect = true,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			dofile_once( "data/scripts/lib/utilities.lua" )
			lift_all_curses( entity_who_picked )
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
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )
			
			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_divine_prank.xml" )

    		dofile_once( "data/scripts/lib/utilities.lua" )
			if get_perk_pickup_count( "D2D_CURSE_DIVINE_PRANK" ) == 1 then
	            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
	            { 
		            extra_modifier = "d2d_divine_prank",
	            } )
	        end
        end,
	},

	-- TODO: Curse that somehow counters infinite healing (maybe lose max hp when you are healed above max?)



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
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_combustion.xml" )
        end,
	},

	{
		id = "D2D_LEVITATION_CRAMPS",
		ui_name = "$perk_d2d_curse_levitation_cramps_name",
		ui_description = "$perk_d2d_curse_levitation_cramps_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/levitation_cramps_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/levitation_cramps.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_levitation_cramps.xml" )
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
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

			LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_fall_damage.xml" )
        end,
	},

	{
		id = "D2D_CURSE_HEAL_BLOCK",
		ui_name = "$perk_d2d_curse_heal_block_name",
		ui_description = "$perk_d2d_curse_heal_block_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/heal_block_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/curses/heal_block.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if reflecting then return end
			local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
			GlobalsSetValue( "PLAYER_CURSE_COUNT", curse_count + 1 )

			-- LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/perks/curses/effect_curse_heal_block.xml" )
			if pickup_count <= 1 then
				EntityAddComponent2( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component,d2d_curse_heal_block",
					script_damage_about_to_be_received = "mods/D2DContentPack/files/scripts/perks/effect_curse_heal_block_on_damage.lua",
					execute_every_n_frame = -1,
				} )
			end
        end,
        func_remove = function( entity_who_picked )
        	dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
        	remove_lua( entity_who_picked, "d2d_curse_heal_block" )
        end
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










d2d_perk_reworks = {
	{
		id = "D2D_ALL_SEEING_EYE",
		id_vanilla = "REMOVE_FOG_OF_WAR",
		ui_name_vanilla = "All-Seeing Eye",
		ui_name = "$perk_d2d_all_seeing_eye_rework_name",
		ui_description = "$perk_d2d_all_seeing_eye_rework_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/all_seeing_eye_rework_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/all_seeing_eye_rework.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
        func = function( entity_perk_item, entity_who_picked, item_name )
            EntityAddChild( entity_who_picked, EntityLoad( "mods/D2DContentPack/files/entities/misc/perks/effect_all_seeing_eye_rework.xml" ) )

            dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
            if not HasFlagPersistent( "d2d_update_msg_displayed_all_seeing_eye_rework" ) then
	            GamePrintDelayed( "[D2D] Prefer the original All-Seeing Eye perk?", 240 )
	            GamePrintDelayed( "[D2D] You can disable this change for future runs in the mod's settings.", 360 )
	            AddFlagPersistent( "d2d_update_msg_displayed_all_seeing_eye_rework" )
	        end
        end,
        func_remove = function( entity_who_picked )
            remove_lua( entity_who_picked, "d2d_all_seeing_eye_rework" )
        end,
	},

	{
		id = "D2D_SPELL_GEMS",
		id_vanilla = "UNLIMITED_SPELLS",
		ui_name_vanilla = "Unlimited Spells",
		ui_name = "$perk_d2d_spell_gems_name",
		ui_description = "$perk_d2d_spell_gems_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/spell_gems_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/spell_gems.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
        func = function( entity_perk_item, entity_who_picked, item_name )
            EntityAddChild( entity_who_picked, EntityLoad( "mods/D2DContentPack/files/entities/misc/perks/effect_spell_gems.xml" ) )

            dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
            if not HasFlagPersistent( "d2d_update_msg_displayed_unlimited_spells_rework" ) then
	            GamePrintDelayed( "[D2D] This perk replaces the original Unlimited Spells perk.", 180 )
	            GamePrintDelayed( "[D2D] You can disable this change for future runs in the mod's settings.", 300 )
	            AddFlagPersistent( "d2d_update_msg_displayed_unlimited_spells_rework" )
	        end
        end,
        func_remove = function( entity_who_picked )
            remove_lua( entity_who_picked, "d2d_spell_gems" )
        end,
	},

	{
		id = "D2D_TINKER_WITH_WANDS_MORE",
		id_vanilla = "EDIT_WANDS_EVERYWHERE",
		ui_name_vanilla = "Tinker With Wands Everywhere",
		ui_name = "$perk_d2d_tinker_rework_name",
		ui_description = "$perk_d2d_tinker_rework_desc",
		ui_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/tinker_with_wands_more_016.png",
		perk_icon = "mods/D2DContentPack/files/gfx/ui_gfx/perks/tinker_with_wands_more.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
        func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
        	if pickup_count > 1 then return end

            EntityAddChild( entity_who_picked, EntityLoad( "mods/D2DContentPack/files/entities/misc/perks/effect_tinker_with_wands_more.xml" ) )

            dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
            if not HasFlagPersistent( "d2d_update_msg_displayed_tinker_with_wands_everywhere_rework" ) then
	            GamePrintDelayed( "[D2D] This perk replaces the original Tinker With Wands Everywhere perk.", 180 )
	            GamePrintDelayed( "[D2D] You can disable this change for future runs in the mod's settings.", 300 )
	            AddFlagPersistent( "d2d_update_msg_displayed_tinker_with_wands_everywhere_rework" )
	        end
        end,
        func_remove = function( entity_who_picked )
            remove_lua( entity_who_picked, "d2d_tinker_with_wands_more" )
        end,
	},
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

local function remove_perk(perk_name)
    local key_to_perk = nil
    for key, perk in pairs( perk_list ) do
        if perk.id == perk_name then
            key_to_perk = key
        end
    end

    if key_to_perk ~= nil then
        table.remove( perk_list, key_to_perk )
    end
end

-- local function replace_perk( new )
-- 	for i = 1, #perk_list do
-- 		local original = perk_list[i]

-- 		if original.id == new.id_vanilla then
-- 			original.id = new.id
-- 			original.ui_name = new.ui_name
-- 			original.ui_description = new.ui_description
-- 			original.ui_icon = new.ui_icon
-- 			original.perk_icon = new.perk_icon
-- 			original.stackable = new.stackable
-- 			original.one_off_effect = new.one_off_effect
-- 			original.usable_by_enemies = new.usable_by_enemies
-- 			original.not_in_default_perk_pool = new.not_in_default_perk_pool
-- 			original.func = new.func
-- 			original.func_remove = new.func_remove
-- 			break
-- 		end
-- 	end
-- end

local function hide_perk( perk_id )
	for i = 1, #perk_list do
		local perk = perk_list[i]
		if perk.id == perk_id then
			perk.not_in_default_perk_pool = true
		end
	end
end

-- add reworks 
if ( perk_list ~= nil ) then
	for k, v in pairs( d2d_perk_reworks )do
		if not HasSettingFlag( v.id .. "_disabled" ) then
			table.insert( perk_list, v )
			-- remove_perk( v.id_vanilla )
			hide_perk( v.id_vanilla )
		end
	end
end

-- add perks
if ( perk_list ~= nil ) then
	for k, v in pairs( d2d_perks )do
		if not HasSettingFlag( v.id .. "_disabled" ) then
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
