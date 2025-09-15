dofile_once( "data/scripts/lib/utilities.lua" )

-- entity id and internal vars
local entity_id = GetUpdatedEntityID()
local wand_id = get_internal_int( entity_id, "source_wand_id" )

-- ezwand vars
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local wand = EZWand( wand_id )

wand.mana = math.max( wand.mana - ( wand.manaChargeSpeed / 60 ) * 2 - ( ( wand.manaMax * 0.1 ) / 60 ), 1 )
