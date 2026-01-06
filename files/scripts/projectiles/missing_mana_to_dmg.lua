dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
local EZWand = dofile_once( "mods/D2DContentPack/files/scripts/lib/ezwand.lua" )
local wand = EZWand.GetHeldWand()

local proj_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
local was_already_applied = get_internal_bool( proj_id, "d2d_missing_mana_to_dmg_applied" )
if exists( wand ) and exists( proj_comp ) and not was_already_applied then
	-- multiply by up to x4 based on the projectile's mana cost (i.e. magic missile gets more mtp than spark bolt)
	local proj_mana_cost = ComponentObjectGetValue2( proj_comp, "config", "action_mana_drain" )
	local mana_cost_mtp = remap( proj_mana_cost, 5, 120, 1.0, 4.0 )

	local missing_mana = wand.manaMax - wand.mana
	local time_until_full_mana = missing_mana / math.max( wand.manaChargeSpeed, 10 )
	local mtp1 = ( time_until_full_mana * 0.05 ) -- so 60s = x3
	local mtp2 = remap( proj_mana_cost, 5, 120, 1.0, 4.0 )
	local mtp3 = remap( missing_mana, 50, 5000, 1.0, 4.0 )

    local mtp = 1.0 + ( mtp1 * mtp2 * mtp3 )
    
	multiply_proj_dmg( proj_id, mtp )
	set_internal_bool( proj_id, "d2d_missing_mana_to_dmg_applied", true )
end