dofile( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )

local hp = ComponentGetValue2( dcomp, "hp" )
local max_hp = ComponentGetValue2( dcomp, "max_hp" )
local gained_max_hp = 0.08

ComponentSetValue( dcomp, "hp", hp + gained_max_hp  )
ComponentSetValue( dcomp, "max_hp", max_hp + gained_max_hp  )

if ( entity_id == get_player() ) then
    GamePrint("+" .. gained_max_hp * 25 .. " max HP")
end
