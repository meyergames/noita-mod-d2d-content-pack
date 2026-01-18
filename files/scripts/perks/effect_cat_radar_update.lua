dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
pos_y = pos_y - 4 -- offset to middle of character

local indicator_distance = 24

for _,grave_id in pairs( EntityGetWithTag( "d2d_afterlife_grave" ) ) do
	local grave_x, grave_y = EntityGetTransform( grave_id )

	local dir_x = grave_x - pos_x
	local dir_y = grave_y - pos_y
	local distance = get_magnitude(dir_x, dir_y)

	-- sprite positions around character
	dir_x,dir_y = vec_normalize(dir_x,dir_y)
	local indicator_x = pos_x + dir_x * indicator_distance
	local indicator_y = pos_y + dir_y * indicator_distance

	-- display sprite based on proximity
	if distance > 5000 then
		GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_grave_faint.png", indicator_x, indicator_y )
	elseif distance > 2500 then
		GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_grave_medium.png", indicator_x, indicator_y )
	elseif distance > 1000 then
		GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_grave_strong.png", indicator_x, indicator_y )
	elseif distance < 50 then
		
	end
end
