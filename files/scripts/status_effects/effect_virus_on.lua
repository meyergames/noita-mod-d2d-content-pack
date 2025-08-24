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

multiply_move_speed( owner, 1.15 )

local x, y = EntityGetTransform( owner )
local pos_string = tostring(x) .. "," .. tostring(y)
EntityAddComponent2( owner, "VariableStorageComponent", {
    name = "player_start_pos",
    value_string = pos_string,
})

addNewInternalVariable( owner, "virus_update_count", "value_int", 0 )
