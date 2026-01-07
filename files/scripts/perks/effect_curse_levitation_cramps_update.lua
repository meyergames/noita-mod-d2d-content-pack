dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

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

		local dmgcomp = EntityGetFirstComponent( owner, "DamageModelComponent" )
		if exists( dmgcomp ) then
			local hp = ComponentGetValue2( dmgcomp, "hp" )
			local max_hp = ComponentGetValue2( dmgcomp, "max_hp" )

			EntityInflictDamage( owner, math.min( max_hp * 0.1, hp - 0.04 ), "DAMAGE_PHYSICS_HIT", "levitation cramps", "NORMAL", 0, 0, owner, x, y, 0 )
		end
		LoadGameEffectEntityTo( owner, "mods/D2DContentPack/files/entities/misc/status_effects/effect_random_teleport_one_off.xml" )
	end
elseif was_already_triggered then
	set_internal_bool( owner, "d2d_curse_levitation_cramps_effect_triggered", false )
end