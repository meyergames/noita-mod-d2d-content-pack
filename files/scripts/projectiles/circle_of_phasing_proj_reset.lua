dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()

local delay = get_internal_int( proj_id, "d2d_circle_of_phasing_reset_delay" )
if exists( delay ) then
	set_internal_int( proj_id, "d2d_circle_of_phasing_reset_delay", delay - 1 )
	if delay == 1 then
		local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
		if exists( proj_comp ) then
			local init_cww = get_internal_bool( proj_id, "d2d_circle_of_phasing_init_cww" )
			local init_cwe = get_internal_bool( proj_id, "d2d_circle_of_phasing_init_cwe" )
			ComponentSetValue2( proj_comp, "collide_with_world", init_cww )
			ComponentSetValue2( proj_comp, "collide_with_entities", init_cwe )

			local sprite_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "SpriteComponent" )
			if exists( sprite_comp ) then
				local init_alpha = get_internal_float( proj_id, "d2d_circle_of_phasing_init_alpha" )
				ComponentSetValue2( sprite_comp, "alpha", init_alpha )
			end
			local particle_comps = EntityGetComponentIncludingDisabled( proj_id, "ParticleEmitterComponent" )
			if exists( particle_comps ) then
				for i,particle_comp in ipairs( particle_comps ) do
					ComponentSetValue2( particle_comp, "custom_alpha", -1 )
				end
			end
		end
	end
end
