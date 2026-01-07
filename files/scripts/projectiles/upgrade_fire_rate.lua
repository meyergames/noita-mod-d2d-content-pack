dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local card_entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent( card_entity_id )
local last_wand_tried = get_internal_int( card_entity_id, "last_wand_tried" )

if not exists( parent_id ) then return end
if not EZWand.IsWand( parent_id ) then return end
if exists( last_wand_tried ) and last_wand_tried == parent_id then return end
if EntityHasTag( parent_id, "d2d_toolbox" ) then return end

local wand = EZWand( parent_id )
local was_cast_delay_upgraded = wand_upgrade_cast_delay( wand, 0.1, 2, 0 )
local was_recharge_time_upgraded = wand_upgrade_recharge_time( wand, 0.1, 2, 0 )

-- do the upgrading
if was_cast_delay_upgraded or was_recharge_time_upgraded then
	local x, y = EntityGetTransform( card_entity_id )
	GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
	EntityKill( card_entity_id )
elseif get_internal_int( card_entity_id, "last_wand_tried" ) ~= parent_id then
	local x, y = EntityGetTransform( card_entity_id )
	GamePlaySound( "data/audio/Desktop/misc.bank", "collision/barrel_water/destroy", x, y )
	set_internal_int( card_entity_id, "last_wand_tried", parent_id )
end
set_internal_int( card_entity_id, "last_wand_tried", parent_id )