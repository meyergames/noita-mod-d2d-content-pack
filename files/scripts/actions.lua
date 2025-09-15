d2d_actions = {
    {
	    id                  = "D2D_OVERCLOCK",
	    name 		        = "$spell_d2d_overclock_name",
	    description         = "$spell_d2d_overclock_desc",
        inject_after        = { "D2D_BURST_FIRE", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/overclock.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.6,0.8,0.9,0.8,0.7,0.6",
	    price               = 240,
	    mana                = 1,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait - 20
                                current_reload_time = current_reload_time - 30

					            if reflecting then return end

                                local entity_id = GetUpdatedEntityID()

							    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
							    local wand = EZWand.GetHeldWand()
                                local x, y = EntityGetTransform( GetUpdatedEntityID() )

							    -- local remaining_mana_percent = ( 1.0 / wand.manaMax ) * (wand.mana - c.action_mana_drain)
							    -- if ( remaining_mana_percent >= 0.5 ) then
							    -- 	c.fire_rate_wait	= c.fire_rate_wait - ( ( remaining_mana_percent - 0.5 ) * 10 )
								-- end

							    local rand = Random( 0, 200 )
							    local chance = 1.0 / ( (1.0 / wand.manaMax) * wand.mana )
                                if( rand <= chance ) then
                                    c.fire_rate_wait    = 40
                                    GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)

                                    local rand2 = Random( 0, 8 )
                                    if( rand2 < 1 ) then -- 2/250 or 1/125
                                        EntityInflictDamage(entity_id, 0.4, "DAMAGE_ELECTRICITY", "overheated wand", "ELECTROCUTION", 0, 0, entity_id, x, y, 0)
                                    elseif( rand2 < 3 ) then -- 2/250 or 1/125
                                        add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml")
                                    elseif( rand2 < 5 ) then -- 2/250 or 1/125
                                        add_projectile("mods/D2DContentPack/files/entities/projectiles/overclock.xml")
                                    else -- 3/250 or 1/83
                                        add_projectile("data/entities/projectiles/deck/fizzle.xml")
                                    end
                                end
                                
			                    draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_FLURRY",
	    name 		        = "$spell_d2d_flurry_name",
	    description         = "$spell_d2d_flurry_desc",
        inject_after        = { "RECHARGE", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/flurry.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "1,1,1,0.9,0.8,0.7,0.6",
	    price               = 210,
	    mana                = 1,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait - 15 -- so it shows in the UI
                                current_reload_time = current_reload_time - 20 -- so it shows in the UI

					            if reflecting then return end

                                local entity_id = GetUpdatedEntityID()

							    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
							    local wand = EZWand.GetHeldWand()

							    c.fire_rate_wait	= c.fire_rate_wait + 15 -- reset
                                current_reload_time = current_reload_time + 20 -- reset

							    local remaining_mana_percent = ( 1.0 / wand.manaMax ) * wand.mana
							    if ( remaining_mana_percent >= 0.75 ) then
							    	c.fire_rate_wait	= c.fire_rate_wait - ( ( remaining_mana_percent - 0.75 ) * ( 15 / 0.25 ) )
							    	current_reload_time	= current_reload_time - ( ( remaining_mana_percent - 0.75 ) * ( 20 / 0.25 ) )
								end
                                
			                    draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_RAPIDFIRE_SALVO",
	    name 		        = "$spell_d2d_rapidfire_salvo_name",
	    description         = "$spell_d2d_rapidfire_salvo_desc",
        inject_after        = { "D2D_FLURRY", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/rapidfire_salvo.png",
	    type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_rapidfire_salvo.xml",
	    price               = 330,
	    mana                = 10,
	    action              = function()
                                draw_actions( 1, true )
	                        end,
    },

	{
		id                  = "D2D_RECYCLE",
		name 		        = "Recycle",
		description         = "May spare a spell's limited uses",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/recycle.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5",
		spawn_probability   = "0.5,1,0.8,0.6,0.4,0.2",
		price               = 200,
		mana                = 20,
		action 		        = function()
								draw_actions( 1, true )

								for i,v in ipairs( hand ) do
									local spell_data = hand[i]
									if spell_data.uses_remaining > 1 then
										if not spell_data.never_unlimited and Random( 0, 4 ) == 4 then
											spell_data.uses_remaining = spell_data.uses_remaining + 1
										elseif Random( 0, 10 ) == 10 then
											spell_data.uses_remaining = spell_data.uses_remaining + 1
										end
									end
								end
		                    end,
	},

    {
	    id                  = "D2D_DAMAGE_MISSING_MANA",
	    name 		        = "$spell_d2d_damage_missing_mana_name",
	    description         = "$spell_d2d_damage_missing_mana_desc",
        inject_after        = { "DAMAGE_FOREVER", "DAMAGE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/damage_missing_mana.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "2,3,4,5,6",
		spawn_probability   = "0.5,0.7,0.9,0.8,0.7",
	    price               = 270,
	    mana                = 20,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait + 4 -- so it shows in the UI

					            if reflecting then return end

							    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
							    local wand = EZWand.GetHeldWand()
							    
                                c.fire_rate_wait    			= c.fire_rate_wait - 4 -- reset

							    local remaining_mana_percent	= ( 1.0 / wand.manaMax ) * wand.mana
						    	local missing_mana				= wand.manaMax - wand.mana
                                local missing_mana_percent		= 1.0 - remaining_mana_percent
						    	local sec_to_recharge_wand		= wand.manaMax / math.max( wand.manaChargeSpeed, 1 ) -- careful for division by zero

                                c.fire_rate_wait    			= c.fire_rate_wait + ( missing_mana_percent * 20 ) -- max 20
                                c.knockback_force				= c.knockback_force + ( missing_mana_percent * 5 ) -- max 5
								shot_effects.recoil_knockback	= shot_effects.recoil_knockback + ( missing_mana_percent * 200 ) -- max 200

                                -- draw the next (chain of) card(s)
			                    draw_actions( 1, true )

                                -- calculate how much mana the hand's projectiles cost
                                local projectile_count = 0
                                local projectiles_mana_drain = 0
								if ( hand ~= nil ) then
									for i,data in ipairs( hand ) do
										local rec = check_recursion( data, recursion_level )
										if ( data ~= nil ) and ( data.type == ACTION_TYPE_PROJECTILE ) and ( rec > -1 ) then
											projectile_count = projectile_count + 1
											projectiles_mana_drain = projectiles_mana_drain + data.mana
										end
									end
								end
								if ( projectile_count == 0 ) then return end
								
								-- calculate net bonus damage
                                local bonus_dmg_raw				= remap( missing_mana, 0, 5000, 0.00, remap( projectiles_mana_drain / projectile_count, 5, 120, 10 * 0.04, 125 * 0.04 ) )
                                								  * remap( sec_to_recharge_wand, 1, 60, 1.0, 10.0 ) -- multiply by the time it takes to recharge
                                								  -- * remap( projectiles_mana_drain, 5, 100, 0.1, 1.0 ) -- higher mana draining projectiles get more damage
                                								  -- * ( 1.0 / projectile_count ) -- divide by the amount of projectiles in the hand/shot

								c.damage_projectile_add			= c.damage_projectile_add + ( bonus_dmg_raw * missing_mana_percent )
								c.extra_entities				= c.extra_entities .. "data/entities/particles/tinyspark_blue_large.xml,"

								if ( remaining_mana_percent <= 0.25 ) then
									c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_orange.xml,"
								end
	                        end,
    },

	{
		id          = "D2D_CURSES_TO_DAMAGE",
		name 		= "$spell_d2d_curses_to_damage_name",
		description = "$spell_d2d_curses_to_damage_desc",
		sprite 		= "mods/D2DContentPack/files/gfx/ui_gfx/spells/curses_to_damage.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0",
		spawn_probability                 = "0",
		price 		= 999,
		mana 		= 5,
		action 		= function()
			c.fire_rate_wait		= c.fire_rate_wait + 5
			c.damage_curse_add 		= c.damage_curse_add + 0.4 -- for the tooltip
			if reflecting then return end

			c.damage_curse_add 		= c.damage_curse_add - 0.4 -- reset
            local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
            if curse_count ~= nil then
				c.damage_curse_add 		= c.damage_curse_add + ( 0.4 * tonumber( curse_count ) )
				c.extra_entities    	= c.extra_entities .. "data/entities/particles/tinyspark_purple_bright.xml,"
	            draw_actions( 1, true )
	        end
		end,
	},

	{
		id          = "D2D_CURSES_TO_MANA",
		name 		= "$spell_d2d_curses_to_mana_name",
		description = "$spell_d2d_curses_to_mana_desc",
		sprite 		= "mods/D2DContentPack/files/gfx/ui_gfx/spells/curses_to_mana.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0",
		spawn_probability                 = "0",
		price 		= 999,
		mana 		= -30,
		action 		= function()
			if reflecting then return end

            local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
            if curse_count ~= nil then
    			mana = mana + ( 30 * ( tonumber( curse_count ) - 1 ) )
	            draw_actions( 1, true )
	        end
		end,
	},

    {
	    id                  = "D2D_SNIPE_SHOT",
	    name 		        = "$spell_d2d_sniper_bolt_name",
	    description         = "$spell_d2d_sniper_bolt_desc",
        inject_after        = { "ARROW" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/snipe_shot.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "0.4,1,2,2",
	    price               = 130,
	    mana                = 40,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 45
                                add_projectile("mods/D2DContentPack/files/entities/projectiles/sniper_bullet_custom.xml")
	                        end,
    },

    {
	    id                  = "D2D_SNIPE_SHOT_TRIGGER",
	    name 		        = "$spell_d2d_sniper_bolt_trigger_name",
	    description         = "$spell_d2d_sniper_bolt_trigger_desc",
        inject_after        = { "D2D_SNIPE_SHOT", "ARROW" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/snipe_shot_trigger.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.5,0.8,0.8,0.9,1,1",
	    price               = 230,
	    mana                = 70,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 67
--                                add_projectile("mods/D2DContentPack/files/entities/projectiles/sniper_bullet_custom.xml")
                    			add_projectile_trigger_hit_world("mods/D2DContentPack/files/entities/projectiles/sniper_bullet_custom.xml", 1)
	                        end,
    },

	{
		id                  = "D2D_GHOST_TRIGGER",
		name 		        = "$spell_d2d_ghost_trigger_name",
		description         = "$spell_d2d_ghost_trigger_desc",
        inject_after        = { "SPARK_BOLT_TIMER" },
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/ghost_trigger.png",
		related_projectiles	= {"mods/D2DContentPack/files/entities/projectiles/deck/ghost_trigger_bullet.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3", -- LIGHT_BULLET_TRIGGER
		spawn_probability   = "1,0.7,0.6,0.5", -- LIGHT_BULLET_TRIGGER
		price               = 90,
		mana                = 5,
		action 		        = function()
                                c.damage_null_all = 1
			                    c.fire_rate_wait = c.fire_rate_wait - 3
			                    add_projectile_trigger_hit_world("mods/D2DContentPack/files/entities/projectiles/deck/ghost_trigger_bullet.xml", 1)
		                    end,
	},

    {
	    id                  = "D2D_GIGA_DRAIN",
	    name 		        = "$spell_d2d_giga_drain_name",
	    description         = "$spell_d2d_giga_drain_desc",
        inject_after        = { "CHAINSAW" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/giga_drain.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.5,0.8,1,1.1,1,0.8,0.5",
	    price               = 150,
	    mana                = 60,
	    action              = function()
		                        c.fire_rate_wait = current_reload_time + 8
		                        current_reload_time = current_reload_time + 20
								shot_effects.recoil_knockback	= shot_effects.recoil_knockback + 100

                                add_projectile("mods/D2DContentPack/files/entities/projectiles/giga_drain_bullet.xml")
	                        end,
    },

    -- {
	--     id                  = "D2D_HOLLOW_ORB",
	--     name 		        = "Hollow Bomb",
	--     description         = "More powerful when your wand is low on mana",
    --     inject_after        = { "CHAINSAW" },
	--     sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/hollow_orb.png",
	--     type 		        = ACTION_TYPE_PROJECTILE,
	-- 	spawn_level         = "0,1,2,3,4,5,6",
	-- 	spawn_probability   = "0.5,0.8,1,1.1,1,0.8,0.5",
	--     price               = 160,
	--     mana                = 10,
	--     action              = function()
    --                             c.fire_rate_wait    = c.fire_rate_wait + 40
	-- 				            if reflecting then return end

	-- 						    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	-- 						    local wand = EZWand.GetHeldWand()
	-- 						    local mana_cost = wand.manaMax * 0.1
	-- 						    wand.mana = wand.mana - mana_cost

	-- 					    	c.knockback_force = c.knockback_force + 5
	-- 					    	shot_effects.recoil_knockback = shot_effects.recoil_knockback + 200

    --                             -- c.fire_rate_wait    			= c.fire_rate_wait + ( missing_mana * 0.03 ) -- 0.5s delay at 1000 missing mana
    --                             -- c.knockback_force				= c.knockback_force + ( missing_mana * 0.001 * 5 ) -- max 5 at "
	-- 							-- shot_effects.recoil_knockback	= shot_effects.recoil_knockback + ( missing_mana * 0.001 * 200 ) -- max 200 at "

    --                             add_projectile("mods/D2DContentPack/files/entities/projectiles/hollow_orb.xml")
	--                         end,
    -- },

    {
	    id                  = "D2D_UNSTABLE_NUCLEUS",
	    name 		        = "$spell_d2d_unstable_nucleus_name",
	    description         = "$spell_d2d_unstable_nucleus_desc",
        inject_after        = { "GRENADE_TIER_3" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/unstable_nucleus.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "2,3,4,5,6,10",
		spawn_probability   = "0.25,0.5,0.75,1,1,0.75",
	    price               = 480,
	    mana                = 100,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait + 160
                                if reflecting then return end
                                c.fire_rate_wait	= c.fire_rate_wait - 160

                                dofile_once( "data/scripts/lib/utilities.lua" )
                                local proj_id = get_internal_int( get_player(), "unstable_nucleus_id" )
                                if proj_id ~= nil and proj_id ~= -1 then
                                	-- shoot charging "projectile"
                                	draw_actions( 1, true )
                                	mana = mana + 100
                                	-- add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/unstable_nucleus_charge.xml")
                                else
                                	c.fire_rate_wait	= c.fire_rate_wait + 160
                                	add_projectile("mods/D2DContentPack/files/entities/projectiles/unstable_nucleus.xml")
                                end
	                        end,
    },

    {
	    id                  = "D2D_CONCRETE_WALL",
	    name 		        = "$spell_d2d_concrete_wall_name",
	    description         = "$spell_d2d_concrete_wall_desc",
        inject_after        = { "D2D_PAYDAY", "SUMMON_ROCK" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/concrete_wall.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.7,0.5,0.3",
	    price               = 200,
	    mana                = 80,
	    max_uses			= 5,
	    action              = function()
			                    c.fire_rate_wait    = c.fire_rate_wait + 40
			                    current_reload_time = current_reload_time + 40

                                add_projectile("mods/D2DContentPack/files/entities/projectiles/concrete_wall_bullet_initial.xml")
	                        end,
    },

    {
	    id                  = "D2D_CONCRETE_WALL_ALT_FIRE",
	    name 		        = "$spell_d2d_concrete_wall_alt_fire_name",
	    description         = "$spell_d2d_concrete_wall_alt_fire_desc",
        inject_after        = { "D2D_CONCRETE_WALL", "D2D_PAYDAY", "SUMMON_ROCK" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_fire_concrete_wall.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.3,0.5,0.6,0.5,0.3,0.2",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_concrete_wall.xml",
	    price               = 200,
	    mana                = 80,
	    max_uses			= 5,
    	custom_uses_logic 	= true,
	    action              = function()
	    						draw_actions( 1, true )
        						mana = mana + 80
	                        end,
    },

	{
		id                  = "D2D_BANANA_BOMB",
		name 		        = "$spell_d2d_banana_bomb_name",
		description         = "$spell_d2d_banana_bomb_desc",
        inject_after        = { "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/banana_bomb.png",
		related_projectiles	= {"mods/D2DContentPack/files/entities/projectiles/banana_bomb.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4", -- DYNAMITE
		spawn_probability   = "0.7,0.6,0.5,0.4,0.3", -- DYNAMITE
		price               = 190,
		mana                = 60,
        max_uses            = 12,
        custom_xml_file     = "mods/D2DContentPack/files/entities/misc/custom_cards/card_banana_bomb.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/D2DContentPack/files/entities/projectiles/banana_bomb.xml", 1)
		                    end,
	},

	{
		id                  = "D2D_BANANA_BOMB_SUPER",
		name 		        = "$spell_d2d_banana_bomb_super_name",
		description         = "$spell_d2d_banana_bomb_super_desc",
        inject_after        = { "D2D_BANANA_BOMB", "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/banana_bomb_super.png",
		related_projectiles	= {"mods/D2DContentPack/files/entities/projectiles/banana_bomb_super.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability   = "0.5,0.6,0.7,0.4,0.3,0.2,0.1",
		price               = 380,
		mana                = 90,
        max_uses            = 6,
        custom_xml_file     = "mods/D2DContentPack/files/entities/misc/custom_cards/card_banana_bomb_super.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/D2DContentPack/files/entities/projectiles/banana_bomb_super.xml", 1)
		                    end,
	},

	{
		id                  = "D2D_BANANA_BOMB_GIGA",
		name 		        = "$spell_d2d_banana_bomb_giga_name",
		description         = "$spell_d2d_banana_bomb_giga_desc",
        inject_after        = { "D2D_BANANA_BOMB_SUPER", "D2D_BANANA_BOMB", "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/banana_bomb_giga.png",
		related_projectiles	= {"mods/D2DContentPack/files/entities/projectiles/banana_bomb_giga.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability   = "0.1,0.2,0.3,0.4,0.4,0.5,0.5",
		price               = 570,
		mana                = 180,
        max_uses            = 3,
        custom_xml_file     = "mods/D2DContentPack/files/entities/misc/custom_cards/card_banana_bomb_giga.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/D2DContentPack/files/entities/projectiles/banana_bomb_giga.xml", 1)
		                    end,
	},

	{
		id                  = "D2D_BAG_OF_BOMBS",
		name 		        = "$spell_d2d_bag_of_bombs_name",
		description         = "$spell_d2d_bag_of_bombs_desc",
        inject_after        = { "DYNAMITE" },
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/bag_of_bombs.png",
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4", -- DYNAMITE
		spawn_probability   = "1,0.9,0.8,0.7,0.6", -- DYNAMITE
		price               = 250,
		mana                = 75,
        max_uses            = 15,
       	custom_xml_file     = "mods/D2DContentPack/files/entities/misc/custom_cards/card_bag_of_bombs.xml",
		action 		        = function()
                                local rand = Random( 0, 1000 )
                                if( rand < 250 ) then -- 25%
			                        add_projectile("data/entities/projectiles/bomb.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 100
                                elseif( rand < 400 ) then -- 15%
			                        add_projectile("mods/D2DContentPack/files/entities/projectiles/banana_bomb.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                elseif( rand < 500 ) then -- 10% (1/10)
			                        add_projectile("data/entities/projectiles/deck/glitter_bomb.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 12.0
                                elseif( rand < 550 ) then -- 5% (1/20)
			                        add_projectile("mods/D2DContentPack/files/entities/projectiles/bomb_dud.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 100
                                elseif( rand < 570 ) then -- 2% (1/50)
			                        add_projectile("mods/D2DContentPack/files/entities/projectiles/banana_bomb_super.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                elseif( rand < 580 ) then -- 1% (1/100)
			                        add_projectile("data/entities/projectiles/bomb_holy.xml")
			                        current_reload_time = current_reload_time + 80
			                        shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
			                        c.fire_rate_wait = c.fire_rate_wait + 40
                                elseif( rand < 585 ) then -- 0.5% (1/200)
			                        add_projectile("mods/D2DContentPack/files/entities/projectiles/banana_bomb_giga.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                elseif( rand < 590 ) then -- 0.5% (1/200)
			                        add_projectile("data/entities/projectiles/propane_tank.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                else -- about 41%
			                        add_projectile("data/entities/projectiles/deck/tnt.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                end
		                    end,
	},

    {
	    id                  = "D2D_SMOKE_BOMB",
	    name 		        = "$spell_d2d_smoke_bomb_name",
	    description         = "$spell_d2d_smoke_bomb_desc",
        inject_after        = { "GRENADE_ANTI", "GRENADE_TIER_3" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/smoke_bomb.png",
        custom_xml_file     = "mods/D2DContentPack/files/entities/misc/custom_cards/card_smoke_bomb.xml",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5",
		spawn_probability   = "0.5,0.7,0.8,0.7,0.5,0.3",
	    price               = 230,
	    mana                = 50,
	    max_uses			= 10,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 45
                                add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/smoke_bomb.xml")
	                        end,
    },

    {
	    id                  = "D2D_SMOKE_BOMB_ALT_FIRE",
	    name 		        = "$spell_d2d_smoke_bomb_alt_fire_name",
	    description         = "$spell_d2d_smoke_bomb_alt_fire_desc",
        inject_after        = { "D2D_SMOKE_BOMB", "GRENADE_ANTI", "GRENADE_TIER_3" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_fire_smoke_bomb.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0,1,2,3,4,5",
		spawn_probability   = "0.4,0.6,0.7,0.6,0.4,0.2",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_smoke_bomb.xml",
	    price               = 230,
	    mana                = 50,
	    max_uses			= 10,
    	custom_uses_logic 	= true,
	    action              = function()
	    						draw_actions( 1, true )
        						mana = mana + 50
	                        end,
    },

    {
	    id                  = "D2D_SMALL_EXPLOSION",
	    name 		        = "$spell_d2d_small_explosion_name",
	    description         = "$spell_d2d_small_explosion_desc",
        inject_after        = { "EXPLOSION" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/small_explosion.png",
	    type 		        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "1.2,1,0.8,0.6",
	    price               = 120,
	    mana                = 20,
	    action              = function()
			                    add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml")
			                    c.fire_rate_wait = c.fire_rate_wait + 1.5
			                    c.screenshake = c.screenshake + 1.25
	                        end,
    },

    {
	    id                  = "D2D_MANA_REFILL",
	    name 		        = "$spell_d2d_mana_refill_name",
	    description         = "$spell_d2d_mana_refill_desc",
        inject_after        = { "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/mana_refill.png",
	    type 		        = ACTION_TYPE_UTILITY,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
	    price               = 330,
	    mana                = 0,
	    max_uses			= 5,
		never_unlimited 	= true,
		-- custom_uses_logic	= true,
	    action              = function()
	    						-- c.fire_rate_wait = c.fire_rate_wait + 30
	    						if reflecting then return end
	    						-- c.fire_rate_wait = c.fire_rate_wait - 30

							    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
							    local wand = EZWand.GetHeldWand()
                                local x, y = EntityGetTransform( GetUpdatedEntityID() )

                                -- if ( mana <= wand.manaMax * 0.25 ) then
						    	mana = wand.manaMax
            					GamePlaySound( "data/audio/Desktop/player.bank", "player_projectiles/wall/create", x, y )
	    						-- end

								-- 	local uses_remaining = -1
								-- 	local icomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "ItemComponent" )
								-- 	if ( icomp ~= nil ) then
								-- 	    uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
								-- 	end
						        --     local spells, attached_spells = wand:GetSpells()
						        --     for i,spell in ipairs( spells ) do
						        --         if ( spell.action_id == "D2D_MANA_REFILL" ) then
						        --             ComponentSetValue2( icomp, "uses_remaining", uses_remaining - 1 )
						        --             break
						        --         end
						        --     end
	            				-- end
	                        end,
    },
	
    {
	    id                  = "D2D_MANA_REFILL_ALT_FIRE",
	    name 		        = "$spell_d2d_mana_refill_alt_fire_name",
	    description         = "$spell_d2d_mana_refill_alt_fire_desc",
        inject_after        = { "D2D_MANA_REFILL_ALT_FIRE", "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_fire_mana_refill.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_mana_refill.xml",
	    price               = 330,
	    mana                = 0,
	    max_uses			= 5,
	    never_unlimited		= true,
    	custom_uses_logic 	= true,
	    action              = function()
	    						draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_REVEAL",
	    name 		        = "$spell_d2d_reveal_name",
	    description         = "$spell_d2d_reveal_desc",
        inject_after        = { "X_RAY" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/reveal.png",
	    type 		        = ACTION_TYPE_UTILITY,
		spawn_level       	= "0,1,2,3,4,5,6", -- X_RAY
		spawn_probability 	= "0.6,0.8,0.8,0.6,0.4,0.2,0.1", -- X_RAY
	    price               = 230,
	    mana                = 100,
	    max_uses			= 10,
	    action              = function()
								-- add_projectile( "data/entities/projectiles/deck/xray.xml" )
                                LoadGameEffectEntityTo( get_player(), "mods/D2DContentPack/files/entities/misc/status_effects/effect_reveal.xml" )
	                        end,
    },

    {
	    id                  = "D2D_REWIND",
	    name 		        = "$spell_d2d_rewind_name",
	    description         = "$spell_d2d_rewind_desc",
        inject_after        = { "TELEPORT_PROJECTILE_STATIC" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/rewind.png",
	    type 		        = ACTION_TYPE_UTILITY,
		spawn_level         = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE_STATIC
		spawn_probability   = "0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE_STATIC
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_rewind.xml",
	    price               = 90,
	    mana                = 40,
	    action              = function()
                                dofile_once( "data/scripts/lib/utilities.lua" )
                                local marker_id = get_internal_int( get_player(), "rewind_marker_id" )
                                if marker_id ~= nil and marker_id ~= -1 then
                                	local x, y = EntityGetTransform( marker_id )
    								GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/teleport/destroy", x, y )
                                	EntitySetTransform( get_player(), x, y )

                                	EntityKill( marker_id )
                                	set_internal_int( get_player(), "rewind_marker_id", -1 )
                                end
	                        end,
    },

    {
	    id                  = "D2D_REWIND_ALT_FIRE",
	    name 		        = "$spell_d2d_rewind_alt_fire_name",
	    description         = "$spell_d2d_rewind_alt_fire_desc",
        inject_after        = { "D2D_REWIND", "TELEPORT_PROJECTILE_STATIC" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_fire_rewind.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE_STATIC
		spawn_probability   = "0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE_STATIC
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_rewind.xml",
	    price               = 90,
	    mana                = 40,
	    action              = function()
	    						draw_actions( 1, true )
        						mana = mana + 40
	                        end,
    },

	{
		id                  = "D2D_FIXED_ALTITUDE",
		name 		        = "$spell_d2d_fixed_altitude_name",
		description         = "$spell_d2d_fixed_altitude_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/fixed_altitude.png",
		type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.3,0.5,0.7,0.9,1.1,1.0",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_fixed_altitude.xml",
		price               = 280,
		mana                = 1,
		action 		        = function()
								draw_actions( 1, true )
		                    end,
	},

	-- {
	-- 	id                  = "D2D_REWIND",
	-- 	name 		        = "Rewind",
	-- 	description         = "Teleports you where you were 4 seconds ago",
	-- 	sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/rewind.png",
	-- 	type 		        = ACTION_TYPE_PASSIVE,
	-- 	spawn_level         = "1,2,3,4,5,6",
	-- 	spawn_probability   = "0.3,0.5,0.7,0.9,1.1,1.0",
	-- 	price               = 280,
	-- 	mana                = 40,
	-- 	custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/torch.xml",
	-- 	action 		        = function()
	-- 							if reflecting then return end

	-- 							local player = GetUpdatedEntityID()

	-- 							-- local vel_x, vel_y = getPlayerVelocities()
	-- 							-- ^ this seems to be an existing method?

	-- 							local vcomp = EntityGetFirstComponent( player, "VelocityComponent" )
	-- 							local cdcomp = EntityGetFirstComponent( player, "CharacterDataComponent" )
	-- 						    if vcomp ~= nil then
	-- 								local v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
	-- 								local d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )

	-- 							    if ( v_vel_y > 0 ) then
	-- 									-- edit_component( player, "VelocityComponent", function(vcomp,vars)
	-- 									-- 	ComponentSetValueVector2( vcomp, "mVelocity", v_vel_x, ( v_vel_y * 0.25 ) - 6 ) end)
										
	-- 									-- edit_component( player, "CharacterDataComponent", function(ccomp,vars)
	-- 									-- 	ComponentSetValueVector2( cdcomp, "mVelocity", d_vel_x, ( d_vel_y * 0.25 ) - 12 ) end)
	-- 									edit_component( player, "VelocityComponent", function(vcomp,vars)
	-- 										ComponentSetValueVector2( vcomp, "mVelocity", v_vel_x, -6 ) end)
										
	-- 									edit_component( player, "CharacterDataComponent", function(ccomp,vars)
	-- 										ComponentSetValueVector2( cdcomp, "mVelocity", d_vel_x, -12 ) end)

	-- 									v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
	-- 									d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )
	-- 								end
	-- 						    end
	-- 	                    end,
	-- },
}

if(actions ~= nil)then
	for k, v in pairs(d2d_actions)do
		if(not HasSettingFlag(v.id.."_disabled"))then
			table.insert(actions, v)
		end
	end
end




-- spells that should only be added if the player has Apotheosis enabled
if ( ModIsEnabled("Apotheosis") ) then
	d2d_apoth_actions = {
	    {
		    id                  = "D2D_SUMMON_CAT",
		    name 		        = "$spell_d2d_summon_cat_name",
		    description         = "$spell_d2d_summon_cat_desc",
	        inject_after        = { "EXPLODING_DEER" },
		    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/summon_cat.png",
		    type 		        = ACTION_TYPE_PROJECTILE,
			spawn_level         = "0", -- never spawns in the world
			spawn_probability   = "0", -- never spawns in the world
		    price               = 400,
		    mana                = 150,
		    max_uses			= 5,
	    	never_unlimited 	= true,
		    action              = function()
		 							if reflecting then return end
		 							
	                                local x, y = EntityGetTransform( GetUpdatedEntityID() )
		    						add_projectile( "mods/Apotheosis/files/entities/special/conjurer_cat_spawner.xml", x, y )
		                        end,
	    },

	    {
		    id                  = "D2D_SUMMON_FAIRIES",
		    name 		        = "$spell_d2d_summon_fairies_name",
		    description         = "$spell_d2d_summon_fairies_desc",
	        inject_after        = { "D2D_SUMMON_CAT", "EXPLODING_DEER" },
		    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/summon_fairies.png",
		    type 		        = ACTION_TYPE_PROJECTILE,
			spawn_level         = "0,1,2,3,4",
			spawn_probability   = "0.1,0.4,0.3,0.4,1.0",
		    price               = 200,
		    mana                = 15,
		    max_uses			= 10,
	    	never_unlimited 	= true,
		    action              = function()
		 							if reflecting then return end
		 							
	                                local x, y = EntityGetTransform( GetUpdatedEntityID() )
	    							add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/summon_fairies_spawner.xml", x, y )
		                        end,
	    },
	}

	if(actions ~= nil)then
		for k, v in pairs(d2d_apoth_actions)do
			if(not HasSettingFlag(v.id.."_disabled"))then
				table.insert(actions, v)
			end
		end
	end
end



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


-- function OrganiseProgress()
--     dofile_once( "data/scripts/gun/gun_actions.lua" )

--     -- Based on Conga Lyne's implementation
--     for insert_index = 1, #d2d_actions do
--         local action_to_insert = d2d_actions[insert_index]
--         -- Check if spells to inject after are defined
--         if action_to_insert.inject_after ~= nil then
--             -- Loop over actions
--             local found = false
--             for actions_index = #actions, 1, -1 do
--                 action = actions[actions_index]
--                 -- Loop over inject after options
--                 for inject_index = 1, #action_to_insert.inject_after do
--                     if action.id == action_to_insert.inject_after[inject_index] then
--                         found = true
--                         break
--                     end
--                 end
--                 if found then
--                     table.insert(actions, actions_index + 1, action_to_insert)
--                     break
--                 end
--                 if actions_index == 1 then
--                     --Insert here as a failsafe incase the matchup ID can't be found.. some other mod might delete the spell we're trying to insert at
--                     actions[#actions + 1] = action_to_insert
--                 end
--             end
--         else
--             actions[#actions + 1] = action_to_insert
--         end
--     end
-- end
