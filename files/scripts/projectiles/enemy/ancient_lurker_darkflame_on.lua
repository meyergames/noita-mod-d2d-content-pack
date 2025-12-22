dofile_once("data/scripts/lib/utilities.lua")

local proj_id = GetUpdatedEntityID()

local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then

	local lurker = EntityGetWithName( "Vanhakupla" )
	GamePrint( lurker )
	if lurker then

		local dmg_comp = EntityGetFirstComponent( lurker, "DamageModelComponent" )
		if dmg_comp then

			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", 1.0 )
			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", 2.0 )
			-- local children = EntityGetAllChildren( lurker )
			-- if children then
			-- 	for i,child in ipairs( children ) do
			-- 		if EntityHasTag( child, "d2d_ancient_lurker_shield") then
			-- 			local ptc_comps = EntityGetComponentIncludingDisabled( child, "ParticleEmitterComponent" )
			-- 			if ptc_comps and #ptc_comps > 0 then
			-- 				for i,ptc_comp in ipairs( ptc_comps ) do
			-- 					ComponentSetValue2( ptc_comp, "custom_alpha", 0 )
			-- 				end
			-- 			end
			-- 		end
			-- 	end
			-- end
		end
	end
end