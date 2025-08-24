dofile_once("data/scripts/lib/utilities.lua")

local EFFECT_RADIUS = 50

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local is_immune_to_fire = GameHasFlagRun( "PERK_PICKED_PROTECTION_FIRE" ) or GameHasFlagRun( "PERK_PICKED_BLEED_OIL" ) or GameHasFlagRun( "PERK_PICKED_FREEZE_FIELD" )

local on_fire_effect_count = GameGetGameEffectCount( owner, "ON_FIRE" )
local is_effect_active = getInternalVariableValue( owner, "pyrelord_is_effect_active", "value_int" )

if( not is_immune_to_fire and on_fire_effect_count == 1 ) then
    if( is_effect_active == 0 ) then
        multiply_move_speed( owner, "pyrelord", 1.333 )
        setInternalVariableValue( owner, "pyrelord_is_effect_active", "value_int", 1 )

        local effect_id = EntityAddComponent( owner, "ShotEffectComponent", { extra_modifier = "ctq_pyrelord_boost_plus" } )
        setInternalVariableValue( owner, "pyrelord_shot_effect_id", "value_int", effect_id )
        setInternalVariableValue( owner, "pyrelord_mana_charge_speed_mtp", "value_int", 100 )

        ComponentSetValue2( cdatacomp, "flying_needs_recharge", false )
    end

--    local enemies = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "mortal" )
--    for i,enemy in ipairs(enemies) do
--        local is_enemy_on_fire = GameGetGameEffectCount( enemy, "ON_FIRE" ) > 0
--        if( not is_enemy_on_fire ) then
--            local e_x, e_y = EntityGetTransform( enemy )
--            shoot_projectile( entity_id, "mods/RiskRewardBundle/files/entities/projectiles/deck/nolla_firebomb.xml", e_x, e_y, 0, 0)
--        end
--    end

local enemies = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "mortal" )
for i,enemy in ipairs(enemies) do
    if( GameGetGameEffectCount( enemy, "ON_FIRE" ) > 0 ) then
        EntityInflictDamage( owner, 0.04, "DAMAGE_HEALING", "pyrelord healing", "NONE", 0, 0, owner, x, y, 0 )
    end
end

elseif( is_immune_to_fire or ( on_fire_effect_count == 0 and is_effect_active == 1 ) ) then
    reset_move_speed( owner, "pyrelord" )
    setInternalVariableValue( owner, "pyrelord_is_effect_active", "value_int", 0 )
    setInternalVariableValue( owner, "pyrelord_mana_charge_speed_mtp", "value_int", 50 )

    EntityRemoveComponent( owner, getInternalVariableValue( owner, "pyrelord_shot_effect_id", "value_int" ) )

    ComponentSetValue2( cdatacomp, "flying_needs_recharge", true )
    ComponentSetValue2( cdatacomp, "fly_time_max", 3 )
end

-- if ( is_immune_to_fire ) then
--     remove_perk( "CTQ_PYRELORD" )
-- end