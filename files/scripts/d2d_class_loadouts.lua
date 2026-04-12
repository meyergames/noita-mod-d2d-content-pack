dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function spawn_loadout_sniper( player_entity_id )
	local x, y = EntityGetTransform( player_entity_id )
	y = y - 32

	-- spawn a unique wand
    local wand = EZWand()
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
	wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/crossbow.png", 10, 5, 11, 0 )
	wand:PlaceAt( x, y - 20 )

	-- spawn perks
    perk_spawn( x - 20, y, "INVISIBILITY", true )
    perk_spawn( x, y, "D2D_LEECH_LIFE", true )
    perk_spawn( x + 20, y, "RISKY_CRITICAL", true )

    -- reduce the player's health
    local dmg_comp = EntityGetFirstComponentIncludingDisabled( player_entity_id, "DamageModelComponent" )
    if exists( dmg_comp ) then
    	ComponentSetValue2( dmg_comp, "hp", 0.8 ) -- 20 hp
    	ComponentSetValue2( dmg_comp, "max_hp", 2 ) -- 50 hp
    end
end

if ModSettingGet( "D2DContentPack.spawn_loadout_sniper" ) then
	spawn_loadout_sniper( get_player() )
end