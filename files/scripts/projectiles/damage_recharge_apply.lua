dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()
local wand = EZWand.GetHeldWand()

-- increase the wand's damage by 10% for every 0.20s of recharge time
multiply_proj_dmg( proj_id, 1.0 + ( wand.rechargeTime * 0.00833 ), "goliath" )
