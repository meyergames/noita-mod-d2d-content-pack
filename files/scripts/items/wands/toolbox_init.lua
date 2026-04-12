dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local wand = EZWand( GetUpdatedEntityID() )
wand:SetName( "Toolbox", true )
wand.shuffle = false
wand.spellsPerCast = 1
wand.castDelay = 0
wand.rechargeTime = 0
wand.manaMax = 1
wand.mana = 1
wand.manaChargeSpeed = 0
wand.capacity = 10
wand.spread = 0
EntityAddTag( wand.entity_id, "d2d_toolbox" )

wand:SetSprite( "mods/D2DContentPack/files/gfx/items_gfx/wands/wand_toolbox.png", 5, 2, 4, 3 )

local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
generate_random_toolbox_spells( 4 + hm_visits, false )

-- disable spell generation in the biome the toolbox was found in
local x, y = EntityGetTransform( GetUpdatedEntityID() )
local currbiome = BiomeMapGetName( x, y )
local flag = "toolbox_" .. tostring(currbiome) .. "_visited"
GameAddFlagRun( flag )
