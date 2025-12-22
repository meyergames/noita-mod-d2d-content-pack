dofile_once( "data/scripts/lib/utilities.lua" )

local existing_cmd_targets = EntityGetWithTag( "cmd_attack_target" )
for i,cmd_target in ipairs( existing_cmd_targets ) do
	EntityKill( cmd_target )
end

local x, y = EntityGetTransform( GetUpdatedEntityID() )
local command_target_id = EntityLoad( "mods/D2DContentPack/files/entities/animals/command_attack_target.xml", x, y+4 )
GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/charm/create", x, y )

-- make all nearby charmed creatures aware of the target
-- local nearby_creatures = EntityGetInRadiusWithTag( x, y, 300, "homing_target" )
-- for i,creature_id in ipairs( nearby_creatures ) do
-- 	if GameGetGameEffect( creature_id, "CHARM" ) ~= 0 then
-- 		local ai_comp = EntityGetFirstComponent( creature_id, "AnimalAIComponent" )
-- 		if ai_comp then
-- 			ComponentSetValue2( ai_comp, "mGreatestThreat", command_target_id )
-- 			ComponentSetValue2( ai_comp, "mGreatestPrey", command_target_id )
-- 			-- ComponentSetValue2( ai_comp, "ai_state", 16 )
-- 			-- ComponentSetValue2( ai_comp, "ai_state_timer", 150 )
-- 		end
-- 	end
-- end
