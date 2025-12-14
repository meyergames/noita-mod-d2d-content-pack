dofile_once("data/scripts/lib/utilities.lua")

local MAX_EFFECT_DISTANCE = 100

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local nearby_targets = EntityGetInRadiusWithTag( x, y, MAX_EFFECT_DISTANCE, "homing_target" )
if #nearby_targets > 0 then
    for i,target_id in ipairs( nearby_targets ) do
        local children = EntityGetAllChildren( target_id, "d2d_ally_protection_shield" )

        local is_charmed = GameGetGameEffect( target_id, "CHARM" )
        local has_shield = children and #children > 0

        if is_charmed ~= 0 and not has_shield then
            local new_shield_id = EntityLoad( "mods/D2DContentPack/files/entities/misc/ally_protection_shield.xml" )
            EntityAddChild( target_id, new_shield_id )
            multiply_move_speed( target_id, "d2d_ally_protection", 1.5 )

            -- create an arc between the player and the charmed creature
            -- local new_arc_id = EntityLoad( "data/entities/misc/arc_electric.xml" )
            -- EntityAddChild( entity_id, new_arc_id )
            -- local arccomp = EntityGetComponentIncludingDisabled( new_arc_id, "ArcComponent" )
            -- if arccomp then
            --     ComponentSetValue2( arccomp, "mArcTarget", target_id )
            -- end
        elseif not is_charmed and has_shield then
            local shield_id = EntityGetAllChildren( target_id, "d2d_ally_protection_shield" )[1]
            EntityKill( shield_id )
            reset_move_speed( target_id, "d2d_ally_protection" )
        end
    end
end

local faraway_targets = EntityGetWithTag( "homing_target" )
if #faraway_targets > 0 then
    for i,target_id in ipairs( faraway_targets ) do
        local children = EntityGetAllChildren( target_id, "d2d_ally_protection_shield" )
        local has_shield = children and #children > 0

        if has_shield and distance_between( entity_id, target_id ) > MAX_EFFECT_DISTANCE then
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