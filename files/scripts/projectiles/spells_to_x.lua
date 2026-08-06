dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetWithTag( "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs( projectiles ) do
		local tags = EntityGetTags( projectile_id )
		
		if ( tags == nil ) or ( string.find( tags, "death_cross" ) == nil ) then
			local px, py = EntityGetTransform( projectile_id )
			
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local vcomp = EntityGetFirstComponent( projectile_id, "VelocityComponent" )
			
			local vx, vy = 0, 0
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs( projectilecomponents ) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			if ( vcomp ~= nil ) then
				vx, vy = vec_normalize( ComponentGetValue2( vcomp, "mVelocity" ) )
			end

			
			local file = get_internal_string( get_player(), "d2d_spells_to_x_target_spell" )
			if exists( file ) then
				local copy_id = shoot_projectile_from_projectile( projectile_id, file, px, py, 0, 0 )

				local proj_speed = 0
				local proj_comp = EntityGetFirstComponentIncludingDisabled( copy_id, "ProjectileComponent" )
				if exists( proj_comp ) then
					local speed_min = ComponentGetValue2( proj_comp, "speed_min" )
					local speed_max = ComponentGetValue2( proj_comp, "speed_max" )
					if exists( speed_min) and exists( speed_max ) then
						proj_speed = Random( speed_min, speed_max )
					end
				end
				
				local vcomp = EntityGetFirstComponentIncludingDisabled( copy_id, "VelocityComponent" )
				if exists( vcomp ) then
					ComponentSetValue2( vcomp, "mVelocity", vx * proj_speed, vy * proj_speed )
				end
			end
			EntityKill( projectile_id )
		end
	end
end