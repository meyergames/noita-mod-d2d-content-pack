dofile_once( "data/scripts/lib/utilities.lua" )

local old_generate_gun = generate_gun
function generate_gun( cost, level, force_unshuffle )
    old_generate_gun( cost, level, force_unshuffle )

	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local biome_name = BiomeMapGetName( x, y )
	local y_to_check = y
	while ( string.find( biome_name, "holy" ) ) do
		biome_name = BiomeMapGetName( x, y_to_check )
		y_to_check = y_to_check + 300
	end
	
	addNewInternalVariable( entity_id, "home_biome", "value_string", biome_name )
	addNewInternalVariable( entity_id, "pickup_pos_x", "value_int", x )
	addNewInternalVariable( entity_id, "pickup_pos_y", "value_int", y )
end