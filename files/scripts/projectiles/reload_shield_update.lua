dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

-- entity id and internal vars
local player = EntityGetRootEntity( GetUpdatedEntityID() )
local wand = EZWand( EntityGetParent( GetUpdatedEntityID() ) )
if not wand then return end

local ability_comp = EntityGetFirstComponentIncludingDisabled( wand.entity_id, "AbilityComponent" )
if ability_comp then
	local reload_ready_frame = ComponentGetValue2( ability_comp, "mReloadNextFrameUsable" )
	if reload_ready_frame < GameGetFrameNum() then

		local shield_comps = EntityGetComponent( GetUpdatedEntityID(), "EnergyShieldComponent" )
		if exists( shield_comps ) then
			for i,shield_comp in ipairs( shield_comps ) do
				ComponentSetValue2( shield_comp, "energy", 0 )
			end
		end

		if get_internal_bool( GetUpdatedEntityID(), "d2d_reload_shield_move_speed_applied" ) then
			reset_move_speed( player, "d2d_reload_shield" )
			set_internal_bool( GetUpdatedEntityID(), "d2d_reload_shield_move_speed_applied", false )
		end
	else
		wand.mana = math.min( wand.mana + ( ( wand.manaChargeSpeed / 60 ) * 3.0 ), wand.manaMax )

		if not get_internal_bool( GetUpdatedEntityID(), "d2d_reload_shield_move_speed_applied" ) then
			multiply_move_speed( player, "d2d_reload_shield", 1.6, 1.3 )
			set_internal_bool( GetUpdatedEntityID(), "d2d_reload_shield_move_speed_applied", true )
		end
	end
end
