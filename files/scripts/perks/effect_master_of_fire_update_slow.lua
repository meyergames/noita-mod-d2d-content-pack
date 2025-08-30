dofile_once("data/scripts/lib/utilities.lua")

local EFFECT_RADIUS_DAMAGE = 150
local EFFECT_RADIUS_HEALING = 100

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
--local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local is_immune_to_fire = has_game_effect( owner, "PROTECTION_FIRE" )
if ( is_immune_to_fire ) then
    -- remove_perk( "CTQ_MASTER_OF_FIRE" )
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

        -- custom fire damage formula
        local remaining_hp_dmg = ( e_hp - e_max_hp * 0.2 ) * 0.02

        -- effectively set regular fire damage to 0 for the player
        if ( enemy == owner ) then
            EntityInflictDamage( owner, -(e_max_hp * 0.01), "DAMAGE_HEALING", "master_of_fire healing", "NONE", 0, 0, owner, x, y, 0 )

            -- fire heals the player if their health is below 20%
            if ( p_hp < p_max_hp * 0.2 ) then
                local heal_dmg = -1 * p_max_hp * 0.01
                EntityInflictDamage( owner, heal_dmg, "DAMAGE_HEALING", "master_of_fire healing", "NONE", 0, 0, owner, x, y, 0 )
                GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
            end

            -- if the player is burning, twice the remaining health-based fire damage spreads to nearby enemies
            for i,other_enemy in ipairs(enemies) do
                if ( other_enemy ~= owner ) then
                    EntityInflictDamage( other_enemy, remaining_hp_dmg * 2, "DAMAGE_FIRE", "master_of_fire fire", "NONE", 0, 0, owner, x, y, 0 )
                    
                    local e_x, e_y = EntityGetTransform( other_enemy )
                    if ( not has_game_effect( other_enemy, "ON_FIRE" ) ) then
                        EntityLoad( "mods/RiskRewardBundle/files/entities/projectiles/deck/hitfx_master_of_fire_impact.xml", e_x, e_y )
                    end
                end
            end
        end

        -- apply the custom fire damage formula
        EntityInflictDamage( enemy, remaining_hp_dmg, "DAMAGE_FIRE", "master_of_fire fire", "NONE", 0, 0, owner, x, y, 0 )

        -- nearby burning enemies heal the player while health is below 40%
        -- if ( enemy ~= owner and p_hp < p_max_hp * 0.4 and distance_between( owner, enemy ) < EFFECT_RADIUS_HEALING ) then
        --     local heal_dmg = -1 * math.max( ( ( e_max_hp * 0.01 ) + ( e_hp * 0.02 ) ) * fire_dmg_mtp, 0.02 )
        --     EntityInflictDamage( owner, heal_dmg, "DAMAGE_HEALING", "master_of_fire healing", "NONE", 0, 0, owner, x, y, 0 )
        --     GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
        --     -- EntityLoad( "mods/RiskRewardBundle/files/entities/particles/heal_master_of_fire.xml", pos_x, pos_y )
        -- end
    end
end
