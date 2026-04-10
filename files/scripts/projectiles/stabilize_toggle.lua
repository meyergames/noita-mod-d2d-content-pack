
function enabled_changed( entity_id, is_enabled )
	GlobalsSetValue( "d2d_try_stabilize_wand", tostring( is_enabled ) )
end
