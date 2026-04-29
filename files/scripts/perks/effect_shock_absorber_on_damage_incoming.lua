dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local player_id = GetUpdatedEntityID()

    for _,dcomp in ipairs( EntityGetComponent( player_id, "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

		if damage > hp and damage < hp * 2 and damage > 0.4 then
			local x, y = EntityGetTransform( player_id )
			EntityLoad( "mods/D2DContentPack/files/entities/misc/shock_absorbed_effect.xml", x, y )
			GamePrint( math.ceil( damage * 25 * 0.5 ) .. " damage was absorbed" )

		    return damage * 0.5, critical_hit_chance
		end
	end

	return damage, critical_hit_chance
end