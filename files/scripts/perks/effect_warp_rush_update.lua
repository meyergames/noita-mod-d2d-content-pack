dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( owner )

local rush_timer = get_internal_int( owner, "d2d_warp_rush_timer" )
if rush_timer and rush_timer > 0 then
	set_internal_int( owner, "d2d_warp_rush_timer", rush_timer - 1 )
	if rush_timer - 1 == 0 then
		reset_move_speed( owner, "d2d_warp_rush" )
	end
end

-- if the player's position changed more than reasonable for normal movement, apply rush effect
local last_pos_x = get_internal_float( owner, "d2d_warp_rush_last_pos_x" )
local last_pos_y = get_internal_float( owner, "d2d_warp_rush_last_pos_y" )

if last_pos_x then
	local platf_comp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterPlatformingComponent" )
	if platf_comp then
		local fall_velocity = ComponentGetValue2( platf_comp, "velocity_max_y" )
		local velocity_max_x = ComponentGetValue2( platf_comp, "velocity_max_x" )

		local dist = get_distance( x, y, last_pos_x, last_pos_y )
		local threshold = ( fall_velocity / 60.0 ) * 3

		if dist > threshold * 1.1 then
			if rush_timer == 0 then
				local increase = 1.4 * get_perk_pickup_count( "D2D_WARP_RUSH" )
				multiply_move_speed( owner, "d2d_warp_rush", 1.0 + increase, 1.0 + ( increase * 0.5 ) )
			end
			
			set_internal_int( owner, "d2d_warp_rush_timer", 8 )
		    GamePlaySound( "data/audio/Desktop/misc.bank", "misc/telekinesis/grab_complete", x, y )
		end
	end
end

-- save variables for next frame
set_internal_float( owner, "d2d_warp_rush_last_pos_x", x )
set_internal_float( owner, "d2d_warp_rush_last_pos_y", y )