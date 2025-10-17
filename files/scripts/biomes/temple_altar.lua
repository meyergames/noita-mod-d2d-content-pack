dofile_once( "data/scripts/lib/utilities.lua" )

local mod_

local old_spawn_hp = spawn_hp
function spawn_hp( x, y )
	old_spawn_hp( x, y )

	if has_perk( "D2D_WANDSMITH" ) then
		-- spawn the hammer and cache its id
		local hammer_id = EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/hammer.xml", x, y )

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
end