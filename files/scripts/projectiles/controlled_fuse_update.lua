dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

if not is_fire_pressed() and not is_alt_fire_pressed() then
	EntityKill( GetUpdatedEntityID() )
	set_internal_bool( get_player(), "is_fuse_being_controlled", false )
end
