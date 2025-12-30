dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local shard_entity = GetUpdatedEntityID()
local owner = EntityGetParent( shard_entity )
local x, y = EntityGetTransform( owner )

local timer = get_internal_int( owner, "glass_shard_detonate_timer" )
if timer then
	set_internal_int( owner, "glass_shard_detonate_timer", timer - 1 )

	if timer - 1 == 0 then
		local stacks = get_internal_int( owner, "glass_shard_stacks" )
		set_internal_int( owner, "glass_shard_stacks", 0 )

		-- inflict damage and play sound
		local postponed_dmg = get_internal_float( owner, "d2d_glass_shard_bonus_dmg" ) or 0
		set_internal_float( owner, "d2d_glass_shard_bonus_dmg", 0 )

		local dmg = ( stacks * 0.28 ) + postponed_dmg
	    EntityInflictDamage( owner, dmg, "DAMAGE_SLICE", "glass shards", "NORMAL", 0, 0, owner, x, y, 0)
	    if dmg >= 1.2 and dmg < 4 then
			GamePlaySound( "data/audio/Desktop/materials.bank", "collision/glass_potion/destroy", x, y )
		elseif dmg >= 4 then
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

	    -- remove all stacks
		EntityKill( shard_entity )
	end
elseif owner and owner ~= 0 then
	set_internal_int( owner, "glass_shard_detonate_timer", 20 )
end
