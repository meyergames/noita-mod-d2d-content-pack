dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local host_id = GetUpdatedEntityID()

	-- when the host is hit with anything more than 1 damage, raise the shield for a few seconds
	if damage > 0.04 then

		local berserk_effect = GameGetGameEffect( host_id, "BERSERK" )
		if not exists( berserk_effect ) then
			LoadGameEffectEntityTo( host_id, "data/entities/misc/effect_berserk.xml" )
		end

		local shield_id = EntityGetAllChildren( host_id, "d2d_parasite_shield" )[1]
		if exists( shield_id ) then
			local shield_comp = EntityGetFirstComponentIncludingDisabled( shield_id, "EnergyShieldComponent" )
			if exists( shield_comp ) then
				ComponentSetValue2( shield_comp, "energy", 10.0 )
				set_internal_int( shield_id, "d2d_parasite_shield_remaining_frames", 120 )
			end
		end
	end
end