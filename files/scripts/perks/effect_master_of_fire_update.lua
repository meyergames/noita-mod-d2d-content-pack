dofile_once("data/scripts/lib/utilities.lua")

local EFFECT_RADIUS = 50

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local is_immune_to_fire = has_game_effect( owner, "PROTECTION_FIRE" )

local on_fire_effect_count = GameGetGameEffectCount( owner, "ON_FIRE" )
local is_effect_active = getInternalVariableValue( owner, "master_of_fire_is_effect_active", "value_int" )

if( not is_immune_to_fire and on_fire_effect_count > 0 ) then

    if( is_effect_active == 0 ) then
        multiply_move_speed( owner, "master_of_fire", 1.33 )
        -- multiply_all_damage( owner, "master_of_fire", 1.5 )
        setInternalVariableValue( owner, "master_of_fire_is_effect_active", "value_int", 1 )

        local effect_id = EntityAddComponent( owner, "ShotEffectComponent", { extra_modifier = "ctq_master_of_fire_boost_plus" } )
        setInternalVariableValue( owner, "master_of_fire_shot_effect_id", "value_int", effect_id )

        ComponentSetValue2( cdatacomp, "flying_needs_recharge", false )
    end

    -- EntityInflictDamage( owner, -(e_max_hp * 0.01), "DAMAGE_HEALING", "master_of_fire healing", "NONE", 0, 0, enemy, x, y, 0 )

elseif( is_immune_to_fire or ( on_fire_effect_count == 0 and is_effect_active == 1 ) ) then

    reset_move_speed( owner, "master_of_fire" )
    -- reset_all_damage( owner, "master_of_fire" )
    setInternalVariableValue( owner, "master_of_fire_is_effect_active", "value_int", 0 )

    EntityRemoveComponent( owner, getInternalVariableValue( owner, "master_of_fire_shot_effect_id", "value_int" ) )

    ComponentSetValue2( cdatacomp, "flying_needs_recharge", true )
    ComponentSetValue2( cdatacomp, "fly_time_max", 3 )

end