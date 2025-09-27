dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
pos_y = pos_y - 4 -- offset to middle of character

local indicator_distance = 24

for _,beacon_id in pairs( EntityGetWithTag( "d2d_beacon" ) ) do
	local beacon_x, beacon_y = EntityGetTransform( beacon_id )
	local parent = EntityGetRootEntity( beacon_id )

	if( IsPlayer( parent ) == false ) then

		local dir_x = beacon_x - pos_x
		local dir_y = beacon_y - pos_y
		local distance = get_magnitude(dir_x, dir_y)

		-- sprite positions around character
		dir_x,dir_y = vec_normalize(dir_x,dir_y)
		local indicator_x = pos_x + dir_x * indicator_distance
		local indicator_y = pos_y + dir_y * indicator_distance

		-- display sprite
		local sprite_path = get_internal_int( beacon_id, "beacon_sprite_path" )
		if sprite_path == nil then sprite_path = "mods/D2DContentPack/files/particles/radar_beacon_danger.png" end
		GameCreateSpriteForXFrames( sprite_path, indicator_x, indicator_y )
	end
end
