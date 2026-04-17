dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

if not is_fire_pressed() and not is_alt_fire_pressed() and GlobalsGetValue( "D2D_RESTART_POINT_ACTIVE", "0" ) == "1" then
	GlobalsSetValue( "D2D_RESTART_POINT_ACTIVE", "0" )
	trigger_wand_refresh( EZWand.GetHeldWand() )
end
