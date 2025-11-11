dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = entity_id
local x, y = EntityGetTransform( owner )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    if entity_thats_responsible == get_player() then
		-- if the damage comes from the player, "teleport" the cat away
		EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
		EntityKill( owner )
		GamePrint( "You scared the cat away... :(" )
        return 0, critical_hit_chance
    elseif damage > 0 then
		return 0, critical_hit_chance
    end
end