dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function shot( projectile_entity_id )
	local player_id = GetUpdatedEntityID()

	local proj_comp = EntityGetFirstComponent( projectile_entity_id, "ProjectileComponent" )
	local old_dmg = ComponentGetValue2( proj_comp, "damage" )

	local dmgcomp = EntityGetFirstComponent( player_id, "DamageModelComponent" )
	if exists( dmgcomp ) then
		local hp = ComponentGetValue2( dmgcomp, "hp" )
		local max_hp = ComponentGetValue2( dmgcomp, "max_hp" )
		local ratio = hp / max_hp

		-- apply a multiplier of 1.0-2.0, based on how much health the player has left
		local mtp = 1.0 + ratio
		multiply_proj_dmg( projectile_entity_id, mtp )
	end
end
