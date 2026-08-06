dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
if not cdatacomp then return end

local platcomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterPlatformingComponent" )
if not platcomp then return end
local frames_in_air = ComponentGetValue2( platcomp, "mFramesInAirCounter" )
local controls = EntityGetFirstComponent( owner, "ControlsComponent" )

reset_move_speed( owner, "d2d_moonwalk" )
reset_gravity( owner, "d2d_moonwalk" )
ComponentSetValue2( cdatacomp, "fly_recharge_spd", 0.4 )
