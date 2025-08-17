dofile_once("data/scripts/lib/utilities.lua")

extra_modifiers["ctq_bomberman_boost"] = function()
	if( not GameHasFlagRun("PERK_PICKED_PROTECTION_EXPLOSION") and not GameHasFlagRun( "PERK_PICKED_EXPLODING_CORPSES" ) ) then
		c.extra_entities = c.extra_entities .. "mods/cheytaq_first_mod/files/entities/projectiles/deck/hitfx_bomberman_impact.xml,"
		c.explosion_radius = c.explosion_radius + 15.0
		c.damage_explosion_add = c.damage_explosion_add + 0.4
		c.knockback_force = c.knockback_force + 5.0
		shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
    end
end

extra_modifiers["ctq_thunderlord_boost"] = function()
    if( not GameHasFlagRun("PERK_PICKED_PROTECTION_ELECTRICITY") and not GameHasFlagRun( "PERK_PICKED_ELECTRICITY" ) ) then
		c.lightning_count = c.lightning_count + 1
		c.damage_electricity_add = c.damage_electricity_add + 0.1
		c.extra_entities = c.extra_entities .. "data/entities/particles/electricity.xml,"
        
		c.speed_multiplier = c.speed_multiplier * 2
--        c.action_mana_drain = (c.action_mana_drain / 4) * 3
		c.fire_rate_wait   = (c.fire_rate_wait / 4) * 3
	    current_reload_time = (current_reload_time / 4) * 3
    end
end

extra_modifiers["ctq_pyrelord_boost"] = function()
    local is_immune_to_fire = GameHasFlagRun( "PERK_PICKED_PROTECTION_FIRE" ) or GameHasFlagRun( "PERK_PICKED_BLEED_OIL" ) or GameHasFlagRun( "PERK_PICKED_FREEZE_FIELD" )
    if( not is_immune_to_fire ) then
--    	c.explosion_radius = c.explosion_radius + 10
--    	c.damage_explosion_add = c.damage_explosion_add + 0.2
	    c.damage_fire_add = c.damage_fire_add + 0.2
		c.extra_entities = c.extra_entities .. "data/entities/misc/burn.xml," .. "mods/cheytaq_first_mod/files/entities/projectiles/deck/hitfx_pyrelord_impact.xml,"
--        c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_on_fire.xml,"
--	    c.extra_entities = c.extra_entities .. "data/particles/smoke_orange.xml"

--        if( c.damage_fire_add > 0 ) then
--            c.action_mana_drain = 0
--        end
        
--	    c.speed_multiplier = c.speed_multiplier * 2
--	    c.fire_rate_wait   = (c.fire_rate_wait / 4) * 2
--        current_reload_time = (current_reload_time / 4) * 2
    end
end

extra_modifiers["ctq_pyrelord_boost_plus"] = function()
	c.damage_fire_add = c.damage_fire_add + 0.4

	c.fire_rate_wait   = (c.fire_rate_wait / 4) * 3
    current_reload_time = (current_reload_time / 4) * 3
end
