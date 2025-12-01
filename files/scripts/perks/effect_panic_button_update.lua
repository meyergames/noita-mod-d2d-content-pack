dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = entity_id

local timer_1 = get_internal_int( owner, "d2d_panic_button_timer_1" )
if timer_1 and timer_1 > 0 then
	set_internal_int( owner, "d2d_panic_button_timer_1", timer_1 - 1 )
	if timer_1 - 1 == 0 then
		reset_move_speed( owner, "d2d_panic_button_1" )
	end
end

local timer_2 = get_internal_int( owner, "d2d_panic_button_timer_2" )
if timer_2 and timer_2 > 0 then
	set_internal_int( owner, "d2d_panic_button_timer_2", timer_2 - 1 )
	if timer_2 - 1 == 0 then
		reset_move_speed( owner, "d2d_panic_button_2" )
	end
end
