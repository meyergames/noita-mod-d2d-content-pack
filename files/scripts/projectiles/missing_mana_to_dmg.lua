dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
local EZWand = dofile_once( "mods/D2DContentPack/files/scripts/lib/ezwand.lua" )
local wand = EZWand.GetHeldWand()

local proj_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
if exists( proj_comp ) then
	-- multiply by up to x4 based on the projectile's mana cost (i.e. magic missile gets more mtp than spark bolt)
	local proj_mana_cost = ComponentObjectGetValue2( proj_comp, "config", "action_mana_drain" )
	local mana_cost_mtp = remap( proj_mana_cost, 5, 120, 1.0, 4.0 )

	local missing_mana = wand.manaMax - wand.mana
	local time_until_full_mana = missing_mana / math.max( wand.manaChargeSpeed, 10 )
    local mtp = 1.0 + ( ( time_until_full_mana * 0.1 ) * mana_cost_mtp )
    
	multiply_proj_dmg( proj_id, mtp )
end