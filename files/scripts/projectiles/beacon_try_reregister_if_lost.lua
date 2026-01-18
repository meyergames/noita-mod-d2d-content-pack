dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "mods/D2DContentPack/files/scripts/projectiles/beacon_utils.lua" )

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
pos_y = pos_y - 4 -- offset to middle of character

local indicator_distance = 32

for i,beacon_id in ipairs( EntityGetWithTag( "d2d_beacon" ) ) do
	local x, y = EntityGetTransform( beacon_id )
	if not get_beacon_by_position( x, y ) then
		beacon_register_global( get_internal_int( beacon_id, "beacon_colour_index" ), x, y )
	end
end
