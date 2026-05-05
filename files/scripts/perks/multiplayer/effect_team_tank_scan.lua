dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EFFECT_RADIUS = 80

-- entity id and internal vars
local player = EntityGetRootEntity( GetUpdatedEntityID() )
if not exists( player ) then return end
local x, y = EntityGetTransform( player )

local nearby_players = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "player_unit" )

-- every 5 seconds, try to give other players the damage redirection script
if exists( nearby_players ) and #nearby_players > 1 then
    for i,nearby_player in ipairs( nearby_players ) do

        local was_already_applied = has_lua( nearby_player, "d2d_team_tank_redirect" )
        if not was_already_applied then
          EntityAddComponent2( nearby_player, "LuaComponent", {
            _tags = "d2d_team_tank_redirect",
            script_damage_about_to_be_received = "mods/D2DContentPack/files/scripts/perks/multiplayer/effect_team_tank_redirect.lua",
          } )
        end
    end
end
