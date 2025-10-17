dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "data/scripts/gun/procedural/gun_action_utils.lua" )
dofile_once( "data/scripts/game_helpers.lua" )

local BASE_AMT_OF_UPGRADES = 3

local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( player_id )

local currbiome = BiomeMapGetName( x, y )
local flag = "evolving_wands_" .. tostring(currbiome) .. "_visited"

if ( GameHasFlagRun( flag ) == false ) then
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	local wand = EZWand.GetHeldWand()

    if wand then
    	dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
    	apply_random_wand_upgrades( wand, get_perk_pickup_count( "D2D_EVOLVING_WANDS" ) )

		GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
		GameAddFlagRun( flag )
    end
end
