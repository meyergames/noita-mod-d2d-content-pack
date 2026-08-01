dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function item_pickup( entity_item, entity_pickupper, item_name )
	local is_obliteration = EntityHasTag( entity_item, "d2d_staff_of_obliteration" )
	on_staff_of_curses_picked_up( entity_item, entity_pickupper, is_obliteration )
end