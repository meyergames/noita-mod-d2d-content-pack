dofile_once( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x,y = EntityGetTransform( entity_item )

	local perk_id = EntityGetInRadiusWithTag( x, y, 128, "perk" )[1]
	if perk_id then EntityKill( perk_id ) end
end