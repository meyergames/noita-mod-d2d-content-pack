dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local player_id = GetUpdatedEntityID()

    for _,dcomp in ipairs( EntityGetComponent( player_id, "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

		-- for any hits higher than 10 and higher than 10% of the player's max HP
		if damage > max_hp * 0.2 and damage > 0.4 and not is_fatal then
			local x, y = EntityGetTransform( player_id )
			EntityLoad( "mods/D2DContentPack/files/entities/misc/shock_absorbed_effect.xml", x, y )
			GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )

    		local heal_mtp = ComponentObjectGetValue2( dcomp, "damage_multipliers", "healing" )
			ComponentSetValue2( dcomp, "hp", hp + ( ( damage * 0.5 ) * heal_mtp ) )

			-- ComponentSetValue2( dcomp, "hp", damage * 0.5 )
			GamePrint( math.ceil( damage * 25 * 0.5 ) .. " damage was restored" )
		end
	end
end