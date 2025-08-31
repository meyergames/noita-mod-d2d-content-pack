dofile( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

-- GameCreateParticle( "concrete_static", x, y, 20, 0, 0, false )
EntityLoad( "mods/RiskRewardBundle/files/entities/projectiles/deck/concrete_ball.xml", x, y )
