dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = entity_id
local x, y = EntityGetTransform( owner )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    if damage > 0 then
        local nearby_fairies = EntityGetInRadiusWithTag( x, y, 160, "fairy" )
        return math.max( damage - ( #nearby_fairies * 0.04 ), damage * 0.5 ), critical_hit_chance
    else
        return damage, critical_hit_chance
    end
end