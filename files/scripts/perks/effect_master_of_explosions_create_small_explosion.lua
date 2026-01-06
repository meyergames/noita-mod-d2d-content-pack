dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local expl_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/master_perk_explosion.xml", x, y )
ComponentSetValue2( EntityGetFirstComponent( expl_id, "ProjectileComponent" ), "mWhoShot", entity_id )