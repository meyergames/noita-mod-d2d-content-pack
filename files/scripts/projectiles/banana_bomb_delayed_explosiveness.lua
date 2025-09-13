dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = entity_id
local x, y = EntityGetTransform( owner )

local pcd_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "PhysicsBodyCollisionDamageComponent" )
local eod_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "ExplodeOnDamageComponent" )

-- ComponentSetValue2( pcd_comp, "enabled", true )
-- ComponentSetValue2( eod_comp, "enabled", true )