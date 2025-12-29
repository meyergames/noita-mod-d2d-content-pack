dofile_once( "data/scripts/lib/utilities.lua" )

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
			if Random( 1, 4 ) ~= 1 then
		    	SetRandomSeed( x, y+i )
			    local rdir_x, rdir_y = vec_rotate( 0, 1, Randomf( -math.pi, math.pi ) )
			    local proj_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/glass_shard_ejected.xml", x, y )
				GameShootProjectile( owner, x, y, x+rdir_x, y+rdir_y, proj_id )
			end
			-- GameShootProjectile( owner, x, y, x+rdir_x, y+rdir_y, EntityLoad( "data/entities/projectiles/deck/light_bullet.xml", x, y ) )
			-- TODO: make the shooter the source of the projectile, somehow?
		end

	    -- remove all stacks
		EntityKill( shard_entity )
	end
elseif owner and owner ~= 0 then
	set_internal_int( owner, "glass_shard_detonate_timer", 20 )
end
