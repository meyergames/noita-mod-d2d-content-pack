dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)
local x, y = EntityGetTransform( owner )



-- check if the player did not cheat
local has_player_cheated = false

local old_hm_count = getInternalVariableValue( owner, "hms_visited_on_trial_start", "value_int" )
local new_hm_count = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
local old_biome_count = getInternalVariableValue( owner, "visited_biomes_count_on_trial_start", "value_int" )
local new_biome_count = tonumber( GlobalsGetValue( "visited_biomes_count", "0" ) )

if new_hm_count <= old_hm_count and y < 12500 then
    has_player_cheated = true
end



-- warp the player back
--EntitySetTransform( owner, start_x, start_y )



if ( owner ~= nil ) and ( owner ~= NULL_ENTITY ) and EntityGetIsAlive( owner ) then
    if ( has_player_cheated ) then
        GamePrintImportant( "The gods are disappointed in you", "A curse has been laid upon you." )
        GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )
        GameScreenshake( 75 )
        apply_random_curse( owner )

        reset_move_speed( owner, "time_trial" )
        -- remove_perk( "D2D_TIME_TRIAL" )
        -- EntityAddComponent2( owner, "UIIconComponent",
        -- {
        --     name = "Time Trial: Lost",
        --     description = "You lost the time trial, earning you a curse.",
        --     icon_sprite_file = "mods/D2DContentPack/files/gfx/ui_gfx/perks/time_trial_016_lost.png",
        --     display_above_head = false,
        --     display_in_hud = true,
        --     is_perk = true,
        -- })
    else
        local time_trial_duration = get_internal_int( owner, "time_trial_update_count" )

        local chest = ""
        if time_trial_duration <= 15 then
            GamePrintImportant( "The gods are in disbelief", "" )
            chest = "mods/D2DContentPack/files/entities/items/pickup/chest_time_trial_t3.xml"
        elseif time_trial_duration <= 30 then
            GamePrintImportant( "The gods are in awe", "" )
            chest = "mods/D2DContentPack/files/entities/items/pickup/chest_time_trial_t2.xml"
        else
            GamePrintImportant( "The gods admire your speed", "" )
            chest = "mods/D2DContentPack/files/entities/items/pickup/chest_time_trial_t1.xml"
        end

        -- double max hp
        -- local damagemodel = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
        -- local hp = ComponentGetValue2( damagemodel, "hp" )
        -- local old_max_hp = ComponentGetValue2( damagemodel, "max_hp" )
        -- local new_max_hp = old_max_hp * 2
        -- ComponentSetValue( damagemodel, "max_hp", new_max_hp )

        local spx = x
        local spy = y - 50
        local nearby_entities = EntityGetInRadius( x, y, 220 )
        for i,nearby_entity in ipairs( nearby_entities ) do
            local filename = EntityGetFilename( nearby_entity )
            if string.find( filename, "temple_statue_01" ) then
                spx, spy = EntityGetTransform( nearby_entity )
                spx = spx + 79
                spy = spy + 38
            end
        end

        EntityLoad( chest, spx, spy )
        GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/chest/create", x, y )
    end
end

--setInternalVariableValue( owner, "time_trial_duration", "value_int", 60 )

