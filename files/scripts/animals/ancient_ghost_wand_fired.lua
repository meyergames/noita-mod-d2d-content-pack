dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

function wand_fired( gun_entity_id )
	local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if dmg_comp then
		ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", 4.0 )
		ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", 8.0 )
		set_internal_int( entity_id, "d2d_ancient_ghost_reset_dmg_multiplier_updates", 10 )

		local children = EntityGetAllChildren( entity_id )
		if children then
			for i,child in ipairs( children ) do
				if EntityHasTag( child, "d2d_ancient_ghost_shield") then
					local ptc_comps = EntityGetComponentIncludingDisabled( child, "ParticleEmitterComponent" )
					if ptc_comps and #ptc_comps > 0 then
						for i,ptc_comp in ipairs( ptc_comps ) do
							ComponentSetValue2( ptc_comp, "custom_alpha", 0 )
						end
					end
				end
			end
		end
	end
end