dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	if entity_thats_responsible ~= get_player() then return end

    for _,dcomp in ipairs( EntityGetComponent( get_player(), "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

		if damage >= hp then
			local x, y = EntityGetTransform( player_id )
			EntityLoad( "mods/D2DContentPack/files/entities/misc/shock_absorbed_effect.xml", x, y )
			GamePrint( "Your safety goggles protect you from... yourself." )
			
			-- make the player stay at 1 hp
			ComponentSetValue2( dcomp, "hp", damage + 0.04 )
		end
	end
end