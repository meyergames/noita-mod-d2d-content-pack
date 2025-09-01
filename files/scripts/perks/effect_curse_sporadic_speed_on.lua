dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

addNewInternalVariable( owner, "sporadic_speed_boost_active", "value_int", 0 )

-- local kcomp = EntityGetComponentIncludingDisabled( owner, "KickComponent" )
-- GamePrint("kcomp: " .. kcomp)
-- if ( kcomp ~= nil ) then
--   local kick_entities = ComponentGetValue2( kcomp, "kick_entities" )
--   ComponentSetValue2( kcomp, "kick_entities", kick_entities .. "mods/D2DContentPack/files/entities/misc/effect_curse_foot_injury_trigger.xml" )
-- end