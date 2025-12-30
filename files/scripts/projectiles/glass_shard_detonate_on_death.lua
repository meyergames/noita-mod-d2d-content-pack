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

			-- 75% chance to spawn a shard
			if Random( 1, 4 ) ~= 1 then
				local rdir_x, rdir_y = 0, 0

				-- 33% chance to aim directly at a random nearby enemy
				local do_random = true
				if Random( 1, 3 ) == 3 then
					local nearby_targets = EntityGetInRadiusWithTag( x, y, 70, "homing_target")
					if exists( nearby_targets ) and #nearby_targets >= 2 then
						local index = Random( 1, #nearby_targets )
						local target = nearby_targets[index]
						-- skip self
						while target == owner do
							index = ( index % #nearby_targets ) + 1
							target = nearby_targets[index]
						end
						local tx, ty = EntityGetTransform( target )
						rdir_x = tx - x
						rdir_y = ty - y
						do_random = false
					end
				end

				-- 66% chance (or if no nearby targets available) to shoot in a random direction
				if do_random then
			    	SetRandomSeed( x, y+i )
				    rdir_x, rdir_y = vec_rotate( 0, 1, Randomf( -math.pi, math.pi ) )
				end

				-- spawn the projectile
			    local proj_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/glass_shard_ejected.xml", x, y )
			    -- if the projectile directly targets someone, set speed to max
				if not do_random then
					local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
					if proj_comp then
						ComponentSetValue2( proj_comp, "speed_min", 850 )
					end
				end
				GameShootProjectile( owner, x, y, x+rdir_x, y+rdir_y, proj_id )
			end
		end
	end
end
