dofile_once( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x,y = EntityGetTransform( entity_item )
	local courier_perk_count = get_perk_pickup_count( "D2D_SPELL_COURIER" )

	-- local chance_to_fail = 1.0 / ( 1 + courier_perk_count )
	-- if Random( 0.0, 1.0 ) >= chance_to_fail then
	-- local chance = 0.16 + ( 0.17 * courier_perk_count )
	local chance = 0.5
	if Random( 0.0, 1.0 ) <= chance then
		dofile( "data/scripts/items/generate_shop_item.lua" )
		generate_shop_item_old( x, y, true, nil, true )

		-- delete the just-spawned sale indicator
		local spawned_entities = EntityGetInRadius( x, y, 3 )
		if spawned_entities then
			for i,entity_id in ipairs( spawned_entities ) do
				local filename = EntityGetFilename( entity_id )
				if filename == "data/entities/misc/sale_indicator.xml" then
					EntityKill( entity_id )
				end
			end
		end

		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/rat/damage/projectile", x, y )
	end
end