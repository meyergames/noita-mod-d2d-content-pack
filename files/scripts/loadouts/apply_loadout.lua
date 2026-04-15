dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
dofile("data/scripts/perks/perk.lua")

local curses_enabled = ModSettingGet( "D2DContentPack.enable_curses_on_loadouts" )

-- this function was copied from the Selectable Classes mod
local function give_perk( target, perk )
    local data = get_perk_with_id(perk_list, perk)

    --apply game effect
    if data.game_effect ~= nil then
        local game_effect_comp = GetGameEffectLoadTo( target, data.game_effect, true )
        if game_effect_comp ~= nil then
            ComponentSetValue(game_effect_comp, "frames", "-1")
        end
    end

    --call extra function
    if data.func ~= nil then
        --these aren't the right arguments, but none of the perks
        --use entity_perk_item or item_name anyway (why would they...?)
        data.func( target, target, perk, 1 )
    end

    --add to UI
    local perk_ui = EntityCreateNew( "" )
    EntityAddComponent( perk_ui, "UIIconComponent", { 
        name = data.ui_name,
        description = data.ui_description,
        icon_sprite_file = data.ui_icon
    })
    EntityAddChild( target, perk_ui )
end

local function empty_inventory( player )
    local wands = {}
    local children = EntityGetAllChildren( player ) or {}
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            local may_be_wands = EntityGetAllChildren( child ) or {}
            if #may_be_wands > 0 then
                for i,may_be_wand in ipairs( may_be_wands ) do
                    -- if EntityHasTag( may_be_wand, "wand" ) then
                        table.insert( wands, may_be_wand )
                    -- end
                end
            end
        end
    end

    if #wands > 0 then
        for i,wand in ipairs( wands ) do
        	EntityKill( wand )
        end
    end
end

function spawn_loadout_sniper( player )
	empty_inventory( player )

	local x, y = EntityGetTransform( player )
	y = y - 32

	-- spawn the second wand first, for some reason
    wand = EZWand()
	wand:SetName( "Extractor", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = 6
	wand.rechargeTime = 17
	wand.manaMax = Random( 90, 99 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 12, 17 )
	wand.capacity = 3
	wand.spread = 0
	wand:AddSpells(
		"DIGGER",
		"D2D_ALT_FIRE_ANYTHING",
		"D2D_GIGA_DRAIN" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/loadouts/sniper_2.png", 3, 3, 8, 0 )
	wand:PutInPlayersInventory()

	-- spawn the first wand
    local wand = EZWand()
	wand:SetName( "Crossbow", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = Random( 8, 12 )
	wand.rechargeTime = Random( 72, 78 )
	wand.manaMax = Random( 170, 220 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 12, 15 )
	wand.capacity = 5
	wand.spread = -5
	wand:AddSpells(
		"D2D_RELOAD_SHIELD",
		"D2D_SNIPE_SHOT" )
	wand:RemoveSpells( "LIGHT_BULLET", "LIGHT_BULLET" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/loadouts/sniper_1.png", 10, 5, 11, 0 )
	wand:PutInPlayersInventory()

	-- spawn perks
	give_perk( player, "INVISIBILITY" )
	give_perk( player, "D2D_ALL_SEEING_EYE" )
	give_perk( player, "LOWER_SPREAD" )
	if curses_enabled then
		give_perk( player, "D2D_CURSE_FRAGILE" )
	end

    -- set the player's health
    local dmg_comp = EntityGetFirstComponentIncludingDisabled( player, "DamageModelComponent" )
    if exists( dmg_comp ) then
    	ComponentSetValue2( dmg_comp, "hp", 2 ) -- 50 hp
    	ComponentSetValue2( dmg_comp, "max_hp", 2 ) -- 50 hp
    end

    -- start with a vial of water
    local x, y = EntityGetTransform( player )
    local water = EntityLoad( "data/entities/items/pickup/potion_water.xml", x, y )
    GamePickUpInventoryItem( player, water, false )
end

function spawn_loadout_tinkerer( player )
	empty_inventory( player )

	local x, y = EntityGetTransform( player )
	y = y - 32

	-- spawn the second wand first, for some reason
    local wand = EZWand()
	wand:SetName( "Wand Mk.2", true )
	wand.shuffle = true
	wand.spellsPerCast = 2
	wand.castDelay = Random( 3, 8 )
	wand.rechargeTime = Random( 1, 10 )
	wand.manaMax = Random( 320, 440 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 5, 20 )
	wand.capacity = 2
	wand.spread = 5
	wand:AddSpells( "D2D_BAG_OF_BOMBS", "D2D_BAG_OF_BOMBS" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/loadouts/tinkerer_2.png", 2, 4, 9, 0 )
	wand:PutInPlayersInventory()

	-- spawn the first wand
    local wand = EZWand()
	wand:SetName( "Wands", true )
	wand.shuffle = true
	wand.spellsPerCast = 1
	wand.manaMax = Random( 170, 220 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 50, 70 )
	wand.capacity = 10
	wand.spread = 15
	if not curses_enabled then
		wand.castDelay = Random( 1, 2 )
		wand.rechargeTime = Random( 16, 24 )
		wand:AttachSpells( "D2D_OVERCLOCK" )
	else
		wand.castDelay = Random( -14, -13 )
		wand.rechargeTime = Random( 1, 2 )
	end
	wand:AttachSpells(
		"CHAOTIC_ARC",
		"BOUNCE" )
	wand:AddSpells(
		"LIGHT_BULLET",
		"RUBBER_BALL",
		"SPITTER",
		"BUBBLESHOT",
		"BOUNCY_ORB",
		"ARROW",
		"BUCKSHOT",
		"DISC_BULLET",
		"D2D_GLASS_SHARD",
		"D2D_ECHO_SHOT" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/loadouts/tinkerer_1.png", 4, 5, 17, 0 )
	wand:PutInPlayersInventory()

	-- perks
	give_perk( player, "D2D_SUMMON_TOOLBOX" )
	give_perk( player, "D2D_TINKER_WITH_WANDS_MORE" )
	give_perk( player, "WAND_EXPERIMENTER" )
	if curses_enabled then
		give_perk( player, "D2D_CURSE_OVERHEATING" )
	end

	-- put the toolbox in the player's inventory
	GamePickUpInventoryItem( player, EntityGetWithTag( "d2d_toolbox")[1], false )

    -- start with a vial of water
    local x, y = EntityGetTransform( player )
    local water = EntityLoad( "data/entities/items/pickup/potion_water.xml", x, y )
    GamePickUpInventoryItem( player, water, false )
end

function spawn_loadout_pyromancer( player )
	empty_inventory( player )

	local x, y = EntityGetTransform( player )
	y = y - 32

	-- spawn the second wand first, for some reason
    local wand = EZWand()
	wand:SetName( "Wildfire", true )
	wand.shuffle = false
	wand.spellsPerCast = 3
	wand.castDelay = Random( 1, 3 )
	wand.rechargeTime = Random( 15, 20 )
	wand.manaMax = Random( 221, 229 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 12, 15 )
	wand.capacity = 3
	wand.spread = 3
	wand:AttachSpells( "TORCH", "LIGHT", "CHAOTIC_ARC", "BOUNCE", "" )
	wand:AddSpells( "AIR_BULLET", "AIR_BULLET", "AIR_BULLET" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/loadouts/pyromancer_2.png", 7, 4, 8, 0 )
	wand:PutInPlayersInventory()

	-- spawn the first wand
    local wand = EZWand()
	wand:SetName( "Combustion", true )
	wand.shuffle = false
	wand.spellsPerCast = 1
	wand.castDelay = Random( 6, 8 )
	wand.rechargeTime = Random( 20, 25 )
	wand.manaMax = Random( 170, 220 )
	wand.mana = wand.manaMax
	wand.manaChargeSpeed = Random( 21, 23 )
	wand.capacity = 5
	wand.spread = 0
	wand:AddSpells( "D2D_ECHO_SHOT", "D2D_ECHO_SHOT", "D2D_ECHO_SHOT" )
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/loadouts/pyromancer_1.png", 7, 5, 13, 0 )
	wand:PutInPlayersInventory()

	-- perks
	give_perk( player, "D2D_MASTER_OF_FIRE" )
	if curses_enabled then
		give_perk( player, "D2D_CURSE_STENDARI" )
	end

    -- start with alcohol
    local x, y = EntityGetTransform( player )
    local water = EntityLoad( "data/entities/items/pickup/potion_slime.xml", x, y )
    GamePickUpInventoryItem( player, water, false )

    -- change the player's sprite
	local spritecomp_body = EntityGetFirstComponent( player, "SpriteComponent" )
	if exists( spritecomp_body ) then
		local image_file = ComponentGetValue2( spritecomp_body, "image_file" )
		ComponentSetValue2( spritecomp_body, "image_file", "mods/D2DContentPack/files/gfx/enemies_gfx/loadouts/player_pyromancer.xml" )
	end

	local children = EntityGetAllChildren( player_id )
	if exists( children ) then
		for i,child in ipairs( children ) do

			-- change the player's arm
			if EntityGetName( child ) == "arm_r" then
				local spritecomp_arm = EntityGetFirstComponent( child, "SpriteComponent" )
				if exists( spritecomp_arm ) then
					local image_file = ComponentGetValue2( spritecomp_arm, "image_file" )
					set_internal_string( player_id, "d2d_afterlife_cached_sprite_arm", image_file )
					ComponentSetValue2( spritecomp_arm, "image_file", "mods/D2DContentPack/files/gfx/enemies_gfx/player_afterlife_arm.xml")
				end
			end
	
			-- hide the cape
		    if EntityGetName( child ) == "cape" then
				for i,child_vp_comp in ipairs( EntityGetComponent( child, "VerletPhysicsComponent" ) ) do
					ComponentSetValue2( child_vp_comp, "follow_entity_transform", false )
				end
		    end
		end
	end
end

function item_pickup( entity_item, entity_who_picked, item_name )
	local function_name = get_internal_string( entity_item, "d2d_class_function_name" )
	_G[function_name]( entity_who_picked )

	local x, y = EntityGetTransform( entity_who_picked )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/orb/create", x, y )
	EntityLoad( "mods/D2DContentPack/files/particles/image_emitters/hammer.xml", x, y-12 )

	local class_cards = EntityGetWithTag( "d2d_class_card" )
	if exists( class_cards ) then
		for i,card in ipairs( class_cards ) do
			EntityKill( card )
		end
	end

	local nearby_aura = EntityGetWithTag( "d2d_class_selection_aura" )[1]
	if exists( nearby_aura ) then
		EntityKill( nearby_aura )
	end
end
