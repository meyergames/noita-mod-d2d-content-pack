dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local existing_shields = EntityGetWithTag( "d2d_health_cap_shield" )
if exists( existing_shields ) then
	local radius = math.max( 16 - ( 2 * #existing_shields ), 10 )

	local shield_comp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "EnergyShieldComponent" )
	if exists( shield_comp ) then
		ComponentSetValue2( shield_comp, "energy", 4 )
		ComponentSetValue2( shield_comp, "radius", radius )
	end
	local particle_comps = EntityGetComponent( GetUpdatedEntityID(), "ParticleEmitterComponent" )
	if exists( particle_comps ) and #particle_comps > 0 then
		for i,particle_comp in ipairs( particle_comps ) do
			ComponentSetValue2( particle_comp, "area_circle_radius", radius, radius )
		end
	end
end