dofile_once("data/scripts/lib/utilities.lua")

local EFFECT_RADIUS_DAMAGE = 150
local EFFECT_RADIUS_HEALING = 100

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
--local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local is_immune_to_fire = has_game_effect( owner, "PROTECTION_FIRE" )
if ( is_immune_to_fire ) then
    -- remove_perk( "CTQ_PYRELORD" )
    return
end

-- twice per second
local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

local enemies = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS_DAMAGE, "mortal" )
for i,enemy in ipairs(enemies) do
    if( GameGetGameEffectCount( enemy, "ON_FIRE" ) > 0 ) then
        local e_dcomp = EntityGetFirstComponentIncludingDisabled( enemy, "DamageModelComponent" )
        local e_hp = ComponentGetValue2( e_dcomp, "hp" )
        local e_max_hp = ComponentGetValue2( e_dcomp, "max_hp" )
        local fire_dmg_mtp = ComponentObjectGetValue2( e_dcomp, "damage_multipliers", "fire" )

        -- custom fire damage
        if ( enemy == owner ) then -- effectively sets regular fire damage to 0
            EntityInflictDamage( owner, -(e_max_hp * 0.01), "DAMAGE_HEALING", "pyrelord healing", "NONE", 0, 0, owner, x, y, 0 )
        end
        EntityInflictDamage( enemy, e_hp * 0.02, "DAMAGE_FIRE", "pyrelord fire", "NONE", 0, 0, owner, x, y, 0 )

        -- nearby burning enemies heal the player
        if ( enemy ~= owner and p_hp < p_max_hp and distance_between( owner, enemy ) < EFFECT_RADIUS_HEALING ) then
            local heal_dmg = -1 * math.max( ( ( e_max_hp * 0.01 ) + ( e_hp * 0.02 ) ) * fire_dmg_mtp, 0.02 )
            EntityInflictDamage( owner, heal_dmg, "DAMAGE_HEALING", "pyrelord healing", "NONE", 0, 0, owner, x, y, 0 )
            GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
        end
    end
end
