dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/projectiles/beacon_utils.lua" )

local config_hide_distance_threshold = ModSettingGet( "D2DContentPack.beacon_hide_distance_threshold" )

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
pos_y = pos_y - 4 -- offset to middle of character

local indicator_distance = 32

local beacons_data = GlobalsGetValue( "d2d_beacons_data" )
if beacons_data then
	local split_values = split_string( beacons_data, "," )
	for _,split_value in pairs( split_values ) do
		local beacon_data = split_string( split_value, "|" )
		local colour_index = tonumber( beacon_data[1] )
		local beacon_x = beacon_data[2]
		local beacon_y = beacon_data[3]

		if( IsPlayer( parent ) == false ) then
			local dir_x = beacon_x - pos_x
			local dir_y = beacon_y - pos_y
			local distance = get_magnitude(dir_x, dir_y)

			-- if enabled via mod settings, hide beacons that are too far away
			if config_hide_distance_threshold == 0 or distance < config_hide_distance_threshold then

				-- sprite positions around character
				dir_x,dir_y = vec_normalize(dir_x,dir_y)
				local indicator_x = pos_x + dir_x * indicator_distance
				local indicator_y = pos_y + dir_y * indicator_distance

				local colour_name = colours[ colour_index ]
				if not colour_name then colour_name = "pink" end

				if distance > 500 then
					GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/indicator_" .. colour_name .. "_faint.png", indicator_x, indicator_y )
				elseif distance > 250 then
					GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/indicator_" .. colour_name .. "_medium.png", indicator_x, indicator_y )
				else
					GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/indicator_" .. colour_name .. "_strong.png", indicator_x, indicator_y )
				end
				
			end
		end
	end
end
