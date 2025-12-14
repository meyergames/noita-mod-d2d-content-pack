dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )

raise_internal_int( owner, "glass_shard_stacks", 1 )
set_internal_int( owner, "glass_shard_detonate_timer", 20 )
