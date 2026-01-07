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
wand.capacity = 4 + hm_visits
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
-- add random upgrade spells
for i = 1, wand.capacity do
	local spell_id = random_from_array( upgrade_spells )
	wand:AddSpells( spell_id )
end

wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_toolbox.png", 5, 2, 4, 3 )
