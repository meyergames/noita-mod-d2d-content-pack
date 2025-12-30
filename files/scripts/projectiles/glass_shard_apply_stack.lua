dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )

if owner and owner ~= 0 then
	raise_internal_int( owner, "glass_shard_stacks", 1 )
	set_internal_int( owner, "glass_shard_detonate_timer", 10 )
end
