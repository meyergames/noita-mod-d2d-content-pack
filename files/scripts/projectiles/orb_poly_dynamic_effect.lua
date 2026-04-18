dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
local polytools = dofile_once( "mods/D2DContentPack/files/scripts/lib/polytools/polytools.lua" )

local effect_id = GetUpdatedEntityID()
local player = get_player()
local target_filename = get_internal_string( player, "d2d_dynamic_poly_target" )
if not target_filename then return end

-- vfx and such
local x, y = EntityGetTransform( player )
local poof = EntityLoad( "data/entities/particles/polymorph_explosion.xml", x, y )
GamePrint( "trying to morph into: " .. target_filename )
polytools.polymorph( player, target_filename, 600, true, nil, true )
EntityAddComponent2( poof, "AudioComponent", {
	file="data/audio/Desktop/misc.bank",
	event_root="game_effect/polymorph" 
} )
EntityKill( effect_id )

-- local x, y = EntityGetTransform( GetUpdatedEntityID() )

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