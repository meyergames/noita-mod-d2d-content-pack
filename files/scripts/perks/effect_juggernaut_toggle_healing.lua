dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local perk_entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( perk_entity_id )
local x, y = EntityGetTransform( owner )
local current_biome_name = BiomeMapGetName( x, y )

-- disable or enable healing, based on whether the player is in a HM
local enable_healing = false
if string.find( current_biome_name, "holy" ) then
	enable_healing = true
end

-- check if the state of healing has changed
local previous_state = get_internal_bool( perk_entity_id, "d2d_juggernaut_was_healing_enabled" )
local state_changed = ( enable_healing ~= previous_state )
if not state_changed then return end
set_internal_bool( perk_entity_id, "d2d_juggernaut_was_healing_enabled", enable_healing )

-- get the player's damage comp
local dmgcomp = EntityGetFirstComponent( owner, "DamageModelComponent" )
if not exists( dmgcomp ) then return end

-- do the actual changing
if enable_healing then
	ComponentObjectSetValue2( dmgcomp, "damage_multipliers", "healing", 1 )
	GamePrint( "Upon entering the Holy Mountain, Juggernaut's heal block was temporarily lifted." )
else
	ComponentObjectSetValue2( dmgcomp, "damage_multipliers", "healing", 0 )
	GamePrint( "Upon leaving the Holy Mountain, Juggernaut's heal block returns to you." )
end
