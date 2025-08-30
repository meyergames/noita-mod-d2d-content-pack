dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

local is_immune_to_explosions = has_game_effect( owner, "PROTECTION_EXPLOSION" )
if( is_immune_to_explosions ) then
	if( GameHasFlagRun( "PERK_PICKED_PROTECTION_EXPLOSION" ) ) then
	   remove_perk( "PROTECTION_EXPLOSION" )
	end

	if( GameHasFlagRun( "PERK_PICKED_EXPLODING_CORPSES" ) ) then
	   remove_perk( "EXPLODING_CORPSES" )
	end
end



--if ( comp ~= nil ) then
--	local old_mtp = ComponentObjectGetValue2( comp, "damage_multipliers", "fire" )
--	local new_mtp = old_mtp * -0.1
--    GamePrint("mtp old: " .. old_mtp)
--	ComponentObjectSetValue2( comp, "damage_multipliers", "fire", new_mtp )
--    GamePrint("mtp new: " .. ComponentObjectGetValue2( comp, "damage_multipliers", "fire" ) )
--end
