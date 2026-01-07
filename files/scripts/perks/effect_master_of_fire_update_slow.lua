dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EFFECT_RADIUS_DAMAGE = 150
local EFFECT_RADIUS_HEALING = 100
local EFFECT_RADIUS_SPREAD = 50

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
--local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local x, y = EntityGetTransform( owner )

local is_immune_to_fire = has_game_effect( owner, "PROTECTION_FIRE" )
if ( is_immune_to_fire ) then
    -- remove_perk( "D2D_MASTER_OF_FIRE" )
    return
end

function spread_fire( source, x, y )
    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/on_fire/create", x, y )
    for i = 1, 8 do

        -- 75% chance to spawn
        if Random( 1, 4 ) ~= 1 then
            local rdir_x, rdir_y = 0, 0

            -- 33% chance to aim directly at a random nearby enemy
            local do_random = true
            if Random( 1, 3 ) == 3 then
                local nearby_targets = EntityGetInRadiusWithTag( x, y, 70, "homing_target")
                if exists( nearby_targets ) and #nearby_targets >= 2 then
                    local index = Random( 1, #nearby_targets )
                    local target = nearby_targets[index]
                    -- skip self
                    while target == source do
                        index = ( index % #nearby_targets ) + 1
                        target = nearby_targets[index]
                    end
                    local tx, ty = EntityGetTransform( target )
                    rdir_x = tx - x
                    rdir_y = ty - y
                    do_random = false
                end
            end

            -- 66% chance (or if no nearby targets available) to shoot in a random direction
            if do_random then
                SetRandomSeed( x, y+i )
                rdir_x, rdir_y = vec_rotate( 0, 1, Randomf( -math.pi, math.pi ) )
            end

            -- spawn the projectile
            local proj_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/master_of_fire_shrapnel.xml", x, y )
            -- if the projectile directly targets someone, set speed to max
            if not do_random then
                local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
                if proj_comp then
                    ComponentSetValue2( proj_comp, "speed_min", 850 )
                end
            end
            GameShootProjectile( source, x, y, x+rdir_x, y+rdir_y, proj_id )
        end
    end
end

-- twice per second
local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

local creatures = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS_DAMAGE, "mortal" )
for i,creature_id in ipairs(creatures) do
    if( GameGetGameEffectCount( creature_id, "ON_FIRE" ) > 0 ) then
        local e_dcomp = EntityGetFirstComponentIncludingDisabled( creature_id, "DamageModelComponent" )
        local e_hp = ComponentGetValue2( e_dcomp, "hp" )
        local e_max_hp = ComponentGetValue2( e_dcomp, "max_hp" )
        local fire_dmg_mtp = ComponentObjectGetValue2( e_dcomp, "damage_multipliers", "fire" )

        -- custom fire damage formula
        local remaining_hp_dmg = ( e_hp - e_max_hp ) * 0.02

        -- maybe spread fire
        if Random( 1, 3 ) == 3 then
            local cx, cy = EntityGetTransform( creature_id )
            spread_fire( creature_id, cx, cy )
        end

        -- fire heals the player if their health is below 20%
        if ( creature_id == owner ) then
            if ( p_hp < p_max_hp * 0.1 ) then
                local heal_dmg = -1 * ( p_max_hp * 0.02 )
                EntityInflictDamage( owner, heal_dmg, "DAMAGE_HEALING", "master of fire healing", "NONE", 0, 0, owner, x, y, 0 )

                GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
            end
        -- apply the custom fire damage formula to everyone except the player
        else
            EntityInflictDamage( creature_id, remaining_hp_dmg, "DAMAGE_FIRE", "master_of_fire fire", "NONE", 0, 0, owner, x, y, 0 )
        end
    end
end
