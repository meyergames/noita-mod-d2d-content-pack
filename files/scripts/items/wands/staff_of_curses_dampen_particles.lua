dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()

local particle_comps = EntityGetComponent( entity_id, "ParticleEmitterComponent" )
if exists( particle_comps ) then
	for i,particle_comp in ipairs( particle_comps ) do
		ComponentSetValue2( particle_comp, "render_ultrabright", false )
	end
end