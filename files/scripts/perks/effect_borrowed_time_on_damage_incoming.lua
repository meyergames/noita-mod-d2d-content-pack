dofile_once( "data/scripts/lib/utilities.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local owner = GetUpdatedEntityID()

	-- reduce the player's max hp by 5% of damage dealt
    for _,dcomp in ipairs( EntityGetComponent( owner, "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )
		ComponentSetValue2( dcomp, "max_hp", max_hp - ( damage * 0.1 ) )
	end

	-- reduce the direct damage by 25%
    return damage * 0.75, critical_hit_chance
end