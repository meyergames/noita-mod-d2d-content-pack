
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	EntityLoad( "mods/D2DContentPack/files/entities/misc/portal_ring_of_returning.xml", x, y )
end