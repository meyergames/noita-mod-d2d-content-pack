dofile_once("data/scripts/lib/utilities.lua")

local CONVERT_RADIUS = 8

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local is_on_ground = ComponentGetValue2( cdatacomp, "is_on_ground" )

local matconv_lavarock_id = getInternalVariableValue( owner, "floor_is_lava_matconv_lavarock_id", "value_int" )
local matconv_lavarockburning_id = getInternalVariableValue( owner, "floor_is_lava_matconv_lavarockburning_id", "value_int" )
local matconv_lava_id = getInternalVariableValue( owner, "floor_is_lava_matconv_lava_id", "value_int" )

local old_val = getInternalVariableValue( owner, "floor_is_lava_counter", "value_int" )
local new_val = 0
if ( is_on_ground ) then
    new_val = old_val + 1
else
	new_val = math.max( old_val - 2, 0 )
end
setInternalVariableValue( owner, "floor_is_lava_counter", "value_int", new_val )

local counter = getInternalVariableValue( owner, "floor_is_lava_counter", "value_int" )
if ( counter < 24 ) then
	ComponentSetValue2( matconv_lavarock_id, "radius", 0 )
	ComponentSetValue2( matconv_lavarockburning_id, "radius", 0 )
	ComponentSetValue2( matconv_lava_id, "radius", 0 )
elseif ( counter >= 24 and counter < 36 ) then
	ComponentSetValue2( matconv_lavarock_id, "radius", CONVERT_RADIUS )
	ComponentSetValue2( matconv_lavarockburning_id, "radius", 0 )
	ComponentSetValue2( matconv_lava_id, "radius", 0 )
elseif ( counter >= 36 and counter < 42 ) then
	ComponentSetValue2( matconv_lavarock_id, "radius", 0 )
	ComponentSetValue2( matconv_lavarockburning_id, "radius", CONVERT_RADIUS )
	ComponentSetValue2( matconv_lava_id, "radius", 0 )
elseif ( counter >= 42 ) then
	ComponentSetValue2( matconv_lavarock_id, "radius", 0 )
	ComponentSetValue2( matconv_lavarockburning_id, "radius", 0)
	ComponentSetValue2( matconv_lava_id, "radius", CONVERT_RADIUS )
end



--if ( comp ~= nil ) then
--	local old_mtp = ComponentObjectGetValue2( comp, "damage_multipliers", "fire" )
--	local new_mtp = old_mtp * -0.1
--    GamePrint("mtp old: " .. old_mtp)
--	ComponentObjectSetValue2( comp, "damage_multipliers", "fire", new_mtp )
--    GamePrint("mtp new: " .. ComponentObjectGetValue2( comp, "damage_multipliers", "fire" ) )
--end
