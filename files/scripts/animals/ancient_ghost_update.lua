dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local old_counter = get_internal_int( entity_id, "d2d_ancient_ghost_reset_dmg_multiplier_updates" )
if old_counter and old_counter > 0 then
	set_internal_int( entity_id, "d2d_ancient_ghost_reset_dmg_multiplier_updates", old_counter - 1 )

	if get_internal_int( entity_id, "d2d_ancient_ghost_reset_dmg_multiplier_updates" ) == 0 then
		local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
		if dmg_comp then
			local mtp = 0.1
			local phase = get_internal_int( entity_id, "d2d_ancient_lurker_phase" )
			if not phase or phase < 2 then mtp = 0.25 end
			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", mtp )
        	ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", mtp * 2 )

			local children = EntityGetAllChildren( entity_id )
			if children then
				for i,child in ipairs( children ) do
					if EntityHasTag( child, "d2d_ancient_ghost_shield") then
						local ptc_comps = EntityGetComponentIncludingDisabled( child, "ParticleEmitterComponent" )
						if ptc_comps and #ptc_comps > 0 then
							for i,ptc_comp in ipairs( ptc_comps ) do
							ComponentSetValue2( ptc_comp, "custom_alpha", 0.3 )
							end
						end
					end
				end
			end
		end
	end
end