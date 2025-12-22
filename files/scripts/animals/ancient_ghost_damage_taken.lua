dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	local hp = ComponentGetValue2( dmg_comp, "hp" )
	local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )

	-- if projectile_thats_responsible then
	-- 	local filename = EntityGetFilename( projectile_thats_responsible )
	-- 	GamePrint( "lurker took damage from " ..  filename )
	-- end

	local phase = get_internal_int( entity_id, "d2d_ancient_lurker_phase" )
    local ai_comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )

	if phase and phase == 1 and hp - damage < max_hp * 0.667 then
		set_internal_int( entity_id, "d2d_ancient_lurker_phase", 2 )

		local shield_id = EntityLoad( "mods/D2DContentPack/files/entities/misc/ancient_lurker_shield.xml", x, y )
		EntityAddChild( entity_id, shield_id )

        ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", 0.1 )
        ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", 1.0 )
		if ai_comp then
			ComponentSetValue2( ai_comp, "attack_ranged_entity_file", "mods/D2DContentPack/files/entities/projectiles/enemy/ancient_lurker_darkflame_explosive.xml" )
			ComponentSetValue2( ai_comp, "attack_ranged_frames_between", 150 )
		end

	elseif phase and phase == 2 and hp - damage < max_hp * 0.334 then
		set_internal_int( entity_id, "d2d_ancient_lurker_phase", 3 )

        ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", 0.1 )
        ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", 1.0 )

		if ai_comp then
			ComponentSetValue2( ai_comp, "attack_ranged_entity_file", "mods/D2DContentPack/files/entities/projectiles/enemy/ancient_lurker_darkflame_explosive_accelerative.xml" )
			ComponentSetValue2( ai_comp, "attack_ranged_frames_between", 120 )
		end

	end
end