dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local owner = EntityGetInRadiusWithTag( x, y, 2, "homing_target" )[1]

local cancel_infatuation = false
if get_internal_bool( owner, "d2d_charming_arrow_cancel_infatuation", true ) then
	cancel_infatuation = true
end

-- if the entity is already berserk, don't infatuate them
local berserk_effect = GameGetGameEffect( owner, "BERSERK" )
if berserk_effect ~= 0 then
	cancel_infatuation = true
end

-- disable bosses from being infatuated
local is_boss = EntityGetComponentIncludingDisabled( owner, "BossHealthBarComponent" )
if is_boss then
	cancel_infatuation = true
end

if cancel_infatuation then
	EntityKill( get_child_by_filename( owner, "effect_charmed_short_d2d.xml" ) )
end
