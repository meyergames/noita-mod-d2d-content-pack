dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

function shot( projectile_entity_id )
	if get_internal_bool( entity_id, "d2d_glass_fist_boost_enabled" ) then
		local pickup_count = get_perk_pickup_count( "D2D_GLASS_FIST" )

		local proj_comp = EntityGetFirstComponent( projectile_entity_id, "ProjectileComponent" )
		local old_dmg = ComponentGetValue2( proj_comp, "damage" )
		multiply_proj_dmg( projectile_entity_id, 3.0 - ( 0.5 ^ ( pickup_count - 1 ) ) )
	end
end
