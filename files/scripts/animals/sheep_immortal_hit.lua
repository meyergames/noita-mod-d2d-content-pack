dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = entity_id
local x, y = EntityGetTransform( owner )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    return 0, 0
end