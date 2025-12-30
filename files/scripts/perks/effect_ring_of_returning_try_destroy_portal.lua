dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local portal_id = GetUpdatedEntityID()
-- local x, y = EntityGetTransform( portal_id )
local player = get_player()

if exists( player ) then
    local px, py = EntityGetTransform( player )

    if is_within_bounds( player, 690, 850, -1000, -670 ) then
    	EntityKill( portal_id )
    end
end