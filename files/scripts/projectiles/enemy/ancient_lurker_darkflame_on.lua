dofile_once("data/scripts/lib/utilities.lua")

local lurker = EntityGetWithName( "$animal_d2d_ancient_lurker" )
if not lurker then return end

-- disable explosion damage for lurker
local proj_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
if proj_comp then
	ComponentObjectSetValue2( proj_comp, "config_explosion", "dont_damage_this", lurker )
end

-- toggle shield
local dmg_comp = EntityGetFirstComponent( lurker, "DamageModelComponent" )
if dmg_comp then

	local phase = get_internal_int( lurker, "d2d_ancient_lurker_phase" )
	local enable_shield = true
	if phase and phase == 2 then
		enable_shield = false
	elseif phase and phase == 3 then
		enable_shield = true
	end

	local children = EntityGetAllChildren( lurker )
	if children then
		for i,child in ipairs( children ) do
			if EntityHasTag( child, "d2d_ancient_lurker_shield" ) then
				local ptc_comps = EntityGetComponentIncludingDisabled( child, "ParticleEmitterComponent" )
				if ptc_comps and #ptc_comps > 0 then
					for i,ptc_comp in ipairs( ptc_comps ) do
						local alpha = 0
						if enable_shield then alpha = 1.0 end

						ComponentSetValue2( ptc_comp, "custom_alpha", alpha )
					end
				end
			end
		end
	end

	set_internal_bool( lurker, "d2d_ancient_lurker_shield_is_active", enable_shield )
end

set_internal_bool( lurker, "d2d_ancient_lurker_passed_player", false )
