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

function spawn_random_staff( x, y )
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	local wand = EZWand()

	local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
	local wand_lvl = hm_visits + 1

	SetRandomSeed( x, y + GameGetFrameNum() )
	local rng = force_rng or Random( 1, 100 )
	if( rng <= 25 ) then

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

	elseif( rng <= 50 ) then

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
		wand:AddSpells( "D2D_EXPAND_MANA" )
		add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_zs.png", 11, 4, 17, 0 )

	elseif( rng <= 75 ) then

		wand:SetName( "Staff of Ancients", true )
		wand.shuffle = false
		wand.spellsPerCast = 1
		wand.castDelay = Random( -3, 5 )
		wand.rechargeTime = Random( 3, 7 )
		wand.manaMax = 128 + ( 128 + Random( -4, 4 ) ) * wand_lvl
		wand.manaChargeSpeed = 192 + ( 192 + Random( -4, 4 ) ) * wand_lvl
		wand.capacity = Random( 3, 5 ) + ( wand_lvl * 2 )
		wand.spread = Random( -5, 0 )
		local random_attach = { "ANTI_HOMING", "LINE_ARC", "HORIZONTAL_ARC", "CHAOTIC_ARC", "TRUE_ORBIT", "GRAVITY", "DECELERATING_SHOT", "ACCELERATING_SHOT", "MATERIAL_ACID", "WATER_TO_POISON", "BLOOD_TO_ACID", "ZERO_DAMAGE", "EXPLOSION_REMOVE", "RECOIL", "LIFETIME_DOWN" }
		wand:AttachSpells( random_attach[ Random( 1, #random_attach ) ] )
		add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_ancient.png", 11, 4, 17, 0 )

	elseif( rng <= 100 ) then

		wand:SetName( "Staff of Glass", true )
		wand.shuffle = false
		wand.spellsPerCast = 1
		wand.castDelay = Random( -4, -1 )
		wand.rechargeTime = Random( 1, 4 )
		wand.manaMax = 128 + ( 128 + Random( -4, 4 ) ) * wand_lvl
		wand.manaChargeSpeed = 192 + ( 192 + Random( -4, 4 ) ) * wand_lvl
		wand.capacity = Random( 3, 5 ) + ( wand_lvl * 2 )
		wand.spread = Random( -8, -2 )
		add_random_cards_to_wand( wand.entity_id, wand_lvl, wand.capacity )
		wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_glass.png", 6, 4, 18, 0 )

		set_internal_int( wand.entity_id, "is_glass", 1 )
		local existing_effect_id = get_internal_int( get_player(), "glass_wand_effect_id" )
		if not existing_effect_id then
			local comp_id = EntityAddComponent( get_player(), "LuaComponent",
			{
				script_damage_received = "mods/D2DContentPack/files/scripts/items/wand_of_glass_on_damage_received.lua",
				execute_every_n_frame = "-1",
			})
			set_internal_int( get_player(), "glass_wand_effect_id", comp_id )
		end

	end

	-- wand:UpdateSprite()
	wand:PlaceAt( x, y )
end