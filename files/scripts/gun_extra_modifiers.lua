dofile_once("data/scripts/lib/utilities.lua")

extra_modifiers["d2d_master_of_explosions_boost"] = function()
	local is_immune_to_explosions = has_game_effect( get_player(), "PROTECTION_EXPLOSION" )
	if( not is_immune_to_explosions ) then
		c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/hitfx_master_of_explosions_impact.xml,"
		c.explosion_radius = c.explosion_radius + 15.0
		c.damage_explosion_add = c.damage_explosion_add + 0.4
		c.knockback_force = c.knockback_force + 5.0
		shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
    end
end

extra_modifiers["d2d_master_of_lightning_boost"] = function()
	local is_immune_to_electricity = has_game_effect( get_player(), "PROTECTION_ELECTRICITY" )
    if( not is_immune_to_electricity ) then
		c.damage_electricity_add = c.damage_electricity_add + 0.2
        c.extra_entities = c.extra_entities .. "data/entities/particles/electricity.xml,"
        c.extra_entities = c.extra_entities .. "mods/D2DContentPack/files/entities/projectiles/deck/master_of_lightning_try_electrify.xml,"
        
		c.speed_multiplier = c.speed_multiplier * 2
		c.fire_rate_wait   = (c.fire_rate_wait / 4) * 3
	    current_reload_time = (current_reload_time / 4) * 3
    end
end

extra_modifiers["d2d_master_of_lightning_boost_plus"] = function()
	c.speed_multiplier = c.speed_multiplier * 1.5
	c.fire_rate_wait	= (c.fire_rate_wait / 7.5) * 5
	current_reload_time	= (current_reload_time / 7.5) * 5
end

extra_modifiers["d2d_master_of_fire_boost"] = function()
    local is_immune_to_fire = has_game_effect( get_player(), "PROTECTION_FIRE" )
    if( not is_immune_to_fire ) then
	    c.damage_fire_add = c.damage_fire_add + 0.2
		c.extra_entities = c.extra_entities .. "data/entities/misc/burn.xml," .. "mods/D2DContentPack/files/entities/projectiles/deck/hitfx_master_of_fire_impact.xml,"
    end
end

extra_modifiers["d2d_master_of_fire_boost_plus"] = function()
	-- c.damage_fire_add = c.damage_fire_add + 0.4

	c.fire_rate_wait   = (c.fire_rate_wait / 5) * 4
    current_reload_time = (current_reload_time / 5) * 4
end

extra_modifiers["d2d_overheating_wands"] = function()
    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
    local entity_id = GetUpdatedEntityID()
    local inventory = EntityGetFirstComponent( entity_id, "Inventory2Component" )
    local active_wand = ComponentGetValue2( inventory, "mActiveItem" )
    local wand = EZWand(active_wand)
    local x, y = EntityGetTransform( get_player() )

    local mana = wand.mana
    local max_mana = wand.manaMax

	local not_enough_mana = c.action_mana_drain < mana

    local rand = Random( 0, 100 )
    local chance = 1.0 / ( ( 1.0 / ( max_mana * 0.5 ) ) * math.max( mana, 0.1 ) )
    if( mana <= max_mana * 0.5 and rand <= chance ) then -- at 100% mana, 1/100 chance for *something* to happen
        c.fire_rate_wait    = 40
        GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)

        local rand2 = Random( 0, 8 )
        if( rand2 < 1 ) then
            EntityInflictDamage(entity_id, 0.4, "DAMAGE_ELECTRICITY", "overheated wand", "ELECTROCUTION", 0, 0, entity_id, x, y, 0)
        elseif( rand2 < 3 ) then
            add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml")
        elseif( rand2 < 5 ) then
            add_projectile("mods/D2DContentPack/files/entities/projectiles/overclock.xml")
        else
            add_projectile("data/entities/projectiles/deck/fizzle.xml")
        end
    end
end

extra_modifiers["d2d_no_rhythm"] = function()
    local rand = Random( 72, 128 )
    c.fire_rate_wait = c.fire_rate_wait * rand * 0.01
    current_reload_time = current_reload_time * rand * 0.01
end

extra_modifiers["d2d_divine_prank"] = function()
    local enabled = get_internal_int( get_player(), "prank_enable_propane" ) == 1
    if ( enabled ) then
        local p_dcomp = EntityGetFirstComponentIncludingDisabled( get_player(), "DamageModelComponent" )
        local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

        -- local i = 1 + math.min( p_max_hp / 4, 10 )
        -- while i > 0 do
            c.extra_entities = c.extra_entities .. "data/entities/misc/perks/projectile_homing_shooter.xml,"
            add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/propane_tank_dud.xml")
            -- i = i - 1
        -- end

        set_internal_int( get_player(), "prank_enable_propane", 0 )
    end
end

extra_modifiers["d2d_rapidfire_salvo"] = function()
    local old_fire_rate_wait = c.fire_rate_wait
    c.fire_rate_wait = c.fire_rate_wait * 0.25
    -- current_reload_time = current_reload_time + ( old_fire_rate_wait * 0.375 )
    current_reload_time = current_reload_time + ( old_fire_rate_wait * 0.75 )
end

extra_modifiers["d2d_spray_and_pray"] = function()
    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
    local wand = EZWand.GetHeldWand()

    if wand and wand.shuffle then
        c.fire_rate_wait = c.fire_rate_wait * 0.25
        current_reload_time = current_reload_time * 0.5
        wand.mana = wand.mana + 10
    end
end
    
extra_modifiers["d2d_fairy_friend"] = function()
    local x, y = EntityGetTransform( get_player() )
    local nearby_fairies = EntityGetInRadiusWithTag( x, y, 160, "fairy" )

    if ( #nearby_fairies > 0 ) then
        c.damage_projectile_add = c.damage_projectile_add + ( 0.04 * #nearby_fairies )
    end
end