dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

local card_entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent( card_entity_id )
if exists( parent_id ) and EZWand.IsWand( parent_id ) then

	local upgrades = get_internal_int( entity_id, "d2d_wand_upgrade_spells_applied" )
	if upgrades < 10 then return end

	local warning_shown_before = get_internal_bool( parent_id, "d2d_wand_limit_warning_shown" )
	if warning_shown_before then return end

	-- show warning
	local x, y = EntityGetTransform( card_entity_id )
	GamePlaySound( "data/audio/Desktop/misc.bank", "collision/barrel_water/destroy", x, y )
	GamePrint( "Your wand has reached its maximum number of Upgrades." )
	set_internal_bool( parent_id, "d2d_wand_limit_warning_shown", true )
end