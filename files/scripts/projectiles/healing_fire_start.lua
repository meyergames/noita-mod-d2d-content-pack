dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

comp = EntityGetFirstComponent( get_player(), "DamageModelComponent" )

if ( comp ~= nil ) then
	local old_mtp = ComponentObjectGetValue2( comp, "damage_multipliers", "fire" )
	local new_mtp = old_mtp * -0.5
    GamePrint("mtp old: " .. old_mtp)
	ComponentObjectSetValue2( comp, "damage_multipliers", "fire", new_mtp )
    GamePrint("mtp new: " .. ComponentObjectGetValue2( comp, "damage_multipliers", "fire" ) )
end
