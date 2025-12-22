dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	local hp = ComponentGetValue2( dmg_comp, "hp" )
	local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )

	if hp - damage < max_hp * 0.5 then
		set_internal_int( entity_id, "d2d_ancient_lurker_phase", 2 )

        local new_shield_id = EntityLoad( "mods/D2DContentPack/files/entities/misc/ancient_ghost_shield.xml" )
        ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", 0.1 )
        ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", 1.0 )

        EntityAddChild( entity_id, new_shield_id )
		EntityRemoveComponent( entity_id, GetUpdatedComponentID() )
	end
end