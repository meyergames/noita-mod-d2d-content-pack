dofile_once( "data/scripts/lib/utilities.lua" )

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    local owner = GetUpdatedEntityID()
	local x, y = EntityGetTransform( owner )
	local stacks = get_internal_int( owner, "glass_shard_stacks" )

	if stacks and stacks > 0 then
		-- play sound
	    if stacks >= 5 and stacks < 15 then
			GamePlaySound( "data/audio/Desktop/materials.bank", "collision/glass_potion/destroy", x, y )
		elseif stacks >= 15 then
			GamePlaySound( "data/audio/Desktop/materials.bank", "collision/lantern/destroy", x, y )
		end

		-- shoot shards around
		for i = 1, stacks do
		    SetRandomSeed( x, y+i )
		    local rdir_x, rdir_y = vec_rotate( 0, 1, Randomf( -math.pi, math.pi ) )
		    local proj_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/glass_shard_ejected.xml", x, y )
			GameShootProjectile( nil, x, y, x+rdir_x, y+rdir_y, proj_id )
			-- GameShootProjectile( owner, x, y, x+rdir_x, y+rdir_y, EntityLoad( "data/entities/projectiles/deck/light_bullet.xml", x, y ) )
			-- TODO: make the shooter the source of the projectile, somehow?
		end
	end
end
