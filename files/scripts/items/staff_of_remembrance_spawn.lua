dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

function item_pickup( entity_item, entity_who_picked, name )
	local ghost = EntityLoad( "mods/D2DContentPack/files/entities/animals/ghost_of_memories.xml", pos_x, pos_y )
	
	local x, y = EntityGetTransform( GetUpdatedEntityID() )

	local shockwave = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/shockwave.xml", pos_x, pos_y - 8 )
	local proj_comp = EntityGetFirstComponent( shockwave, "ProjectileComponent" )
	if proj_comp then
		ComponentObjectSetValue2( proj_comp, "config_explosion", "dont_damage_this", ghost )
	end


	-- local p_dmg_comp = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
	-- if exists( p_dmg_comp ) then
	-- 	-- spawn the wand
	-- 	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	-- 	local wand = init_wand_of_memories()
	-- 	wand:PlaceAt( pos_x, pos_y - 20 ) 
	-- 	-- wand:PutInPlayersInventory()

	-- 	-- make it pretty
	-- 	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/barren_puzzle_completed/create", pos_x, pos_y )
	-- 	-- GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/wand/create", pos_x, pos_y )
	-- 	-- EntityLoad( "data/entities/particles/image_emitters/wand_effect.xml", pos_x, pos_y )
	-- 	-- GamePrintImportant( "Picked up the Staff of Remembrance" )

	-- 	-- halve the player's hp
	-- 	local p_hp = ComponentGetValue2( p_dmg_comp, "hp" )
	-- 	local p_max_hp = ComponentGetValue2( p_dmg_comp, "max_hp" )
	-- 	EntityInflictDamage( entity_who_picked, p_hp * 0.5, "DAMAGE_SLICE", "tore a muscle", "NONE", 0, 0, entity_who_picked, x, y, 0)
	-- 	EntityKill( entity_id )
	-- end
end
