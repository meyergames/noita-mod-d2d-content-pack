dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function interacting( entity_who_interacted, entity_interacted, interactable_name )
	local x, y = EntityGetTransform( entity_interacted )
	local ghost = EntityLoad( "mods/D2DContentPack/files/entities/animals/staff_guardian_finality.xml", x, y )

	local shockwave = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/shockwave.xml", x, y - 8 )
	local proj_comp = EntityGetFirstComponent( shockwave, "ProjectileComponent" )
	if proj_comp then
		ComponentObjectSetValue2( proj_comp, "config_explosion", "dont_damage_this", ghost )
	end

	EntityKill( entity_interacted )
end
