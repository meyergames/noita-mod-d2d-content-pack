dofile_once("data/scripts/lib/utilities.lua")

-------------------------------------------------------------------------------

function drop_rewards( x, y )
	CreateItemActionEntity( "TELEPORT_PROJECTILE_SHORT", x, y )
	if ModIsEnabled( "Apotheosis" ) then
		CreateItemActionEntity( "APOTHEOSIS_ALT_FIRE_TELEPORT_SHORT", x, y )
	end
	
    dofile_once( "data/scripts/perks/perk.lua" )
	perk_spawn( x, y - 20, "D2D_WARP_RUSH", true )

	-- spawn wand
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	local wand = EZWand()
	wand:SetName( "Staff of Time", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = 24
	wand.rechargeTime = 240
	wand.manaMax = 120
	wand.manaChargeSpeed = 30
	wand.capacity = 0
	wand.spread = 0
	wand:AttachSpells( "D2D_BLOOD_PRICE", "D2D_BLINK", "D2D_REWIND_ALT_FIRE" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_time_t2.png", 8, 4, 19, 0 )
	wand:PlaceAt( x, y - 40 )

	-- EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/chest_time_trial_t2.xml", 230, -79 )
	
	return true
end

function on_open( entity_item )
	local x, y = EntityGetTransform( entity_item )
	local rand_x = x
	local rand_y = y

	-- PositionSeedComponent
	local position_comp = EntityGetFirstComponent( entity_item, "PositionSeedComponent" )
	if( position_comp ) then
		rand_x = tonumber(ComponentGetValue( position_comp, "pos_x") )
		rand_y = tonumber(ComponentGetValue( position_comp, "pos_y") )
	end

	SetRandomSeed( rand_x, rand_y )

	local good_item_dropped = drop_rewards( x, y )

	EntityLoad( "data/entities/particles/image_emitters/chest_effect.xml", x, y )
end

function item_pickup( entity_item, entity_who_picked, name )
	GamePrintImportant( "Your speed is rewarded", "" )

	on_open( entity_item )
	
	EntityKill( entity_item )
end

function physics_body_modified( is_destroyed )
	local entity_item = GetUpdatedEntityID()
	
	on_open( entity_item )

	edit_component( entity_item, "ItemComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_item, comp, false )
	end)
	
	EntityKill( entity_item )
end