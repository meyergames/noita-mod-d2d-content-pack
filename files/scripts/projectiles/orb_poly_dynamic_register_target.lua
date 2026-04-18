dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local player = get_player()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local nearby_enemies = EntityGetInRadiusWithTag( x, y, 50, "homing_target" )
GamePrint( "enemies found: " .. #nearby_enemies )
for i,enemy in ipairs( nearby_enemies ) do
	if enemy ~= player then
		-- local target = EntityGetRootEntity( GetUpdatedEntityID() )
		local target_filename = EntityGetFilename( enemy )
		if target_filename and target_filename ~= "" then
			GamePrint( "target set: " .. target_filename )
			set_internal_string( player, "d2d_dynamic_poly_target", target_filename )
			LoadGameEffectEntityTo( player, "mods/D2DContentPack/files/entities/misc/status_effects/effect_polymorph_dynamic.xml" )
			return
		end
	end
end

-- local target = EntityGetInRadiusWithTag( x, y, 5, "homing_target" )[1]
-- local target_filename = EntityGetFilename( target )

-- -- local poly_effect_entity_id = EntityLoad( "mods/D2DContentPack/files/entities/misc/status_effects/effect_polymorph_dynamic.xml", x, y )
-- local poly_effect_entity_id = LoadGameEffectEntityTo( get_player(), "mods/D2DContentPack/files/entities/misc/status_effects/effect_polymorph_dynamic.xml" )
-- local effect_comp = EntityGetFirstComponentIncludingDisabled( poly_effect_entity_id, "GameEffectComponent" )
-- if exists( effect_comp ) then
-- 	GamePrint( "trying to morph into: " .. target_filename )
-- 	-- ComponentSetValue2( effect_comp, "polymorph_target", target_filename )
-- 	-- ComponentSetValue2( effect_comp, "frames", 600 )
-- 	-- EntityAddChild( get_player(), poly_effect_entity_id )
-- 	local player = get_player()
--     if EntityHasTag( player, "player_unit" ) then
--         local entity = EntityCreateNew()
-- 		EntityAddComponent2( entity, "GameEffectComponent", {
-- 			frames = 600,
-- 			polymorph_target = target_filename,
-- 			effect = "POLYMORPH",
-- 			exclusivity_group = 1,
-- 		})
-- 		EntityAddChild( player, entity )
--     end
-- end


-- local polytools = dofile_once( "mods/D2DContentPack/files/scripts/lib/polytools/polytools.lua" )
-- local effect_id = GetUpdatedEntityID()
-- local root_entity = EntityGetRootEntity( effect_id )
-- polytools.polymorph( root_entity, target_filename, 360, true, nil, true )
-- local x, y = EntityGetTransform(polytools)
-- local poof = EntityLoad( "data/entities/particles/polymorph_explosion.xml", x, y )
-- EntityAddComponent2(poof, "AudioComponent", {
-- 	file="data/audio/Desktop/misc.bank",
-- 	event_root="game_effect/polymorph" 
-- })
-- EntityKill( effect_id )