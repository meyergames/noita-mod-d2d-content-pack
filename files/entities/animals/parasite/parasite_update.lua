dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local parasite_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( parasite_id )

local nearby_enemies = EntityGetInRadiusWithTag( x, y, 12, "homing_target" )
if exists( nearby_enemies ) then
	for i,nearby_enemy in ipairs( nearby_enemies ) do
		if nearby_enemy ~= parasite_id then
			dofile_once( "mods/D2DContentPack/files/entities/animals/parasite/parasite_utils.lua" )
			try_infect( nearby_enemy )
		end
	end
end
