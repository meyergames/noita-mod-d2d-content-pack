dofile_once("data/scripts/lib/utilities.lua")

local lurker = EntityGetWithName( "$animal_d2d_ancient_lurker" )
local x, y = EntityGetTransform( lurker )
local distance_full = 48

if get_internal_bool( lurker, "d2d_ancient_lurker_shield_is_active" ) then
	local nearby_creatures = EntityGetInRadiusWithTag( x, y, distance_full, "prey" )
	if nearby_creatures and #nearby_creatures > 0 then
		for i,creature_id in ipairs( nearby_creatures ) do
			EntityInflictDamage( creature_id, 0.4, "DAMAGE_CURSE", "aura", "NONE", 0, 0, lurker )
		end
	end
end