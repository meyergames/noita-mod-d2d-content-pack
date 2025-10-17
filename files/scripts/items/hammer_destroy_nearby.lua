dofile_once( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x,y = EntityGetTransform( entity_item )

	local small_hammer_id = EntityGetInRadiusWithTag( x, y, 128, "temple_hammer_small" )[1]
	if small_hammer_id then
		EntityKill( small_hammer_id )
	end

	local hammer_id = EntityGetInRadiusWithTag( x, y, 128, "temple_hammer" )[1]
	if hammer_id then
		local spx,spy = EntityGetTransform( hammer_id )
		if ModIsEnabled( "disable-auto-pickup" ) then
			EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer_small_manual_pickup.xml", spx, spy )
		else
			EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer_small.xml", spx, spy )
		end

		EntityKill( hammer_id )
	end
end