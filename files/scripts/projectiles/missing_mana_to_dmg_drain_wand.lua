dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EZWand = dofile_once( "mods/D2DContentPack/files/scripts/lib/ezwand.lua" )
local wand = EZWand.GetHeldWand()
wand.mana = 1
