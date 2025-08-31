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
if ( ( new_hm_count <= old_hm_count and y < 12500 ) or ( new_biome_count - old_biome_count) == 0 ) then
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
        remove_perk( "D2D_TIME_TRIAL" )
        EntityAddComponent2( owner, "UIIconComponent",
        {
            name = "Time Trial: Lost",
            description = "You lost the time trial, earning you a curse.",
            icon_sprite_file = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/time_trial_016_lost.png",
            display_above_head = false,
            display_in_hud = true,
            is_perk = true,
        })
    else
        local was_player_REALLY_fast = getInternalVariableValue( owner, "time_trial_update_count", "value_int" ) < 30
        if( not was_player_REALLY_fast ) then
            GamePrintImportant( "The gods admire your speed", "Your max health has been doubled.\nYour move speed has been permanently increased." )
        else
            GamePrintImportant( "The gods are in awe", "You've earned an even bigger reward!" )
        end

        -- double max hp
        local damagemodel = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
        local hp = ComponentGetValue2( damagemodel, "hp" )
        local old_max_hp = ComponentGetValue2( damagemodel, "max_hp" )
        local new_max_hp = old_max_hp * 2
        ComponentSetValue( damagemodel, "max_hp", new_max_hp )
        
        -- spawn reward chest based on depth
        local spx, spy = 0,0
        local chest = "data/entities/items/pickup/chest_random.xml"
--        local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
--        if( hm_visits == 1 ) then
        if( y < 1500 ) then
            spx, spy = -680, 1390
        elseif ( y < 3100 ) then
            spx, spy = -680, 2930
        elseif ( y < 5200 ) then
            spx, spy = -680, 4980
        elseif ( y < 6700 ) then
            spx, spy = -680, 6520
        elseif ( y < 8800 ) then
            spx, spy = -680, 8570
        elseif ( y < 12500 ) then
            spx, spy = -680, 10610
            chest = "data/entities/items/pickup/chest_random_super.xml"
        elseif ( y > 12500 ) then
            spx, spy = 1910, 13170
            chest = "data/entities/items/pickup/chest_random_super.xml"
        end
        if( was_player_REALLY_fast ) then
            chest = "data/entities/items/pickup/chest_random_super.xml"
        end
        EntityLoad( chest, spx, spy )
        GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/chest/create", x, y )

        remove_perk( "D2D_TIME_TRIAL" )
        EntityAddComponent2( owner, "UIIconComponent",
        {
            name = "Time Trial: Won",
            description = "You were rewarded with doubled max health, increased move speed and a chest.",
            icon_sprite_file = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/time_trial_016_won.png",
            display_above_head = false,
            display_in_hud = true,
            is_perk = true,
        })
    end
end

--setInternalVariableValue( owner, "time_trial_duration", "value_int", 60 )

