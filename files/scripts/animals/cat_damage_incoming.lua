dofile_once( "data/scripts/lib/utilities.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    if entity_thats_responsible == get_player() then
    	local cat_id = GetUpdatedEntityID()
		local cx, cy = EntityGetTransform( cat_id )

    	GamePrint( cat_id .. " (" .. EntityGetFilename( cat_id ) .. ")" )

		-- if the damage comes from the player, "teleport" the cat away
		EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", cx, cy )
		EntityKill( cat_id ) -- they're not really dead... right?
		GamePrint( "You scared the cat away... :(" )

        return 0, critical_hit_chance
    elseif damage > 0 then
		return 0, critical_hit_chance
    end
end