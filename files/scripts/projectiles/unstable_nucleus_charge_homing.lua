-- Credit to gkbrkb for this script
dofile_once( "data/scripts/lib/utilities.lua" )

function ease_angle( angle, target_angle, easing )
    local dir = ( angle - target_angle ) / (math.pi * 2)
    dir = dir - math.floor( dir + 0.5 )
    dir = dir * ( math.pi * 2 )
    return angle - dir * easing
end

local entity = GetUpdatedEntityID()
raise_internal_int( entity, "frames_alive", 1 )

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if projectile ~= nil then
    local unstable_nucleus_id = get_internal_int( get_player(), "unstable_nucleus_id" )
    local charges = get_internal_int( entity, "charges" )
    if charges == nil then charges = 0 end

    if unstable_nucleus_id ~= nil and unstable_nucleus_id ~= -1 then
        local target_x, target_y = EntityGetTransform( unstable_nucleus_id )
        local x, y = EntityGetTransform( entity )
        local target_angle = math.atan2( target_y - y, target_x - x )
        local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" )
        if velocity ~= nil then
            SetRandomSeed( x, y )
            local vx, vy = ComponentGetValue2( velocity, "mVelocity" )
            local angle = math.atan2( vy, vx )

            -- local magnitude = math.min( math.sqrt( vx * vx + vy * vy ) * 1.05 + 1, 50 + ( charges * 0.15 ) )
            -- local magnitude = Random( 50, 200 ) * ( 0.25 + ( charges * 0.00075 ) )
            -- local magnitude = Random( 50, 200 ) * ( 1.0 + ( charges * 0.001 ) ) -- surprisingly, this one yields the best result
            -- local magnitude = 50 + Random( 0, get_internal_int( entity, "frames_alive" ) )
            local magnitude = 20 + get_internal_int( entity, "frames_alive" ) * 2

            local distance = math.sqrt( math.pow( target_x - x, 2 ) + math.pow( target_y - y, 2 ) )
            -- local magnitude = 100 + ( 150 * ( ( 500 - math.min( distance, 500 ) ) * 0.002 ) )

            local ease = distance / ( distance + 100 ) + math.sqrt( magnitude ) * 0.02
            local new_angle = ease_angle( angle, target_angle, math.min( math.max( 0, ease ), 1 ) * Random() )
            ComponentSetValue2( velocity, "mVelocity", math.cos( new_angle ) * magnitude * 0.92, math.sin( new_angle ) * magnitude * 0.92 )
        end
    -- else
    --     local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" )
    --     if velocity ~= nil then
    --         local vx, vy = ComponentGetValue2( velocity, "mVelocity" )
    --         local angle = math.atan2( vy * -1, vx * -1 )
    --         local magnitude = Random( 50, 200 )
    --         local new_angle = angle * -1
    --         ComponentSetValue2( velocity, "mVelocity", math.cos( new_angle ) * magnitude * 0.92, math.sin( new_angle ) * magnitude * 0.92 )
    --     end
    end
end
