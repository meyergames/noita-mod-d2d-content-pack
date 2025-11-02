dofile_once( "data/scripts/lib/utilities.lua" )

local INIT_COOLDOWN = 120
local ENEMY_DETECTION_RADIUS = 100

local entity_id = GetUpdatedEntityID()
-- local owner = EntityGetParent( entity_id )
local owner = get_player()
local x, y = EntityGetTransform( owner )

local initial_cooldown = get_internal_int( owner, "prank_init_cooldown" )
if initial_cooldown == nil then
    set_internal_int( owner, "prank_init_cooldown", INIT_COOLDOWN )
elseif initial_cooldown > 0 then
    set_internal_int( owner, "prank_init_cooldown", initial_cooldown - 1 )
    if initial_cooldown - 1 <= 0 then
        GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )
        GameScreenshake( 75 )
        GamePrintImportant( "You hear a faint chuckle..." )
    end
end
initial_cooldown = get_internal_int( owner, "prank_init_cooldown" )
if initial_cooldown > 0 then return end


local pranked_times = get_internal_int( owner, "pranked_times" )
if pranked_times == nil then
    set_internal_int( owner, "pranked_times", 0 )
    pranked_times = get_internal_int( owner, "pranked_times" )
end
-- if get_perk_pickup_count( "D2D_CURSE_DIVINE_PRANK" ) - pranked_times <= 0 then return end



-- now for the actual prank logic

local prank_was_just_triggered = false

local nearby_enemy_count = #EntityGetInRadiusWithTag( x, y, ENEMY_DETECTION_RADIUS, "homing_target" ) -- no -1 necessary because the player is no homing target?
local far_enemy_count = #EntityGetInRadiusWithTag( x, y, ENEMY_DETECTION_RADIUS * 2, "homing_target" )
local is_in_holy_mountain = string.find( BiomeMapGetName( x, y ), "holy" )

local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
local is_health_low = p_hp <= math.min( p_max_hp * 0.25, 2 )

if not is_in_holy_mountain then
    -- GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )
    -- GameScreenshake( 75 )
    -- -- ^ this might spoil the shock if you've already experienced it once before for a different prank

    -- if not GameHasFlagRun( "prank_blindness_triggered" ) and rnd == 1 and is_health_low and far_enemy_count == 0 then

    --     LoadGameEffectEntityTo( owner, "mods/D2DContentPack/files/entities/misc/status_effects/effect_blindness_short.xml" )
    --     -- local rnd2 = Random( 1, 4 )
    --     -- if rnd2 == 1 then
    --     GamePlaySound( "data/audio/Desktop/materials.bank", "materials/electric_spark", x, y + 5 )
    --     -- elseif rnd2 == 2 then
    --     -- elseif rnd2 == 3 then
    --     -- elseif rnd2 == 4 then
    --     -- end

    --     set_internal_int( owner, "prank_msg_delay_time", 5 )
    --     prank_was_just_triggered = true

    -- elseif rnd == 2 and is_health_low and ModIsEnabled("Apotheosis") then
    --     -- sadly, this one seems to make the player instantly die lol

    --     -- for i = 1, 5 do
    --     --     SetRandomSeed( x-i, y+i )
    --     --     dofile("mods/Apotheosis/files/scripts/misc/psychotic_illusion_populator.lua")
    --     -- end

    --     set_internal_int( owner, "prank_msg_delay_time", 4 )
    --     prank_was_just_triggered = true

    if ( GameHasFlagRun( "prank_polymorph_triggered" ) == false )
        and nearby_enemy_count >= 2 
        and Random( 1, 100 ) <= 5 then

        LoadGameEffectEntityTo( owner, "mods/D2DContentPack/files/entities/misc/status_effects/effect_polymorph_short.xml" )
        GameAddFlagRun( "prank_polymorph_triggered" )
        prank_was_just_triggered = true

    elseif ( GameHasFlagRun( "prank_propane_triggered" ) == false )
        and is_health_low
        and Random( 1, 100 ) <= 1 then

        set_internal_int( owner, "prank_enable_propane", 1 )
        GameAddFlagRun( "prank_propane_triggered" )
        prank_was_just_triggered = true

    end

    if ( prank_was_just_triggered ) then
        raise_internal_int( owner, "pranked_times", 1 )
    end
end
