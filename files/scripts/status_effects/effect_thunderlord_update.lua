dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local is_immune_to_electricity = GameHasFlagRun("PERK_PICKED_PROTECTION_ELECTRICITY") and not GameHasFlagRun( "PERK_PICKED_ELECTRICITY" )
local electrocuted_effect_count = GameGetGameEffectCount( owner, "ELECTROCUTION" )

local extra_boost_timer = getInternalVariableValue( owner, "thunderlord_extra_boost_timer", "value_int" )
if( not is_immune_to_electricity and electrocuted_effect_count > 0 ) then
    setInternalVariableValue( owner, "thunderlord_extra_boost_timer", "value_int", extra_boost_timer + 2 )
    GamePrint("charging... " .. extra_boost_timer)
end

if ( electrocuted_effect_count > 0 ) then return end -- don't execute the rest of this script if the player is executed



local is_effect_active = getInternalVariableValue( owner, "thunderlord_is_effect_active", "value_int" )
if ( extra_boost_timer > 0 ) then

    if ( is_effect_active == 0 ) then

        setInternalVariableValue( owner, "thunderlord_is_effect_active", "value_int", 1 )

        multiply_move_speed( owner, "thunderlord", 2.0 )
        local effect_id = EntityAddComponent( owner, "ShotEffectComponent", { extra_modifier = "ctq_thunderlord_boost_plus" } )
        setInternalVariableValue( owner, "thunderlord_shot_effect_id", "value_int", effect_id )

    end

    setInternalVariableValue( owner, "thunderlord_extra_boost_timer", "value_int", extra_boost_timer - 1 )

elseif ( is_effect_active == 1 ) then -- i.e. if extra_boost_timer is 0 and the effect is still active

    setInternalVariableValue( owner, "thunderlord_is_effect_active", "value_int", 1 )

    EntityRemoveComponent( owner, getInternalVariableValue( owner, "thunderlord_shot_effect_id", "value_int" ) )
    setInternalVariableValue( owner, "thunderlord_is_effect_active", "value_int", 0 )
    reset_move_speed( owner, "thunderlord" )

end

-- if ( is_immune_to_electricity ) then
--     remove_perk( "CTQ_THUNDERLORD" )
-- end