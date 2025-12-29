dofile_once( "data/scripts/lib/utilities.lua" )

local old_spawn_hp = spawn_hp
function spawn_hp( x, y )
	old_spawn_hp( x, y )

	if has_perk( "D2D_WANDSMITH" ) then
		-- spawn the hammer and cache its id
		local hammer_id = -1
		if ModIsEnabled( "disable-auto-pickup" ) then
			hammer_id = EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer_manual_pickup.xml", x, y )
		else
			hammer_id = EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer.xml", x, y )
		end

		-- disable auto pickup if mod setting
		-- local config_auto_pickup_hammer = ModSettingGet( "D2DContentPack.auto_pickup_hammer" )
		-- if config_auto_pickup_hammer == false then
		-- 	GamePrint("test1")
	    --     local item = EntityGetFirstComponent( hammer_id, "ItemComponent" )
	    --     if item then ComponentSetValue2( item, "auto_pickup", false ) end
		-- end

		-- get the ids of the nearby heart and spell refresher
		local heart_id = EntityGetInRadiusWithTag( x-16, y, 4, "drillable" )[1]
		local refresher_id = EntityGetInRadiusWithTag( x+16, y, 4, "drillable" )[1]
		-- add a component to them that destroys the hammer when picked up
		EntityAddComponent2( heart_id, "LuaComponent", {
			script_item_picked_up="mods/D2DContentPack/files/scripts/items/hammer_destroy_nearby.lua"
		})
		EntityAddComponent2( refresher_id, "LuaComponent", {
			script_item_picked_up="mods/D2DContentPack/files/scripts/items/hammer_destroy_nearby.lua"
		})
	end

	if has_perk( "D2D_PERKSMITH" ) then
		-- spawn the perk and cache its id
		local perk_id = perk_spawn_random( x, y + 8, true )

		-- get the ids of the nearby heart and spell refresher
		local heart_id = EntityGetInRadiusWithTag( x-16, y, 4, "drillable" )[1]
		local refresher_id = EntityGetInRadiusWithTag( x+16, y, 4, "drillable" )[1]

		-- add a component to them that destroys the hammer when picked up
		EntityAddComponent2( perk_id, "LuaComponent", {
			script_item_picked_up="mods/D2DContentPack/files/scripts/items/perk_destroy_nearby_pickups.lua"
		})
		EntityAddComponent2( heart_id, "LuaComponent", {
			script_item_picked_up="mods/D2DContentPack/files/scripts/items/pickup_destroy_nearby_perk.lua"
		})
		EntityAddComponent2( refresher_id, "LuaComponent", {
			script_item_picked_up="mods/D2DContentPack/files/scripts/items/pickup_destroy_nearby_perk.lua"
		})
	end
end