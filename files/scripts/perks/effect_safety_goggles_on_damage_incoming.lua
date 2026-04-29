dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local player_id = GetUpdatedEntityID()

    for _,dcomp in ipairs( EntityGetComponent( player_id, "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

		if entity_thats_responsible == player_id and damage > hp then

			local x, y = EntityGetTransform( player_id )
			EntityLoad( "mods/D2DContentPack/files/entities/misc/shock_absorbed_effect.xml", x, y )
			GamePrint( "Your safety goggles protect you from... yourself." )

			local capped_damage = math.min( hp - 0.04, damage )
			GamePrint( capped_damage )
			return capped_damage, critical_hit_chance
		end
	end

	return damage, critical_hit_chance
end
