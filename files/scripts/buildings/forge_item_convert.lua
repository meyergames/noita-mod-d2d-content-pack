dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local pos_x, pos_y = EntityGetTransform( GetUpdatedEntityID() )
local converted_d2d = false

for _,id in pairs( EntityGetInRadiusWithTag( pos_x, pos_y, 70, "d2d_starting_wand" ) or {} ) do
	GamePrint("TRIED pt.2")
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity( id ) == id then
		local x, y = EntityGetTransform( id )

		spawn_staff_of_loyalty( x, y - 10, id )

		EntityLoad( "data/entities/projectiles/explosion.xml", x, y - 10 )
		EntityKill( id )
		converted_d2d = true
	end
end

if converted_d2d then
	GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
	GameTriggerMusicEvent( "music/oneshot/dark_01", true, pos_x, pos_y )
end
