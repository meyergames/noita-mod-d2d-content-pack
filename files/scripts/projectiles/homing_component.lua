dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local owner_id = 0

local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if ( comp ~= nil ) then
	owner_id = ComponentGetValue2( comp, "mWhoShot" )
end

if ( owner_id ~= nil ) and ( owner_id ~= NULL_ENTITY ) and EntityGetIsAlive( owner_id ) then
	local tx, ty = EntityGetFirstHitboxCenter( owner_id )
    EntitySetVelocity( entity_id, (tx - pos_x)*60, (ty - pos_y)*60 )
end
