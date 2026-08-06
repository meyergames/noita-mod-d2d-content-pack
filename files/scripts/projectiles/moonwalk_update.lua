dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( owner )


local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
if not cdatacomp then return end
local flying_time_left = ComponentGetValue2( cdatacomp, "mFlyingTimeLeft" )

local platcomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterPlatformingComponent" )
if not platcomp then return end
local frames_in_air = ComponentGetValue2( platcomp, "mFramesInAirCounter" )

local controls = EntityGetFirstComponent( owner, "ControlsComponent" )
local is_fly_pressed = ComponentGetValue2( controls, "mButtonDownFly" )
local is_drop_pressed = ComponentGetValue2( controls, "mButtonDownDown" )
local is_falling = get_internal_bool( owner, "d2d_moonwalk_is_falling" )

if ( flying_time_left <= 0 ) or ( frames_in_air == 0 ) then
    reset_move_speed( owner, "d2d_moonwalk" )
    reset_gravity( owner, "d2d_moonwalk" )
    ComponentSetValue2( cdatacomp, "fly_recharge_spd", 0.4 )

    if not is_falling then
        set_internal_bool( owner, "d2d_moonwalk_is_falling", true )
    end
    if frames_in_air == 0 then
        set_internal_bool( owner, "d2d_moonwalk_is_falling", false )
    end
    return
end

if is_fly_pressed and ( frames_in_air == 1 ) then
    -- player jumped
    GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/teleport/create", x, y )
    multiply_move_speed( owner, "d2d_moonwalk", 1.5, 1.5 )
    multiply_gravity( owner, "d2d_moonwalk", 0.25 )
    ComponentSetValue2( cdatacomp, "fly_recharge_spd", 0 )

elseif frames_in_air >= 10 and not is_falling then
    multiply_move_speed( owner, "d2d_moonwalk", 1.5, 1.5 )

	if is_drop_pressed then
        ComponentSetValue2( cdatacomp, "mFlyingTimeLeft", flying_time_left - 0.0167 )
        reset_gravity( owner, "d2d_moonwalk" )
        multiply_gravity( owner, "d2d_moonwalk", 2 )
    else
        reset_gravity( owner, "d2d_moonwalk" )
        multiply_gravity( owner, "d2d_moonwalk", 0.25 )
        ComponentSetValue2( cdatacomp, "fly_recharge_spd", 0 )

        -- held_wand.mana = held_wand.mana - mana_drain_amt
        -- ComponentSetValue2( cdatacomp, "mFlyingTimeLeft", flying_time_left - 0.0167 )
	end
end