dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	-- reduce the player's max hp by 10% of damage taken
    for _,dcomp in ipairs( EntityGetComponent( GetUpdatedEntityID(), "DamageModelComponent" ) or {} ) do
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )
		ComponentSetValue2( dcomp, "max_hp", max_hp - ( damage * 0.1 ) )
	end
end