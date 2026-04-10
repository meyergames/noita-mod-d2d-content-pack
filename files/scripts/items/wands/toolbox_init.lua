dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )

local wand = EZWand( GetUpdatedEntityID() )
wand:SetName( "Toolbox", true )
wand.shuffle = false
wand.spellsPerCast = 1
wand.castDelay = 0
wand.rechargeTime = 0
wand.manaMax = 1
wand.mana = 1
wand.manaChargeSpeed = 0
local rare_spell_slots = 2 + math.floor( hm_visits / 2 ) -- 2-5 slots for rare spells
wand.capacity = 4 + hm_visits + rare_spell_slots
wand.spread = 0

-- add duplicates to make some upgrades less common
local upgrade_spells = {
	"D2D_UPGRADE_CAPACITY",
	"D2D_UPGRADE_CAPACITY",
	"D2D_UPGRADE_CAPACITY",
	"D2D_UPGRADE_CAPACITY",
	"D2D_UPGRADE_FIRE_RATE",
	"D2D_UPGRADE_FIRE_RATE",
	"D2D_UPGRADE_MAX_MANA",
	"D2D_UPGRADE_MAX_MANA",
	"D2D_UPGRADE_MANA_CHARGE_SPEED",
	"D2D_UPGRADE_MANA_CHARGE_SPEED",
	"D2D_UPGRADE_SHUFFLE",
	"D2D_UPGRADE_REMOVE_ALWAYS_CAST",
}
local rare_spells = {
	-- shields
	"ENERGY_SHIELD",
	"ENERGY_SHIELD_SECTOR",
	"ENERGY_SHIELD_SECTOR",
	"D2D_RELOAD_SHIELD",

	-- mana related
	"D2D_MANA_SPLIT",
	"D2D_MANA_REFILL_ALT_FIRE",

	-- mobility related
	"D2D_REWIND_ALT_FIRE",
	"D2D_FIXED_ALTITUDE",

	-- limited-use related
	"D2D_SECOND_WIND",
	"D2D_SECOND_WIND",
	"D2D_SECOND_WIND",
	"D2D_RECYCLE",
	"D2D_RECYCLE",
	"D2D_FORCE_CAST",

	-- shuffle-related
	"D2D_STABILIZE",
	"D2D_STABILIZE",
	"D2D_SPRAY_AND_PRAY",
	"D2D_SPRAY_AND_PRAY",

	-- all-round utility
	"D2D_ALT_FIRE_ANYTHING",
}
if HasFlagPersistent( "d2d_ancient_lurker_defeated" ) and hm_visits >= 4 then
	table.insert( rare_spells, "D2D_RECYCLE_PLUS" )
end
if ModIsEnabled( "Apotheosis" ) then
	table.insert( rare_spells, "APOTHEOSIS_ALT_FIRE_TELEPORT_SHORT" )
	table.insert( rare_spells, "APOTHEOSIS_ALT_FIRE_TELEPORT_SHORT" )
	table.insert( rare_spells, "APOTHEOSIS_ALT_FIRE_TELEPORT_SHORT" )
	table.insert( rare_spells, "APOTHEOSIS_ALT_FIRE_TELEPORT" )
end

-- add random upgrade spells
for i = 1, wand.capacity - rare_spell_slots do
	local spell_id = random_from_array( upgrade_spells )
	wand:AddSpells( spell_id )
end
-- add random Passive/Other-type spells
for i = 1, rare_spell_slots do
	local spell_id = random_from_array( rare_spells )
	wand:AddSpells( spell_id )
end

wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_toolbox.png", 5, 2, 4, 3 )
