dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/projectiles/beacon_utils.lua" )

local old_interacting = interacting
function interacting( entity_who_interacted, entity_interacted, interactable_name )
	local x, y = EntityGetTransform( entity_interacted )
	beacon_next_colour( x, y )
end