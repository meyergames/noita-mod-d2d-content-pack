dofile_once( "data/scripts/lib/utilities.lua" )

colours = {
	"white",
	"red",
	"orange",
	"yellow",
	"green",
	"cyan",
	"blue",
	"purple",
	"pink",
}

function assign_first_available_colour( beacon_id )
	-- for colour_index=1,#colours do
	-- 	if is_colour_available( colour_index ) then
	-- 		beacon_set_colour( beacon_id, colour_index )
	-- 		return
	-- 	end
	-- end
	beacon_set_colour( beacon_id, 1 )
end

function is_colour_available( colour_index )
	for _,other_beacon_id in pairs( EntityGetWithTag( "d2d_beacon" ) ) do
		local existing_colour_index = get_internal_int( other_beacon_id, "beacon_colour_index" )
		if existing_colour_index and existing_colour_index == colour_index then
			return false
		end
	end

	return true
end

function beacon_set_colour( beacon_id, new_index )
	set_internal_int( beacon_id, "beacon_colour_index", new_index )

	local colour_name = colours[ new_index ]
	set_internal_string( beacon_id, "beacon_colour_name", colour_name )

	local sprite_comp = EntityGetFirstComponentIncludingDisabled( beacon_id, "SpriteComponent" )
	if sprite_comp then
		local x, y = EntityGetTransform( beacon_id )
		ComponentSetValue2( sprite_comp, "image_file", "mods/D2DContentPack/files/gfx/projectiles_gfx/beacon_" .. colour_name .. ".xml" )
	end
end

function beacon_next_colour( x, y )
	local beacon_id = get_beacon_by_position( x, y )
	if not beacon_id then return end

	local current_index = get_internal_int( beacon_id, "beacon_colour_index" )
	if not current_index then current_index = 1 end

	current_index = current_index + 1
	if current_index > #colours then current_index = 1 end
	set_internal_int( beacon_id, "beacon_colour_index", current_index )

	local colour_name = colours[ current_index ]
	set_internal_string( beacon_id, "beacon_colour_name", colour_name )

	local sprite_comp = EntityGetFirstComponentIncludingDisabled( beacon_id, "SpriteComponent" )
	if sprite_comp then
		local x, y = EntityGetTransform( beacon_id )
    	GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/create", x, y )
		ComponentSetValue2( sprite_comp, "image_file", "mods/D2DContentPack/files/gfx/projectiles_gfx/beacon_" .. colour_name .. ".xml" )
	end

	beacon_deregister_global( x, y )
	beacon_register_global( current_index, x, y )
end

function get_beacon_by_position( x, y )
	local beacon_id = EntityGetInRadiusWithTag( x, y, 1, "d2d_beacon" )[1]
	if beacon_id then
		return beacon_id
	end
end

function beacon_register_global( colour_index, x, y )
	local append = colour_index .. "|" .. x .. "|" .. y .. ","
	local data = GlobalsGetValue( "d2d_beacons_data" )
	GlobalsSetValue( "d2d_beacons_data", data .. append )
end

function beacon_deregister_global( x, y )
	local data = GlobalsGetValue( "d2d_beacons_data" )
	local updated_data = ""

	local split_values = split_string( data, "," )
	for _,split_value in pairs( split_values ) do
		local beacon_data = split_string( split_value, "|" )
		local beacon_x = tonumber( beacon_data[2] )
		local beacon_y = tonumber( beacon_data[3] )

		if get_distance( x, y, beacon_x, beacon_y ) > 1 then
			updated_data = updated_data .. beacon_data[1] .. "|" .. beacon_x .. "|" .. beacon_y .. ","
		end
	end

	GlobalsSetValue( "d2d_beacons_data", updated_data )
end
