dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/perks.lua" )

-------------------------------------------------------------------------------

function random_wand_reward( x, y, cursed_chests_opened )
	SetRandomSeed( x, y + GameGetFrameNum() )

	local rnd = Random( 1, 100 )
	local chance_for_t10 = cursed_chests_opened * 1 -- 1% at first, up to 10% after 10 (and 20% after 20)
	local chance_for_t6 = cursed_chests_opened * 3 -- 3% at first, up to 30% after 10
	local chance_for_t5 = cursed_chests_opened * 6 -- 6% at first, up to 60% after 10
	local chance_for_t4 = cursed_chests_opened * 20 -- 20% at first, up to 100% after 5
	local is_non_shuffle = Random( 1, 20 ) < cursed_chests_opened + 10

	if rnd < chance_for_t10 then

		EntityLoad( "data/entities/items/wand_level_10.xml", x, y )

	elseif rnd < chance_for_t6 then

		if is_non_shuffle then
			EntityLoad( "data/entities/items/wand_unshuffle_06.xml", x, y )
		else
			EntityLoad( "data/entities/items/wand_level_06.xml", x, y )
		end

	elseif rnd < chance_for_t5 then

		if is_non_shuffle then
			EntityLoad( "data/entities/items/wand_unshuffle_05.xml", x, y )
		else
			EntityLoad( "data/entities/items/wand_level_05.xml", x, y )
		end

	elseif rnd < chance_for_t4 then

		if is_non_shuffle then
			EntityLoad( "data/entities/items/wand_unshuffle_04.xml", x, y )
		else
			EntityLoad( "data/entities/items/wand_level_04.xml", x, y )
		end

	else

		if is_non_shuffle then
			EntityLoad( "data/entities/items/wand_unshuffle_03.xml", x, y )
		else
			EntityLoad( "data/entities/items/wand_level_03.xml", x, y )
		end

	end
end

function random_perk_reward( x, y, cursed_chests_opened )
	SetRandomSeed( x, y + GameGetFrameNum() )

    local blurses = {}
	local blurses_already_spawned = GlobalsGetValue( "d2d_blurses_spawned", "" )
	for k,v in ipairs( d2d_blurses or {} ) do
		if not has_perk( v.id ) and not string.find( blurses_already_spawned, v.id ) then
			table.insert( blurses, v.id )
		end
	end

	if #blurses > 0 and cursed_chests_opened % 2 == 1 then
		local random_blurse_id = random_from_array( blurses )
		spawn_perk( random_blurse_id, x, y )
		GlobalsSetValue( "d2d_blurses_spawned", blurses_already_spawned .. random_blurse_id .. "," )

		spawn_random_perk( x - 20, y )
		spawn_random_perk( x + 20, y )
	else
		spawn_random_perk( x - 20, y )
		spawn_random_perk( x, y )
		spawn_random_perk( x + 20, y )
	end
end

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
    local max_curse_count = #d2d_curses
	local cursed_chests_opened = get_internal_int( get_player(), "d2d_cursed_chests_opened" )

	if cursed_chests_opened == 1 then

		-- on the first chest, spawn the Curse Hunter perk and the "Curses To X" spells
		spawn_perk( "D2D_HUNT_CURSES", x, y )
   		CreateItemActionEntity( "D2D_CURSES_TO_DAMAGE", x - 20, y )
   		CreateItemActionEntity( "D2D_CURSES_TO_MANA", x + 20, y )
		random_wand_reward( x, y - 20, cursed_chests_opened )

	elseif cursed_chests_opened == max_curse_count + 1 then

		-- on the last chest, spawn the Lift Curses perk and the Staff of Obliteration
		spawn_perk( "D2D_LIFT_CURSES", x, y )
		spawn_staff_of_obliteration( x, y - 20 )
		AddFlagPersistent( "d2d_staff_of_obliteration_obtained" )

	else

		-- on most chests, give random perks to choose from, including a Blurse if possible
		random_perk_reward( x, y, cursed_chests_opened )
		random_wand_reward( x, y - 20, cursed_chests_opened )

	end
end

function on_open( entity_item )
	raise_internal_int( get_player(), "d2d_cursed_chests_opened", 1 )

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
	
	if ( distance_between( get_player(), entity_item ) <= 100 ) then
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