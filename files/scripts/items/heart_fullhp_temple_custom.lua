dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua")

local function handle_glass_heart( entity_item, entity_who_picked )
    if has_lua( entity_who_picked, "d2d_glass_heart" ) then
        local x, y = EntityGetTransform( entity_item )
        local start_y = get_internal_float( entity_who_picked, "d2d_glass_heart_start_y" )
        local is_deeper = y + 1000 > start_y

        if not EntityHasTag( entity_item, "d2d_glass_heart_disqualified" ) and is_deeper then
            local p_dcomp = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
            local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
            ComponentSetValue2( p_dcomp, "max_hp", p_max_hp * 3 )
            GamePrintImportant( "Your max health is tripled")

            -- spawn Staff of Glass
            dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
            spawn_glass_staff( x, y - 10 )

            -- spawn Glass Fist perk
            dofile_once( "data/scripts/perks/perk.lua" )
            perk_spawn( x, y - 8, "D2D_GLASS_FIST", true )

            -- remove the effect's UI entity and all associated Lua scripts
            local ui_icon_id = get_child_with_tag( entity_who_picked, "d2d_effect_glass_heart" )
            if ui_icon_id then
                EntityKill( ui_icon_id )
            end
            remove_lua( entity_who_picked, "d2d_glass_heart" )

            -- make the icon show that the perk is "spent"
            swap_perk_icon_for_spent( owner, "d2d_glass_heart" )
        else
            GamePrintImportant( "The Glass Heart requires a deeper heart" )
        end
    end
end

local function handle_glass_fist_boost( entity_item, entity_who_picked )
    if get_perk_pickup_count( "D2D_GLASS_FIST" ) >= 1 then
        set_internal_bool( entity_who_picked, "d2d_glass_fist_boost_enabled", true )
        local ui_icon_id = get_child_by_filename( entity_who_picked, "glass_fist_overhead_icon.xml" )
        if not ui_icon_id then
            LoadGameEffectEntityTo( entity_who_picked, "mods/D2DContentPack/files/entities/misc/status_effects/glass_fist_overhead_icon.xml" )
        end
    end
end

local old_item_pickup = item_pickup
item_pickup = function( entity_item, entity_who_picked, name )
    EntityRemoveIngestionStatusEffect( entity_who_picked, "VIRAL_INFECTION" )

    handle_glass_heart( entity_item, entity_who_picked )
    handle_glass_fist_boost( entity_item, entity_who_picked )

    old_item_pickup( entity_item, entity_who_picked, name )
    
--	local deepest_hm = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_DEPTH", "0" ) )
--    GamePrint( "Deepest Holy Mountain: " .. deepest_hm )
--
--    local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
--    GamePrint( "Holy Mountains visited: " .. hm_visits )
end
