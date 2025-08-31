dofile_once("data/scripts/lib/utilities.lua")

local is_immune_to_explosions = has_game_effect( owner, "PROTECTION_EXPLOSION" )

if ( is_immune_to_explosions ) then
    -- remove_perk( "D2D_MASTER_OF_EXPLOSIONS" )
end