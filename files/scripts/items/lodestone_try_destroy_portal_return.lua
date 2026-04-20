dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local portal_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( portal_id )
local player = get_player()

if exists( player ) then
    local px, py = EntityGetTransform( player )
    -- destroy the return portal if the player walks outside of the portal's vicinity radius
    if get_distance( x, y, px, py ) > 300 then
        EntityKill( portal_id )

        -- if the player is *just* outside of the radius, assume they didn't take the portal and print the message
        if get_distance( x, y, px, py ) < 600 then
			GamePrintImportant( "The return portal has closed" )
			GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/rune/create", px, py )
		end
    end
end