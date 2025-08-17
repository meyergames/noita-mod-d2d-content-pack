dofile_once( "data/scripts/lib/utilities.lua" )

GamePrintImportant("You're on borrowed time...", "Seek medical attention. NOW.")


-- Speed up the player until the effect is removed, like with OnFire
local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)

local dcomps = EntityGetComponent( owner, "DamageModelComponent" )
if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
    for i,damagemodel in ipairs( dcomps ) do
        local hp = ComponentGetValue2( damagemodel, "hp" )
        local old_max_hp = ComponentGetValue2( damagemodel, "max_hp" )
        ComponentSetValue( damagemodel, "max_hp", old_max_hp )
        ComponentSetValue( damagemodel, "hp", old_max_hp )
--        EntityInflictDamage( owner, hp * 0.1, "NONE", "viral infection", "BLOOD_EXPLOSION", 0, 0, owner, x, y, 0 )
        GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)

		ComponentObjectSetValue2( damagemodel, "damage_multipliers", "healing", 0 )
    end
end

local character_platforming_component = EntityGetFirstComponentIncludingDisabled( owner, "CharacterPlatformingComponent" )

local properties_to_change = {
    velocity_min_x = 1.15,
    velocity_max_x = 1.15,
	jump_velocity_y = 1.15,
	jump_velocity_x = 1.15,
	fly_speed_max_up = 1.15,
	fly_speed_max_down = 1.15,
	fly_velocity_x = 1.15
}

if character_platforming_component then
	local old_values = ""
	for k, v in pairs(properties_to_change) do
		local value = ComponentGetValue2(character_platforming_component, k)
		local string_value = tostring(value)
		if type(value) == "boolean" then
			string_value = value and "1" or "0"
		end
		old_values = old_values .. k .. ":" .. type(value) .. "=" .. string_value
		if next(properties_to_change, k) then
			old_values = old_values .. ","
		end
		ComponentSetValue2(character_platforming_component, k, value * v)
	end

	EntityAddComponent2( owner, "VariableStorageComponent", {
		name = "old_platforming_values",
		value_string = old_values,
	})
end

local x, y = EntityGetTransform( owner )
local pos_string = tostring(x) .. "," .. tostring(y)
EntityAddComponent2( owner, "VariableStorageComponent", {
    name = "player_start_pos",
    value_string = pos_string,
})

addNewInternalVariable( owner, "virus_update_count", "value_int", 0 )
