dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
dofile_once( "data/scripts/perks/perk.lua" )

local MAX_EFFECT_DISTANCE = 25

local player = GetUpdatedEntityID()
local x, y = EntityGetTransform( player )

local radius_mtp = 0.5 + ( 0.5 * get_perk_pickup_count( "D2D_ALLY_PROTECTION" ) )

local nearby_targets = EntityGetInRadiusWithTag( x, y, MAX_EFFECT_DISTANCE * radius_mtp, "homing_target" )
if #nearby_targets > 0 then
    for i,target_id in ipairs( nearby_targets ) do

        local were_perks_given = get_internal_bool( target_id, "d2d_were_perks_given" )
        if GameGetGameEffect( target_id, "CHARM" ) ~= 0 and not were_perks_given then
            -- give each (compatible) perk of the player to the charmed enemy
            for i,perk in ipairs( perk_list ) do
                if has_perk( perk.id ) then
                    -- only apply to enemies if the perk is usable by them
                    local data = get_perk_with_id( perk_list, perk.id )
                    if data.usable_by_enemies then
                        share_perk_with_enemy( data, target_id, target_id )
                    end
                end
            end
            GamePlaySound( "data/audio/Desktop/player.bank", "player_projectiles/wall/create", x, y )
            set_internal_bool( target_id, "d2d_were_perks_given", true )

        -- elseif not is_charmed then
        --     local shield_id = EntityGetAllChildren( target_id, "d2d_ally_protection_shield" )[1]
        --     EntityKill( shield_id )
        --     reset_move_speed( target_id, "d2d_ally_protection" )
        end
    end
end

local faraway_targets = EntityGetWithTag( "homing_target" )
if #faraway_targets > 0 then
    for i,target_id in ipairs( faraway_targets ) do
        local children = EntityGetAllChildren( target_id, "d2d_ally_protection_shield" )
        local has_shield = children and #children > 0

        if has_shield and distance_between( player, target_id ) > MAX_EFFECT_DISTANCE then
            local shield_id = EntityGetAllChildren( target_id, "d2d_ally_protection_shield" )[1]
            EntityKill( shield_id )
            reset_move_speed( target_id, "d2d_ally_protection" )

            -- children = EntityGetAllChildren( target_id )
            -- for i,child_id in ipairs( children ) do
            --     if EntityGetComponentIncludingDisabled( child_id, "ArcComponent" ) then
            --         EntityKill( EntityGetComponentIncludingDisabled( child_id, "ArcComponent" )[1] )
            --     end
            -- end
        end
    end
end