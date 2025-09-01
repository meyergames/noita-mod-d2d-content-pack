dofile_once( "data/scripts/lib/utilities.lua" )

local EFFECT_RADIUS_DETECT = 125

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )





-- local divine_prank_print_cooldown_time = getInternalVariableValue( owner, "divine_prank_print_cooldown_time", "value_int" )
-- if ( divine_prank_print_cooldown_time > 0 ) then
--     setInternalVariableValue( owner, "divine_prank_print_cooldown_time", "value_int", divine_prank_print_cooldown_time - 1 )
-- end
-- divine_prank_print_cooldown_time = getInternalVariableValue( owner, "divine_prank_print_cooldown_time", "value_int" )

local delayed_message_time = getInternalVariableValue( owner, "divine_prank_message_delay_time", "value_int" )
if ( delayed_message_time > -1 ) then
    setInternalVariableValue( owner, "divine_prank_message_delay_time", "value_int", delayed_message_time - 1 )
    
    delayed_message_time = getInternalVariableValue( owner, "divine_prank_message_delay_time", "value_int" )
    if ( delayed_message_time == 0 ) then
        GamePrint( "The gods chuckle as they totally prank you." )
        setInternalVariableValue( owner, "divine_prank_print_cooldown_time", "value_int", 5 )
    end
end

local gods_fake_angry = getInternalVariableValue( owner, "divine_prank_gods_are_fake_angry", "value_int" )
if ( gods_fake_angry == 1 and x > -122) then
    GamePrintImportant( "The gods were just kidding!", "They are not angry at you :)" )
    GameTriggerMusicEvent( "music/temple/enter", true, pos_x, pos_y )
    setInternalVariableValue( owner, "divine_prank_gods_are_fake_angry", "value_int", 0 )
end

local cooldown_time = getInternalVariableValue( owner, "divine_prank_cooldown_time", "value_int" )
if ( cooldown_time > 0 ) then
    setInternalVariableValue( owner, "divine_prank_cooldown_time", "value_int", cooldown_time - 1 )
    return
end

local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

local gods_angry_prank_triggered = getInternalVariableValue( owner, "divine_prank_gods_angry_prank_triggered", "value_int" )
local propane_prank_triggered = getInternalVariableValue( owner, "divine_prank_propane_prank_triggered", "value_int" )
local polymorph_prank_triggered = getInternalVariableValue( owner, "divine_prank_polymorph_prank_triggered", "value_int" )



-- now for the pranks

local chance_to_prank = 5 -- 5
if ( Random( 0, 100 ) > chance_to_prank) then return end
local prank_was_just_triggered = false

nearby_enemies = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS_DETECT, "mortal" )
local nearby_enemy_count = #nearby_enemies - 1

local biome_name = BiomeMapGetName( x, y )
if ( not gods_angry_prank_triggered
     and string.find( biome_name, "holy" )
     and ( GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) == 0
     and GlobalsGetValue( "TEMPLE_PEACE_WITH_GODS" ) == "1" ) ) then
    -- local guard_spawn_id = EntityGetClosestWithTag( x, y, "guardian_spawn_pos" )
    -- local guard_x = x
    -- local guard_y = y
    -- EntityLoad( "mods/D2DContentPack/files/entities/misc/fake_stevari.xml", x, y )

    GamePrintImportant( "$logdesc_temple_spawn_guardian", "" )
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )
    GameScreenshake( 150 )
    GameTriggerMusicFadeOutAndDequeueAll( 4.0 )
    GameTriggerMusicEvent( "music/temple/necromancer_shop", true, pos_x, pos_y )
    -- EntityAddComponent2(entity_id, "MusicEnergyAffectorComponent", {
    --     energy_target=100
    -- } )
    setInternalVariableValue( owner, "divine_prank_gods_are_fake_angry", "value_int", 1 )
    setInternalVariableValue( owner, "divine_prank_gods_angry_prank_triggered", "value_int", 1 )
    prank_was_just_triggered = true
-- elseif ( ModIsEnabled("Apotheosis") and p_hp <= p_max_hp * 0.2 ) then
--     GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )
--     GameScreenshake( 75 )

--     EntityInflictDamage( owner, p_hp - 1, "NONE", "a prank gone wrong", "NONE", 0, 0, owner, x, y, 0 )
--     EntityInflictDamage( owner, -p_hp - 1, "DAMAGE_HEALING", "a prank gone wrong", "NONE", 0, 0, owner, x, y, 0 )

--     dofile("mods/Apotheosis/files/scripts/misc/psychotic_illusion_populator.lua")
--     dofile("mods/Apotheosis/files/scripts/misc/psychotic_illusion_populator.lua")
--     dofile("mods/Apotheosis/files/scripts/misc/psychotic_illusion_populator.lua")
--     dofile("mods/Apotheosis/files/scripts/misc/psychotic_illusion_populator.lua")
--     dofile("mods/Apotheosis/files/scripts/misc/psychotic_illusion_populator.lua")
--     setInternalVariableValue( owner, "divine_prank_message_delay_time", "value_int", 3 )
elseif ( not propane_prank_triggered
         and p_hp <= p_max_hp * 0.25 ) then
    setInternalVariableValue( owner, "divine_prank_enable_propane_effect", "value_int", 1 )
    setInternalVariableValue( owner, "divine_prank_propane_prank_triggered", "value_int", 1 )
    prank_was_just_triggered = true
elseif ( not polymorph_prank_triggered
         and p_hp <= p_max_hp * 0.25
         and nearby_enemy_count == 0 ) then
    LoadGameEffectEntityTo( owner, "data/entities/misc/effect_polymorph.xml" )
    setInternalVariableValue( owner, "divine_prank_message_delay_time", "value_int", 1 )
    setInternalVariableValue( owner, "divine_prank_polymorph_prank_triggered", "value_int", 1 )
    prank_was_just_triggered = true
end

if ( prank_was_just_triggered ) then
    setInternalVariableValue( owner, "divine_prank_cooldown_time", 300 )
end
