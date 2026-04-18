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
	    id                  = "D2D_CONTROLLED_FUSE",
	    name 		        = "$spell_d2d_controlled_fuse_name",
	    description         = "$spell_d2d_controlled_fuse_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/controlled_fuse.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.3,0.4,0.5,0.6,0.7,0.8",
	    price               = 330,
	    mana                = 20,
	    action              = function()
	    						-- c.fire_rate_wait = c.fire_rate_wait + 60
								if reflecting then return end

								dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
								if not get_internal_bool( get_player(), "is_fuse_being_controlled" ) then
									c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/controlled_fuse.xml,"
                                	draw_actions( 1, true )
                                	set_internal_bool( get_player(), "is_fuse_being_controlled", true )
                                else
                                	for i,v in ipairs( hand ) do
										table.insert( discarded, v )
									end
									hand = {}

									for i,v in ipairs( deck ) do
										table.insert( discarded, v )
									end
									deck = {}
									
									if ( force_stop_draws == false ) then
										force_stop_draws = true
										move_discarded_to_deck()
										order_deck()
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
	    max_uses			= 10,
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
		id          		= "D2D_CURSES_TO_DAMAGE",
		name 				= "$spell_d2d_curses_to_damage_name",
		description 		= "$spell_d2d_curses_to_damage_desc",
		sprite 				= "mods/D2DContentPack/files/gfx/ui_gfx/spells/curses_to_damage.png",
		type 				= ACTION_TYPE_MODIFIER,
		spawn_level         = "0",
		spawn_probability   = "0",
		price 				= 999,
		mana 				= 5,
		action 				= function()
			c.fire_rate_wait		= c.fire_rate_wait + 5
			c.damage_curse_add 		= c.damage_curse_add + 0.2 -- for the tooltip
			if reflecting then return end

			c.damage_curse_add 		= c.damage_curse_add - 0.2 -- reset
            local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
            if curse_count ~= nil then
				c.damage_curse_add 		= c.damage_curse_add + ( 0.2 * tonumber( curse_count ) )
				-- c.extra_entities    	= c.extra_entities .. "data/entities/particles/tinyspark_purple_bright.xml,"
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
		mana 		= -10,
		action 		= function()
			if reflecting then return end

            local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
            if curse_count ~= nil then
    			mana = mana + ( 10 * ( tonumber( curse_count ) - 1 ) )
	            draw_actions( 1, true )
	        end
		end,
	},

	{
		id                  = "D2D_MISSING_MANA_TO_DMG",
		name 		        = "$spell_d2d_damage_missing_mana_name",
		description         = "$spell_d2d_damage_missing_mana_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/damage_missing_mana.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "1,2,3,4,5", -- 2/3 of DAMAGE
		spawn_probability   = "0.4,0.4,0.6,0.4,0.4", -- 2/3 of DAMAGE
		price               = 220,
		mana                = 50,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 25
			                    c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/missing_mana_to_dmg.xml,"
								shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0

			                    draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_HOVER_TO_DAMAGE",
		name 		        = "$spell_d2d_hover_to_damage_name",
		description         = "$spell_d2d_hover_to_damage_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/hover_to_damage.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "1,2,3,4,5", -- 2/3 of DAMAGE
		spawn_probability   = "0.4,0.4,0.6,0.4,0.4", -- 2/3 of DAMAGE
		price               = 200,
		mana                = 0,
		action 		        = function()
								c.damage_projectile_add = c.damage_projectile_add + 0.8

								if reflecting then return end
								c.damage_projectile_add = c.damage_projectile_add - 0.8

								local cdatacomp = EntityGetFirstComponentIncludingDisabled( get_player(), "CharacterDataComponent" )
								if cdatacomp then
									local is_on_ground = ComponentGetValue2( cdatacomp, "is_on_ground" )
									local hover_energy = ComponentGetValue2( cdatacomp, "mFlyingTimeLeft" )
									if not is_on_ground and hover_energy >= 0.15 then
										c.damage_projectile_add = c.damage_projectile_add + 0.8
										ComponentSetValue2( cdatacomp, "mFlyingTimeLeft", hover_energy - 0.15 )
									end
								end

			                    draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_COMBO_DAMAGE",
		name 		        = "$spell_d2d_combo_damage_name",
		description         = "$spell_d2d_combo_damage_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/combo_damage.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "1,2,3,4,5", -- 2/3 of DAMAGE
		spawn_probability   = "0.4,0.4,0.6,0.4,0.4", -- 2/3 of DAMAGE
		price               = 200,
		mana                = 20,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 5
			                    current_reload_time = current_reload_time + 5
								c.damage_projectile_add = c.damage_projectile_add + 0.32
								c.damage_critical_chance = c.damage_critical_chance + 8
								if reflecting then return end
			                    c.fire_rate_wait = c.fire_rate_wait - 5
			                    current_reload_time = current_reload_time - 5
								c.damage_projectile_add = c.damage_projectile_add - 0.32
								c.damage_critical_chance = c.damage_critical_chance - 8

								local prior_projectiles = 0
								if #discarded > 0 then
									for i,v in ipairs( discarded ) do
										if discarded[i].type == 0 then -- 0 == ACTION_TYPE_PROJECTILE, apparently
											prior_projectiles = prior_projectiles + 1
										end
									end
			                    	c.fire_rate_wait = c.fire_rate_wait + ( 5 * prior_projectiles )
			                    	current_reload_time = current_reload_time + ( 5 * prior_projectiles )
									c.damage_projectile_add = c.damage_projectile_add + ( 0.32 * prior_projectiles )
									c.damage_critical_chance = c.damage_critical_chance + ( 8 * prior_projectiles )
								end

			                    draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_DAMAGE_MULT",
		name 		        = "$spell_d2d_damage_mult_name",
		description         = "$spell_d2d_damage_mult_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/damage_mult.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "1,2,3,4,5,6,10", -- 2/3 of DAMAGE
		spawn_probability   = "0.4,0.4,0.6,0.4,0.4,0.6,0.6", -- 2/3 of DAMAGE
		price               = 200,
		mana                = 50,
		action 		        = function()
			                    current_reload_time = current_reload_time + 24
								shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0

								if reflecting then return end

								c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/damage_mult.xml,"
								c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"

			                    draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_DAMAGE_RECHARGE",
		name 		        = "$spell_d2d_damage_recharge_name",
		description         = "$spell_d2d_damage_recharge_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/damage_recharge.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "1,2,3,4,5,6,10", -- 2/3 of DAMAGE
		spawn_probability   = "0.4,0.4,0.6,0.4,0.4,0.6,0.6", -- 2/3 of DAMAGE
		price               = 200,
		mana                = 50,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 25
								shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0

								if reflecting then return end

								c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/damage_recharge.xml,"
								c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"

			                    draw_actions( 1, true )
		                    end,
	},

	{
		id          		= "D2D_PROJECTILE_MORPH",
		name 				= "$spell_d2d_projectile_morph_name",
		description 		= "$spell_d2d_projectile_morph_desc",
		sprite 				= "mods/D2DContentPack/files/gfx/ui_gfx/spells/projectile_morph.png",
		type 				= ACTION_TYPE_MODIFIER,
		spawn_level 		= "3,4,5,6,10",
		spawn_probability	= "0.3,0.4,0.5,0.6,0.7",
        spawn_requires_flag	= "d2d_ancient_lurker_defeated",
		price 				= 390,
		mana 				= 120,
		action 				= function()
			c.fire_rate_wait = c.fire_rate_wait + 24
			c.friendly_fire	 = false
			c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/projectile_morph_entity.xml,"

			-- TODO:	maybe Piercing makes it more satisfying to use?
			-- TODO #2: double the damage on anything shot through Projectile Morph?
			-- TODO #3: make the player automatically immune to anything shot through Projectile Morph?
            -- c.extra_entities = c.extra_entities .. "data/entities/misc/piercing_shot.xml,"

			draw_actions( 1, true )
		end,
	},

	{
		id                  = "D2D_SHOCKWAVE",
		name 		        = "$spell_d2d_shockwave_name",
		description         = "$spell_d2d_shockwave_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/shockwave.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "0.5,0.5,1,1",
		price               = 220,
		mana                = 30,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 40
			                    if reflecting then return end

			                    c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/shockwave_modifier.xml,"
			                    draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_SPARK_BOLT_ENHANCER",
		name 		        = "$spell_d2d_spark_bolt_enhancer_name",
		description         = "$spell_d2d_spark_bolt_enhancer_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/spark_bolt_enhancer.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0", -- only appears on the Staff of Loyalty
		spawn_probability   = "0", -- only appears on the Staff of Loyalty
		price               = 220,
		mana                = 30,
		action 		        = function()								
								c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/spark_bolt_enhancer.xml,"
								draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_BANANA_BOMB_ENHANCER",
		name 		        = "$spell_d2d_banana_bomb_enhancer_name",
		description         = "$spell_d2d_banana_bomb_enhancer_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/banana_bomb_enhancer.png",
		type 		        = ACTION_TYPE_MODIFIER,
		spawn_requires_flag = "d2d_staff_guardian_nutrition_defeated",
		spawn_level         = "0,1,2,3,4,5",
		spawn_probability   = "0.6,0.5,0.4,0.3,0.3,0.3",
		price               = 250,
		mana                = 30,
		action 		        = function()								
								c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/banana_bomb_enhancer.xml,"
								draw_actions( 1, true )
		                    end,
	},

	-- {
	-- 	id                  = "D2D_OPENING_SHOT",
	-- 	name 		        = "Opening Shot",
	-- 	description         = "Makes a projectile deal more damage when the enemy has full health",
	-- 	sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/opening_shot.png",
	-- 	type 		        = ACTION_TYPE_MODIFIER,
	-- 	spawn_level         = "0,1,2,3",
	-- 	spawn_probability   = "0.5,0.5,1,1",
	-- 	price               = 220,
	-- 	mana                = 3,
	-- 	action 		        = function()
	-- 		                    c.fire_rate_wait = c.fire_rate_wait + 5

	-- 		                    -- for the tooltip
	-- 		                    c.damage_projectile_add = c.damage_projectile_add + 0.8
	-- 		                    if reflecting then return end
	-- 		                    c.damage_projectile_add = c.damage_projectile_add - 0.8

	-- 		                    c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/opening_shot.xml,"
	-- 		                    draw_actions( 1, true )
	-- 	                    end,
	-- },

	-- {
	-- 	id                  = "D2D_HEALTHY_SHOT",
	-- 	name 		        = "Healthy Shot (idk)",
	-- 	description         = "Makes a projectile deal more damage when you have full health",
	-- 	sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/opening_shot.png",
	-- 	type 		        = ACTION_TYPE_MODIFIER,
	-- 	spawn_level         = "0,1,2,3",
	-- 	spawn_probability   = "0.5,0.5,1,1",
	-- 	price               = 220,
	-- 	mana                = 2,
	-- 	action 		        = function()
	-- 		                    c.fire_rate_wait = c.fire_rate_wait + 5

	-- 		                    -- for the tooltip
	-- 		                    c.damage_projectile_add = c.damage_projectile_add + 0.4
	-- 		                    if reflecting then return end
	-- 		                    c.damage_projectile_add = c.damage_projectile_add - 0.4

	-- 							local dmg_comp = EntityGetFirstComponent( GetUpdatedEntityID(), "DamageModelComponent" )
	-- 							local hp = ComponentGetValue2( dmg_comp, "hp" )
	-- 							local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
	-- 							if hp > max_hp - 0.04 then
	-- 								c.damage_projectile_add = c.damage_projectile_add + 0.4
	-- 							end

	-- 		                    draw_actions( 1, true )
	-- 	                    end,
	-- },

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

	{
		id          		= "D2D_CHARMING_ARROW",
		name 				= "$spell_d2d_charming_arrow_name",
		description 		= "$spell_d2d_charming_arrow_desc",
		sprite 				= "mods/D2DContentPack/files/gfx/ui_gfx/spells/charming_arrow.png",
		related_projectiles	= { "mods/D2DContentPack/files/entities/projectiles/charming_arrow.xml" },
		type 				= ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,4,5",
		spawn_probability	= "0.4,0.5,0.7,0.8",
		price 				= 270,
		mana 				= 50,
		max_uses 			= 3,
		never_unlimited		= true,
		action 				= function()
			c.fire_rate_wait = c.fire_rate_wait + 50
			c.spread_degrees = c.spread_degrees + 12

			if reflecting then return end
			add_projectile( "mods/D2DContentPack/files/entities/projectiles/charming_arrow.xml" )
		end,
	},

    {
	    id                  = "D2D_COMMAND_ATTACK",
	    name 		        = "$spell_d2d_command_attack_name",
	    description         = "$spell_d2d_command_attack_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/command_attack.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2",
		spawn_probability   = "0.4,0.6,0.8",
	    price               = 190,
	    mana                = 40,
	    action              = function()
	 							add_projectile( "mods/D2DContentPack/files/entities/projectiles/command_attack_targetter.xml" )
	 						end
    },

    {
	    id                  = "D2D_COMMAND_WARP",
	    name 		        = "$spell_d2d_command_warp_name",
	    description         = "$spell_d2d_command_warp_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/command_warp.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2",
		spawn_probability   = "0.4,0.6,0.8",
	    price               = 190,
	    mana                = 40,
        custom_xml_file     = "mods/D2DContentPack/files/entities/misc/custom_cards/card_command_warp.xml",
	    action              = function()
	 							add_projectile( "mods/D2DContentPack/files/entities/projectiles/command_warp_targetter.xml" )
	 						end
    },

	{
		id                  = "D2D_GLASS_SHARD",
		name 		        = "$spell_d2d_glass_shard_name",
		description         = "$spell_d2d_glass_shard_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/glass_shard.png",
		related_projectiles	= {"mods/D2DContentPack/files/entities/projectiles/glass_shard.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3", -- LIGHT_BULLET_TRIGGER
		spawn_probability   = "1,0.7,0.6,0.5", -- LIGHT_BULLET_TRIGGER
		price               = 90,
		mana                = 5,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait - 1
			                    c.spread_degrees = c.spread_degrees + 6
			                    add_projectile( "mods/D2DContentPack/files/entities/projectiles/glass_shard.xml" )
		                    end,
	},

	{
		id                  = "D2D_ECHO_SHOT",
		name 		        = "$spell_d2d_echo_shot_name",
		description         = "$spell_d2d_echo_shot_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/echo_shot.png",
		related_projectiles	= { "mods/D2DContentPack/files/entities/projectiles/echo_shot.xml" },
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4",
		spawn_probability   = "0.4,0.6,0.8,1,1",
		price               = 130,
		mana                = 23,
		action 		        = function()
								c.fire_rate_wait = c.fire_rate_wait + 7
								c.screenshake = c.screenshake + 1
								shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0

			                    add_projectile( "mods/D2DContentPack/files/entities/projectiles/echo_shot.xml" )
		                    end,
	},

	{
		id                  = "D2D_PRISMATIC_SHOT",
		name 		        = "$spell_d2d_prismatic_shot_name",
		description         = "$spell_d2d_prismatic_shot_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/prismatic_shot.png",
		type 		        = ACTION_TYPE_PROJECTILE,
		recursive			= true,
		spawn_level         = "1,2,3,4,5", -- BULLET
		spawn_probability   = "0.5,0.8,1,1,1", -- inverse of BULLET
		price               = 250,
		mana                = 5,
		action 		        = function()
								-- c.fire_rate_wait = c.fire_rate_wait + 3
								if reflecting then return end

								dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
								local children = EntityGetAllChildren( get_player() )
								local success = false
								for k=1,#children do
									child = children[k]
								    if EntityGetName( child ) == "inventory_full" then
								        local inventory_items = EntityGetAllChildren(child)
								        if( inventory_items ~= nil ) then
								            for z=1, #inventory_items do
								            	item = inventory_items[z]

								            	local ia_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemActionComponent" )
								            	if ia_comp then
								            		local action_id = ComponentGetValue2( ia_comp, "action_id" )
								            		local data = get_actions_lua_data( action_id )
								            		local item_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemComponent" )
								            		local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
													if not data.recursive and data.type == 0 and uses_remaining ~= 0 then
														local rec = check_recursion( data, recursion_level )
														if rec > -1 then
															data.action( rec )
															mana = mana - data.mana
															if uses_remaining > 0 then
																ComponentSetValue2( item_comp, "uses_remaining", uses_remaining - 1 )
															end
															success = true
															break
														end
								            		end
								            	end
								            end
								        end
								    end
								end

								if not success then
			                    	add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/ghost_trigger_bullet.xml" )
								end
		                    end,
	},

	{
	    id                  = "D2D_BLUE_MAGIC",
	    name 		        = "$spell_d2d_blue_magic_name",
	    description         = "$spell_d2d_blue_magic_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/blue_magic.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "5,6,10",
		spawn_probability   = "0.4,0.6,1",
		spawn_requires_flag	= "d2d_staff_of_curses_obtained",
	    price               = 150,
	    mana                = 20,
	    -- max_uses			= 10,
	    -- custom_uses_logic	= true,
	    action              = function()
	    						c.fire_rate_wait = c.fire_rate_wait + 15

                                if reflecting then return end
                                dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

								local action = hand[#hand]
								if action.id ~= "D2D_BLUE_MAGIC" then
									c.damage_projectile_add = c.damage_projectile_add + 0.04
			                    	add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/ghost_trigger_bullet.xml" )
			                    	mana = mana + 15
									return
								end
								local action_entity = find_action_entity( action )
								if not action_entity then
									c.damage_projectile_add = c.damage_projectile_add + 0.04
			                    	add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/ghost_trigger_bullet.xml" )
			                    	mana = mana + 15
									return
								end

                                local proj_file = get_internal_string( action_entity, "d2d_blue_magic_projectile_file" )
                                if exists( proj_file ) and proj_file ~= "" then
                                	add_projectile( proj_file )

                                	-- local cast_delay = get_internal_int( action_entity, "d2d_blue_magic_cast_delay" )
                                	-- if exists( cast_delay ) then
	                                -- 	c.fire_rate_wait = c.fire_rate_wait + ( cast_delay * 0.25 )
	                                -- end

				            		local item_comp = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemComponent" )
				            		if exists( item_comp ) then
				            			local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
				            			-- if uses_remaining > 0 then
											-- ComponentSetValue2( item_comp, "uses_remaining", uses_remaining - 1 )
										-- end
										if uses_remaining == 0 then
	                                		set_internal_string( action_entity, "d2d_blue_magic_projectile_file", "" )
									        ComponentSetValue2( item_comp, "item_name", GameTextGetTranslatedOrNot( "$spell_d2d_blue_magic_name" ) )
									        ComponentSetValue2( item_comp, "always_use_item_name_in_ui", true )

									        -- play last use effects
									        -- local x, y = EntityGetTransform( get_player() )
					                        -- GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
					                        -- EntityLoad( "mods/D2DContentPack/files/particles/fade_blue_magic.xml", x, y )
	                                	end
                                	end
                                else
									c.damage_projectile_add = c.damage_projectile_add + 0.04
			                    	add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/ghost_trigger_bullet.xml" )
			                    	mana = mana + 15
                                end
	                        end,
	},

	-- {
	-- 	id          		= "D2D_POLY_DYNAMIC",
	-- 	name 				= "$spell_d2d_poly_dynamic_name",
	-- 	description 		= "$spell_d2d_poly_dynamic_desc",
	-- 	sprite 				= "mods/D2DContentPack/files/gfx/ui_gfx/spells/poly_dynamic.png",
	-- 	related_projectiles	= { "mods/D2DContentPack/files/entities/projectiles/orb_poly_dynamic.xml" },
	-- 	type 				= ACTION_TYPE_PROJECTILE,
	-- 	spawn_level         = "1,2,4,5",
	-- 	spawn_probability	= "0.4,0.5,0.7,0.8",
	-- 	price 				= 270,
	-- 	mana 				= 50,
	-- 	-- max_uses 			= 5,
	-- 	-- never_unlimited		= true,
	-- 	action 				= function()
	-- 		c.fire_rate_wait = c.fire_rate_wait + 50
	-- 		c.spread_degrees = c.spread_degrees + 12

	-- 		if reflecting then return end
	-- 		add_projectile( "mods/D2DContentPack/files/entities/projectiles/orb_poly_dynamic.xml" )
	-- 	end,
	-- },

    {
	    id                  = "D2D_UNSTABLE_NUCLEUS",
	    name 		        = "$spell_d2d_unstable_nucleus_name",
	    description         = "$spell_d2d_unstable_nucleus_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/unstable_nucleus.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0", -- only spawns on the Wand of Destruction
		spawn_probability   = "0", -- only spawns on the Wand of Destruction
		spawn_requires_flag	= "d2d_impossible_spawn",
	    price               = 480,
	    mana                = 100,
	    -- max_uses			= 3,
	    -- custom_uses_logic	= true,
        custom_xml_file     = "mods/D2DContentPack/files/entities/misc/custom_cards/card_unstable_nucleus.xml",
	    action              = function()
                                if reflecting then return end

                                dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
                                local nucleus = EntityGetWithTag( "d2d_unstable_nucleus" )
                                if exists( nucleus ) and #nucleus > 0 then
                                	-- trigger the effect of Wand Refresh
									for i,v in ipairs( hand ) do
										table.insert( discarded, v )
									end
									for i,v in ipairs( deck ) do
										table.insert( discarded, v )
									end
									hand = {}
									deck = {}
									if not force_stop_draws then
										force_stop_draws = true
										move_discarded_to_deck()
										order_deck()
									end

                                	-- shoot charging "projectile"
                                	-- draw_actions( 1, true )
                                	mana = mana + 100
                                else
                                	add_projectile("mods/D2DContentPack/files/entities/projectiles/unstable_nucleus.xml")
                                	c.fire_rate_wait    = c.fire_rate_wait + 160

									-- local action_entity = find_action_entity( hand[#hand] )
									-- if action_entity then
					            	-- 	local item_comp = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemComponent" )
					            	-- 	if exists( item_comp ) then
									-- 	    uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
									--         ComponentSetValue2( item_comp, "uses_remaining", uses_remaining - 1 )
									--         if ( uses_remaining == 1 ) then
									-- 			local x, y = EntityGetTransform( get_player() )
									--             GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
									--             EntityLoad("mods/D2DContentPack/files/particles/fade_unstable_nucleus.xml", x, y )
		                            --     	end
		                            --     end
	                                -- end
                                end
	                        end,
    },

	{
		id                  = "D2D_DEATH_RAY",
		name 		        = "$spell_d2d_death_ray_name",
		description         = "$spell_d2d_death_ray_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/death_ray.png",
		related_projectiles	= {"mods/D2DContentPack/files/entities/projectiles/death_ray.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "6,10",
		spawn_probability   = "0.1,0.5",
		spawn_requires_flag = "d2d_staff_of_obliteration_obtained",
		price               = 690,
		mana                = 99,
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait - 22
			                    c.spread_degrees = c.spread_degrees - 12
								shot_effects.recoil_knockback	= shot_effects.recoil_knockback + 10

								c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
								c.extra_entities    = c.extra_entities .. "mods/D2DContentPack/files/particles/deathray_spark.xml,"

			                    add_projectile( "mods/D2DContentPack/files/entities/projectiles/death_ray.xml" )
		                    end,
	},

    {
	    id                  = "D2D_GIGA_DRAIN",
	    name 		        = "$spell_d2d_giga_drain_name",
	    description         = "$spell_d2d_giga_drain_desc",
        inject_after        = { "CHAINSAW" },
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/giga_drain.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4", -- spawning it in The Vault does not make sense
		spawn_probability   = "0.5,0.8,1,1.1,1",
	    price               = 150,
	    mana                = 60,
	    action              = function()
		                        c.fire_rate_wait = current_reload_time + 8
		                        current_reload_time = current_reload_time + 20
								shot_effects.recoil_knockback	= shot_effects.recoil_knockback + 50

                                add_projectile( "mods/D2DContentPack/files/entities/projectiles/giga_drain_bullet.xml" )
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
	    id                  = "D2D_CIRCLE_OF_TINKERING",
	    name 		        = "$spell_d2d_circle_of_tinkering_name",
	    description         = "$spell_d2d_circle_of_tinkering_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/circle_of_tinkering.png",
	    type 		        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "5,6,10",
		spawn_probability   = "0.4,0.6,1",
	    price               = 200,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
		destroyed_on_use	= true,
	    action              = function()
								c.fire_rate_wait = c.fire_rate_wait + 15

	    						if reflecting then return end

								local action = hand[#hand]
								if action.id == "D2D_CIRCLE_OF_TINKERING" then
									local action_entity = find_action_entity( action )
									if action_entity then
			    						-- spawn a permanent circle of tinkering
			    						local x, y = EntityGetTransform( GetUpdatedEntityID() )
										EntityLoad( "mods/D2DContentPack/files/entities/misc/wand_tinkering_aura.xml", x, y )

										-- ...then destroy this spell as a sacrifice
										EntityKill( action_entity )
										EntityLoad("mods/D2DContentPack/files/particles/fade_circle_of_tinkering.xml", x, y )
										GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
										GamePrint( "The \"Circle of Tinkering\" spell was consumed" )
									end
								end
	                        end,
    },

    {
	    id                  = "D2D_SUMMON_BEACON",
	    name 		        = "$spell_d2d_summon_beacon_name",
	    description         = "$spell_d2d_summon_beacon_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/summon_beacon.png",
	    type 		        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.5,0.6,0.7,0.8,0.9,1",
		only_if_mod_disabled= "d2d_beacons",
	    price               = 200,
	    mana                = 50,
	    max_uses			= 10,
	    action              = function()
	    						c.fire_rate_wait = c.fire_rate_wait + 40
	    						current_reload_time = current_reload_time + 40

	    						if reflecting then return end

                                dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
                                local radar_id = get_internal_int( GetUpdatedEntityID(), "beacon_radar_id" )
                                if not radar_id or radar_id == 0 then
									radar_id = EntityAddComponent2( GetUpdatedEntityID(), "LuaComponent", 
									{ 
										script_source_file = "mods/D2DContentPack/files/scripts/projectiles/beacon_radar.lua",
										execute_every_n_frame = 1,
									} )
									set_internal_int( GetUpdatedEntityID(), "beacon_radar_id", radar_id )
                                end

                                add_projectile( "mods/D2DContentPack/files/entities/projectiles/beacon.xml" )
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
								c.damage_projectile_add = c.damage_projectile_add + 0.12

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

									if copies >= 2 then
										-- cool muzzle
										dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
										local x, y = EntityGetTransform( EZWand.GetHeldWand().entity_id )
										EntityLoadAtWandTip( GetUpdatedEntityID(), "mods/D2DContentPack/files/particles/muzzle_flashes/muzzle_flash_laser_death_ray.xml" )
										-- GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/chain_bolt/create", x, y )
									end

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
		spawn_level         = "2,3,4,5,6,10",
		spawn_probability   = "0.05,0.1,0.2,0.3,0.4,0.5",
        spawn_requires_flag	= "d2d_time_trial_bronze",
	    price               = 800,
        mana 				= 200,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 60
	    						if reflecting then return end
	    						
	                            -- spawn the "projectile"
	    						add_projectile( "mods/D2DContentPack/files/entities/projectiles/deck/blink.xml" )

	                            -- deal max health damage (cannot kill)
								local p_dcomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "DamageModelComponent" )
								local p_hp = ComponentGetValue2( p_dcomp, "hp" )
								local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
	                            dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
								local mtp = determine_blink_dmg_mtp()
	                            EntityInflictDamage( GetUpdatedEntityID(), math.min( p_max_hp * mtp, p_hp - 0.04 ), "DAMAGE_SLICE", "blood price", "NONE", 0, 0, GetUpdatedEntityID(), x, y, 0)
	                        end,
    },

    {
	    id                  = "D2D_BLINK_MID_FIRE",
	    name 		        = "$spell_d2d_blink_mid_fire_name",
	    description         = "$spell_d2d_blink_mid_fire_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/blink_mid_fire.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0", -- should only spawn on the Staff of Time
		spawn_probability   = "0", -- should only spawn on the Staff of Time
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_blink_mid_fire.xml",
        price 				= 800,
        mana 				= 200,
	    action              = function()
	    						draw_actions( 1, true )
	    						
	    						if reflecting then return end

            					-- only restore mana if this spell is NOT an always-cast
	    						dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    						if not held_wand_contains_always_cast( GetUpdatedEntityID(), "D2D_BLINK_MID_FIRE" ) then
	            					mana = mana + 200
	            				end

	    						if not GameHasFlagRun( "d2d_mid_fire_key_rebind_explained" ) then
	    							dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    							GamePrintDelayed( "[D2D] By default, 'Mid Fire Blink' is cast with the middle mouse button", 60 )
	    							GamePrintDelayed( "[D2D] You can change this keybind in the mod's settings", 180 )
	    							GameAddFlagRun( "d2d_mid_fire_key_rebind_explained" )
	    						end
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

    -- {
	--     id                  = "D2D_COOKIE",
	--     name 		        = "Cookie",
	--     description         = "Scrumptious! Restores 10% of your missing health (max. 20)",
	--     sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/cookie.png",
	--     type 		        = ACTION_TYPE_UTILITY,
	-- 	spawn_level         = "0,1,2,3",
	-- 	spawn_probability   = "1,0.8,0.6,0.4",
	--     price               = 250,
	--     mana                = 20,
	--     max_uses			= 5,
	--     never_unlimited		= true,
	--     action              = function()
	-- 							c.fire_rate_wait = c.fire_rate_wait + 60

    --                             if reflecting then return end
    --                             dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

	-- 							-- heal the player
	-- 							local p_dcomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "DamageModelComponent" )
	-- 							local p_hp = ComponentGetValue2( p_dcomp, "hp" )
	-- 							local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
	-- 							ComponentSetValue2( p_dcomp, "hp", p_hp + math.min( ( p_max_hp - p_hp ) * 0.1, 0.8 ) )

	-- 							-- play sound effect
	-- 							local x, y = EntityGetTransform( GetUpdatedEntityID() )
	-- 							GamePlaySound( "data/audio/Desktop/animals.bank", "animals/generic/attack_bite", x, y )
	-- 							GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )

	-- 							-- gfx effect
	-- 							local entity_fx = EntityLoad( "data/entities/particles/heal_effect.xml", x, y )
	-- 							EntityAddChild( GetUpdatedEntityID(), entity_fx )

	-- 							-- fill the player's stomach a bit
	-- 							local ing_comp = EntityGetFirstComponent( GetUpdatedEntityID(), "IngestionComponent" )
	-- 							if exists( ing_comp ) then
	-- 								local old_size = ComponentGetValue2( ing_comp, "ingestion_size" )
	-- 								ComponentSetValue2( ing_comp, "ingestion_size", old_size + 375 )
	-- 							end

	-- 							-- if there are no charges left, destroy the first copy of Cookie in hand
	-- 							for i,card in ipairs( hand ) do
	-- 								if card.id == "D2D_COOKIE" and card.uses_remaining == 1 then
	-- 									local EZWand = dofile_once( "mods/D2DContentPack/files/scripts/lib/ezwand.lua" )
	-- 									EZWand.GetHeldWand():RemoveSpells( "D2D_COOKIE" )
	-- 									break
	-- 								end
	-- 							end
	--                         end,
    -- },

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
			                    draw_actions( 1, true )
	                        end,
    },

    -- {
	--     id                  = "D2D_PASSIVE_MANA_CHARGE",
	--     name 		        = "$spell_d2d_passive_mana_charge_name",
	--     description         = "$spell_d2d_passive_mana_charge_desc",
	--     sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/passive_mana_charge.png",
	--     type 		        = ACTION_TYPE_PASSIVE,
	-- 	spawn_level         = "0,1,2,3,4,5,6",
	-- 	spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
	-- 	custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_passive_mana_charge.xml",
	--     price               = 80,
	--     mana                = 0,
	--     action              = function()
	-- 		                    draw_actions( 1, true )
	--                         end,
    -- },

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
		type 		        = ACTION_TYPE_PASSIVE, -- TODO: Test if this works decently
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
		id                  = "D2D_RELOAD_SHIELD",
		name 		        = "$spell_d2d_reload_shield_name",
		description         = "$spell_d2d_reload_shield_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/reload_shield.png",
		type 		        = ACTION_TYPE_PASSIVE, -- TODO: Test if this works decently
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.05,0.4,0.8,0.4,0.4,0.6",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_reload_shield.xml",
		price               = 280,
		mana                = 10,
		action 		        = function()
								current_reload_time = current_reload_time + 15
								draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_MANA_LOCK",
		name 		        = "$spell_d2d_mana_lock_name",
		description         = "$spell_d2d_mana_lock_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/mana_lock.png",
		type 		        = ACTION_TYPE_OTHER,
		-- spawn_level         = "1,2,3,4,5,6,10",
		-- spawn_probability   = "0.3,0.5,0.7,0.9,1.1,1,1",
		spawn_level         = "0",
		spawn_probability   = "0",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_mana_lock.xml",
		price               = 280,
		mana                = 0,
		action 		        = function()
	    						if reflecting then return end
	    						GamePrint( "[D2D] The 'Mana Lock' spell is currently out of order; please come back later." )

								-- SCANNING 'hand' HERE DOESN'T MAKE SENSE IF IT'S A PASSIVE SPELL

								-- local mana_init = mana
								-- draw_actions( 1, true )

								-- local total_mana_cost = mana_init - mana
								-- if total_mana_cost > 0 then
								-- 	-- local refund = total_mana_cost * 0.9
								-- 	local reduced_cost = total_mana_cost * 0.1
								-- 	mana = mana_init - reduced_cost
								-- end
		                    end,
	},

    -- {
	--     id                  = "D2D_BLINK_MID_FIRE",
	--     name 		        = "$spell_d2d_blink_name",
	--     description         = "$spell_d2d_blink_desc",
	--     sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/mid_fire_blink.png",
	--     type 		        = ACTION_TYPE_PASSIVE,
    --     subtype     		= { altfire = true },
	-- 	spawn_level         = "0",
	-- 	spawn_probability   = "0",
	-- 	custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_mid_fire_blink.xml",
	--     price               = 300,
	--     mana                = 80,
	--     max_uses			= 10,
	--     never_unlimited		= true,
	--     action              = function()	    						
	--     						draw_actions( 1, true )
    --         					mana = mana + 20
	--                         end,
    -- },

	{
		id                  = "D2D_RECYCLE",
		name 		        = "$spell_d2d_recycle_name",
		description         = "$spell_d2d_recycle_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/recycle.png",
		type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0,1,2,3,4,5",
		spawn_probability   = "0.5,1,0.8,0.6,0.4,0.2",
		price               = 200,
		mana                = 20,
		action 		        = function()
								if reflecting then return end

								local next_card = deck[1]
								if next_card and next_card.uses_remaining > 0 then

									-- prevent the spell from gaining more uses than it had
									local next_card_init_uses = next_card.uses_remaining

									-- draw the spell
									draw_actions( 1, true )

									-- 1/4 chance to save a charge

									-- determine chance
									local save_chance = 50
									if next_card.never_unlimited then save_chance = 25 end

									if Random( 1, 100 ) < save_chance then
										next_card.uses_remaining = math.min( next_card.uses_remaining + 1, next_card_init_uses + 1 )

										local x, y = EntityGetTransform( GetUpdatedEntityID() )
										GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
									end

									-- if Random( 1, 4 ) == 4 then
									-- 	next_card.uses_remaining = math.min( next_card.uses_remaining + 1, next_card_init_uses + 1 )
									-- end
								end
		                    end,
	},

	{
		id                  = "D2D_RECYCLE_PLUS",
		name 		        = "$spell_d2d_recycle_plus_name",
		description         = "$spell_d2d_recycle_plus_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/recycle_plus.png",
		type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "5,6,10",
		spawn_probability   = "0.2,0.3,1",
		spawn_requires_flag	= "d2d_ancient_lurker_defeated",
		price               = 400,
		mana                = 40,
		action 		        = function()
								c.fire_rate_wait = c.fire_rate_wait + 15

								if reflecting then return end

								local next_card = deck[1]
								if next_card and next_card.uses_remaining > 0 then

									-- prevent the spell from gaining more uses than it had
									local next_card_init_uses = next_card.uses_remaining

									-- draw the spell
									draw_actions( 1, true )

									-- determine chance
									local save_chance = 90
									if next_card.never_unlimited then save_chance = 75 end

									if Random( 1, 100 ) < save_chance then
										next_card.uses_remaining = math.min( next_card.uses_remaining + 1, next_card_init_uses + 1 )
									end
								end
		                    end,
	},

	{
		id                  = "D2D_INDULGENCE_ALT_FIRE",
		name 		        = "$spell_d2d_indulgence_alt_fire_name",
		description         = "$spell_d2d_indulgence_alt_fire_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/indulgence_alt_fire.png",
		type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "1,2,3,4,5,6,10",
		spawn_probability   = "0.2,0.2,0.4,0.4,0.6,0.6,1",
		spawn_requires_flag	= "d2d_indulgence_unlocked",
		custom_xml_file		= "mods/D2DContentPack/files/entities/misc/custom_cards/card_indulgence_alt_fire.xml",
		price               = 1000,
		mana                = 0,
		action 		        = function()
								draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_AUTO_RELOAD",
		name 		        = "$spell_d2d_auto_reload_name",
		description         = "$spell_d2d_auto_reload_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/auto_reload.png",
		type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file		= "mods/D2DContentPack/files/entities/misc/custom_cards/card_auto_reload.xml",
		price               = 150,
		mana                = 0,
		action 		        = function()
								draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_RESTART_POINT",
		name 		        = "$spell_d2d_restart_point_name",
		description         = "$spell_d2d_restart_point_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/restart_point.png",
		type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file		= "mods/D2DContentPack/files/entities/misc/custom_cards/card_restart_point.xml",
		price               = 150,
		mana                = 10,
		action 		        = function()
								if reflecting then return end

								if GlobalsGetValue( "D2D_RESTART_POINT_ACTIVE", "0" ) == "0" and #deck > 0 then
									for i=1, #discarded do
										table.remove( discarded, 1 )
									end
									GlobalsSetValue( "D2D_RESTART_POINT_ACTIVE", "1" )
								end

								draw_actions( 1, true )
		                    end,
	},

	{
		id                  = "D2D_SECOND_WIND",
		name 		        = "$spell_d2d_second_wind_name",
		description         = "$spell_d2d_second_wind_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/second_wind.png",
		type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0,1,2,3,4,10",
		spawn_probability   = "0.3,0.5,0.4,0.3,0.2,0.5",
		price               = 200,
		mana                = 0,
		action 		        = function()
								if reflecting then return end
								dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

								local action = hand[#hand]
								if action.id == "D2D_SECOND_WIND" then
									local action_entity = find_action_entity( action )
									if action_entity then
										-- draw the next spell
										draw_actions( 1, true )

										if #hand >= 2 then
											local next_limited_use_spell = nil
											for i,card in ipairs( hand ) do
												local _data = get_actions_lua_data( card.id )
												if _data.max_uses and _data.max_uses > -1 then
													next_limited_use_spell = card
													break
												end
											end

											-- if the next spell is destroyed on use, do nothing
											if next_limited_use_spell.id == "D2D_CIRCLE_OF_TINKERING" then
												return
											end

											-- if the next spell is limited-use, refill it
											if next_limited_use_spell and next_limited_use_spell.uses_remaining == 1 then
												local action_lua_data = get_actions_lua_data( next_limited_use_spell.id )

												local x, y = EntityGetTransform( GetUpdatedEntityID() )
												next_limited_use_spell.uses_remaining = action_lua_data.max_uses + 1

												-- ...then destroy this spell as a sacrifice
												EntityKill( action_entity )
												EntityLoad("mods/D2DContentPack/files/particles/fade_second_wind.xml", x, y )
												GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
												GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/spell_refresh/create", x, y )
												GamePrint( "\"Second Wind\" was sacrificed to refill \"" .. GameTextGetTranslatedOrNot( action_lua_data.name ) .. "\"" )
											end
										end
									end
								end
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
		id                  = "D2D_PRISM",
		name 		        = "$spell_d2d_prism_name",
		description         = "$spell_d2d_prism_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/prism.png",
		type 		        = ACTION_TYPE_OTHER,
		recursive			= true,
		spawn_level         = "2,3,4,10",
		spawn_probability   = "0.2,0.4,1,1",
		price               = 300,
		mana                = 20,
		action 		        = function()
								-- c.fire_rate_wait = c.fire_rate_wait + 15
								if reflecting then return end

								dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
								local children = EntityGetAllChildren( get_player() )
								for k=1,#children do
									child = children[k]
								    if EntityGetName( child ) == "inventory_full" then
								        local inventory_items = EntityGetAllChildren(child)
								        if( inventory_items ~= nil ) then
								            for z=1, #inventory_items do
								            	local index = #inventory_items+1-z -- start at the end
								            	if index > 0 then
									            	item = inventory_items[index]

									            	local ia_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemActionComponent" )
									            	if ia_comp then
									            		local action_id = ComponentGetValue2( ia_comp, "action_id" )
									            		local data = get_actions_lua_data( action_id )
									            		local item_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemComponent" )
									            		local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
														if not data.recursive and uses_remaining ~= 0 then
															local rec = check_recursion( data, recursion_level )
															if ( data ~= nil ) and ( rec > -1 ) then
																data.action( rec )
																mana = mana - data.mana
																if uses_remaining > 0 then
																	ComponentSetValue2( item_comp, "uses_remaining", uses_remaining - 1 )
																end
																success = true
																break
															end
									            		end
										            end
										        end
								            end
								        end
								    end
								end
		                    end,
	},

	{
		id                  = "D2D_DELTA",
		name 		        = "$spell_d2d_delta_name",
		description         = "$spell_d2d_delta_desc",
		sprite              = "mods/D2DContentPack/files/gfx/ui_gfx/spells/delta.png",
		type 		        = ACTION_TYPE_OTHER,
		recursive			= true,
		spawn_level         = "5,6,10", -- ALPHA
		spawn_probability   = "0.1,0.2,1", -- ALPHA
		spawn_requires_flag = "card_unlocked_duplicate",
		price               = 600,
		mana                = 80,
		action 		        = function()
								c.fire_rate_wait = c.fire_rate_wait + 15
								if reflecting then return end

								dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
								local children = EntityGetAllChildren( get_player() )
								for k=1,#children do
									child = children[k]
								    if EntityGetName( child ) == "inventory_full" then
								        local inventory_items = EntityGetAllChildren(child)
								        if( inventory_items ~= nil ) then
								            for z=1, #inventory_items do
								            	local index = #inventory_items+1-z -- start at the end
								            	if index > 0 then
									            	item = inventory_items[index]

									            	local ia_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemActionComponent" )
									            	if ia_comp then
									            		local action_id = ComponentGetValue2( ia_comp, "action_id" )
									            		local data = get_actions_lua_data( action_id )
														local rec = check_recursion( data, recursion_level )
														if exists( data ) and not data.recursive and rec > -1 then
															data.action( rec )
															break
														end
									            	end
									            end
								            end
								        end
								    end
								end
		                    end,
	},

    {
	    id                  = "D2D_UPGRADE_CAPACITY",
	    name 		        = "$spell_d2d_upgrade_capacity_name",
	    description         = "$spell_d2d_upgrade_capacity_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/upgrade_capacity.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_upgrade_capacity.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },

    {
	    id                  = "D2D_UPGRADE_FIRE_RATE",
	    name 		        = "$spell_d2d_upgrade_fire_rate_name",
	    description         = "$spell_d2d_upgrade_fire_rate_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/upgrade_fire_rate.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_upgrade_fire_rate.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },

    {
	    id                  = "D2D_UPGRADE_MAX_MANA",
	    name 		        = "$spell_d2d_upgrade_max_mana_name",
	    description         = "$spell_d2d_upgrade_max_mana_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/upgrade_max_mana.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_upgrade_max_mana.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },

    {
	    id                  = "D2D_UPGRADE_MANA_CHARGE_SPEED",
	    name 		        = "$spell_d2d_upgrade_mana_charge_speed_name",
	    description         = "$spell_d2d_upgrade_mana_charge_speed_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/upgrade_mana_charge_speed.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_upgrade_mana_charge_speed.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },

    {
	    id                  = "D2D_UPGRADE_SHUFFLE",
	    name 		        = "$spell_d2d_upgrade_shuffle_name",
	    description         = "$spell_d2d_upgrade_shuffle_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/upgrade_shuffle.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_upgrade_shuffle.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },

    {
	    id                  = "D2D_UPGRADE_REMOVE_ALWAYS_CAST",
	    name 		        = "$spell_d2d_upgrade_remove_always_cast_name",
	    description         = "$spell_d2d_upgrade_remove_always_cast_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/upgrade_remove_always_cast.png",
	    type 		        = ACTION_TYPE_OTHER,
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_upgrade_remove_always_cast.xml",
	    price               = 100,
	    mana                = 0,
	    max_uses			= 1,
	    custom_uses_logic	= true,
	    action              = function()
	    						-- do nothing here
	                        end,	
    },

    {
	    id                  = "D2D_ANIMATE_WAND_MID_FIRE",
	    name 		        = "$spell_d2d_animate_wand_mid_fire_name",
	    description         = "$spell_d2d_animate_wand_mid_fire_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/animate_wand_mid_fire.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0", -- should only spawn on the Staff of Loyalty
		spawn_probability   = "0", -- should only spawn on the Staff of Loyalty
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_animate_wand_mid_fire.xml",
        price 				= 500,
        mana 				= 0,
	    action              = function()
	    						draw_actions( 1, true )
            					mana = mana + 0

	    						if reflecting then return end

	    						if not GameHasFlagRun( "d2d_mid_fire_key_rebind_explained" ) then
	    							dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    							GamePrintDelayed( "[D2D] By default, 'Animate / Recall' is cast with the middle mouse button", 60 )
	    							GamePrintDelayed( "[D2D] You can change this keybind in the mod's settings", 180 )
	    							GameAddFlagRun( "d2d_mid_fire_key_rebind_explained" )
	    						end
	                        end,
    },

    {
	    id                  = "D2D_HOME_TELEPORT_MID_FIRE",
	    name 		        = "$spell_d2d_home_teleport_mid_fire_name",
	    description         = "$spell_d2d_home_teleport_mid_fire_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/home_teleport_mid_fire.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0", -- should only spawn on the Staff of Loyalty
		spawn_probability   = "0", -- should only spawn on the Staff of Loyalty
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_home_teleport_mid_fire.xml",
        price 				= 500,
        mana 				= 0,
	    action              = function()
	    						draw_actions( 1, true )

	    						if reflecting then return end

	    						if not GameHasFlagRun( "d2d_mid_fire_key_rebind_explained" ) then
	    							dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    							GamePrintDelayed( "[D2D] By default, 'Home Teleport' is cast with the middle mouse button", 60 )
	    							GamePrintDelayed( "[D2D] You can change this keybind in the mod's settings", 180 )
	    							GameAddFlagRun( "d2d_mid_fire_key_rebind_explained" )
	    						end
	                        end,
    },

    -- {
	--     id                  = "D2D_UPGRADE_RESET_SPELLS_PER_CAST",
	--     name 		        = "$spell_d2d_upgrade_reset_spells_per_cast_name",
	--     description         = "$spell_d2d_upgrade_reset_spells_per_cast_desc",
	--     sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/upgrade_reset_spells_per_cast.png",
	--     type 		        = ACTION_TYPE_OTHER,
	-- 	spawn_level         = "0",
	-- 	spawn_probability   = "0",
	-- 	custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_upgrade_reset_spells_per_cast.xml",
	--     price               = 490,
	--     mana                = 0,
	--     max_uses			= 1,
	--     custom_uses_logic	= true,
	--     action              = function()
	--     						-- do nothing here
	--                         end,	
    -- },

    {
	    id                  = "D2D_CATS_TO_DAMAGE",
	    name 		        = "$spell_d2d_cats_to_damage_name",
	    description         = "$spell_d2d_cats_to_damage_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/cats_to_damage.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0", -- never spawns in the world
		spawn_probability   = "0", -- never spawns in the world
		spawn_requires_flag = "d2d_impossible_spawn",
		only_if_mod_enabled = "Apotheosis",
	    price               = 400,
	    mana                = 5,
	    action              = function()
								c.fire_rate_wait		= c.fire_rate_wait + 5
								c.damage_projectile_add = c.damage_projectile_add + 0.04 -- for the tooltip
								if reflecting then return end
								c.damage_projectile_add = c.damage_projectile_add - 0.04 -- reset

								dofile_once( "data/scripts/lib/utilities.lua" )
					            local cats_petted = get_internal_int( GetUpdatedEntityID(), "cats_petted", 1 )
					            c.damage_projectile_add = c.damage_projectile_add + ( 0.04 * cats_petted )

	    						draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "D2D_ALT_FIRE_ANYTHING",
	    name 		        = "$spell_d2d_alt_fire_anything_name",
	    description         = "$spell_d2d_alt_fire_anything_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/alt_fire_anything.png",
	    type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "1,2,3,4,5,6,10",
		spawn_probability   = "0.2,0.4,0.6,0.8,1,1,1",
		only_if_mod_disabled= "alt_fire_anything",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_anything.xml",
	    price               = 400,
	    mana                = 0,
		action 				= function()
								while #deck > 0 do
									local data = deck[1]
									---@diagnostic disable-next-line: inject-field
									data.in_fake_hand = true
									table.insert(hand, data)
									table.remove(deck, 1)
								end
								draw_actions(1, true)
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
	    max_uses			= 10,
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

	    						if reflecting then return end

            					-- only restore mana if this spell is NOT an always-cast
	    						dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    						if not held_wand_contains_always_cast( GetUpdatedEntityID(), "D2D_CONCRETE_WALL_ALT_FIRE" ) then
        							mana = mana + 80
	            				end
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

	    						if reflecting then return end

            					-- only restore mana if this spell is NOT an always-cast
	    						dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    						if not held_wand_contains_always_cast( GetUpdatedEntityID(), "D2D_BOLT_CATCHER_ALT_FIRE" ) then
        							mana = mana + 30
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
		spawn_level         = "0,1,2,3,4,5,6", -- TELEPORT_PROJECTILE_STATIC
		spawn_probability   = "0.6,0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE_STATIC
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_alt_fire_rewind.xml",
	    price               = 90,
	    mana                = 40,
	    action              = function()
	    						draw_actions( 1, true )

	    						if reflecting then return end

            					-- only restore mana if this spell is NOT an always-cast
	    						dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    						if not held_wand_contains_always_cast( GetUpdatedEntityID(), "D2D_REWIND_ALT_FIRE" ) then
        							mana = mana + 40
	            				end
	                        end,	
    },

    {
	    id                  = "D2D_DISMANTLE_MID_FIRE",
	    name 		        = "$spell_d2d_dismantle_mid_fire_name",
	    description         = "$spell_d2d_dismantle_mid_fire_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/dismantle_mid_fire.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0",
		spawn_probability   = "0",
		spawn_requires_flag = "d2d_impossible_spawn",
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_dismantle_mid_fire.xml",
	    price               = 200,
	    mana                = 0,
	    action              = function()
	    						current_reload_time = current_reload_time + 90
	    						if reflecting then return end
	    						current_reload_time = current_reload_time - 90

	    						draw_actions( 1, true )
	                        end,	
    },

    {
	    id                  = "D2D_HUE_SHIFT_A",
	    name 		        = "$spell_d2d_hue_shift_a_name",
	    description         = "$spell_d2d_hue_shift_a_desc",
	    sprite 		        = "mods/D2DContentPack/files/gfx/ui_gfx/spells/hue_shift_a.png",
	    type 		        = ACTION_TYPE_PASSIVE,
        subtype     		= { altfire = true },
		spawn_level         = "0", -- should only spawn on the Staff of Light
		spawn_probability   = "0", -- should only spawn on the Staff of Light
		custom_xml_file 	= "mods/D2DContentPack/files/entities/misc/custom_cards/card_hue_shift_a.xml",
	    price               = 500,
	    mana                = 0,
	    action              = function()
	    						draw_actions( 1, true )

	    						if reflecting then return end

	    						if not GameHasFlagRun( "d2d_mid_fire_key_rebind_explained" ) then
	    							dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
	    							GamePrint( "[D2D] By default, 'Hue Shift' is cast with the middle mouse button", 60 )
	    							GamePrintDelayed( "[D2D] You can change this keybind in the mod's settings", 180 )
	    							GameAddFlagRun( "d2d_mid_fire_key_rebind_explained" )
	    						end
	                        end,
    },
}

if actions ~= nil then
	for k, v in pairs( d2d_actions ) do
		if not HasSettingFlag( v.id.."_disabled" ) then
			if v.only_if_mod_enabled then
				if ModIsEnabled( v.only_if_mod_enabled ) then
					table.insert( actions, v )
				end
			elseif v.only_if_mod_disabled then
				if not ModIsEnabled( v.only_if_mod_disabled ) then
					table.insert( actions, v )
				end
			else
				table.insert( actions, v )
			end
		end
	end
end










-- reworks
if actions ~= nil then
	local actions_to_edit = {
		["DARKFLAME"] = {
			max_uses = -1,
		},

		["ZETA"] = {
			description         = "$spell_d2d_zeta_rework_desc",
			spawn_level         = "5,6,10",
			spawn_probability   = "0.1,0.1,1",
			price               = 600,
			mana                = 320,
			action 		        = function()
									c.fire_rate_wait = c.fire_rate_wait + 50
									if reflecting then return end

									dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
									local last_wand = last_wand( get_player() )
									if not exists( last_wand ) then return end
									local actions = get_all_wand_actions( EZWand( last_wand ) )
									if not exists( actions ) or #actions == 0 then return end

									local spells_that_halt = { "RESET", "D2D_ALT_FIRE_ANYTHING", "ND2D_ALT_FIRE_ANYTHING" }
						            for i=1, #actions do
						            	local action = actions[i].entity_id
					            		local action_id = actions[i].action_id

					            		-- if the spell is RESET or AFA, end the loop
					            		for i,spell_that_halts in ipairs( spells_that_halt ) do
					            			if action_id == spell_that_halts then
					            				return
					            			end
					            		end

					            		local data = get_actions_lua_data( action_id )
					            		local item_comp = EntityGetFirstComponentIncludingDisabled( action, "ItemComponent" )
					            		local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )

					            		-- below part is copied from OMEGA
										local rec = check_recursion( data, recursion_level )
										if ( data ~= nil ) and ( ( data.recursive == nil ) or ( data.recursive == false ) ) then
											dont_draw_actions = true
											data.action( rec )
											dont_draw_actions = false
										end
						            end
			                    end,
	    },
	    
	    ["ROCKET_TIER_2"] = {
	    	max_uses = 10,
	    },
	    
	    ["ROCKET_TIER_3"] = {
	    	max_uses = 10,
	    },
	}

	for i=1,#actions do
        if actions_to_edit[actions[i].id] then
            for key, value in pairs(actions_to_edit[actions[i].id]) do
                actions[i][key] = value
            end
            actions[i]['d2d_reworked'] = true
        end
    end
end

if actions ~= nil and ModSettingGet( "D2DContentPack.nerf_greek_spells" ) then
	local actions_to_edit = {
	    ["ALPHA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["GAMMA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["TAU"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["OMEGA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["MU"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["PHI"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["SIGMA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["APOTHEOSIS_CHI"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["APOTHEOSIS_KAPPA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["D2D_DELTA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["ZETA"] = {
			max_uses = 30,
			never_unlimited = true,
	    },
	}

	for i=1,#actions do -- fast as fuck boi
        if actions_to_edit[actions[i].id] then
            for key, value in pairs(actions_to_edit[actions[i].id]) do
                actions[i][key] = value
            end
            actions[i]['d2d_reworked'] = true
        end
    end
end