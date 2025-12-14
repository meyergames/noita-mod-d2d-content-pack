dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )

local timer = get_internal_int( owner, "glass_shard_detonate_timer" )
if timer then
	set_internal_int( owner, "glass_shard_detonate_timer", timer - 1 )

	if timer - 1 == 0 then
		local stacks = get_internal_int( owner, "glass_shard_stacks" )

		local dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
		local hp = ComponentGetValue2( dcomp, "hp" )
	    EntityInflictDamage( GetUpdatedEntityID(), hp * 0.44, "DAMAGE_SLICE", "glass shards", "NONE", 0, 0, owner, x, y, 0)

	    -- remove all stacks
		set_internal_int( owner, "glass_shard_stacks", 0 )
		EntityRemoveComponent( entity_id, GetUpdatedComponentID() )
	end
else
	set_internal_int( owner, "glass_shard_detonate_timer", 20 )
end