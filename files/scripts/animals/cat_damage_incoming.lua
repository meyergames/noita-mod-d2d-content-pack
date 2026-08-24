dofile_once( "data/scripts/lib/utilities.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    if EntityHasTag(entity_thats_responsible, "player_unit") then
    	local cat_id = GetUpdatedEntityID()
		local cx, cy = EntityGetTransform( cat_id )

		-- if the damage comes from the player, "teleport" the cat away
		EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", cx, cy )
		EntityKill( cat_id ) -- they're not really dead... right? --Surely not -K
		GamePrint( "$log_d2d_feline_affection_scared_cat" )

        return 0, critical_hit_chance
    elseif damage > 0 then
		return 0, critical_hit_chance
    end
end