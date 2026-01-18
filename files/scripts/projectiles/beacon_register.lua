dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/projectiles/beacon_utils.lua" )

EntityAddComponent2( GetUpdatedEntityID(), "PhysicsBodyComponent", {
	_tags="enabled_in_world",
	is_static=true,
} )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
beacon_register_global( get_internal_int( GetUpdatedEntityID(), "beacon_colour_index" ), x, y )
