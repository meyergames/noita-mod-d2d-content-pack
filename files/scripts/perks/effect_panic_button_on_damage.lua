dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = entity_id
local x, y = EntityGetTransform( owner )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
    if damage > 0 then

    	if entity_thats_responsible ~= 0 then
			local timer = get_internal_int( owner, "d2d_panic_button_timer_1" )
			if timer and timer == 0 then
				local increase = 1.4 * get_perk_pickup_count( "D2D_PANIC_BUTTON" )
				multiply_move_speed( owner, "d2d_panic_button_1", 1.0 + increase, 1.0 + ( increase * 0.5 ) )

		    	GamePlaySound( "data/audio/Desktop/misc.bank", "misc/telekinesis/grab_complete", x, y )
			end

			set_internal_int( owner, "d2d_panic_button_timer_1", 20 )
		else
			local timer = get_internal_int( owner, "d2d_panic_button_timer_2" )
			if timer and timer == 0 then
				local increase = 0.5 * get_perk_pickup_count( "D2D_PANIC_BUTTON" )
				multiply_move_speed( owner, "d2d_panic_button_2", 1.0 + increase, 1.0 + ( increase * 0.5 ) )
			end

			set_internal_int( owner, "d2d_panic_button_timer_2", 4 )
		end
    end
end
