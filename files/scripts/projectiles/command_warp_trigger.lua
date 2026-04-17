dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
local px, py = EntityGetTransform( get_player() )

local dir_x = px - x
local dir_y = py - y
dir_x, dir_y = vec_normalize( dir_x, dir_y )

local nearby_enemies = EntityGetInRadiusWithTag( px, py, 200, "homing_target" )
for i,enemy in ipairs( nearby_enemies ) do

	local was_teleport_prepared = get_internal_bool( enemy, "d2d_command_warp_prepared" )
    if was_teleport_prepared then
    	EntitySetTransform( enemy, x + dir_x * 20, y + dir_y * 20 )

    	-- reset velocity
    	local vcomp = EntityGetFirstComponent( enemy, "VelocityComponent" )
    	if exists( vcomp ) then
	    	ComponentSetValueVector2( vcomp, "mVelocity", 0, 0 )
	    end

    	-- play teleport effects
		EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
		GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/teleport/destroy", x, y )

		-- disable the 'flag'
		set_internal_bool( enemy, "d2d_command_warp_prepared", false )
    end
end
