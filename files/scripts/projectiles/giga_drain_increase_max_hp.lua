dofile( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local MAX_HP_GAIN_FOR_PERK_SPAWN = 100

local entity_id = GetUpdatedEntityID()
local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )

local hp = ComponentGetValue2( dcomp, "hp" )
local max_hp = ComponentGetValue2( dcomp, "max_hp" )
local gained_max_hp = 0.08

ComponentSetValue( dcomp, "hp", hp + gained_max_hp  )
ComponentSetValue( dcomp, "max_hp", max_hp + gained_max_hp  )

if ( entity_id == get_player() ) then
    GamePrint("+" .. gained_max_hp * 25 .. " max HP")

    raise_internal_int( entity_id, "d2d_giga_drain_max_hp_gained", ( gained_max_hp * 25 ) )

    if get_internal_int( entity_id, "d2d_giga_drain_max_hp_gained" ) >= MAX_HP_GAIN_FOR_PERK_SPAWN
    and not GameHasFlagRun( "d2d_leech_life_perk_spawned") then
        GameAddFlagRun( "d2d_leech_life_perk_spawned" )
        
        local x, y = EntityGetTransform( GetUpdatedEntityID() )
        spawn_perk( "D2D_LEECH_LIFE", x, y, true )
    end
    -- raise_internal_int( get_player(), "giga_drain_total_max_hp_gain", gained_max_hp * 25 )

    -- local total_max_hp_gain = get_internal_int( get_player(), "giga_drain_total_max_hp_gain" )
    -- if total_max_hp_gain and total_max_hp_gain % 50 == 0 then
    --     GamePrint( "Total max HP gained from Giga Drain: " .. total_max_hp_gain )
    -- end
end
