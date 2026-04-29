dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua")

local EFFECT_RADIUS = 50

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local on_fire_effect_count = GameGetGameEffectCount( owner, "ON_FIRE" )
local is_effect_active = getInternalVariableValue( owner, "master_of_fire_is_effect_active", "value_int" )

if not is_immune_to_fire() and on_fire_effect_count > 0 then

    if( is_effect_active == 0 ) then
        multiply_move_speed( owner, "master_of_fire", 1.33 )
        -- multiply_all_damage( owner, "master_of_fire", 1.5 )
        setInternalVariableValue( owner, "master_of_fire_is_effect_active", "value_int", 1 )

        ComponentSetValue2( cdatacomp, "flying_needs_recharge", false )

        local conv_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "MagicConvertMaterialComponent" )
        if exists( conv_comp ) then
            ComponentSetValue2( conv_comp, "radius", 16 )
        end
    end

    -- EntityInflictDamage( owner, -(e_max_hp * 0.01), "DAMAGE_HEALING", "master_of_fire healing", "NONE", 0, 0, enemy, x, y, 0 )

elseif is_immune_to_fire() or ( on_fire_effect_count == 0 and is_effect_active == 1 ) then

    reset_move_speed( owner, "master_of_fire" )
    -- reset_all_damage( owner, "master_of_fire" )
    setInternalVariableValue( owner, "master_of_fire_is_effect_active", "value_int", 0 )

    ComponentSetValue2( cdatacomp, "flying_needs_recharge", true )
    ComponentSetValue2( cdatacomp, "fly_time_max", 3 )

    local conv_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "MagicConvertMaterialComponent" )
    if exists( conv_comp ) then
        ComponentSetValue2( conv_comp, "radius", 0 )
    end

end