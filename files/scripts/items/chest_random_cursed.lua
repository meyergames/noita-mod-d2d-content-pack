dofile_once("data/scripts/lib/utilities.lua")

-------------------------------------------------------------------------------

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
	local set_rnd = false 
	if( set_rnd_ ~= nil ) then set_rnd = set_rnd_ end

	if( set_rnd ) then
		SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	end
	
	local good_item_dropped = true
	
	-- using deferred loading of entities, since loading some of them (e.g. potion.xml) will call SetRandomSeed(...)
	-- if position is not given (in entities table), will load the entity to rand_x, rand_y and then move it to chest position
	-- reason for this is that then the SetRandomSeed() of those entities will be deterministic 
	-- but for some reason it cannot be done to random_card.xml, since I'm guessing
	local entities = {}
	local count = 1

	-- if( Random( 0, 100000) >= 100000 ) then
	-- 	EntityLoadEndGameItem( "data/entities/animals/boss_centipede/sampo.xml", x, y )
	-- 	count = 0
	-- 	return 
	-- end

	-- TODO:
	-- [ ] LC/AP component potions
	-- [ ] 2-3 perks to choose from, including Curse Lifter
	-- [ ] live super/giga banana bomb
	-- [ ] live Circle Of Gold spellcast

	local rnd = Random(1,100)
	-- maybe spawn gold (15% chance)
	if ( rnd <= 15 ) then
		local rnd2 = Random( 1,100 )
		if ( rnd2 <= 99 ) then
			table.insert( entities, { "mods/D2DContentPack/files/entities/projectiles/deck/circle_gold_128.xml" } )
		elseif ( rnd2 <= 100) then -- 1/1,000
			table.insert( entities, { "mods/D2DContentPack/files/entities/projectiles/deck/circle_gold_256.xml" } )
		end
	-- maybe spawn a heart (15% chance)
	elseif ( rnd <= 30 ) then
		local rnd2 = Random( 1, 100 )
		if ( rnd2 <= 70 ) then -- 10.5% chance for +50 max hp
			table.insert( entities, { "data/entities/items/pickup/heart.xml" } )
		elseif ( rnd2 <= 85 ) then -- 2.25% chance for +50 max hp
			table.insert( entities, { "data/entities/items/pickup/heart_better.xml" } )
		elseif ( rnd2 <= 100 ) then -- 2.25% chance for a full heal
			table.insert( entities, { "data/entities/items/pickup/heart_fullhp.xml" } )
		end
	-- maybe spawn an item (10% chance)
	elseif ( rnd <= 40 ) then
		local rnd2 = Random( 1, 100 )
		if ( rnd2 <= 30 ) then -- 4%
			table.insert( entities, { "mods/D2DContentPack/files/entities/items/pickup/emergency_injection.xml" } )
		elseif ( rnd2 <= 40 ) then -- 1%
			table.insert( entities, { "data/entities/items/pickup/safe_haven.xml" } )
		elseif ( rnd2 <= 60 ) then -- 2%
			table.insert( entities, { "data/entities/items/pickup/lightningstone.xml" } )
		elseif ( rnd2 <= 80 ) then -- 2%
			table.insert( entities, { "data/entities/items/pickup/brimstone.xml" } )
		elseif ( rnd2 <= 85 ) then -- 0.5%
			table.insert( entities, { "data/entities/items/pickup/waterstone.xml" } )
		elseif ( rnd2 <= 95 ) then -- 1.0%
			table.insert( entities, { "mods/D2DContentPack/files/entities/projectiles/banana_bomb_super.xml"} )
		elseif ( rnd2 <= 100 ) then -- 0.5%
			table.insert( entities, { "mods/D2DContentPack/files/entities/projectiles/banana_bomb_giga.xml"} )
		end
	-- maybe spawn a curse-related spell (15% chance)
	elseif ( rnd <= 55 ) then
		local spells = { "D2D_CURSES_TO_POWER", "D2D_CURSES_TO_MANA" }
		local rnd2 = Random( 1, #spells )
		local spell_to_spawn = spells[rnd2]
   		CreateItemActionEntity( spell_to_spawn, x, y )
	-- maybe spawn a perk (10% chance)
	elseif ( rnd <= 65 ) then
		local rnd2 = Random( 1, 100 )
		if ( not has_perk( "D2D_HUNT_CURSES" ) ) then
			spawn_random_perk( x - 10, y )
			spawn_perk( "D2D_HUNT_CURSES", x + 10, y )
		elseif ( rnd2 <= 70 ) then -- 7%
			spawn_random_perk( x, y )
		elseif ( rnd2 <= 100 ) then -- 3%
			spawn_random_perk( x - 10, y )
			spawn_random_perk( x + 10, y )
		end
		-- else -- 1%
		-- 	spawn_random_perk_custom( x - 10, y, { "D2D_LIFT_CURSES" } )
		-- 	spawn_random_perk( x + 10, y )
		-- end
	-- maybe spawn a bunch of spells (10% chance)
	elseif ( rnd <= 75 ) then
		local amount = 1
		local rnd2 = Random(0,100)
		if (rnd2 <= 50) then -- 5%
			amount = 4
		elseif (rnd2 <= 70) then -- 2%
			amount = amount + 1
		elseif (rnd2 <= 80) then -- 1%
			amount = amount + 2
		elseif (rnd2 <= 90) then -- 1%
			amount = amount + 3
		elseif (rnd2 <= 100) then -- 1%
			amount = amount + 4
		end

		for i=1,amount do
			local spx = x + (i - (amount / 2)) * 12
			local spy = y - 4 + Random(-5,5)

			dofile_once( "data/scripts/items/chest_random.lua" )
			make_random_card( spx, spy )
		end
	-- maybe spawn one or more cats (2% chance), if Apotheosis is enabled
	elseif ( rnd <= 77 and ModIsEnabled("Apotheosis") ) then
		local rnd2 = Random( 1, 100 )
		if( rnd2 <= 50 ) then -- 1% (1/100)
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
		elseif( rnd2 <= 75 ) then -- 0.5% (1/200)
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
		elseif( rnd2 <= 90 ) then -- 0.3% (1/333)
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
		elseif( rnd2 <= 100 ) then -- 0.2% (1/500)
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
			table.insert( entities, { "mods/Apotheosis/data/entities/animals/cat_immortal.xml" } )
		end
	-- maybe spawn a wand
	else
		local rnd2 = Random( 1, 100 )
		if( rnd2 <= 25 ) then -- 6.25%
			table.insert( entities, { "data/entities/items/wand_level_04.xml" } )
		elseif( rnd2 <= 50 ) then -- 6.25%
			table.insert( entities, { "data/entities/items/wand_unshuffle_04.xml" } )
		elseif( rnd2 <= 75 ) then -- 6.25%
			table.insert( entities, { "data/entities/items/wand_level_05.xml" } )
		elseif( rnd2 <= 90 ) then -- 3.75%
			table.insert( entities, { "data/entities/items/wand_unshuffle_05.xml" } )
		elseif( rnd2 <= 96 ) then -- 1.5%
			table.insert( entities, { "data/entities/items/wand_level_06.xml" } )
		elseif( rnd2 <= 98 ) then -- 0.5%
			table.insert( entities, { "data/entities/items/wand_unshuffle_06.xml" } )
		elseif( rnd2 <= 99 ) then -- 0.25%
			table.insert( entities, { "data/entities/items/wand_level_06.xml" } )
		elseif( rnd2 <= 100 ) then -- 0.25%
			table.insert( entities, { "data/entities/items/wand_level_10.xml" } )
		end
	end

	for i,entity in ipairs(entities) do
		local eid = 0 
		if( entity[2] ~= nil and entity[3] ~= nil ) then 
			eid = EntityLoad( entity[1], entity[2], entity[3] ) 
		else
			eid = EntityLoad( entity[1], rand_x, rand_y )
			EntityApplyTransform( eid, x + Random(-10,10), y - 4 + Random(-5,5)  )
		end

		local item_comp = EntityGetFirstComponent( eid, "ItemComponent" )

		-- auto_pickup e.g. gold should have a delay in the next_frame_pickable, since they get gobbled up too fast by the player to see
		if item_comp ~= nil then
			if( ComponentGetValue2( item_comp, "auto_pickup") ) then
				ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 30 )	
			end
		end
	end

	return good_item_dropped
end

function drop_money( entity_item )
	
	-- 
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
	
	if ( distance_between( get_player(), GetUpdatedEntityID() ) <= 100 ) then
		apply_random_curse( get_player() )

		local good_item_dropped = drop_random_reward( x, y, entity_item, rand_x, rand_y, false )
		
		EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
		EntityLoad( "data/entities/particles/image_emitters/chest_effect.xml", x, y )
		-- GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/chest_bad", x, y )
		-- else
		--     EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
		-- end
		if ( has_perk( "D2D_HUNT_CURSES" ) ) then
			LoadGameEffectEntityTo( get_player(), "data/entities/misc/effect_regeneration.xml" )
		end
	end
end

function item_pickup( entity_item, entity_who_picked, name )
	GamePrintImportant( "$log_chest", "" )
	-- GameTriggerMusicCue( "item" )

	--if (remove_entity == false) then
	--	EntityLoad( "data/entities/misc/chest_random_dummy.xml", x, y )
	--end

	on_open( entity_item )
	
	EntityKill( entity_item )
end

function physics_body_modified( is_destroyed )
	-- GamePrint( "A chest was broken open" )
	-- GameTriggerMusicCue( "item" )
	local entity_item = GetUpdatedEntityID()
	
	on_open( entity_item )

	edit_component( entity_item, "ItemComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_item, comp, false )
	end)
	
	EntityKill( entity_item )
end