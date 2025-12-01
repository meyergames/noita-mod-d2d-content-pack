dofile_once("data/scripts/lib/utilities.lua")

local old_item_pickup = item_pickup
item_pickup = function( entity_item, entity_who_picked, name )
    EntityRemoveIngestionStatusEffect( entity_who_picked, "VIRAL_INFECTION" )

    if has_lua( entity_who_picked, "d2d_glass_heart" ) then
        local x, y = EntityGetTransform( entity_item )
        local start_y = get_internal_float( entity_who_picked, "d2d_glass_heart_start_y" )
        local is_deeper = y + 1000 > start_y

        if not EntityHasTag( entity_item, "d2d_glass_heart_disqualified") and is_deeper then
            local p_dcomp = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
            local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
            ComponentSetValue2( p_dcomp, "max_hp", p_max_hp * 3 )
            GamePrintImportant( "Your max health is tripled")

            -- spawn Staff of Glass
            dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
            spawn_glass_staff( x, y - 10 )

            -- remove the effect's UI entity and all associated Lua scripts
            local ui_icon_id = get_child_with_name( entity_who_picked, "effect_glass_heart.xml" )
            if ui_icon_id then
                EntityKill( ui_icon_id )
            end
            remove_lua( entity_who_picked, "d2d_glass_heart" )
        else
            GamePrintImportant( "The Glass Heart requires a deeper heart")
        end
    end

    old_item_pickup( entity_item, entity_who_picked, name )
    
--	local deepest_hm = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_DEPTH", "0" ) )
--    GamePrint( "Deepest Holy Mountain: " .. deepest_hm )
--
--    local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
--    GamePrint( "Holy Mountains visited: " .. hm_visits )
end
