dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local portal_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( portal_id )
local player = get_player()

if exists( player ) then
    local px, py = EntityGetTransform( player )
    if get_distance( x, y, px, py ) > 300 then
        EntityKill( portal_id )
    end
end