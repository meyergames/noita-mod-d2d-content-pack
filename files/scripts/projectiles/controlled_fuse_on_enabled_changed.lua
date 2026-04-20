dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function enabled_changed( entity_id, is_enabled )
	-- disable variable, in case it gets stuck
	if not is_enabled then
		set_internal_bool( get_player(), "is_fuse_being_controlled", false )
	end
end