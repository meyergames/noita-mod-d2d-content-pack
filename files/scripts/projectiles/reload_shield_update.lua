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
	else
		wand.mana = math.min( wand.mana + ( ( wand.manaChargeSpeed / 60 ) * 3.0 ), wand.manaMax )
	end
end
