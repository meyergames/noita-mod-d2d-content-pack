dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

if not GameHasFlagRun( "d2d_poi_spawned_staff_of_light" ) then
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	spawn_staff_of_light( x, y )
	GameAddFlagRun( "d2d_poi_spawned_staff_of_light" )
end