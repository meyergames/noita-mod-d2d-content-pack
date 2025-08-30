ctq_actions = {
    -- {
	--     id                  = "CTQ_OVERCLOCK",
	--     name 		        = "Overclock",
	--     description         = "Pushes your wand to its limits; may cause overheating",
    --     inject_after        = { "RECHARGE", "MANA_REDUCE" },
	--     sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/overclock.png",
	--     type 		        = ACTION_TYPE_MODIFIER,
	-- 	spawn_level         = "0,1,2,3,4,5,6",
	-- 	spawn_probability   = "0.4,0.6,0.8,0.9,1.0,1.0,1.0",
	--     price               = 260,
	--     mana                = -30,
	--     action              = function()
    --                             local entity_id = GetUpdatedEntityID()

    --                             local rand = Random( 0, 50 )
    --                             if( rand == 1 ) then -- 1/50 chance for *something* to happen
    --                                 c.fire_rate_wait    = 40
    --                                 GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)

    --                                 local rand2 = Random( 0, 8 )
    --                                 if( rand2 < 1 ) then -- 2/250 or 1/125
    --                                     EntityInflictDamage(entity_id, 0.4, "DAMAGE_ELECTRICITY", "overheated wand", "ELECTROCUTION", 0, 0, entity_id, x, y, 0)
    --                                 elseif( rand2 < 3 ) then -- 2/250 or 1/125
    --                                     add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/small_explosion.xml")
    --                                 elseif( rand2 < 5 ) then -- 2/250 or 1/125
    --                                     add_projectile("mods/RiskRewardBundle/files/entities/projectiles/overclock.xml")
    --                                 else -- 3/250 or 1/83
    --                                     add_projectile("data/entities/projectiles/deck/fizzle.xml")
    --                                 end
    --                             else
    --                                 c.fire_rate_wait    = c.fire_rate_wait - 15
    --                                 current_reload_time = current_reload_time - 20
    --                             end
                                
	-- 		                    draw_actions( 1, true )
	--                         end,
    -- },

    {
	    id                  = "CTQ_OPTIMIZE",
	    name 		        = "$spell_riskreward_optimize_name",
	    description         = "$spell_riskreward_optimize_desc",
        inject_after        = { "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/optimize.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "1.0,0.9,0.7,0.5",
	    price               = 120,
	    mana                = -5,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait - 3
                                current_reload_time = current_reload_time - 6

	    						draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "CTQ_MANA_REFILL",
	    name 		        = "$spell_riskreward_mana_refill_name",
	    description         = "$spell_riskreward_mana_refill_desc",
        inject_after        = { "MANA_REDUCE" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/mana_refill.png",
	    type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
	    price               = 330,
	    mana                = 0,
	    max_uses			= 5,
		never_unlimited 	= true,
		custom_uses_logic	= true,
	    action              = function()
	    						c.fire_rate_wait = c.fire_rate_wait + 30
	    						if reflecting then return end
	    						c.fire_rate_wait = c.fire_rate_wait - 30

							    local EZWand = dofile_once("mods/Apotheosis/lib/EZWand/EZWand.lua")
							    local wand = EZWand.GetHeldWand()
                                local x, y = EntityGetTransform( GetUpdatedEntityID() )

                                if ( mana <= wand.manaMax * 0.25 ) then
							    	mana = wand.manaMax
	            					GamePlaySound( "data/audio/Desktop/player.bank", "player_projectiles/wall/create", x, y )
	    							c.fire_rate_wait = c.fire_rate_wait + 30

									local uses_remaining = -1
									local icomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "ItemComponent" )
									if ( icomp ~= nil ) then
									    uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
									end
						            local spells, attached_spells = wand:GetSpells()
						            for i,spell in ipairs( spells ) do
						                if ( spell.action_id == "CTQ_MANA_REFILL" ) then
						                    ComponentSetValue2( icomp, "uses_remaining", uses_remaining - 1 )
						                    break
						                end
						            end
	            				end
	                        end,
    },

    {
	    id                  = "CTQ_FLURRY",
	    name 		        = "$spell_riskreward_flurry_name",
	    description         = "$spell_riskreward_flurry_desc",
        inject_after        = { "RECHARGE", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/flurry.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "1,1,1,0.9,0.8,0.7,0.6",
	    price               = 180,
	    mana                = 1,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait - 15 -- so it shows in the UI
                                current_reload_time = current_reload_time - 20 -- so it shows in the UI

					            if reflecting then return end

                                local entity_id = GetUpdatedEntityID()

							    local EZWand = dofile_once("mods/Apotheosis/lib/EZWand/EZWand.lua")
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
	    id                  = "CTQ_OVERCLOCK",
	    name 		        = "$spell_riskreward_overclock_name",
	    description         = "$spell_riskreward_overclock_desc",
        inject_after        = { "CTQ_BURST_FIRE", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/overclock.png",
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

							    local EZWand = dofile_once("mods/Apotheosis/lib/EZWand/EZWand.lua")
							    local wand = EZWand.GetHeldWand()
                                local x, y = EntityGetTransform( GetUpdatedEntityID() )

							    -- local remaining_mana_percent = ( 1.0 / wand.manaMax ) * (wand.mana - c.action_mana_drain)
							    -- if ( remaining_mana_percent >= 0.5 ) then
							    -- 	c.fire_rate_wait	= c.fire_rate_wait - ( ( remaining_mana_percent - 0.5 ) * 10 )
								-- end

							    local rand = Random( 0, 100 )
							    local chance = 1.0 / ( (1.0 / wand.manaMax) * wand.mana )
                                if( rand <= chance ) then
                                    c.fire_rate_wait    = 40
                                    GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)

                                    local rand2 = Random( 0, 8 )
                                    if( rand2 < 1 ) then -- 2/250 or 1/125
                                        EntityInflictDamage(entity_id, 0.4, "DAMAGE_ELECTRICITY", "overheated wand", "ELECTROCUTION", 0, 0, entity_id, x, y, 0)
                                    elseif( rand2 < 3 ) then -- 2/250 or 1/125
                                        add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/small_explosion.xml")
                                    elseif( rand2 < 5 ) then -- 2/250 or 1/125
                                        add_projectile("mods/RiskRewardBundle/files/entities/projectiles/overclock.xml")
                                    else -- 3/250 or 1/83
                                        add_projectile("data/entities/projectiles/deck/fizzle.xml")
                                    end
                                end
                                
			                    draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "CTQ_RAPIDFIRE_SALVO",
	    name 		        = "$spell_riskreward_rapidfire_salvo_name",
	    description         = "$spell_riskreward_rapidfire_salvo_desc",
        inject_after        = { "CTQ_FLURRY", "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/rapidfire_salvo.png",
	    type 		        = ACTION_TYPE_PASSIVE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
		custom_xml_file 	= "mods/RiskRewardBundle/files/entities/misc/custom_cards/card_rapidfire_salvo.xml",
	    price               = 330,
	    mana                = 1,
	    action              = function()
                                draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "CTQ_SNIPE_SHOT",
	    name 		        = "$spell_riskreward_sniper_bolt_name",
	    description         = "$spell_riskreward_sniper_bolt_desc",
        inject_after        = { "ARROW" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/snipe_shot.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "0.4,1,2,2",
	    price               = 130,
	    mana                = 40,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 45
                                add_projectile("mods/RiskRewardBundle/files/entities/projectiles/sniper_bullet_custom.xml")
	                        end,
    },

    {
	    id                  = "CTQ_SNIPE_SHOT_TRIGGER",
	    name 		        = "$spell_riskreward_sniper_bolt_trigger_name",
	    description         = "$spell_riskreward_sniper_bolt_trigger_desc",
        inject_after        = { "CTQ_SNIPE_SHOT", "ARROW" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/snipe_shot_trigger.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.5,0.8,0.8,0.9,1,1",
	    price               = 230,
	    mana                = 70,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 67
--                                add_projectile("mods/RiskRewardBundle/files/entities/projectiles/sniper_bullet_custom.xml")
                    			add_projectile_trigger_hit_world("mods/RiskRewardBundle/files/entities/projectiles/sniper_bullet_custom.xml", 1)
	                        end,
    },

	{
		id                  = "CTQ_GHOST_TRIGGER",
		name 		        = "$spell_riskreward_ghost_trigger_name",
		description         = "$spell_riskreward_ghost_trigger_desc",
        inject_after        = { "SPARK_BOLT_TIMER" },
		sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/ghost_trigger.png",
		related_projectiles	= {"mods/RiskRewardBundle/files/entities/projectiles/deck/ghost_trigger_bullet.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3", -- LIGHT_BULLET_TRIGGER
		spawn_probability   = "1,0.7,0.6,0.5", -- LIGHT_BULLET_TRIGGER
		price               = 90,
		mana                = 5,
		action 		        = function()
                                c.damage_null_all = 1
			                    c.fire_rate_wait = c.fire_rate_wait - 3
			                    add_projectile_trigger_hit_world("mods/RiskRewardBundle/files/entities/projectiles/deck/ghost_trigger_bullet.xml", 1)
		                    end,
	},

    {
	    id                  = "CTQ_GIGA_DRAIN",
	    name 		        = "$spell_riskreward_giga_drain_name",
	    description         = "$spell_riskreward_giga_drain_desc",
        inject_after        = { "CHAINSAW" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/giga_drain.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.5,0.8,1,1.1,1,0.8,0.5",
	    price               = 150,
	    mana                = 60,
	    action              = function()
		                        c.fire_rate_wait = current_reload_time + 8
		                        current_reload_time = current_reload_time + 20
                                add_projectile("mods/RiskRewardBundle/files/entities/projectiles/giga_drain_bullet.xml")
	                        end,
    },

    {
	    id                  = "CTQ_PAYDAY",
	    name 		        = "$spell_riskreward_payday_name",
	    description         = "$spell_riskreward_payday_desc",
        inject_after        = { "SUMMON_ROCK" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/payday.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6", -- SUMMON_ROCK
		spawn_probability   = "0.7,0.7,0.5,0.5,0.2,0.6,0.6", -- SUMMON_ROCK (-0.1)
	    price               = 100,
	    mana                = 10,
--        max_uses            = 20,
	    action              = function()
			                    c.fire_rate_wait    = c.fire_rate_wait + 40
			                    current_reload_time = current_reload_time + 40

			                    local player = GetUpdatedEntityID()
                                local wallet = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
                                local x, y = EntityGetTransform( player )
                                
                                if (wallet ~= nil) then
    	                            local money = ComponentGetValue2(wallet, "money")
                                    if (money ~= nil) then
                                        if ( money >= 10 ) then
			                                add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/payday_nugget.xml")
                                            ComponentSetValue2(wallet, "money", money - 10)
                                        else
                                            GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)
                                        end
                                    end
                                end
	                        end,
    },

    {
	    id                  = "CTQ_CONCRETE_WALL",
	    name 		        = "$spell_riskreward_concrete_wall_name",
	    description         = "$spell_riskreward_concrete_wall_desc",
        inject_after        = { "CTQ_PAYDAY", "SUMMON_ROCK" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/concrete_wall.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.4,0.7,0.8,0.7,0.5,0.3",
	    price               = 200,
	    mana                = 80,
	    max_uses			= 5,
	    action              = function()
			                    c.fire_rate_wait    = c.fire_rate_wait + 40
			                    current_reload_time = current_reload_time + 40

                                add_projectile("mods/RiskRewardBundle/files/entities/projectiles/concrete_wall_bullet_initial.xml")
	                        end,
    },

    {
	    id                  = "CTQ_SMALL_EXPLOSION",
	    name 		        = "$spell_riskreward_small_explosion_name",
	    description         = "$spell_riskreward_small_explosion_desc",
        inject_after        = { "EXPLOSION" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/small_explosion.png",
	    type 		        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "1.2,1,0.8,0.6",
	    price               = 120,
	    mana                = 25,
	    action              = function()
			                    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/small_explosion.xml")
			                    c.fire_rate_wait = c.fire_rate_wait + 1.5
			                    c.screenshake = c.screenshake + 1.25
	                        end,
    },

	-- {
	-- 	id                  = "CTQ_GHOSTLY_MESSENGER",
	-- 	name 		        = "Ghostly Messenger",
    --     inject_after        = { "CTQ_GHOST_TRIGGER", "SPARK_BOLT_TIMER" },
	-- 	description         = "Penetrates all terrain to cast another spell upon collision",
	-- 	sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/ghostly_messenger.png",
	-- 	related_projectiles	= {"mods/RiskRewardBundle/files/entities/projectiles/deck/ghostly_messenger.xml"},
	-- 	type 		        = ACTION_TYPE_PROJECTILE,
	-- 	spawn_level         = "2,3,4,5,6",
	-- 	spawn_probability   = "0.3,0.5,0.7,0.9,1",
	-- 	price               = 390,
	-- 	mana                = 150,
	-- 	action 		        = function()
    --                             c.damage_null_all = 1
	-- 		                    c.fire_rate_wait = c.fire_rate_wait + 45
	-- 	                        current_reload_time = current_reload_time + 93
	-- 		                    add_projectile_trigger_hit_world("mods/RiskRewardBundle/files/entities/projectiles/deck/ghostly_messenger.xml", 1)
	-- 	                    end,
	-- },

	{
		id                  = "CTQ_BANANA_BOMB",
		name 		        = "$spell_riskreward_banana_bomb_name",
		description         = "$spell_riskreward_banana_bomb_desc",
        inject_after        = { "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/banana_bomb.png",
		related_projectiles	= {"mods/RiskRewardBundle/files/entities/projectiles/banana_bomb.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4", -- DYNAMITE
		spawn_probability   = "0.7,0.6,0.5,0.4,0.3", -- DYNAMITE
		price               = 190,
		mana                = 60,
        max_uses            = 12,
        custom_xml_file     = "mods/RiskRewardBundle/files/entities/misc/custom_cards/card_banana_bomb.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_BANANA_BOMB_SUPER",
		name 		        = "$spell_riskreward_banana_bomb_super_name",
		description         = "$spell_riskreward_banana_bomb_super_desc",
        inject_after        = { "CTQ_BANANA_BOMB", "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/banana_bomb_super.png",
		related_projectiles	= {"mods/RiskRewardBundle/files/entities/projectiles/banana_bomb_super.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability   = "0.5,0.6,0.7,0.4,0.3,0.2,0.1",
		price               = 380,
		mana                = 90,
        max_uses            = 6,
        custom_xml_file     = "mods/RiskRewardBundle/files/entities/misc/custom_cards/card_banana_bomb_super.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb_super.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_BANANA_BOMB_GIGA",
		name 		        = "$spell_riskreward_banana_bomb_giga_name",
		description         = "$spell_riskreward_banana_bomb_giga_desc",
        inject_after        = { "CTQ_BANANA_BOMB_SUPER", "CTQ_BANANA_BOMB", "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/banana_bomb_giga.png",
		related_projectiles	= {"mods/RiskRewardBundle/files/entities/projectiles/banana_bomb_giga.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability   = "0.1,0.2,0.3,0.4,0.4,0.5,0.5",
		price               = 570,
		mana                = 180,
        max_uses            = 3,
        custom_xml_file     = "mods/RiskRewardBundle/files/entities/misc/custom_cards/card_banana_bomb_giga.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb_giga.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_BAG_OF_BOMBS",
		name 		        = "$spell_riskreward_bag_of_bombs_name",
		description         = "$spell_riskreward_bag_of_bombs_desc",
        inject_after        = { "DYNAMITE" },
		sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/bag_of_bombs.png",
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4", -- DYNAMITE
		spawn_probability   = "1,0.9,0.8,0.7,0.6", -- DYNAMITE
		price               = 250,
		mana                = 75,
        max_uses            = 15,
       	custom_xml_file     = "mods/RiskRewardBundle/files/entities/misc/custom_cards/card_bag_of_bombs.xml",
		action 		        = function()
                                local rand = Random( 0, 1000 )
                                if( rand < 250 ) then -- 25%
			                        add_projectile("data/entities/projectiles/bomb.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 100
                                elseif( rand < 400 ) then -- 15%
			                        add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                elseif( rand < 500 ) then -- 10% (1/10)
			                        add_projectile("data/entities/projectiles/deck/glitter_bomb.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 12.0
                                elseif( rand < 550 ) then -- 5% (1/20)
			                        add_projectile("mods/RiskRewardBundle/files/entities/projectiles/bomb_dud.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 100
                                elseif( rand < 570 ) then -- 2% (1/50)
			                        add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb_super.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                elseif( rand < 580 ) then -- 1% (1/100)
			                        add_projectile("data/entities/projectiles/bomb_holy.xml")
			                        current_reload_time = current_reload_time + 80
			                        shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
			                        c.fire_rate_wait = c.fire_rate_wait + 40
                                elseif( rand < 585 ) then -- 0.5% (1/200)
			                        add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb_giga.xml", 1)
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

	-- {
	-- 	id                  = "CTQ_DRILL_VOLCANIC",
	-- 	name 		        = "Volcanic Drill",
	-- 	description         = "Perfectly suited for any and all mining operations",
	-- 	sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/spell_icon_drill_infernal.png",
	-- 	type 		        = ACTION_TYPE_PROJECTILE,
	-- 	spawn_level         = "2,3,4,5,6",
	-- 	spawn_probability   = "0.5,0.6,0.7,0.8,0.9",
	-- 	price               = 350,
	-- 	mana                = 27,
	-- 	sound_loop_tag      = "sound_digger",
	-- 	action 		        = function()
	-- 		                    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/drill_volcanic.xml")
	-- 		                    c.fire_rate_wait = c.fire_rate_wait + 1
	-- 		                    current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
	-- 	                    end,
	-- },

	-- {
	-- 	id                  = "CTQ_DRILL_INFERNAL",
	-- 	name 		        = "Infernal Drill",
	-- 	description         = "Not even brickwork is safe",
	-- 	sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/spell_icon_drill_infernal.png",
	-- 	type 		        = ACTION_TYPE_PROJECTILE,
	-- 	spawn_level         = "4,5,6",
	-- 	spawn_probability   = "0.4,0.6,0.8",
	-- 	price               = 700,
	-- 	mana                = 90,
	-- 	sound_loop_tag      = "sound_digger",
	-- 	action 		        = function()
	-- 		                    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/drill_infernal.xml")
	-- 		                    c.fire_rate_wait = c.fire_rate_wait + 1
	-- 		                    current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
	-- 	                    end,
	-- },

	-- {
	-- 	id          = "CTQ_CIRCLE_GOLD",
	-- 	name 		= "Circle Of Gold",
	-- 	description = "Spawns a circle of gold",
	-- 	sprite 		= "data/ui_gfx/gun_actions/circle_water.png",
	-- 	sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
	-- 	-- related_projectiles	= {"data/entities/projectiles/deck/circle_water.xml"},
	-- 	type 		= ACTION_TYPE_MATERIAL,
	-- 	spawn_level                       = "0",
	-- 	spawn_probability                 = "0",
	-- 	price = 160,
	-- 	mana = 20,
	-- 	max_uses = 1,
	-- 	action 		= function()
	-- 		add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/circle_gold_128.xml")
	-- 		c.fire_rate_wait = c.fire_rate_wait + 20
	-- 	end,
	-- },

	-- {
	-- 	id          = "CTQ_CIRCLE_GOLD_BIG",
	-- 	name 		= "Sea Of Gold",
	-- 	description = "Spawns a sea of gold",
	-- 	sprite 		= "data/ui_gfx/gun_actions/circle_water.png",
	-- 	sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
	-- 	-- related_projectiles	= {"data/entities/projectiles/deck/circle_water.xml"},
	-- 	type 		= ACTION_TYPE_MATERIAL,
	-- 	spawn_level                       = "0",
	-- 	spawn_probability                 = "0",
	-- 	price = 160,
	-- 	mana = 20,
	-- 	max_uses = 1,
	-- 	action 		= function()
	-- 		add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/circle_gold_256.xml")
	-- 		c.fire_rate_wait = c.fire_rate_wait + 20
	-- 	end,
	-- },

    {
	    id                  = "CTQ_DAMAGE_MISSING_MANA",
	    name 		        = "$spell_riskreward_damage_missing_mana_name",
	    description         = "$spell_riskreward_damage_missing_mana_desc",
        inject_after        = { "DAMAGE_FOREVER", "DAMAGE" },
	    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/damage_missing_mana.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.6,0.8,0.9,0.8,0.7,0.6",
	    price               = 270,
	    mana                = 20,
	    action              = function()
                                c.fire_rate_wait    = c.fire_rate_wait + 4 -- so it shows in the UI

					            if reflecting then return end

							    local EZWand = dofile_once("mods/Apotheosis/lib/EZWand/EZWand.lua")
							    -- local entity_id = GetUpdatedEntityID()
							    -- local inventory = EntityGetFirstComponent( entity_id, "Inventory2Component" )
							    -- local active_wand = ComponentGetValue2( inventory, "mActiveItem" )
							    -- local wand = EZWand(active_wand)
							    local wand = EZWand.GetHeldWand()
							    
                                c.fire_rate_wait    			= c.fire_rate_wait - 4 -- reset

							    local remaining_mana_percent	= ( 1.0 / wand.manaMax ) * wand.mana
						    	local missing_mana				= wand.manaMax - wand.mana
						    	local sec_to_recharge_wand		= wand.manaMax / math.max( wand.manaChargeSpeed, 1 ) -- careful for division by zero
                                -- local spell_cast_delay			= math.max( c.fire_rate_wait, 0 ) -- sniper bolt is 45
                                local missing_mana_percent		= 1.0 - remaining_mana_percent

                                local bonus_dmg_raw				= ( 0.04 * missing_mana * 0.1 ) -- first check how much mana the player is missing
                                								  * ( 1.0 + 0.1 * math.min( sec_to_recharge_wand, 90 ) ) -- multiply by the time it takes to recharge
                                								  -- * ( 1.0 + 0.05 * math.min( spell_cast_delay, 60 ) ) -- multiply by the projectile's cast delay
								c.damage_projectile_add			= c.damage_projectile_add + ( bonus_dmg_raw * missing_mana_percent )
								-- GamePrint("dealt " .. 25 * ( c.damage_projectile_add + ( bonus_dmg_raw * missing_mana_percent ) ) .. " bonus damage")
								c.extra_entities				= c.extra_entities .. "data/entities/particles/tinyspark_blue_large.xml,"

                                c.fire_rate_wait    			= c.fire_rate_wait + ( missing_mana_percent * 20 ) -- max 20
                                c.knockback_force				= c.knockback_force + ( missing_mana_percent * 5 ) -- max 5
								shot_effects.recoil_knockback	= shot_effects.recoil_knockback + ( missing_mana_percent * 200 ) -- max 200

								if ( remaining_mana_percent <= 0.25 ) then
									c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_orange.xml,"
								end




								-- local util = dofile_once( "data/scripts/lib/utilities.lua" )
    							-- local function adjust_all_entity_damage( entity, callback )
    							-- 	adjust_entity_damage( entity,
								--         function( current_damage ) return callback( current_damage ) end,
								--         function( current_damages )
								--             for type,current_damage in pairs( current_damages ) do
								--                 if current_damage ~= 0 then
								--                     current_damages[type] = callback( current_damage )
								--                 end
								--             end
								--             return current_damages
								--         end,
								--         function( current_damage ) return callback( current_damage ) end,
								--         function( current_damage ) return callback( current_damage ) end,
								--         function( current_damage ) return callback( current_damage ) end
								--     )
								-- end
    							-- adjust_all_entity_damage( c, function( current_damage ) return ( current_damage ) * (1 + missing_mana_percent) end )

    							-- WHY IS IT SO HARD TO MULTIPLY DAMAGE?!




			                    draw_actions( 1, true )
	                        end,
    },

	{
		id          = "CTQ_CURSES_TO_POWER",
		name 		= "Curses To Power",
		description = "Adds 10 damage for each curse you have",
		sprite 		= "mods/RiskRewardBundle/files/gfx/ui_gfx/curses_to_power.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0",
		spawn_probability                 = "0",
		price 		= 999,
		mana 		= 5,
		action 		= function()
			c.fire_rate_wait		= c.fire_rate_wait + 5
			c.damage_curse_add 		= c.damage_curse_add + 0.4 -- for the tooltip
			if reflecting then return end

			c.damage_curse_add 		= c.damage_curse_add - 0.6 -- reset
            local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
            if curse_count ~= nil then
				c.damage_curse_add 		= c.damage_curse_add + ( 0.4 * tonumber( curse_count ) )
				c.extra_entities    	= c.extra_entities .. "data/entities/particles/tinyspark_purple_bright.xml,"
	            draw_actions( 1, true )
	        end
		end,
	},

	-- {
	-- 	id          = "CTQ_CURSED_BOLT",
	-- 	name 		= "Cursed Bolt",
	-- 	description = "Deals more damage the more curses you carry",
	-- 	sprite 		= "mods/RiskRewardBundle/files/gfx/ui_gfx/cursed_bolt.png",
	-- 	type 		= ACTION_TYPE_PROJECTILE,
	-- 	spawn_level                       = "0",
	-- 	spawn_probability                 = "0",
	-- 	price = 999,
	-- 	mana = 30,
	-- 	action 		= function()
	-- 		c.fire_rate_wait = c.fire_rate_wait + 20
	-- 		shot_effects.recoil_knockback = 40.0

	-- 		if reflecting then return end

    --         local curse_count = GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" )
    --         if curse_count ~= nil then
	-- 			c.damage_curse_add = ( 0.4 * tonumber( curse_count ) ) * ( 1.1 * tonumber( curse_count ) )
	-- 			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_purple_bright.xml,"
	--         end

	-- 		add_projectile("mods/RiskRewardBundle/files/entities/projectiles/deck/cursed_bolt.xml")
	-- 	end,
	-- },

	{
		id          = "CTQ_CURSES_TO_MANA",
		name 		= "Curses To Mana",
		description = "Restores 30 mana for each curse you have",
		sprite 		= "mods/RiskRewardBundle/files/gfx/ui_gfx/curses_to_mana.png",
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
		id                  = "CTQ_FIXED_ALTITUDE",
		name 		        = "Fixed Altitude",
		description         = "Resets your vertical velocity",
		sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/fixed_altitude.png",
		type 		        = ACTION_TYPE_UTILITY,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.3,0.5,0.7,0.9,1.1,1.0",
		price               = 280,
		mana                = 1,
		action 		        = function()
								if reflecting then return end

								local player = GetUpdatedEntityID()

								-- local vel_x, vel_y = getPlayerVelocities()
								-- ^ this seems to be an existing method?

								local vcomp = EntityGetFirstComponent( player, "VelocityComponent" )
								local cdcomp = EntityGetFirstComponent( player, "CharacterDataComponent" )
							    if vcomp ~= nil then
									local v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
									local d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )

								    if ( v_vel_y > 0 ) then
										-- edit_component( player, "VelocityComponent", function(vcomp,vars)
										-- 	ComponentSetValueVector2( vcomp, "mVelocity", v_vel_x, ( v_vel_y * 0.25 ) - 6 ) end)
										
										-- edit_component( player, "CharacterDataComponent", function(ccomp,vars)
										-- 	ComponentSetValueVector2( cdcomp, "mVelocity", d_vel_x, ( d_vel_y * 0.25 ) - 12 ) end)
										edit_component( player, "VelocityComponent", function(vcomp,vars)
											ComponentSetValueVector2( vcomp, "mVelocity", v_vel_x, -6 ) end)
										
										edit_component( player, "CharacterDataComponent", function(ccomp,vars)
											ComponentSetValueVector2( cdcomp, "mVelocity", d_vel_x, -12 ) end)

										v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
										d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )
									end
							    end
		                    end,
	},

	-- {
	-- 	id                  = "CTQ_REWIND",
	-- 	name 		        = "Rewind",
	-- 	description         = "Teleports you where you were 4 seconds ago",
	-- 	sprite              = "mods/RiskRewardBundle/files/gfx/ui_gfx/rewind.png",
	-- 	type 		        = ACTION_TYPE_PASSIVE,
	-- 	spawn_level         = "1,2,3,4,5,6",
	-- 	spawn_probability   = "0.3,0.5,0.7,0.9,1.1,1.0",
	-- 	price               = 280,
	-- 	mana                = 40,
	-- 	custom_xml_file 	= "mods/RiskRewardBundle/files/entities/misc/torch.xml",
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


if ( ModIsEnabled("Apotheosis") ) then
	ctq_apoth_actions = {
	    {
		    id                  = "CTQ_MANA_REFILL_ALT_FIRE",
		    name 		        = "$spell_riskreward_mana_refill_alt_fire_name",
		    description         = "$spell_riskreward_mana_refill_alt_fire_desc",
	        inject_after        = { "CTQ_MANA_REFILL_ALT_FIRE", "MANA_REDUCE" },
		    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/alt_fire_mana_refill.png",
		    type 		        = ACTION_TYPE_PASSIVE,
	        subtype     		= { altfire = true },
			spawn_level         = "0,1,2,3,4,5,6",
			spawn_probability   = "0.4,0.7,0.8,0.9,0.8,0.7,0.6",
			custom_xml_file 	= "mods/RiskRewardBundle/files/entities/misc/custom_cards/alt_fire_mana_refill.xml",
		    price               = 330,
		    mana                = 0,
		    max_uses			= 5,
		    never_unlimited		= true,
        	custom_uses_logic 	= true,
		    action              = function()
		    						draw_actions( 1, true )

									-- local icomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "ItemComponent" )
									-- if ( icomp ~= nil ) then
									--     uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
									--     ComponentSetValue2( icomp, "uses_remaining", uses_remaining + 1 )
									-- end
									-- -- TODO: uses are still consumed on left-click (i.e. normal spell usage)
									-- -- check in Apotheosis' actions.lua how the "alt_fire_cov" spell (which has limited uses) handles this?
		                        end,
	    },

	    {
		    id                  = "CTQ_CONCRETE_WALL_ALT_FIRE",
		    name 		        = "$spell_riskreward_concrete_wall_alt_fire_name",
		    description         = "$spell_riskreward_concrete_wall_alt_fire_desc",
	        inject_after        = { "CTQ_CONCRETE_WALL", "CTQ_PAYDAY", "SUMMON_ROCK" },
		    sprite 		        = "mods/RiskRewardBundle/files/gfx/ui_gfx/alt_fire_concrete_wall.png",
		    type 		        = ACTION_TYPE_PASSIVE,
	        subtype     		= { altfire = true },
			spawn_level         = "1,2,3,4,5,6",
			spawn_probability   = "0.3,0.5,0.6,0.5,0.3,0.2",
			custom_xml_file 	= "mods/RiskRewardBundle/files/entities/misc/custom_cards/alt_fire_concrete_wall.xml",
		    price               = 200,
		    mana                = 80,
		    max_uses			= 5,
        	custom_uses_logic 	= true,
		    action              = function()
		    						draw_actions( 1, true )
            						mana = mana + 80
		                        end,
	    },
	}
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

if(actions ~= nil)then
	for k, v in pairs(ctq_actions)do
		if(not HasSettingFlag(v.id.."_disabled"))then
			table.insert(actions, v)
		end
	end
end

if ( ModIsEnabled("Apotheosis") ) then
	if(actions ~= nil)then
		for k, v in pairs(ctq_apoth_actions)do
			if(not HasSettingFlag(v.id.."_disabled"))then
				table.insert(actions, v)
			end
		end
	end
end


function OrganiseProgress()
    dofile_once( "data/scripts/gun/gun_actions.lua" )

    -- Based on Conga Lyne's implementation
    for insert_index = 1, #ctq_actions do
        local action_to_insert = ctq_actions[insert_index]
        -- Check if spells to inject after are defined
        if action_to_insert.inject_after ~= nil then
            -- Loop over actions
            local found = false
            for actions_index = #actions, 1, -1 do
                action = actions[actions_index]
                -- Loop over inject after options
                for inject_index = 1, #action_to_insert.inject_after do
                    if action.id == action_to_insert.inject_after[inject_index] then
                        found = true
                        break
                    end
                end
                if found then
                    table.insert(actions, actions_index + 1, action_to_insert)
                    GamePrint("inserted")
                    break
                end
                if actions_index == 1 then
                    --Insert here as a failsafe incase the matchup ID can't be found.. some other mod might delete the spell we're trying to insert at
                    actions[#actions + 1] = action_to_insert
                end
            end
        else
            actions[#actions + 1] = action_to_insert
        end
    end
end
