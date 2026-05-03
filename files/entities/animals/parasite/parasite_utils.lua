dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function try_infect( host_id )
	if not exists( host_id ) then return end

	-- cannot infect the player
	if host_id == get_player() then return end
	
	-- cannot infect an already infected enemy
	if get_internal_bool( host_id, "d2d_is_parasited" ) then return end

	local x, y = EntityGetTransform( host_id )
	local parasite_id = EntityGetInRadiusWithTag( x, y, 10, "d2d_parasite" )[1]
	if not exists( parasite_id ) then return end

	set_internal_bool( host_id, "d2d_is_parasited", true )



	-- raise the host's (max) hp by 50
	local dmg_comp = EntityGetFirstComponentIncludingDisabled( host_id, "DamageModelComponent" )
	if exists( dmg_comp ) then
		local hp = ComponentGetValue2( dmg_comp, "hp" )
		local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
		ComponentSetValue2( dmg_comp, "max_hp", hp + 2 )
		ComponentSetValue2( dmg_comp, "hp", hp + 2 )
	end

	-- give the host a shield
	EntityAddChild( host_id, EntityLoad( "mods/D2DContentPack/files/entities/animals/parasite/parasite_status_shield.xml", x, y ) )
	EntityAddComponent2( host_id, "LuaComponent", {
		script_damage_received = "mods/D2DContentPack/files/entities/animals/parasite/parasite_host_damage_received.lua",
		execute_every_n_frame = -1,
	} )

	-- make the host berserk
	LoadGameEffectEntityTo( host_id, "data/entities/misc/effect_berserk.xml" )

	-- make the host spawn a new parasite on death
	EntityAddComponent2( host_id, "LuaComponent", {
		script_source_file = "mods/D2DContentPack/files/entities/animals/parasite/parasite_host_end.lua",
		execute_every_n_frame = -1,
		execute_on_removed = true,
	} )

	-- kill the parasite, but first prevent its gold drop
	EntityAddComponent2( parasite_id, "VariableStorageComponent", {
		_tags = "no_gold_drop",
	} )
	EntityKill( parasite_id )

end
