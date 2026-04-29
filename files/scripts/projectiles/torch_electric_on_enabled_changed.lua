dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function enabled_changed( entity_id, is_enabled )
	set_internal_bool( get_player(), "d2d_torch_electric_enabled", is_enabled )
end