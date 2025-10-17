dofile_once( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x,y = EntityGetTransform( entity_item )
	local hammer_id = EntityGetInRadiusWithTag( x, y, 128, "temple_hammer" )[1]
	if hammer_id then
		EntityKill( hammer_id )
	end
end