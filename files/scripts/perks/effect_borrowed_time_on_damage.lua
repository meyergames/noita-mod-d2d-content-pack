dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	if EntityHasTag( entity_thats_responsible, "d2d_perk_borrowed_time" ) then return end

	local player = GetUpdatedEntityID()
    for _,dcomp in ipairs( EntityGetComponent( player, "DamageModelComponent" ) or {} ) do
    	-- first do x2 since it was ÷2 in on_damage_incoming
    	-- then do * 0.5 because only half of the damage taken needs to be stored
    	-- this cancels each other out, but still nice to have it here to remember how it works
		raise_internal_float( player, "d2d_borrowed_time_stored_dmg", damage * 2 * 0.5 )
	end
end
