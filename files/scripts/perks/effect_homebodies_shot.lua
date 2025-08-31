dofile_once( "data/scripts/lib/utilities.lua" )

local MAX_EFFECT_DISTANCE = 500

function shot( proj_id )
   	GamePrint("test")

	local EZWand = dofile_once("mods/RiskRewardBundle/files/scripts/lib/ezwand.lua")
   	local wand = EZWand.GetHeldWand()

   	-- GamePrint("wand entity id? " .. wand.entity_id)
   	-- local pickup_x = getInternalVariableValue( wand.entity_id, "pickup_pos_x", "value_int" )
   	-- local pickup_y = getInternalVariableValue( wand.entity_id, "pickup_pos_y", "value_int" )
   	local x, y = EntityGetTransform( wand.entity_id )
   	-- GamePrint("current pos: " .. current_x .. "," .. current_y)
   	-- GamePrint("pickup pos: " .. pickup_x .. "," .. pickup_y)
   	-- if ( pickup_x == nil or pickup_y == nil) then return end

   	-- local distance_from_origin_pos = get_distance( pickup_x, pickup_y, current_x, current_y )
   	-- GamePrint("dist: " .. distance_from_origin_pos)

   	local home_biome = getInternalVariableValueIncludingDisabled( wand.entity_id, "home_biome", "value_string" )
   	local current_biome = BiomeMapGetName( x, y )

   	if home_biome == nil then home_biome = "_EMPTY_" end
   	GamePrint("home biome: " .. home_biome)
   	GamePrint("current biome: " .. current_biome)

   	if ( home_biome ~= current_biome ) then return end
   	GamePrint("projectile should be enhanced...")
   	wand.mana = wand.manaMax

	local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
	if( proj_comp ~= nil ) then
	-- 	local damage = ComponentGetValue2( proj_comp, "damage" )
	-- 	damage = damage * 2.0
	-- 	ComponentSetValue2( proj_comp, "damage", damage )

	-- 	-- multiply all damage by x1.5
	-- 	local dtypes = { "fire", "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill" }
	-- 	for a,b in ipairs(dtypes) do
	-- 		local v = tonumber(ComponentObjectGetValue( proj_comp, "damage_by_type", b ))
	-- 		v = v * 1.5
	-- 		ComponentObjectSetValue( proj_comp, "damage_by_type", b, tonumber(v) )
	-- 	end

		local extra_entities = ComponentObjectGetValue( proj_comp, "config", "extra_entities" )
		extra_entities = extra_entities .. "data/entities/particles/tinyspark_green_trail.xml,"
		ComponentObjectSetValue2( proj_comp, "config", "extra_entities", tostring( extra_entities ) )
	end
end