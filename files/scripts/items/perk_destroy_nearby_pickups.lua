dofile_once( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x,y = EntityGetTransform( entity_item )

	local nearby_pickups = EntityGetInRadiusWithTag( x, y, 128, "drillable" )
	for i,pickup_id in ipairs( nearby_pickups ) do
		EntityKill( pickup_id )
	end
end