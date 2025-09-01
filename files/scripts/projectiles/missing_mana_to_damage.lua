dofile_once( "data/scripts/lib/utilities.lua" )

function shot( entity_id )
    local proj_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "ProjectileComponent" )
	local projectile_mana_drain = ComponentObjectGetValue2( proj_comp, "config", "action_mana_drain" )
	local projectile_cast_delay = ComponentObjectGetValue2( proj_comp, "config", "fire_rate_wait" )

	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
    local wand = EZWand.GetHeldWand()

    local remaining_mana_percent	= ( 1.0 / wand.manaMax ) * wand.mana
	local missing_mana				= wand.manaMax - wand.mana
	local sec_to_recharge_wand		= wand.manaMax / math.max( wand.manaChargeSpeed, 1 ) -- careful for division by zero
    -- local spell_cast_delay			= math.max( c.fire_rate_wait, 0 ) -- sniper bolt is 45
    local missing_mana_percent		= 1.0 - remaining_mana_percent

    local mtp_missing_mana			= 1.0 + ( missing_mana * 0.0015 ) -- at 2000 max mana, this is a x4 mtp
    local mtp_sec_to_recharge		= 1.0 + ( 0.05 * math.min( sec_to_recharge_wand, 60 ) ) -- at 60s for a full recharge: x4 mtp
    local total_mtp					= math.max( mtp_missing_mana * mtp_sec_to_recharge * missing_mana_percent, 1.0 ) -- max mtp: x16

	-- c.extra_entities				= c.extra_entities .. "data/entities/particles/tinyspark_blue_large.xml,"
    -- c.fire_rate_wait    			= c.fire_rate_wait + ( missing_mana_percent * 20 ) -- max 20
    -- c.knockback_force				= c.knockback_force + ( missing_mana_percent * 5 ) -- max 5
	-- shot_effects.recoil_knockback	= shot_effects.recoil_knockback + ( missing_mana_percent * 200 ) -- max 200


	-- increase all damage
	local damage = ComponentGetValue2( proj_comp, "damage" )
	damage = damage * total_mtp
	ComponentSetValue2( proj_comp, "damage", damage )
	local dmg_types = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill", "fire" }
	for i,dmg_type in ipairs( dmg_types ) do
		local v = tonumber(ComponentObjectGetValue( proj_comp, "damage_by_type", dmg_type ))
		v = v * total_mtp
		ComponentObjectSetValue2( proj_comp, "damage_by_type", dmg_type, tonumber( v ) )
	end

	-- spawn trail
	local extra_entities = ComponentObjectGetValue( proj_comp, "config", "extra_entities" )
	extra_entities = extra_entities .. "data/entities/particles/tinyspark_blue_large.xml,"
	if ( remaining_mana_percent <= 0.25 ) then
		extra_entities = extra_entities .. "data/entities/particles/tinyspark_orange.xml,"
	end
	ComponentObjectSetValue2( proj_comp, "config", "extra_entities", tostring( extra_entities ) )

	-- set cast delay
	-- local fire_rate_wait = ComponentObjectGetValue( proj_comp, "config", "fire_rate_wait" )
	-- fire_rate_wait = fire_rate_wait + ( missing_mana_percent * 20 )
	-- ComponentObjectSetValue2( proj_comp, "config", "fire_rate_wait", fire_rate_wait )
end