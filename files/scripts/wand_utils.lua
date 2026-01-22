dofile_once( "data/scripts/lib/utilities.lua" )
EZWand = dofile_once( "mods/D2DContentPack/files/scripts/lib/ezwand.lua" )

function add_random_cards_to_wand( entity_id, level, deck_capacity )

	local is_rare = true
	local x, y = EntityGetTransform( entity_id )

	-- stuff in the gun
	local good_cards = 5
	if( Random(0,100) < 7 ) then good_cards = Random(20,50) end

	if( is_rare == 1 ) then
		good_cards = good_cards * 2
	end

	if( level == nil ) then level = 1 end
	level = tonumber( level )

	local orig_level = level
	level = level - 1
	local deck_capacity = deck_capacity
	local actions_per_round = 1
	local card_count = Random( 1, 3 ) 
	local bullet_card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, 0 )
	local card = ""
	local random_bullets = 0 
	local good_card_count = 0

	if( Random(0,100) < 50 and card_count < 3 ) then card_count = card_count + 1 end 
	
	if( Random(0,100) < 10 or is_rare == 1 ) then 
		card_count = card_count + Random( 1, 2 )
	end

	good_cards = Random( 5, 45 )
	card_count = Random( 0.51 * deck_capacity, deck_capacity )
	card_count = clamp( card_count, 1, deck_capacity-1 )

	-- card count is in between 1 and 6

	if( Random(0,100) < (orig_level*10)-5 ) then
		random_bullets = 1
	end

	-- --------------- CARDS -------------------------
	-- TODO: tweak the % 
	if( Random( 0, 100 ) < 50 ) then

		-- more structured placement
		-- DRAW_MANY + MOD + BULLET

		-- local bullet_card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, 0 )
		local extra_level = level
		while( Random( 1, 10 ) == 10 ) do
			extra_level = extra_level + 1
			bullet_card = GetRandomActionWithType( x, y, extra_level, ACTION_TYPE_PROJECTILE, 0 )
		end

		if( card_count < 3 ) then
			if( card_count > 1 and Random( 0, 100 ) < 20 ) then
				card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, 2 )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			for i=1,card_count do
				AddGunAction( entity_id, bullet_card )
			end
		else
			-- DRAW_MANY + MOD
			if( Random( 0, 100 ) < 40 ) then
				card = GetRandomActionWithType( x, y, level, ACTION_TYPE_DRAW_MANY, 1 )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			-- add another DRAW_MANY
			if( card_count > 3 and Random( 0, 100 ) < 40 ) then
				card = GetRandomActionWithType( x, y, level, ACTION_TYPE_DRAW_MANY, 1 )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			if( Random( 0, 100 ) < 80 ) then
				card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, 2 )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end


			for i=1,card_count do
				AddGunAction( entity_id, bullet_card )
			end
		end
	else
		for i=1,card_count do
			if( Random(0,100) < good_cards and card_count > 2 ) then
				-- if actions_per_round == 1 and the first good card, then make sure it's a draw x
				if( good_card_count == 0 and actions_per_round == 1 ) then
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_DRAW_MANY, i )
					good_card_count = good_card_count + 1
				else
					if( Random(0,100) < 83 ) then
						card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, i )
					else
						card = GetRandomActionWithType( x, y, level, ACTION_TYPE_DRAW_MANY, i )
					end
				end
			
				AddGunAction( entity_id, card )
			else
				AddGunAction( entity_id, bullet_card )
				if( random_bullets == 1 ) then
					bullet_card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, i )
				end
			end
		end
	end
end

function apply_random_wand_upgrades( wand, upgrade_amt, wand_name )
	-- get the wand's base name (i.e. without upgrade suffix)
	local base_wand_name, show_in_ui = wand:GetName()
	local wand_version = 1
	if ( string.find( base_wand_name, " Mk." ) ) then
		wand_version = tonumber( split_string( base_wand_name, " Mk." )[2] ) or 1
		base_wand_name = split_string( base_wand_name, " Mk." )[1]
	end
	if ( string.find( base_wand_name, "_" ) or base_wand_name == "" ) then
		base_wand_name = "Wand"
	end

	if not wand_name then wand_name = base_wand_name end

	-- apply upgrades
	if upgrade_amt == 0 then upgrade_amt = 1 end
	for i = 1, upgrade_amt do
		local rnd = Random( 0, 100 )

		if rnd <= 10 and wand.shuffle == true then -- 5% chance to make non-shuffle
			wand.shuffle = false

			GamePrint("Your " .. wand_name .. " became non-shuffle!")

		elseif rnd <= 20 and wand.capacity < 25 then
			local old_capacity = wand.capacity
			wand.capacity = old_capacity + 1

			GamePrint( "Your " .. wand_name .. "'s capacity was increased! (" .. old_capacity .. " > " .. wand.capacity .. ")" )

		elseif rnd <= 40 and wand.spread > -30.0 then
			local old_spread = wand.spread
			wand.spread = math.max( wand.spread - math.max( wand.spread * 0.5, 3.0 ), -30.0 )

			GamePrint("Your " .. wand_name .. "'s accuracy was increased. (" .. old_spread .. " > " .. wand.spread .. ")" )

		elseif rnd <= 60 and wand.manaMax < 20000 then
			local old_mana_max = wand.manaMax
			wand.manaMax = math.min( old_mana_max + math.max( old_mana_max * 0.1, 30 ), 5000 )

			GamePrint("Your " .. wand_name .. "'s max mana was increased. (" .. string.format( "%.0f", old_mana_max ) .. " > " .. string.format( "%.0f", wand.manaMax ) .. ")" )

		elseif rnd <= 80 and wand.manaChargeSpeed < 20000 then
			local old_mana_charge_speed = wand.manaChargeSpeed
			wand.manaChargeSpeed = math.min( old_mana_charge_speed + math.max( old_mana_charge_speed * 0.1, 30 ), 5000 )

			GamePrint("Your " .. wand_name .. "'s mana charge speed was increased. (" .. string.format("%.0f",old_mana_charge_speed) .. " > " .. string.format("%.0f",wand.manaChargeSpeed) .. ")" )

		elseif rnd <= 100 then
			local old_cast_delay = wand.castDelay
			local old_recharge_time = wand.rechargeTime

			if ( wand.castDelay > -21 ) then
				wand.castDelay = math.max( old_cast_delay - math.max( old_cast_delay * 0.1, 2 ), -21 ) -- at least 0.03s reduction
			end
			if ( wand.rechargeTime > -21) then
				wand.rechargeTime = math.max( old_recharge_time - math.max( old_recharge_time * 0.1, 3 ), -21 ) -- at least 0.05s reduction
			end

			GamePrint("Your " .. wand_name .. "'s fire rate was increased! (" .. string.format( "%.2f", old_cast_delay / 60 ) .. "/" .. string.format( "%.2f", old_recharge_time / 60 ) .. " > " .. string.format( "%.2f", wand.castDelay / 60 ) .. "/" .. string.format( "%.2f", wand.rechargeTime / 60 ) .. ")" )
		end
	end

	-- change the wand's name and play sfx
	wand:SetName( base_wand_name .. " Mk." .. ( wand_version + upgrade_amt ), true )
	-- GamePlaySound( "mods/D2DContentPack/lib/anvil_of_destiny/audio/anvil_of_destiny.bank", "hammer_hit", x, y )
end

function wand_upgrade_shuffle( wand )
	local old_value = wand.capacity

	if wand.shuffle then
		wand.shuffle = false
		GamePrint( "Your wand became non-shuffle!" )
		return true
	end

	GamePrint( "Your wand is already non-shuffle!" )
	return false
end

function wand_upgrade_capacity( wand, increase, limit )
	local old_value = wand.capacity

	if wand.capacity < limit then
		wand.capacity = math.min( old_value + increase, limit )
		GamePrint( "Your wand's capacity was increased! (" .. old_value .. " > " .. wand.capacity .. ")" )
		return true
	end

	GamePrint( "Your wand cannot hold another spell slot!" )
	return false
end

function wand_upgrade_cast_delay( wand, percent, min_increase, limit )
	local old_value = wand.castDelay

	if wand.castDelay > limit then
		wand.castDelay = math.max( old_value - math.max( old_value * percent, min_increase ), limit )
		GamePrint( "Your wand's cast delay was increased! (" .. string.format( "%.2f", old_value / 60 ) .. " > " .. string.format( "%.2f", wand.castDelay / 60 ) .. ")" )
		return true
	end

	GamePrint( "Your wand's cast delay cannot be reduced further!" )
	return false
end

function wand_upgrade_recharge_time( wand, percent, min_increase, limit )
	local old_value = wand.rechargeTime

	if wand.rechargeTime > limit then
		wand.rechargeTime = math.max( old_value - math.max( old_value * percent, min_increase ), limit )
		GamePrint("Your wand's cast delay was increased! (" .. string.format( "%.2f", old_value / 60 ) .. " > " .. string.format( "%.2f", wand.rechargeTime / 60 ) .. ")" )
		return true
	end

	GamePrint( "Your wand's recharge time cannot be reduced further!" )
	return false
end

function wand_upgrade_max_mana( wand, percent, min_increase, limit )
	local old_value = wand.manaMax

	if wand.manaMax < limit then
		wand.manaMax = math.min( old_value + math.max( old_value * percent, min_increase ), limit )
		GamePrint( "Your wand's max mana was increased! (" .. string.format( "%.0f", old_value ) .. " > " .. string.format( "%.0f", wand.manaMax ) .. ")" )
		return true
	end

	GamePrint( "Your wand's max mana cannot be increased further!" )
	return false
end

function wand_upgrade_mana_charge_speed( wand, percent, min_increase, limit )
	local old_value = wand.manaChargeSpeed

	if wand.manaChargeSpeed < limit then
		wand.manaChargeSpeed = math.min( old_value + math.max( old_value * percent, min_increase ), limit )
		GamePrint("Your wand's mana charge speed was increased! (" .. string.format( "%.0f", old_value ) .. " > " .. string.format( "%.0f",wand.manaChargeSpeed ) .. ")" )
		return true
	end

	GamePrint( "Your wand's mana charge speed cannot be increased further!" )
	return false
end

function wand_reset_spells_per_cast( wand )
	local old_value = wand.spellsPerCast

	if wand.spellsPerCast > 1 then
		wand.spellsPerCast = 1
		GamePrint( "Your wand's spells-per-cast was set to 1!" )
		return true
	end

	GamePrint( "Your wand's spells-per-cast is already 1!" )
	return false
end

function wand_remove_random_always_cast( wand )
	local spells, always_casts = wand:GetSpells()
	print( "always casts: " .. #always_casts )
	if #always_casts >= 1 then
		local spell_to_demote = random_from_array( always_casts )
		local spell_name = GameTextGetTranslatedOrNot( get_actions_lua_data( spell_to_demote.action_id ).name )
		GamePrint( "Your wand's always-cast '" .. spell_name .. "' was ejected!" )

		if Random( 1, 2 ) == 2 then
			local x, y = EntityGetTransform( wand.entity_id )
			CreateItemActionEntity( spell_to_demote.action_id, x, y )
		else
			GamePrint( "It was destroyed in the process..." )
		end

		EntityKill( spell_to_demote.entity_id )
		return true
	end

	GamePrint( "Your wand has no always-cast spells!" )
	return false
end

function determine_blink_dmg_mtp()
	-- first check the staff
    local wand = EZWand.GetHeldWand()
    if wand then
    	local tier = get_internal_int( wand.entity_id, "staff_of_time_tier" )
    	if tier == 3 then
    		return 0.02
    	elseif tier == 2 then
    		return 0.05
    	elseif tier == 1 then
    		return 0.10
    	end
    end

    -- if the spell is cast outside of the Staff of Time, check the player's fastest Time Trial completion this run
    if GameHasFlagRun( "d2d_time_trial_gold_this_run" ) then
    	return 0.02
    elseif GameHasFlagRun( "d2d_time_trial_silver_this_run" ) then
    	return 0.05
    else
    	return 0.10
    end
end

function spawn_glass_staff( x, y )
    local wand = EZWand()
    local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
    local wand_lvl = hm_visits
    wand:SetName( "Staff of Glass", true )
    wand.shuffle = false
    wand.spellsPerCast = 1
    wand.castDelay = 5
    wand.rechargeTime = 6
    wand.manaMax = 64 + ( 128 + Random( -4, 4 ) ) * wand_lvl
    wand.manaChargeSpeed = 96 + ( 192 + Random( -4, 4 ) ) * wand_lvl
    wand.capacity = ( wand_lvl * 4 ) + Random( -1, 1 )
    wand.spread = Random( -8, -2 )
    dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
    
    wand:AttachSpells( "D2D_BOLT_CATCHER_ALT_FIRE" )
    wand:AddSpells( "SPREAD_REDUCE", "D2D_COMPACT_SHOT" )
    for i = 1, ( wand.capacity - 2 ) do
    	wand:AddSpells( "D2D_GLASS_SHARD" )
    end

    wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_glass.png", 6, 4, 18, 0 )

    set_internal_int( wand.entity_id, "is_glass", 1 )
    local existing_effect_id = get_child_by_filename( get_player(), "wand_of_glass_on_damage_received" )
    if not existing_effect_id then
        local comp_id = EntityAddComponent( get_player(), "LuaComponent",
        {
            script_damage_received = "mods/D2DContentPack/files/scripts/items/wand_of_glass_on_damage_received.lua",
            execute_every_n_frame = "-1",
        })
    end

    EntityAddTag( wand.entity_id, "glass_wand" )
    wand:PlaceAt( x, y - 20 )
end

function spawn_ancient_staff( x, y )
	local staff = init_ancient_staff()
	staff:PlaceAt( x, y )
end

function init_ancient_staff()
    local wand = EZWand()
    wand:SetName( "Staff of Ancients", true )
    wand.shuffle = false
    wand.spellsPerCast = 1
    wand.castDelay = 5
    wand.rechargeTime = 117
    wand.manaMax = 2277
    wand.manaChargeSpeed = 702
    wand.capacity = 25
    wand.spread = 0
	wand:AddSpells( "D2D_PROJECTILE_MORPH", "ACCELERATING_SHOT", "AREA_DAMAGE", "D2D_SHOCKWAVE", "D2D_RECYCLE_PLUS", "LARPA_DEATH", "D2D_RECYCLE_PLUS", "DARKFLAME" )

    wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_ancient_2.png", 11, 4, 17, 0 )
    EntityAddChild( wand.entity_id, EntityLoad( "mods/D2DContentPack/files/entities/items/staff_of_ancients.xml" ) )
    
    return wand
end

-- switching mods could cause stored spells to no longer 'exist' when the wand is loaded in
function does_spell_exist( action_id )
	if spell == "" then return false end
    dofile_once( "data/scripts/gun/gun_actions.lua" )

    for i,action in ipairs( actions ) do
    	if action.id == action_id then
    		return true
    	end
    end
    return false
end

function init_staff_of_remembrance()
    local wand = EZWand()
    wand:SetName( "Staff of Remembrance", true )
    wand.shuffle = false
    wand.spellsPerCast = 1
    wand.castDelay = 3
    wand.rechargeTime = 20
    wand.manaMax = 255
    wand.manaChargeSpeed = 187
    wand.capacity = 5
    wand.spread = 0

    local csv = ModSettingGet( "D2DContentPack.som_stored_spells" )
    if csv and csv ~= "" then
        local spells = split_string( csv, ',' )

        local spells_added = 0
        for i,spell in ipairs( spells ) do
            if does_spell_exist( spell ) and spells_added < 5 then
                wand:AddSpells( spell )
                spells_added = spells_added + 1
            end
        end
    else
    	-- define the wand's initial spells
    	-- wand:AddSpells( "I_SHAPE", "TELEPORT_PROJECTILE_SHORT", "D2D_GHOST_TRIGGER", "CIRCLE_WATER" )
    	-- wand:AddSpells( "I_SHAPE", "TELEPORT_PROJECTILE_SHORT", "LIGHTNING" )
    	wand:AddSpells( "LARPA_DEATH", "LIGHT", "GLOWING_BOLT" )
    end

    wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/remembrance.png", 10, 4, 15, 0 )
    EntityAddChild( wand.entity_id, EntityLoad( "mods/D2DContentPack/files/entities/items/wand_of_memories.xml" ) )

    return wand
end

function spawn_staff_of_transience( x, y )
    local wand = EZWand()
	wand:SetName( "Staff of Transience", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = 5
	wand.rechargeTime = 20
	wand.manaMax = 2277 -- (~1.67x regular high mana wands)
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = 0
	wand.capacity = 25
	wand.spread = 0
	-- wand:AttachSpells( "D2D_MANA_LOCK" ) -- disabled until this spell is fixed
	wand:AddSpells( "D2D_MISSING_MANA_TO_DMG" )
	add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_zs.png", 11, 4, 17, 0 )
	wand:PlaceAt( x, y )
end

function init_staff_of_finality( x, y )
    local wand = EZWand()
	wand:SetName( "Staff of Finality", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = 36
	wand.rechargeTime = 216
	wand.manaMax = 4999
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = 1
	wand.capacity = 25
	wand.spread = -13.2
	-- wand:AttachSpells( "D2D_MANA_LOCK" ) -- disabled until this spell is fixed
	wand:AttachSpells( "D2D_MISSING_MANA_TO_DMG" )
	wand:AddSpells( "D2D_RECYCLE_PLUS", "ROCKET", "D2D_RECYCLE_PLUS", "ROCKET_TIER_2", "D2D_RECYCLE_PLUS", "ROCKET_TIER_3" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_ags.png", 8, 6, 17, 0 )

	return wand
end

function spawn_staff_of_obliteration( x, y )
	local staff = init_staff_of_obliteration()
	staff:PlaceAt( x, y )
end

function init_staff_of_obliteration()
    local wand = EZWand()
	wand:SetName( "Staff of Obliteration", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	-- wand.castDelay = 15
	-- wand.rechargeTime = 20
	wand.castDelay = 0
	wand.rechargeTime = 0
	wand.manaMax = 999
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = 512
	wand.capacity = 25
	wand.spread = 0
	-- wand:AttachSpells( "D2D_MISSING_MANA_TO_DMG" )
	wand:AttachSpells( "D2D_CURSES_TO_DAMAGE", "D2D_CURSES_TO_MANA" )
	wand:AddSpells( "D2D_DEATH_RAY" )
	-- wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_mjav.png", 8, 6, 14, 0 )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_cursed.png", 8, 6, 19, 0 )
	-- wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_soa.png", 12, 6, 14, 0 )

	return wand
end

function spawn_staff_of_loyalty( x, y )
	local staff = init_staff_of_loyalty()
	staff:PlaceAt( x, y )
end

function init_staff_of_loyalty()
	local wand = EZWand()

	wand:SetName( "Staff of Loyalty", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = Random( 6, 9 )
	wand.rechargeTime = Random( 15, 20 )
	wand.manaMax = Random( 470, 520 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 145, 160 )
	wand.capacity = 8
	wand.spread = 0

	wand:AttachSpells( "D2D_ANIMATE_WAND_MID_FIRE", "D2D_SPARK_BOLT_ENHANCER" )
	wand:AddSpells( "LIGHT_BULLET", "LIGHT_BULLET", "D2D_COMPACT_SHOT" )
	for i = 1, ( wand.capacity - 3 ) do
		wand:AddSpells( "LIGHT_BULLET" )
	end

	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_loyalty_t1.png", 8, 4, 17, 0 )
	EntityAddTag( wand.entity_id, "d2d_staff_of_loyalty" )
	set_internal_int( wand.entity_id, "d2d_staff_tier", 1 )
    EntityAddComponent2( wand.entity_id, "LuaComponent", {
    	script_item_picked_up = "mods/D2DContentPack/files/scripts/items/wands/staff_of_loyalty_on_pickup.lua",
		execute_every_n_frame = -1,
    })

	return wand
end

function upgrade_staff_of_loyalty( original )
	local wand = EZWand()

	wand:SetName( "Staff of Loyalty", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = Random( 3, 6 )
	wand.rechargeTime = Random( 10, 15 )
	wand.manaMax = Random( 940, 1040 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 290, 320 )
	wand.capacity = 18
	wand.spread = 0
	local spells, always_casts = original:GetSpells()
	for i,always_cast in ipairs( always_casts ) do
		wand:AttachSpells( always_cast.action_id )
	end
	for i,spell in ipairs( spells ) do
		wand:AddSpells( spell.action_id )
	end
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_loyalty_t2.png", 10, 4, 18, 0 )
	EntityAddTag( wand.entity_id, "d2d_staff_of_loyalty" )
	set_internal_int( wand.entity_id, "d2d_staff_tier", 2 )
    EntityAddComponent2( wand.entity_id, "LuaComponent", {
    	script_item_picked_up = "mods/D2DContentPack/files/scripts/items/wands/staff_of_loyalty_on_pickup.lua",
		execute_every_n_frame = -1,
    })

    -- place the wand
	local x, y = EntityGetTransform( original.entity_id )
	wand:PlaceAt( x, y )

	-- make it pop
	GamePrintImportant( "Your loyalty has borne fruit" )
	EntityLoad( "data/entities/particles/image_emitters/chest_effect.xml", x, y )

	-- destroy the original
	EntityKill( original.entity_id )
end