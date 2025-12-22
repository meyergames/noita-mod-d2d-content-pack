dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

function wand_fired( gun_entity_id )
	local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if dmg_comp then

		local phase = get_internal_int( entity_id, "d2d_ancient_lurker_phase" )
		local shield_alpha = 0
		if phase and phase == 2 then
			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", 0.4 )
			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", 2.0 )
			shield_alpha = 0
		elseif phase and phase == 3 then
			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", 0.1 )
			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", 2.0 )
			shield_alpha = 0.33
		end

		local children = EntityGetAllChildren( entity_id )
		if children then
			GamePrint("test 1")
			for i,child in ipairs( children ) do
				if EntityHasTag( child, "d2d_ancient_lurker_shield" ) then
					GamePrint("test 2")
					local shield_comp = EntityGetFirstComponentIncludingDisabled( child, "EnergyShieldComponent" )
					if shield_comp then
						GamePrint("test 3")
						ComponentSetValue2( shield_comp, "energy", shield_alpha * 6 )
						ComponentSetValue2( shield_comp, "max_energy", shield_alpha * 6 )
					end

					local ptc_comps = EntityGetComponentIncludingDisabled( child, "ParticleEmitterComponent" )
					if ptc_comps and #ptc_comps > 0 then
						GamePrint("test 4")
						for i,ptc_comp in ipairs( ptc_comps ) do
							ComponentSetValue2( ptc_comp, "custom_alpha", shield_alpha )
						end
					end
				end
			end
		end
	end
end