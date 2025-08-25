dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

local dcomp = EntityGetFirstComponent( owner, "DamageModelComponent" )
if ( dcomp ~= nil ) then
  ComponentSetValue2( dcomp, "falling_damages", true )
end
