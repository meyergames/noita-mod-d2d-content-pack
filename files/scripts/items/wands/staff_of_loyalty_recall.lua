dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local ghost = GetUpdatedEntityID()
local gx, gy = EntityGetTransform( ghost )
GamePrint( ghost )

-- try to identify the wand
local wand_id = GameGetAllInventoryItems( ghost )[1]
local wand = EZWand( wand_id )
GamePrint( wand_id )
GamePrint( EZWand.IsWand( wand_id ) )

-- make a clone of the wand and give it to the player
local clone = wand:Clone()
clone:PutInPlayersInventory()
EntityAddTag( clone.entity_id, "d2d_staff_of_loyalty" )
set_internal_int( clone.entity_id, "d2d_staff_tier", staff_tier )
set_internal_bool( clone.entity_id, "d2d_staff_of_loyalty_is_animated", false )
GamePrint( clone.entity_id )

-- kill the ghost
EntityKill( ghost )

-- sfx/vfx for feedback
EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_move_success", x, y )
