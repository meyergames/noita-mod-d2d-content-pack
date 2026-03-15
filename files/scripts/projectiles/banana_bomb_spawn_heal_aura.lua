dofile( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/banana_bomb_heal_aura.xml", x, y )
