dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	if EntityHasTag( entity_thats_responsible, "d2d_perk_borrowed_time" ) then
		return damage, critical_hit_chance
	end

	local player = GetUpdatedEntityID()
    for _,dcomp in ipairs( EntityGetComponent( player, "DamageModelComponent" ) or {} ) do
		return damage * 0.5, critical_hit_chance
	end

    return damage, critical_hit_chance
end