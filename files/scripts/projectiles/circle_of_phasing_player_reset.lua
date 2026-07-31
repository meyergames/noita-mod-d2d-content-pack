dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local player_id = GetUpdatedEntityID()

local delay = get_internal_int( player_id, "d2d_circle_of_phasing_reset_delay" )
if exists( delay ) and delay > 0 then
	set_internal_int( player_id, "d2d_circle_of_phasing_reset_delay", delay - 1 )
	if delay == 1 then
		make_player_unspooky( player_id )
	end
else
	local damage_tick_speed = get_internal_int( player_id, "d2d_circle_of_phasing_damage_tick_speed" )
	if GameGetFrameNum() % 60 == 0 and exists( damage_tick_speed ) and damage_tick_speed < 60 then
		set_internal_int( player_id, "d2d_circle_of_phasing_damage_tick_speed", math.min( damage_tick_speed + 1, 60 ) )
	end
end
