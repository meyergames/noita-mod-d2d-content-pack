dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( entity_id )
y = y - 4 -- offset to middle of character

local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local flying_time_left = ComponentGetValue2( cdatacomp, "mFlyingTimeLeft" )

local was_already_triggered = get_internal_bool( owner, "d2d_curse_levitation_cramps_effect_triggered", true )
if flying_time_left <= 0 then
	if not was_already_triggered then
		set_internal_bool( owner, "d2d_curse_levitation_cramps_effect_triggered", true )
		EntityInflictDamage( owner, 0.4, "DAMAGE_ELECTRICITY", "levitation cramps", "ELECTROCUTION", 0, 0, owner, x, y, 0)
		EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml", x, y )
	end
elseif was_already_triggered then
	set_internal_bool( owner, "d2d_curse_levitation_cramps_effect_triggered", false )
end