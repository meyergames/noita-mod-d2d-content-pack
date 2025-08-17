ctq_actions = {
--    {
--	    id                  = "CTQ_MEDKIT",
--	    name 		        = "Medkit",
--	    description         = "Restores health, at the cost of some maximum health",
--	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/bandaid.png",
--	    type 		        = ACTION_TYPE_UTILITY,
--	    spawn_level         = "0,1,2,3,4,5", -- X_RAY
--	    spawn_probability   = "1.2,1.1,1.0,0.8,0.5,0.2", -- X_RAY
--	    price               = 99,
--	    max_uses            = 2,
--	    mana                = 50,
--	    action              = function()
--                                c.damage_healing_add = "-2"
--                                current_reload_time = current_reload_time + 30
--                                add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/bandaid.xml")
--                                c.action_never_unlimited = false -- losing max hp is a big enough drawback
--
--			                    local entity_id = GetUpdatedEntityID()
--			                    local dcomps = EntityGetComponent( entity_id, "DamageModelComponent" )
--                                if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
--                                    for i,damagemodel in ipairs( dcomps ) do
--                                        local hp = ComponentGetValue2( damagemodel, "hp" )
--                                        local old_max_hp = ComponentGetValue2( damagemodel, "max_hp" )
--                                        local new_max_hp = math.max(old_max_hp - 0.4, 0.04)
--
--                                        ComponentSetValue( damagemodel, "max_hp", new_max_hp)
--                                        ComponentSetValue( damagemodel, "hp", math.min(hp + 2, new_max_hp) )
--	                                    EntityInflictDamage( entity_id, math.min(old_max_hp - new_max_hp, hp-1), "NONE", "borrowed time", "BLOOD_EXPLOSION", 0, 0, entity_id, x, y, 0)
--                                        GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
--		                                ComponentSetValue( damagemodel, "hp", math.min(hp + 2, new_max_hp) )
--
--                                        if ( old_max_hp > 0.04 ) then
--                                            GamePrint(string.format("Max health lowered from %d to %d.", old_max_hp * 25, new_max_hp * 25))
--                                        end
--                                    end
--                                end
--	                        end,
--    },

--    {
--	    id                  = "CTQ_EMERGENCY_INJECTION",
--	    name 		        = "Emergency Injection",
--	    description         = "A dubious mixture of healthium and some pitch-black liquid...",
--	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/emergency_injection.png",
--	    type 		        = ACTION_TYPE_UTILITY,
--	    spawn_level         = "0,1,2,3,4,5,6", -- X_RAY
--	    spawn_probability   = "0.6,0.7,0.8,0.9,1.0,1.1,1.2", -- X_RAY
--	    price               = 150,
--	    max_uses            = 1,
--	    mana                = 100,
--	    action              = function()
--                                add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/bandaid.xml")
--                                c.action_never_unlimited = true
--
--			                    local entity_id = GetUpdatedEntityID()
--			                    local dcomps = EntityGetComponent( entity_id, "DamageModelComponent" )
--                                if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
--                                    for i,damagemodel in ipairs( dcomps ) do
--                                        local hp = ComponentGetValue2( damagemodel, "hp" )
--                                        local old_max_hp = ComponentGetValue2( damagemodel, "max_hp" )
--
--                                        ComponentSetValue( damagemodel, "max_hp", old_max_hp )
--                                        ComponentSetValue( damagemodel, "hp", old_max_hp )
--	                                    EntityInflictDamage( entity_id, hp * 0.1, "NONE", "viral infection", "BLOOD_EXPLOSION", 0, 0, entity_id, x, y, 0 )
--                                        GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
--
--                                        EntityIngestMaterial( entity_id, CellFactory_GetType("magic_liquid_infected_healthium"), 60)
--                                    end
--                                end
--	                        end,
--    },

    {
	    id                  = "CTQ_OVERCLOCK",
	    name 		        = "Overclock",
	    description         = "Pushes your wand to its limits; may cause overheating",
        inject_after        = { "RECHARGE", "MANA_REDUCE" },
	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/overclock.png",
	    type 		        = ACTION_TYPE_MODIFIER,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.4,0.6,0.8,0.9,1.0,1.0,1.0",
	    price               = 260,
	    mana                = -20,
	    action              = function()
                                local entity_id = GetUpdatedEntityID()
                                -- TODO: increase overheat chance if player's mana is low
--                                local ezwand = dofile_once( "mods/cheytaq_first_mod/files/scripts/ezwand.lua" )
--                                local inventory = EntityGetFirstComponent( entity_id, "Inventory2Component" )
--                                local active_wand = ComponentGetValue2( inventory, "mActiveItem" )
--                                local wand = ezwand(active_wand)
--                                GamePrint("Remaining mana: " .. wand.mana)
                                -- if( rand == 1 or wand.mana <= 0 ) then

                                local rand = Random( 0, 50 )
                                if( rand == 1 ) then -- 1/50 chance for *something* to happen
                                    c.fire_rate_wait    = 40
                                    GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)
--                                    current_reload_time = current_reload_time + 50

                                    local rand2 = Random( 0, 8 )
--                                    if( rand2 < 1 ) then -- 1/500
--			                            c.extra_entities = c.extra_entities .. "data/entities/misc/nolla.xml"
                                    if( rand2 < 1 ) then -- 2/250 or 1/125
                                        EntityInflictDamage(entity_id, 0.4, "DAMAGE_ELECTRICITY", "overheated wand", "ELECTROCUTION", 0, 0, entity_id, x, y, 0)
                                    elseif( rand2 < 3 ) then -- 2/250 or 1/125
                                        add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/deck/small_explosion.xml")
                                    elseif( rand2 < 5 ) then -- 2/250 or 1/125
                                        add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/overclock.xml")
                                    else -- 3/250 or 1/83
                                        add_projectile("data/entities/projectiles/deck/fizzle.xml")
                                    end
                                else
                                    c.fire_rate_wait    = c.fire_rate_wait - 15
                                    current_reload_time = current_reload_time - 20
                                end
                                
			                    draw_actions( 1, true )
	                        end,
    },

    {
	    id                  = "CTQ_PAYDAY",
	    name 		        = "Payday",
	    description         = "Use your money as ammo!",
        inject_after        = { "SUMMON_ROCK" },
	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/payday.png",
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
                                
                                if (wallet ~= nil) then
    	                            local money = ComponentGetValue2(wallet, "money")
                                    if (money ~= nil) then
                                        if ( money >= 10 ) then
			                                add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/deck/payday_nugget.xml")
                                            ComponentSetValue2(wallet, "money", money - 10)
                                        else
                                            GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)
                                        end
                                    end
                                end
	                        end,
    },

    {
	    id                  = "CTQ_SNIPE_SHOT",
	    name 		        = "Sniper Bolt",
	    description         = "A fast and lethal piercing shot",
        inject_after        = { "ARROW" },
	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/snipe_shot.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "0.4,1,2,2",
	    price               = 130,
	    mana                = 40,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 45
                                add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/sniper_bullet_custom.xml")
	                        end,
    },

    {
	    id                  = "CTQ_SNIPE_SHOT_TRIGGER",
	    name 		        = "Sniper Bolt With Trigger",
	    description         = "A piercing shot that casts another spell upon collision",
        inject_after        = { "CTQ_SNIPE_SHOT", "ARROW" },
	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/snipe_shot_trigger.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,3,4,5,6",
		spawn_probability   = "0.5,0.8,0.8,0.9,1,1",
	    price               = 230,
	    mana                = 70,
	    action              = function()
                                c.fire_rate_wait = c.fire_rate_wait + 67
--                                add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/sniper_bullet_custom.xml")
                    			add_projectile_trigger_hit_world("mods/cheytaq_first_mod/files/entities/projectiles/sniper_bullet_custom.xml", 1)
	                        end,
    },

    {
	    id                  = "CTQ_SMALL_EXPLOSION",
	    name 		        = "Small Explosion",
	    description         = "Safe for everyone!*",
        inject_after        = { "EXPLOSION" },
	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/small_explosion.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3",
		spawn_probability   = "1.2,1,0.8,0.6",
	    price               = 120,
	    mana                = 30,
	    action              = function()
			                    add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/deck/small_explosion.xml")
			                    c.fire_rate_wait = c.fire_rate_wait + 1.5
			                    c.screenshake = c.screenshake + 1.25
	                        end,
    },

    {
	    id                  = "CTQ_GIGA_DRAIN",
	    name 		        = "Giga Drain",
	    description         = "Drains organic creatures of their life force",
        inject_after        = { "CHAINSAW" },
	    sprite 		        = "mods/cheytaq_first_mod/files/gfx/ui_gfx/giga_drain.png",
	    type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6",
		spawn_probability   = "0.5,0.8,1,1.1,1,0.8,0.5",
	    price               = 150,
	    mana                = 60,
	    action              = function()
		                        c.fire_rate_wait = current_reload_time + 8
		                        current_reload_time = current_reload_time + 20
                                add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/giga_drain_bullet_(BACKUP).xml")
	                        end,
    },

	{
		id                  = "CTQ_GHOST_TRIGGER",
		name 		        = "Ghost Trigger",
		description         = "A harmless bolt that casts another spell upon collision",
        inject_after        = { "SPARK_BOLT_TIMER" },
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/ghost_trigger.png",
		related_projectiles	= {"mods/cheytaq_first_mod/files/entities/projectiles/deck/ghost_trigger_bullet.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3", -- LIGHT_BULLET_TRIGGER
		spawn_probability   = "1,0.7,0.6,0.5", -- LIGHT_BULLET_TRIGGER
		price               = 90,
		mana                = 5,
		action 		        = function()
                                c.damage_null_all = 1
			                    c.fire_rate_wait = c.fire_rate_wait - 5
			                    add_projectile_trigger_hit_world("mods/cheytaq_first_mod/files/entities/projectiles/deck/ghost_trigger_bullet.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_GHOSTLY_MESSENGER",
		name 		        = "Ghostly Messenger",
        inject_after        = { "CTQ_GHOST_TRIGGER", "SPARK_BOLT_TIMER" },
		description         = "Penetrates all terrain to cast another spell upon collision",
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/ghostly_messenger.png",
		related_projectiles	= {"mods/cheytaq_first_mod/files/entities/projectiles/deck/ghostly_messenger.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "2,3,4,5,6",
		spawn_probability   = "0.3,0.5,0.7,0.9,1",
		price               = 390,
		mana                = 150,
		action 		        = function()
                                c.damage_null_all = 1
			                    c.fire_rate_wait = c.fire_rate_wait + 45
		                        current_reload_time = current_reload_time + 93
			                    add_projectile_trigger_hit_world("mods/cheytaq_first_mod/files/entities/projectiles/deck/ghostly_messenger.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_BANANA_BOMB",
		name 		        = "Banana Bomb",
		description         = "The soft fruit of doom",
        inject_after        = { "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/banana_bomb.png",
		related_projectiles	= {"mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4", -- DYNAMITE
		spawn_probability   = "1,0.9,0.8,0.7,0.6", -- DYNAMITE
		price               = 190,
		mana                = 60,
        max_uses            = 10,
        custom_xml_file     = "mods/cheytaq_first_mod/files/entities/misc/custom_cards/card_banana_bomb.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_BANANA_BOMB_SUPER",
		name 		        = "Super Banana Bomb",
		description         = "The soft fruit of recursive doom",
        inject_after        = { "CTQ_BANANA_BOMB", "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/banana_bomb_super.png",
		related_projectiles	= {"mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb_super.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability   = "0.5,0.6,0.7,0.4,0.3,0.2,0.1",
		price               = 380,
		mana                = 120,
        max_uses            = 3,
        custom_xml_file     = "mods/cheytaq_first_mod/files/entities/misc/custom_cards/card_banana_bomb_super.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb_super.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_BANANA_BOMB_GIGA",
		name 		        = "Giga Banana Bomb",
		description         = "The softest fruit of the most recursive doom",
        inject_after        = { "CTQ_BANANA_BOMB_SUPER", "CTQ_BANANA_BOMB", "GLUE_SHOT", "SPORE_POD" },
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/banana_bomb_giga.png",
		related_projectiles	= {"mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb_giga.xml"},
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability   = "0.1,0.2,0.3,0.4,0.4,0.5,0.5",
		price               = 570,
		mana                = 180,
        max_uses            = 2,
        custom_xml_file     = "mods/cheytaq_first_mod/files/entities/misc/custom_cards/card_banana_bomb_giga.xml",
		action 		        = function()
			                    c.fire_rate_wait = c.fire_rate_wait + 50
			                    c.spread_degrees = c.spread_degrees + 6.0
			                    add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb_giga.xml", 1)
		                    end,
	},

	{
		id                  = "CTQ_BAG_OF_BOMBS",
		name 		        = "Bag Of Bombs",
		description         = "Who knows what you'll get...",
        inject_after        = { "DYNAMITE" },
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/bag_of_bombs.png",
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2,3,4", -- DYNAMITE
		spawn_probability   = "1,0.9,0.8,0.7,0.6", -- DYNAMITE
		price               = 250,
		mana                = 75,
        max_uses            = 15,
--        custom_xml_file     = "mods/cheytaq_first_mod/files/entities/misc/custom_cards/card_bag_of_bombs.xml",
		action 		        = function()
                                local rand = Random( 0, 1000 )
                                if( rand < 250 ) then -- 25%
			                        add_projectile("data/entities/projectiles/bomb.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 100
                                elseif( rand < 400 ) then -- 15%
			                        add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                elseif( rand < 500 ) then -- 10% (1/10)
			                        add_projectile("data/entities/projectiles/deck/glitter_bomb.xml")
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 12.0
                                elseif( rand < 550 ) then -- 5% (1/20)
			                        add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/bomb_dud.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 100
                                elseif( rand < 570 ) then -- 2% (1/50)
			                        add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb_super.xml", 1)
			                        c.fire_rate_wait = c.fire_rate_wait + 50
			                        c.spread_degrees = c.spread_degrees + 6.0
                                elseif( rand < 580 ) then -- 1% (1/100)
			                        add_projectile("data/entities/projectiles/bomb_holy.xml")
			                        current_reload_time = current_reload_time + 80
			                        shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
			                        c.fire_rate_wait = c.fire_rate_wait + 40
                                elseif( rand < 585 ) then -- 0.5% (1/200)
			                        add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb_giga.xml", 1)
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
		id                  = "CTQ_DRILL_VOLCANIC",
		name 		        = "Volcanic Drill",
		description         = "Perfectly suited for any and all mining operations",
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/spell_icon_drill_volcanic.png",
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "2,3,4,5,6",
		spawn_probability   = "0.5,0.6,0.7,0.8,0.9",
		price               = 350,
		mana                = 30,
		sound_loop_tag      = "sound_digger",
		action 		        = function()
			                    add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/deck/drill_volcanic.xml")
			                    c.fire_rate_wait = c.fire_rate_wait + 1
			                    current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		                    end,
	},

	{
		id                  = "CTQ_DRILL_INFERNAL",
		name 		        = "Infernal Drill",
		description         = "Not even brickwork is safe",
		sprite              = "mods/cheytaq_first_mod/files/gfx/ui_gfx/spell_icon_drill_infernal.png",
		type 		        = ACTION_TYPE_PROJECTILE,
		spawn_level         = "4,5,6",
		spawn_probability   = "0.4,0.6,0.8",
		price               = 700,
		mana                = 90,
		sound_loop_tag      = "sound_digger",
		action 		        = function()
			                    add_projectile("mods/cheytaq_first_mod/files/entities/projectiles/deck/drill_infernal.xml")
			                    c.fire_rate_wait = c.fire_rate_wait + 1
			                    current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
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

if(actions ~= nil)then
	for k, v in pairs(ctq_actions)do
		if(not HasSettingFlag(v.id.."_disabled"))then
			table.insert(actions, v)
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
