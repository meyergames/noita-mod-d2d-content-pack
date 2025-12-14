dofile_once( "data/scripts/lib/utilities.lua" )

local MAX_EFFECT_DISTANCE = 100

local entity = GetUpdatedEntityID()
local parent = EntityGetParent( entity )

if parent ~= nil then
    local px, py = EntityGetTransform( parent )

    local parent_controls = EntityGetFirstComponent( parent, "ControlsComponent" )
    if parent_controls ~= nil then
        local mx, my = ComponentGetValue2( parent_controls, "mMousePosition" )

        -- local dist = get_distance( px, py, mx, my )
        -- local dir_vec_x, dir_vec_y = vec_normalize( mx - px, my - py )

        -- local x = dir_vec_x * math.min( dist, MAX_EFFECT_DISTANCE )
        -- local y = dir_vec_y * math.min( dist, MAX_EFFECT_DISTANCE )

        -- EntitySetTransform( entity, px + x, py + y )
        EntitySetTransform( entity, mx, my )
    else
        EntitySetTransform( entity, px, py )
    end
end