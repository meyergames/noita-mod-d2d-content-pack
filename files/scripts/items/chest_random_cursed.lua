dofile_once("data/scripts/lib/utilities.lua")

-------------------------------------------------------------------------------

function random_perk_reward( x, y )
	if ( not has_perk( "D2D_HUNT_CURSES" ) ) then
		spawn_random_perk( x - 20, y )
		spawn_perk( "D2D_HUNT_CURSES", x, y )
		spawn_random_perk( x + 20, y )
	else
		-- local rnd = Random( 1, 100 )
		spawn_random_perk( x - 20, y )
		spawn_random_perk( x, y )
		spawn_random_perk( x + 20, y )
	end
	-- else -- 1%
	-- 	spawn_random_perk_custom( x - 10, y, { "D2D_LIFT_CURSES" } )
	-- 	spawn_random_perk( x + 10, y )
	-- end
end

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
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

	local cursed_chests_opened = get_internal_int( get_player(), "d2d_cursed_chests_opened" )
	if cursed_chests_opened == 1 then
		random_perk_reward()
	else
		local rnd = Random(1,100)
		-- maybe spawn gold (10% chance)
		if ( rnd <= 10 ) then
			local rnd2 = Random( 1,100 )
			if rnd2 <= 99 - cursed_chests_opened then -- higher chance for the big circle if you have more curses
				table.insert( entities, { "mods/D2DContentPack/files/entities/projectiles/deck/circle_gold_128.xml" } )
			elseif rnd2 <= 100 then -- 1/1,000
				table.insert( entities, { "mods/D2DContentPack/files/entities/projectiles/deck/circle_gold_256.xml" } )
			end
		-- maybe spawn a hammer (5% chance)
		elseif ( rnd <= 15 ) then
			table.insert( entities, { "mods/D2DContentPack/files/entities/items/pickup/hammer.xml" } )
		-- maybe spawn a heart (15% chance)
		elseif ( rnd <= 30 ) then
			local rnd2 = Random( 1, 100 )
			if ( rnd2 <= 80 ) then -- 12% chance for +50 max hp
				table.insert( entities, { "data/entities/items/pickup/heart_better.xml" } )
			elseif ( rnd2 <= 100 ) then -- 3% chance for a full heal
				table.insert( entities, { "data/entities/items/pickup/heart_fullhp.xml" } )
			end
		-- maybe spawn an item (15-5% chance)
		elseif rnd <= math.max( 45 - cursed_chests_opened, 35 ) then
			local rnd2 = Random( 1, 100 )
			if ( rnd2 <= 25 ) then -- 2.5%
				table.insert( entities, { "mods/D2DContentPack/files/entities/items/pickup/emergency_injection.xml" } )
			elseif ( rnd2 <= 35 ) then -- 1%
				table.insert( entities, { "data/entities/items/pickup/safe_haven.xml" } )
			elseif ( rnd2 <= 65 ) then -- 3%
				table.insert( entities, { "data/entities/items/pickup/lightningstone.xml" } )
			elseif ( rnd2 <= 95 ) then -- 3%
				table.insert( entities, { "data/entities/items/pickup/brimstone.xml" } )
			elseif ( rnd2 <= 100 ) then -- 0.5%
				table.insert( entities, { "data/entities/items/pickup/waterstone.xml" } )
			end
		-- maybe spawn a perk (15-25% chance)
		elseif ( rnd <= 55 ) then
			random_perk_reward()
		-- maybe spawn a bunch of spells, including a guaranteed curse-related spell (15% chance)
		elseif ( rnd <= 70 ) then
			local spells = { "D2D_CURSES_TO_DAMAGE", "D2D_CURSES_TO_MANA" }
			local rnd2 = Random( 1, #spells )
			local spell_to_spawn = spells[rnd2]
	   		CreateItemActionEntity( spell_to_spawn, x, y )

			local amount = 3
			local rnd2 = Random(0,100)
			if (rnd2 <= 50) then -- 5%
				amount = 3
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
		-- maybe spawn a wand (30% chance)
		else
			local rnd3 = Random( 1, 100 )
			if cursed_chests_opened <= 2 then

				if rnd3 <= 50 then -- 50%
					table.insert( entities, { "data/entities/items/wand_unshuffle_04.xml" } )
				elseif rnd3 <= 80 then -- 30%
					table.insert( entities, { "data/entities/items/wand_level_04.xml" } )
				elseif rnd3 <= 100 then -- 20% (i.e. 6%)
			    	dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
					spawn_random_staff( x, y )
				end

			elseif cursed_chests_opened <= 3 then

				if rnd3 <= 50 then -- 50%
					table.insert( entities, { "data/entities/items/wand_unshuffle_05.xml" } )
				elseif rnd3 <= 80 then -- 30%
					table.insert( entities, { "data/entities/items/wand_level_05.xml" } )
				elseif rnd3 <= 100 then -- 20% (i.e. 6%)
			    	dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
					spawn_random_staff( x, y )
				end

			elseif cursed_chests_opened <= 4 then

				if rnd3 <= 50 then -- 50%
					table.insert( entities, { "data/entities/items/wand_unshuffle_06.xml" } )
				elseif rnd3 <= 80 then -- 30%
					table.insert( entities, { "data/entities/items/wand_level_06.xml" } )
				elseif rnd3 <= 100 then -- 20% (i.e. 6%)
			    	dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
					spawn_random_staff( x, y )
				end

			elseif cursed_chests_opened >= 5 then

				if rnd3 <= 25 then -- 25%
					table.insert( entities, { "data/entities/items/wand_unshuffle_06.xml" } )
				elseif rnd3 <= 40 then -- 15%
					table.insert( entities, { "data/entities/items/wand_level_06.xml" } )
				elseif rnd3 <= 80 then -- 40%
					table.insert( entities, { "data/entities/items/wand_level_10.xml" } )
				elseif rnd3 <= 100 then -- 20% (i.e. 6%)
			    	dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
					spawn_random_staff( x, y )
				end
			end
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
	raise_internal_int( get_player(), "d2d_cursed_chests_opened" )

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
		
		-- local config_curses_enabled = ModSettingGet("D2DContentPack.enable_curses")
		-- if config_curses_enabled then
		EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
		-- end

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