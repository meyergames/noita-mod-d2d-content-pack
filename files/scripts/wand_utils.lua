dofile_once( "data/scripts/lib/utilities.lua" )

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

function spawn_random_staff( x, y, force_rng )
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	local wand = EZWand()

	local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
	local wand_lvl = hm_visits + 1

	SetRandomSeed( x, y + GameGetFrameNum() )
	local rng = force_rng or Random( 1, 100 )
	if( rng <= 20 ) then

		wand:SetName( "Staff of Justice", true )
		wand.shuffle = false
		wand.spellsPerCast = 1
		wand.castDelay = Random( 31, 59 ) -- between 0.50 and 1.00
		wand.rechargeTime = Random( 61, 89 ) -- between 1.00 and 1.50
		wand.manaMax = ( 50 + (150 * wand_lvl) + ( Random( -5, 5 ) * 10 ) ) * 3 -- existing formula for high mana wands
		wand.manaChargeSpeed = wand.manaMax / 30 -- always takes 30s to reach full mana
		wand.capacity = Random( 3, 5 ) + math.ceil( wand_lvl / 2 )
		wand.spread = Random( -5, 0 )
		wand:AttachSpells( "SPEED", "EXPLOSIVE_PROJECTILE", "DAMAGE_FOREVER" )
		wand:AddSpells( "D2D_SNIPE_SHOT" )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_ags.png", 8, 6, 17, 0 )

	elseif( rng <= 40 ) then

		wand:SetName( "Staff of Transience", true )
		wand.shuffle = false
		wand.spellsPerCast = 1
		wand.castDelay = Random( -3, 5 )
		wand.rechargeTime = Random( 3, 9 )
		wand.manaMax = ( 50 + (150 * wand_lvl) + ( Random( -5, 5 ) * 10 ) ) * 5 -- (~1.67x regular high mana wands)
		wand.mana = wand.manaMax
		wand.manaChargeSpeed = 0
		wand.capacity = Random( 3, 5 ) + ( wand_lvl * 2 )
		wand.spread = Random( -3, 3 )
		wand:AttachSpells( "D2D_MANA_LOCK" )
		wand:AddSpells( "D2D_CURSES_TO_DAMAGE" )
		add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_zs.png", 11, 4, 17, 0 )

	elseif( rng <= 60 ) then

		wand:SetName( "Staff of Ancients", true )
		wand.shuffle = false
		wand.spellsPerCast = 1
		wand.castDelay = Random( -3, 5 )
		wand.rechargeTime = Random( 3, 7 )
		wand.manaMax = 128 + ( 128 + Random( -4, 4 ) ) * wand_lvl
		wand.manaChargeSpeed = 192 + ( 192 + Random( -4, 4 ) ) * wand_lvl
		wand.capacity = Random( 3, 5 ) + ( wand_lvl * 2 )
		wand.spread = Random( -5, 0 )
		wand:AttachSpells( "FREEZE" )
		wand:AddSpells( "D2D_CURSES_TO_DAMAGE" )
		add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_ancient.png", 11, 4, 17, 0 )

	-- elseif( rng <= 80 ) then

	-- 	wand:SetName( "Staff of Duality", true )
	-- 	wand.shuffle = false
	-- 	wand.spellsPerCast = 1
	-- 	wand.castDelay = Random( -3, 5 )
	-- 	wand.rechargeTime = Random( 3, 7 )
	-- 	wand.manaMax = 128 + ( 128 + Random( -4, 4 ) ) * wand_lvl
	-- 	wand.manaChargeSpeed = 192 + ( 192 + Random( -4, 4 ) ) * wand_lvl
	-- 	wand.capacity = Random( 3, 5 ) + ( wand_lvl * 2 )
	-- 	wand.spread = 0
	-- -- 	-- local random_attach_2 = { "DYNAMITE", "BOMB", "ROCKET" }
	-- 	wand:AttachSpells( "I_SHOT" )
	-- 	add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
	-- 	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_dual.png", 15, 4, 14, 0 )

	elseif( rng <= 80 ) then

		wand:SetName( "Staff of Humble Beginnings", true )
		wand.shuffle = false
		wand.spellsPerCast = 1
		wand.castDelay = Random( 9, 15 )
		wand.rechargeTime = Random( 20, 28 )
		wand.manaMax = Random( 80, 130 ) * 10
		wand.manaChargeSpeed = Random( 25, 40 ) * 10
		wand.capacity = 20
		wand.spread = 0
		wand:AddSpells( "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET", "LIGHT_BULLET" )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_starter_1.png", 11, 4, 17, 0 )

	elseif( rng <= 100 ) then

		wand:SetName( "Staff of Humble Bombings", true )
		wand.shuffle = true
		wand.spellsPerCast = 1
		wand.castDelay = Random( 3, 8 )
		wand.rechargeTime = Random( 1, 10 )
		wand.manaMax = Random( 80, 110 ) * 10
		wand.manaChargeSpeed = Random( 5, 20 ) * 10
		wand.capacity = 1
		wand.spread = 0
		wand:AttachSpells( "EXPLOSIVE_PROJECTILE", "EXPLOSIVE_PROJECTILE", "EXPLOSIVE_PROJECTILE", "EXPLOSIVE_PROJECTILE" )
		wand:AddSpells( "BOMB" )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_starter_2.png", 11, 4, 17, 0 )

	-- elseif( rng <= 120 ) then

	-- 	wand:SetName( "Staff of Glass", true )
	-- 	wand.shuffle = false
	-- 	wand.spellsPerCast = 1
	-- 	wand.castDelay = Random( -4, -1 )
	-- 	wand.rechargeTime = Random( 1, 4 )
	-- 	wand.manaMax = 128 + ( 128 + Random( -4, 4 ) ) * wand_lvl
	-- 	wand.manaChargeSpeed = 192 + ( 192 + Random( -4, 4 ) ) * wand_lvl
	-- 	wand.capacity = Random( 3, 5 ) + ( wand_lvl * 2 )
	-- 	wand.spread = Random( -8, -2 )
	-- 	add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
	-- 	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_glass.png", 6, 4, 18, 0 )

	-- 	set_internal_int( wand.entity_id, "is_glass", 1 )
	-- 	local existing_effect_id = get_internal_int( get_player(), "glass_wand_effect_id" )
	-- 	if not existing_effect_id then
	-- 		local comp_id = EntityAddComponent( get_player(), "LuaComponent",
	-- 		{
	-- 			script_damage_received = "mods/D2DContentPack/files/scripts/items/wand_of_glass_on_damage_received.lua",
	-- 			execute_every_n_frame = "-1",
	-- 		})
	-- 		set_internal_int( get_player(), "glass_wand_effect_id", comp_id )
	-- 	end

	end

	-- wand:UpdateSprite()
	wand:PlaceAt( x, y )
end

function Test_SpawnCommunityModWand()
    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
    local wand = EZWand()
    local x, y = EntityGetTransform( get_player() )

    local rnd = Random( 1, 14 )
    if rnd == 1 then
	    wand:SetName( "Bolt", true )
	    wand.shuffle = false
	    wand.spellsPerCast = 1
	    wand.castDelay = 2 -- 0.03
	    wand.rechargeTime = Random( 28, 35 ) -- between 0.47 and 0.58
	    wand.manaMax = Random( 90, 110 )
	    wand.manaChargeSpeed = Random( 27, 33 )
	    wand.capacity = 4
	    wand.spread = 0
	    wand:AddSpells( "LIGHT_BULLET", "LIGHT_BULLET", "SCATTER_2", "ELECTRIC_CHARGE" )
	    -- wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_ags.png", 8, 6, 17, 0 )
		-- wand:UpdateSprite()
		wand:PlaceAt( x - 10, y - 20 )

	    wand:SetName( "Wand", true )
	    wand.shuffle = true
	    wand.spellsPerCast = 1
	    wand.castDelay = Random( 3, 8 ) -- between 0.03 and 0.07
	    wand.rechargeTime = Random( 1, 10 ) -- between 0.52 and 0.58
	    wand.manaMax = Random( 72, 78 )
	    wand.manaChargeSpeed = Random( 22, 28 )
	    wand.capacity = 1
	    wand.spread = 0
	    wand:AddSpells( "LIGHT_BULLET", "LIGHT_BULLET", "SCATTER_2", "ELECTRIC_CHARGE" )
	    -- wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_ags.png", 8, 6, 17, 0 )
		-- wand:UpdateSprite()
		wand:PlaceAt( x + 10, y - 20 )
	end

    local x, y = EntityGetTransform( get_player() )
	wand:PlaceAt( x, y - 20 )
end

function apply_random_wand_upgrades( wand, upgrade_amt, wand_name )
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

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

function spawn_glass_staff( x, y )
    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
    local wand = EZWand()
    local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
    local wand_lvl = hm_visits + 1
    wand:SetName( "Staff of Glass", true )
    wand.shuffle = false
    wand.spellsPerCast = 1
    wand.castDelay = Random( 1, 5 ) - wand_lvl
    wand.rechargeTime = Random( 6, 10 ) - ( wand_lvl * 2 )
    wand.manaMax = 64 + ( 128 + Random( -4, 4 ) ) * wand_lvl
    wand.manaChargeSpeed = 96 + ( 192 + Random( -4, 4 ) ) * wand_lvl
    wand.capacity = Random( 3, 5 ) + ( wand_lvl * 2 )
    wand.spread = Random( -8, -2 )
    dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
    add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
    wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_glass.png", 6, 4, 18, 0 )

    set_internal_int( wand.entity_id, "is_glass", 1 )
    local existing_effect_id = get_child_with_name( get_player(), "wand_of_glass_on_damage_received" )
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