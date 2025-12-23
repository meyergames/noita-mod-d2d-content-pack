dofile_once( "data/scripts/lib/utilities.lua" )

local shard_entity = GetUpdatedEntityID()
local owner = EntityGetParent( shard_entity )
local x, y = EntityGetTransform( owner )

function shatter()
	local timer = get_internal_int( owner, "glass_shard_detonate_timer" )
	if timer then
		set_internal_int( owner, "glass_shard_detonate_timer", timer - 1 )

		if timer - 1 == 0 then
			local stacks = get_internal_int( owner, "glass_shard_stacks" )

		    EntityInflictDamage( owner, stacks * 0.28, "DAMAGE_SLICE", "glass shards", "NONE", 0, 0, owner, x, y, 0)
		    if stacks >= 5 and stacks < 15 then
				GamePlaySound( "data/audio/Desktop/materials.bank", "collision/glass_potion/destroy", x, y )
			elseif stacks >= 15 then
				GamePlaySound( "data/audio/Desktop/materials.bank", "collision/lantern/destroy", x, y )
			end

			-- shoot shards around
			for i = 1, stacks do
			    SetRandomSeed( x, y+i )
			    local rdir_x, rdir_y = vec_rotate( 0, 1, Randomf( -math.pi, math.pi ) )
			    local proj_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/glass_shard.xml", x, y )
			    local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
			    if proj_comp then
			    	ComponentSetValue2( proj_comp, "speed_min", 50 )
			    end

				GameShootProjectile( owner, x, y, x+rdir_x, y+rdir_y, proj_id )
				-- GameShootProjectile( owner, x, y, x+rdir_x, y+rdir_y, EntityLoad( "data/entities/projectiles/deck/light_bullet.xml", x, y ) )
				-- TODO: make the shooter the source of the projectile, somehow
			end

		    -- remove all stacks
			set_internal_int( owner, "glass_shard_stacks", 0 )
			EntityKill( shard_entity )
		end
	else
		set_internal_int( owner, "glass_shard_detonate_timer", 20 )
	end
end

shatter()

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	shatter()
end