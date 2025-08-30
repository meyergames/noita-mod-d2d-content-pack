dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local is_immune_to_electricity = has_game_effect( owner, "PROTECTION_ELECTRICITY" )
local electrocuted_effect_count = GameGetGameEffectCount( owner, "ELECTROCUTION" )

local extra_boost_timer = getInternalVariableValue( owner, "master_of_thunder_extra_boost_timer", "value_int" )
if( not is_immune_to_electricity and electrocuted_effect_count > 0 ) then
    setInternalVariableValue( owner, "master_of_thunder_extra_boost_timer", "value_int", extra_boost_timer + 2 )
end

if ( electrocuted_effect_count > 0 ) then return end -- don't execute the rest of this script if the player is executed



local is_effect_active = getInternalVariableValue( owner, "master_of_thunder_is_effect_active", "value_int" )
if ( extra_boost_timer > 0 ) then

    if ( is_effect_active == 0 ) then
        setInternalVariableValue( owner, "master_of_thunder_is_effect_active", "value_int", 1 )

        -- move speed is doubled
        multiply_move_speed( owner, "master_of_thunder", 2.0 )

        -- mana recharges 4x as fast (i.e. +300%)
        setInternalVariableValue( owner, "master_of_thunder_mana_charge_speed_mtp", "value_int", 300 )
        
        -- fire rate is increased further
        local effect_id = EntityAddComponent( owner, "ShotEffectComponent", { extra_modifier = "ctq_master_of_thunder_boost_plus" } )
        setInternalVariableValue( owner, "master_of_thunder_shot_effect_id", "value_int", effect_id )
    end

    setInternalVariableValue( owner, "master_of_thunder_extra_boost_timer", "value_int", extra_boost_timer - 1 )

elseif ( is_effect_active == 1 ) then -- i.e. if extra_boost_timer is 0 and the effect is still active

    setInternalVariableValue( owner, "master_of_thunder_is_effect_active", "value_int", 1 )

    EntityRemoveComponent( owner, getInternalVariableValue( owner, "master_of_thunder_shot_effect_id", "value_int" ) )
    setInternalVariableValue( owner, "master_of_thunder_is_effect_active", "value_int", 0 )
    setInternalVariableValue( owner, "master_of_thunder_mana_charge_speed_mtp", "value_int", 0 )
    reset_move_speed( owner, "master_of_thunder" )

end

-- if ( is_immune_to_electricity ) then
--     remove_perk( "CTQ_MASTER_OF_THUNDER" )
-- end