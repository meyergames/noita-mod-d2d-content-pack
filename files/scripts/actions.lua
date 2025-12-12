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
                                local x, y = EntityGetTransform( wand.entity_id )

							    local rand = Random( 0, 200 )
							    local chance = 1.0 / ( (1.0 / wand.manaMax) * wand.mana )
                                if( rand <= chance ) then
                                    c.fire_rate_wait = 40
                                    GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)

                                    local rand2 = Random( 0, 8 )
                                    if( rand2 < 1 ) then -- 2/250 or 1/125
                                        EntityInflictDamage( get_player(), 0.4, "DAMAGE_ELECTRICITY", "overheated wand", "ELECTROCUTION", 0, 0, entity_id, x, y, 0)
                                    elseif( rand2 < 3 ) then -- 2/250 or 1/125
                                        EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml", x, y )
                                    elseif( rand2 < 5 ) then -- 2/250 or 1/125
                                        EntityLoad( "mods/D2DContentPack/files/entities/projectiles/overclock.xml", x, y )
                                    else -- 3/250 or 1/83
                                        EntityLoad( "data/entities/projectiles/deck/fizzle.xml", x, y )
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
		spawn_probability   = "1,1,1,0.9,0.7,0.5,0.3",
	    price               = 210,
	    mana                = 3,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait - 15 -- so it shows in the UI
                                current_reload_time = current_reload_time - 20 -- so it shows in the UI

					            if reflecting then return end

                                local entity_id = GetUpdatedEntityID()
							    c.fire_rate_wait	= c.fire_rate_wait + 15 -- reset
                                current_reload_time = current_reload_time + 20 -- reset

                                dofile_once( "data/scripts/lib/utilities.lua" )

                                local ctrlcomp = EntityGetFirstComponentIncludingDisabled( get_player(), "ControlsComponent" )
                                local fire_frame = ComponentGetValue2( ctrlcomp, "mButtonFrameFire" )
                                local current_frame = GameGetFrameNum()

                                local last_fire_frame = get_internal_int( get_player(), "flurry_last_fire_frame" )
                                if last_fire_frame ~= nil then
	                                local diff = fire_frame - last_fire_frame
	                                if diff > 0 and diff < 30 then
	                                	current_frame = current_frame + 20
	                                end
                                end
                                set_internal_int( get_player(), "flurry_last_fire_frame", fire_frame )

                                local frames_firing = current_frame - fire_frame
                                local burst_duration = 20
                                if frames_firing < burst_duration then
                                	c.fire_rate_wait = c.fire_rate_wait - ( ( 15 / burst_duration ) * ( burst_duration - frames_firing ) )
                                	current_reload_time = current_reload_time - ( ( 20 / burst_duration ) * ( burst_duration - frames_firing ) )
	                            end

			                    draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_RAMP_UP",
	    name 		        = "$spell_d2d_ramp_up_name",
	    description         = "$spell_d2d_ramp_up_desc",
        inject_after        = { "D2D_FLURRY", "RECHARGE", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/ramp_up.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "1,1,1,0.9,0.7,0.5,0.3",
	    price               = 210,
	    mana                = 6,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait - 15 -- so it shows in the UI
                                current_reload_time = current_reload_time - 20 -- so it shows in the UI

					            if reflecting then return end

                                local entity_id = GetUpdatedEntityID()
							    c.fire_rate_wait	= c.fire_rate_wait + 15 -- reset
                                current_reload_time = current_reload_time + 20 -- reset

                                local ctrlcomp = EntityGetFirstComponentIncludingDisabled( get_player(), "ControlsComponent" )
                                local fire_frame = ComponentGetValue2( ctrlcomp, "mButtonFrameFire" )
                                local current_frame = GameGetFrameNum()

                                local frames_firing = current_frame - fire_frame
                                local frames_for_max_effect = 150
                                if frames_firing < frames_for_max_effect then
                                	c.fire_rate_wait = c.fire_rate_wait - ( ( 15 / frames_for_max_effect ) * frames_firing )
                                	current_reload_time = current_reload_time - ( ( 20 / frames_for_max_effect ) * frames_firing )
                                else
                                	c.fire_rate_wait = c.fire_rate_wait - 15
                                	current_reload_time = current_reload_time - 20
	                            end
	                            
			                    draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_QUICK_BURNER", -- discontinued as of 10/12/25, to be removed in a future patch
	    name 		        = "$spell_d2d_quick_burner_name",
	    description         = "$spell_d2d_quick_burner_desc",
        inject_after        = { "D2D_FLURRY", "RECHARGE", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/quick_burner.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0", -- discontinued as of 10/12/25, to be removed in a future patch
		spawn_probability   = "0", -- discontinued as of 10/12/25, to be removed in a future patch
		related_extra_entities = { "mods/D2DContentPack/files/entities/projectiles/deck/quick_burner.xml" },
	    price               = 330,
	    mana                = 8,
	    action              = function()
					            c.damage_projectile_add = c.damage_projectile_add + 0.4
								c.fire_rate_wait 		= c.fire_rate_wait - 10
								current_reload_time 	= current_reload_time - 20
								c.speed_multiplier		= c.speed_multiplier * 2
								if reflecting then return end
								c.knockback_force 		= c.knockback_force + 3.0

								c.extra_entities    	= c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/quick_burner.xml,"
			                    draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_CONTROLLED_REACH",
	    name 		        = "$spell_d2d_controlled_reach_name",
	    description         = "$spell_d2d_controlled_reach_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/controlled_reach.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "1,1,1,0.9,0.7,0.5,0.3",
		related_extra_entities = { "mods/D2DContentPack/files/entities/projectiles/deck/controlled_reach.xml" },
	    price               = 330,
	    mana                = 3,
	    action              = function()
	    						-- for the tooltip
								c.fire_rate_wait 		= c.fire_rate_wait - 15
								current_reload_time 	= current_reload_time - 20
								c.damage_projectile_add = c.damage_projectile_add + 0.2

								if reflecting then return end

								-- reset
								c.fire_rate_wait 		= c.fire_rate_wait + 15
								current_reload_time 	= current_reload_time + 20
								c.damage_projectile_add = c.damage_projectile_add - 0.2

								-- add entity that controls the spell's reach
								c.extra_entities    	= c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/controlled_reach.xml,"

								-- determine the distance
								dofile_once( "data/scripts/lib/utilities.lua" )
								local ox, oy 			= EntityGetTransform( GetUpdatedEntityID() )
								local mx, my 			= DEBUG_GetMouseWorld()
								local dist 				= get_distance( ox, oy, mx, my )

								-- increase fire rate and projectile speed based on distance
								local buff_ratio 		= remap( dist, 180, 65, 0.1, 1.0 )
								c.fire_rate_wait 		= c.fire_rate_wait - ( 15 * buff_ratio )
								current_reload_time 	= current_reload_time - ( 20 * buff_ratio )
								c.damage_projectile_add = c.damage_projectile_add + ( 0.2 * buff_ratio )
								c.speed_multiplier		= c.speed_multiplier * ( 1.5 + ( 1.0 * buff_ratio ) )

								-- finally, draw the next spell
			                    draw_actions( 1, true )
	                        end,
    },

	{
		id                  = "D2D_RECYCLE",
		name 		        = "$spell_d2d_recycle_name",
		description         = "$spell_d2d_recycle_desc",
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
	    id                  = "D2D_MANA_REFILL",
	    name 		        = "$spell_d2d_mana_refill_name",
	    description         = "$spell_d2d_mana_refill_desc",
        inject_after        = { "MANA_REDUCE" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/mana_refill.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
	    price               = 330,
	    mana                = 0,
	    max_uses			= 5,
		never_unlimited 	= true,
		-- custom_uses_logic	= true,
	    action              = function()
	    						if reflecting then return end

							    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
							    local wand = EZWand.GetHeldWand()
                                local x, y = EntityGetTransform( GetUpdatedEntityID() )

						    	mana = wand.manaMax
            					GamePlaySound( "data/audio/Desktop/player.bank", "player_projectiles/wall/create", x, y )

            					draw_actions( 1, true )
	                        end,
    },

    -- {
	--     id                  = "D2D_OPENING_SHOT",
	--     name 		        = "Opening Shot",
	--     description         = "Makes a projectile deal double damage on full-health enemies",
    --     inject_after        = { "ARROW" },
	--     sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/snipe_shot.png",
	--     type 		        = ACTION_TYPE_PROJECTILE,
	-- 	spawn_level         = "0,1,2,3,4,5,6",
	-- 	spawn_probability   = "0.4,1,2,1.5,0.6,0.4,0.2",
	--     price               = 270,
	--     mana                = 20,
	--     action              = function()
    --                             c.fire_rate_wait = c.fire_rate_wait + 45
    --                             add_projectile("mods/D2DContentPack/files/entities/projectiles/sniper_bullet_custom.xml")
	--                         end,
    -- },
    
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
			c.damage_curse_add 		= c.damage_curse_add + 0.2 -- for the tooltip
			if reflecting then return end

			c.damage_curse_add 		= c.damage_curse_add - 0.2 -- reset
            local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
            if curse_count ~= nil then
				c.damage_curse_add 		= c.damage_curse_add + ( 0.2 * tonumber( curse_count ) )
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
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,1,2,1.5,0.6,0.4,0.2",
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
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.2,0.5,1,0.8,0.3,0.2,0.1",
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

	-- {
	-- 	id                  = "D2D_GLASS_SHARD",
	-- 	name 		        = "$spell_d2d_glass_shard_name",
	-- 	description         = "$spell_d2d_glass_shard_desc",
	-- 	sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/glass_shard.png",
	-- 	related_projectiles	= {"mods/D2DContentPack/files/entities/projectiles/glass_shard.xml"},
	-- 	type 		        = ACTION_TYPE_PROJECTILE,
	-- 	spawn_level         = "0,1,2,3", -- LIGHT_BULLET_TRIGGER
	-- 	spawn_probability   = "1,0.7,0.6,0.5", -- LIGHT_BULLET_TRIGGER
	-- 	price               = 90,
	-- 	mana                = 5,
	-- 	action 		        = function()
	-- 		                    c.fire_rate_wait = c.fire_rate_wait - 3
	-- 		                    add_projectile( "mods/D2DContentPack/files/entities/projectiles/glass_shard.xml" )
	-- 	                    end,
	-- },

    {
	    id                  = "D2D_GIGA_DRAIN",
	    name 		        = "$spell_d2d_giga_drain_name",
	    description         = "$spell_d2d_giga_drain_desc",
        inject_after        = { "CHAINSAW" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/giga_drain.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,6", -- spawning it in The Vault does not make sense
		spawn_probability   = "0.5,0.8,1,1.1,1,0.5",
	    price               = 150,
	    mana                = 60,
	    action              = function()
		                        c.fire_rate_wait = current_reload_time + 8
		                        current_reload_time = current_reload_time + 20
								shot_effects.recoil_knockback	= shot_effects.recoil_knockback + 100

                                add_projectile( "mods/D2DContentPack/files/entities/projectiles/giga_drain_bullet.xml" )
	                        end,
    },

    {
	    id                  = "D2D_UNSTABLE_NUCLEUS",
	    name 		        = "$spell_d2d_unstable_nucleus_name",
	    description         = "$spell_d2d_unstable_nucleus_desc",
        inject_after        = { "GRENADE_TIER_3" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/unstable_nucleus.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,3,4,5,6,10",
		spawn_probability   = "0.1,0.25,0.5,0.75,1,1,0.75",
	    price               = 480,
	    mana                = 100,
	    max_uses			= 3,
	    custom_uses_logic	= true,
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
                                else
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
		spawn_level         = "1,2,3,4,5", -- BOMB
		spawn_probability   = "0.6,0.7,0.4,0.3,0.2",
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
		spawn_level         = "2,3,4,5,6", -- BOMB
		spawn_probability   = "0.3,0.4,0.4,0.5,0.5",
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
        max_uses            = 30,
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
	    id                  = "D2D_SMALL_EXPLOSION",
	    name 		        = "$spell_d2d_small_explosion_name",
	    description         = "$spell_d2d_small_explosion_desc",
        inject_after        = { "EXPLOSION" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/small_explosion.png",
	    type 		        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "1.2,1,0.8,0.6",
	    price               = 120,
	    mana                = 18,
	    action              = function()
			                    add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml")
			                    c.fire_rate_wait = c.fire_rate_wait + 1.5
			                    c.screenshake = c.screenshake + 1.25
	                        end,
    },

	{
		id                  = "D2D_SHOCKWAVE",
		name 		        = "$spell_d2d_shockwave_name",
		description         = "$spell_d2d_shockwave_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/shockwave.png",
		type 		        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "0.5,0.5,1,1",
		price               = 220,
		mana                = 30,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 40
			                    if reflecting then return end

								add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/shockwave.xml" )
		                    end,
	},

	{
		id                  = "D2D_BOLT_CATCHER",
		name 		        = "$spell_d2d_bolt_catcher_name",
		description         = "$spell_d2d_bolt_catcher_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/bolt_catcher.png",
		type 		        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.1,0.5,0.6,0.7,0.8,0.5",
		price               = 220,
		mana                = 30,
		max_uses			= 30,
		never_unlimited		= true,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 30
			                    if reflecting then return end

								add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/bolt_catcher.xml" )
		                    end,
	},

    {
	    id                  = "D2D_COMPACT_SHOT",
	    name 		        = "$spell_d2d_compact_shot_name",
	    description         = "$spell_d2d_compact_shot_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/compact_shot.png",
	    type 		        = ACTION_TYPE_DRAW_MANY,
		spawn_level       	= "1,2,3,4,5,6",
		spawn_probability 	= "0.6,0.6,0.4,0.4,0.2,0.2",
	    price               = 200,
	    mana                = 5,
	    action              = function()
								c.damage_projectile_add = c.damage_projectile_add + 0.08

	    						if reflecting then return end

                                draw_actions( 1, true )

	    						local first_proj_index = -1
								for i,v in ipairs( hand ) do
									local spell_data = hand[i]
									if spell_data.type == ACTION_TYPE_PROJECTILE then
										first_proj_index = i
										break
									end
								end

                                if first_proj_index > -1 then
		    						local next_spell_id = hand[first_proj_index].id

		    						local copies = 0
		    						local mana_refund = 0
									for i,v in ipairs( deck ) do
										local spell_data = deck[i]
										if spell_data.id == next_spell_id then
											copies = copies + 1
											-- mana_refund = mana_refund + spell_data.mana
										else
											break
										end
									end

									-- local cached_fire_rate_wait = c.fire_rate_wait
									c.spread_degrees = c.spread_degrees + ( 1.5 * copies )
									draw_actions( copies, true )

									-- c.fire_rate_wait = cached_fire_rate_wait * copies * 0.5
									-- current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10
								end

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
	    max_uses			= 20,
	    action              = function()
	    						if reflecting then return end
	    						
								-- add_projectile( "data/entities/projectiles/deck/xray.xml" )
                                LoadGameEffectEntityTo( get_player(), "mods/D2DContentPack/files/entities/misc/status_effects/effect_reveal.xml" )
	                        end,
    },

    {
	    id                  = "D2D_BLINK",
	    name 		        = "$spell_d2d_blink_name",
	    description         = "$spell_d2d_blink_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/blink.png",
	    type 		        = ACTION_TYPE_UTILITY,
		spawn_level         = "2,3,4,5,6,10", -- TELEPORT_PROJECTILE
		spawn_probability   = "0.05,0.1,0.2,0.3,0.4,0.5", -- TELEPORT_PROJECTILE
	    price               = 300,
	    mana                = 80,
	    max_uses			= 10,
	    never_unlimited		= true,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 60
                                current_reload_time = current_reload_time + 60
	    						if reflecting then return end

	    						add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/blink.xml" )
	                        end,
    },

    {
	    id                  = "D2D_BLINK_TRIGGER",
	    name 		        = "$spell_d2d_blink_trigger_name",
	    description         = "$spell_d2d_blink_trigger_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/blink_trigger.png",
	    type 		        = ACTION_TYPE_UTILITY,
		spawn_level         = "3,4,5,6,10", -- TELEPORT_PROJECTILE
		spawn_probability   = "0.05,0.1,0.15,0.2,0.25", -- TELEPORT_PROJECTILE
	    price               = 360,
	    mana                = 85,
	    max_uses			= 10,
	    never_unlimited		= true,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 60
                                current_reload_time = current_reload_time + 60
								if reflecting then return end

								add_projectile_trigger_death( "mods/D2DContentPack/files/entities/projectiles/deck/blink.xml", 1 )
	                        end,
    },

    {
	    id                  = "D2D_REWIND",
	    name 		        = "$spell_d2d_rewind_name",
	    description         = "$spell_d2d_rewind_desc",
        inject_after        = { "TELEPORT_PROJECTILE_STATIC" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/rewind.png",
	    type 		        = ACTION_TYPE_UTILITY,
		spawn_level         = "0,1,2,3,4,5,6", -- TELEPORT_PROJECTILE_STATIC
		spawn_probability   = "0.6,0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE_STATIC
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
                            	else
                            		mana = mana + 40
                                end
	                        end,
    },

    {
	    id                  = "D2D_SPRAY_AND_PRAY",
	    name 		        = "$spell_d2d_spray_and_pray_name",
	    description         = "$spell_d2d_spray_and_pray_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/spray_and_pray.png",
	    type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_spray_and_pray.xml",
	    price               = 330,
	    mana                = 1,
	    action              = function()
								c.spread_degrees = c.spread_degrees + 3.0
                                -- c.fire_rate_wait    = c.fire_rate_wait * 0.25 -- so it shows in the UI
                                -- current_reload_time = current_reload_time * 0.5 -- so it shows in the UI
                                -- if reflecting then return end
                                -- c.fire_rate_wait    = c.fire_rate_wait + 15
                                -- current_reload_time = current_reload_time + 20

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
		id                  = "D2D_FIXED_ALTITUDE",
		name 		        = "$spell_d2d_fixed_altitude_name",
		description         = "$spell_d2d_fixed_altitude_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/fixed_altitude.png",
		type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.3,0.5,0.7,0.9,1.1,1",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_fixed_altitude.xml",
		price               = 280,
		mana                = 1,
		action 		        = function()
								draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_MANA_LOCK",
		name 		        = "$spell_d2d_mana_lock_name",
		description         = "$spell_d2d_mana_lock_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/mana_lock.png",
		type 		        = ACTION_TYPE_PASSIVE,
		-- spawn_level         = "1,2,3,4,5,6,10",
		-- spawn_probability   = "0.3,0.5,0.7,0.9,1.1,1,1",
		spawn_level         = "0",
		spawn_probability   = "0",
		-- custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_mana_lock.xml",
		price               = 280,
		mana                = 0,
		action 		        = function()
								GamePrint( "The 'Mana Lock' spell is currently out of order; please come back later.")
								-- disable Add Mana etc
								-- for i,v in ipairs( deck ) do
								-- 	local spell_data = deck[i]
								-- 	if spell_data.mana < 0 then
								-- 		mana = mana - math.abs( spell_data.mana )
								-- 	end
								-- end
								-- for i,v in ipairs( discarded ) do
								-- 	local spell_data = discarded[i]
								-- 	if spell_data.mana < 0 then
								-- 		mana = mana - math.abs( spell_data.mana )
								-- 	end
								-- end

								draw_actions( 1, true )
		                    end,
	},

    {
	    id                  = "D2D_ALT_ALT_FIRE_TELEPORT_BOLT",
	    name 		        = "$spell_d2d_alt_alt_fire_teleport_bolt_name",
	    description         = "$spell_d2d_alt_alt_fire_teleport_bolt_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_alt_fire_teleport_bolt.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
        -- spawn_level			= "4,5,6,10",
        -- spawn_probability	= "0.2,0.2,0.2,0.6",
        spawn_level			= "0",
        spawn_probability	= "0",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_alt_fire_teleport_bolt.xml",
        price 				= 130,
        mana 				= 20,
	    action              = function()
	    						draw_actions( 1, true )
            					mana = mana + 20
	                        end,
    },

	{
		id                  = "D2D_MANA_SPLIT",
		name 		        = "$spell_d2d_mana_split_name",
		description         = "$spell_d2d_mana_split_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/mana_split.png",
		type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "1,2,3,4,5,6", -- MANA_REDUCE
		spawn_probability   = "0.7,0.9,1,1,1,1", -- MANA_REDUCE
		price               = 250,
		mana                = 0,
		action 		        = function()
								c.fire_rate_wait = c.fire_rate_wait + 10
								draw_actions( 1, true )

								if #hand >= 2 and hand[2] then
									local refund = hand[2].mana * 0.5
									if refund > 0 then
										mana = mana + refund
									end
								end
		                    end,
	},

    {
	    id                  = "D2D_BLOOD_PRICE",
	    name 		        = "$spell_d2d_blood_price_name",
	    description         = "$spell_d2d_blood_price_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/blood_price.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level       	= "0", -- cannot be found normally
		spawn_probability 	= "0", -- cannot be found normally
	    price               = 500,
	    mana                = 0,
	    action              = function()
	    						if reflecting then return end

	                            -- deal 2% max health damage (cannot kill)
								local p_dcomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "DamageModelComponent" )
								local p_hp = ComponentGetValue2( p_dcomp, "hp" )
								local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
	                            EntityInflictDamage( GetUpdatedEntityID(), math.min( p_max_hp * 0.02, p_hp - 0.04 ), "DAMAGE_NONE", "blood price", "NONE", 0, 0, GetUpdatedEntityID(), x, y, 0)

                                draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_BLOOD_TOLL",
	    name 		        = "$spell_d2d_blood_toll_name",
	    description         = "$spell_d2d_blood_toll_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/blood_toll.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level       	= "0", -- cannot be found normally
		spawn_probability 	= "0", -- cannot be found normally
	    price               = 500,
	    mana                = 0,	
	    action              = function()
	    						if reflecting then return end

	                            -- deal 5% max health damage (cannot kill)
								local p_dcomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "DamageModelComponent" )
								local p_hp = ComponentGetValue2( p_dcomp, "hp" )
								local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
	                            EntityInflictDamage( GetUpdatedEntityID(), math.min( p_max_hp * 0.05, p_hp - 0.04 ), "DAMAGE_NONE", "blood toll", "NONE", 0, 0, GetUpdatedEntityID(), x, y, 0)

                                draw_actions( 1, true )
	                        end,
    },
}

if actions ~= nil then
	for k, v in pairs( d2d_actions ) do
		if not HasSettingFlag( v.id.."_disabled" ) then
			table.insert( actions, v )
		end
	end
end





-- spells that should only be added if the player has Apotheosis enabled
if ( ModIsEnabled("Apotheosis") ) then
	d2d_apoth_actions = {
	    {
		    id                  = "D2D_CATS_TO_DAMAGE",
		    name 		        = "$spell_d2d_cats_to_damage_name",
		    description         = "$spell_d2d_cats_to_damage_desc",
		    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/cats_to_damage.png",
		    type 		        = ACTION_TYPE_MODIFIER,
			spawn_level         = "0", -- never spawns in the world
			spawn_probability   = "0", -- never spawns in the world
		    price               = 400,
		    mana                = 5,
		    action              = function()
									c.fire_rate_wait		= c.fire_rate_wait + 5
									c.damage_projectile_add = c.damage_projectile_add + 0.04 -- for the tooltip
									if reflecting then return end
									c.damage_projectile_add = c.damage_projectile_add - 0.04 -- reset

									dofile_once( "data/scripts/lib/utilities.lua" )
						            local cats_petted = get_internal_int( get_player(), "cats_petted", 1 )
						            c.damage_projectile_add = c.damage_projectile_add + ( 0.04 * cats_petted )
		                        end,
	    },

	    {
		    id                  = "D2D_SUMMON_FAIRIES", -- discontinued as of 10/12/25, to be removed in a future patch
		    name 		        = "$spell_d2d_summon_fairies_name",
		    description         = "$spell_d2d_summon_fairies_desc",
		    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/summon_fairies.png",
		    type 		        = ACTION_TYPE_PROJECTILE,
			spawn_level         = "0", -- discontinued as of 10/12/25, to be removed in a future patch
			spawn_probability   = "0", -- discontinued as of 10/12/25, to be removed in a future patch
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





d2d_alt_fire_actions = {
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
	    id                  = "D2D_SMOKE_BOMB_ALT_FIRE", -- discontinued as of 10/12/25, to be removed
	    name 		        = "$spell_d2d_smoke_bomb_alt_fire_name",
	    description         = "$spell_d2d_smoke_bomb_alt_fire_desc",
        inject_after        = { "D2D_SMOKE_BOMB", "GRENADE_ANTI", "GRENADE_TIER_3" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_fire_smoke_bomb.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0", -- discontinued as of 10/12/25, to be removed
		spawn_probability   = "0", -- discontinued as of 10/12/25, to be removed
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
		id                  = "D2D_BOLT_CATCHER_ALT_FIRE",
		name 		        = "$spell_d2d_bolt_catcher_alt_fire_name",
		description         = "$spell_d2d_bolt_catcher_alt_fire_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_fire_bolt_catcher.png",
		type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.1,0.5,0.6,0.7,0.8,0.5",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_bolt_catcher.xml",
		price               = 220,
		mana                = 30,
		max_uses			= 30,
		never_unlimited		= true,
    	custom_uses_logic 	= true,
		action 		        = function()
	    						draw_actions( 1, true )
        						mana = mana + 30
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
		spawn_level         = "0,1,2,3,4,5,6", -- TELEPORT_PROJECTILE_STATIC
		spawn_probability   = "0.6,0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE_STATIC
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_rewind.xml",
	    price               = 90,
	    mana                = 40,
	    action              = function()
	    						draw_actions( 1, true )
        						mana = mana + 40
	                        end,	
    },
}

if actions ~= nil and d2d_alt_fire_actions ~= nil then
	for k, v in pairs( d2d_alt_fire_actions ) do
		if( not HasSettingFlag( v.id .. "_disabled" ) ) then
			table.insert(actions, v)
		end
	end
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
