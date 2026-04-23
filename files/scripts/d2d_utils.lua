dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/alt_fire_utils.lua" )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

function exists( id )
    return id and id ~= 0
end

-- Shorthands for a really common actions (thanks raksa)
function EntityGetValue( entity, component_name, attr_name )
  if not exists( entity) then return end

  return ComponentGetValue2( EntityGetFirstComponentIncludingDisabled( entity, component_name ), attr_name )
end

function EntitySetValue( entity, component_name, attr_name, value )
  if not exists( entity) then return end

  return ComponentSetValue2( EntityGetFirstComponentIncludingDisabled( entity, component_name ), attr_name, value )
end

function EntityInflictMaxHealthDamage( entity_id, ratio, can_kill, death_msg )
    local x, y = EntityGetTransform( entity_id )

    local p_dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
    if not exists( p_dcomp ) then return end
    local p_mhp = ComponentGetValue2( p_dcomp, "max_hp" )

    if can_kill then
        EntityInflictDamage( entity_id, p_mhp * ratio, "DAMAGE_CURSE", death_msg or "death", "NONE", 0, 0, entity_id, x, y, 0 )
    else
        local p_hp = ComponentGetValue2( p_dcomp, "hp" )
        EntityInflictDamage( entity_id, math.min( p_mhp * ratio, p_hp - 0.04 ), "DAMAGE_CURSE", death_msg or "death", "NONE", 0, 0, entity_id, x, y, 0 )
    end
end

function GamePrintDelayed( message, delay )
    local print_entity_id = EntityCreateNew()
    EntityAddComponent2( print_entity_id, "LuaComponent", {
        script_source_file = "mods/D2DContentPack/files/scripts/gameprint_delayed.lua",
        execute_on_added = false,
        execute_every_n_frame = delay,
        execute_times = 1,
        remove_after_executed = true,
    } )
    set_internal_string( print_entity_id, "d2d_delayed_print_msg", message )
end

function try_trigger_short_circuit( chance )
    local rand = Random( 0, 100 )
    if rand <= chance then
        GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)

        local rand2 = Random( 0, 8 )
        if( rand2 < 1 ) then
            EntityInflictDamage(entity_id, 0.4, "DAMAGE_ELECTRICITY", "overheated wand", "ELECTROCUTION", 0, 0, entity_id, x, y, 0)
        elseif( rand2 < 3 ) then
            add_projectile("mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml")
        elseif( rand2 < 5 ) then
            add_projectile("mods/D2DContentPack/files/entities/projectiles/overclock.xml")
        else
            add_projectile("data/entities/projectiles/deck/fizzle.xml")
        end
        return true
    end
    return false
end

function get_actions_lua_data( action_id )
    dofile_once( "mods/D2DContentPack/files/scripts/actions.lua" )
    for i,action in ipairs( actions ) do
        if action.id == action_id then
            return action
        end
    end
    return nil
end

function math_clamp( value, low, high )
    return math.min( math.max( value, low ), high )
end

function multiply_proj_dmg( proj_id, mtp, mtp_source_name )
    local existing_mtp_sources = get_internal_string( proj_id, "d2d_proj_dmg_mtp_sources" ) or ""

    if not string.find( existing_mtp_sources, mtp_source_name ) then
        set_internal_string( proj_id, "d2d_proj_dmg_mtp_sources", existing_mtp_sources .. mtp_source_name .. "," )

        local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
        if proj_comp then
            local old_dmg = ComponentGetValue2( proj_comp, "damage" )
            ComponentSetValue2( proj_comp, "damage", old_dmg * mtp )

            local old_expl_dmg = ComponentObjectGetValue2( proj_comp, "config_explosion", "damage" )
            if exists( old_expl_dmg ) then
                ComponentObjectSetValue2( proj_comp, "config_explosion", "damage", old_expl_dmg * mtp )
            end

            -- TODO: do this for the other damage types as well
            local damage_types = { "melee", "projectile", "explosion", "electricity", "fire", "drill", "slice", "ice", "healing", "physics_hit", "radioactive", "poison", "curse", "holy" }
            for i,dmg_type in ipairs( damage_types ) do
                local old_dmg = ComponentObjectGetValue2( proj_comp, "damage_by_type", dmg_type )
                if exists( old_dmg ) then
                    ComponentObjectSetValue2( proj_comp, "damage_by_type", dmg_type, old_dmg * mtp )
                end 
            end
        end
    end
end

-- function trigger_proj_dmg_mtp( proj_id )
--     local mtp = get_internal_float( proj_id, "d2d_proj_dmg_mtp" )
--     if not mtp then return end

--     set_internal_float( proj_id, "d2d_proj_dmg_mtp", 1.0 )
-- end

function multiply_proj_speed( proj_id, mtp )
    local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
    if proj_comp then
        local old_value = ComponentGetValue2( proj_comp, "speed_min" )
        ComponentSetValue2( proj_comp, "speed_min", old_value * mtp )

        old_value = ComponentGetValue2( proj_comp, "speed_max" )
        ComponentSetValue2( proj_comp, "speed_max", old_value * mtp )
    end
    local velo_comp = EntityGetFirstComponent( proj_id, "VelocityComponent" )
    if velo_comp then
        local old_value = ComponentGetValue2( velo_comp, "air_friction" )
        ComponentSetValue2( velo_comp, "air_friction", old_value * ( 1.0 / mtp ) )

        local old_x, old_y = ComponentGetValue2( velo_comp, "mVelocity" )
        ComponentSetValue2( velo_comp, "mVelocity", old_x * mtp, old_y * mtp )
    end
end

function EntityLoadAtWandTip( player_entity_id, load_this_entity, wand_id )
    local wand_entity_id = wand_id or EZWand.GetHeldWand().entity_id
    if not exists( player_entity_id ) or not exists( wand_entity_id ) then return end

    local ctrl_comp = EntityGetFirstComponent( player_entity_id, "ControlsComponent" )
    local hs_comp = EntityGetFirstComponentIncludingDisabled( wand_entity_id, "HotspotComponent" )
    if exists( ctrl_comp ) and exists( hs_comp ) then
        local aim_x, aim_y = ComponentGetValue2( ctrl_comp, "mAimingVectorNormalized" )
        local offset_mag = get_magnitude( ComponentGetValue2( hs_comp, "offset" ) )

        local wx, wy = EntityGetTransform( wand_entity_id )
        local tx = wx + ( offset_mag * aim_x )
        local ty = wy + ( offset_mag * aim_y )
        EntityLoad( load_this_entity, tx, ty )
    end
end

function held_wand_contains_slotted_spell( player_entity_id, action_id )
    local held_wand = EZWand.GetHeldWand()
    if not held_wand then return end

    local spells, always_casts = held_wand:GetSpells()
    for i,spell in ipairs( spells ) do
        if spell.action_id == action_id then
            return true
        end
    end

    return false
end

function held_wand_contains_always_cast( player_entity_id, action_id )
    local held_wand = EZWand.GetHeldWand()
    local spells, always_casts = held_wand:GetSpells()
    
    for i,always_cast in ipairs( always_casts ) do
        if always_cast.action_id == action_id then
            return true
        end
    end

    return false
end

function any_wand_contains_spell( player_entity_id, action_id )
    local wands = {}
    local children = EntityGetAllChildren( player_entity_id ) or {}
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            local may_be_wands = EntityGetAllChildren( child ) or {}
            if #may_be_wands > 0 then
                for i,may_be_wand in ipairs( may_be_wands ) do
                    if EntityHasTag( may_be_wand, "wand" ) then
                        table.insert( wands, may_be_wand )
                    end
                end
            end
        end
    end

    if #wands > 0 then
        for i,wand in ipairs( wands ) do
            if held_wand_contains_slotted_spell( player_entity_id, action_id ) then
                return true
            elseif held_wand_contains_always_cast( player_entity_id, action_id ) then
                return true
            end
        end
    end

    return false
end

function swap_perk_icon_for_spent( player_id, perk_name )
    for i,child_id in ipairs( EntityGetAllChildren( player_id ) or {} ) do
        if EntityHasTag( child_id, "perk_entity" ) then
            local iconcomp = EntityGetFirstComponent( child_id, "UIIconComponent" )
            if exists( iconcomp ) then
                local comp_name = ComponentGetValue2( iconcomp, "name" )
                if string.find( comp_name, perk_name ) then
                    local current_sprite_file = ComponentGetValue2( iconcomp, "icon_sprite_file" )
                    local new_sprite_file = current_sprite_file:sub( 1, -5 ) .. "_spent.png"
                    ComponentSetValue2( iconcomp, "icon_sprite_file", new_sprite_file )
                    ComponentSetValue2( iconcomp, "name", GameTextGetTranslatedOrNot( comp_name ) .. " (spent)" )
                end
            end
        end
    end
end

-- this function is from Goki's Things
function find_action_entity( action )
    for _,e in pairs( EntityGetWithTag( "card_action" ) ) do
        local item = EntityGetFirstComponentIncludingDisabled( e, "ItemComponent" )
        if item then
            if ComponentGetValue2( item, "mItemUid" ) == action.inventoryitem_id then
                return e
            end
        end
    end
end

function debug_piles( deck, hand, discarded )
    for i,card in ipairs( deck ) do
        GamePrint( "DECK: " .. card.id )
    end
    for i,card in ipairs( hand ) do
        GamePrint( "HAND: " .. card.id )
    end
    for i,card in ipairs( discarded ) do
        GamePrint( "DISCARDED: " .. card.id )
    end
end

function get_carried_item_with_tag( tag )
    local children = EntityGetAllChildren( get_player() )
    for k=1,#children do
        child = children[k]
        if EntityGetName( child ) == "inventory_quick" then
            local inventory_items = EntityGetAllChildren(child)
            if( inventory_items ~= nil ) then
                for i,item in ipairs( inventory_items ) do
                    if EntityHasTag( item, tag ) then
                        return item
                    end
                end
            end
        end
    end
    return nil
end

function is_immune_to_fire()
    return has_game_effect( get_player(), "PROTECTION_FIRE" ) or exists( get_carried_item_with_tag( "brimstone" ) )
end

function is_immune_to_electricity()
    return has_game_effect( get_player(), "PROTECTION_ELECTRICITY" ) or exists( get_carried_item_with_tag( "thunderstone" ) )
end

-- this function was copied from the Selectable Classes mod
function give_perk( target, perk_id )
    dofile_once( "data/scripts/perks/perk.lua" )
    local data = get_perk_with_id( perk_list, perk_id )

    -- only apply to enemies if the perk is usable by them
    if target == get_player() then
        -- register the perk flag
        local flag_name = get_perk_picked_flag_name( perk_id )
        local current_pickup_count = get_perk_pickup_count( perk_id )
        local pickup_count = GlobalsSetValue( flag_name .. "_PICKUP_COUNT", tostring( current_pickup_count + 1 ) )
    else
        return
    end

    --apply game effect
    if data.game_effect ~= nil then
        local game_effect_comp = GetGameEffectLoadTo( target, data.game_effect, true )
        if game_effect_comp ~= nil then
            ComponentSetValue( game_effect_comp, "frames", "-1" )
        end
    end

    --call extra function
    if data.func ~= nil then
        --these aren't the right arguments, but none of the perks
        --use entity_perk_item or item_name anyway (why would they...?)
        data.func( target, target, perk_id, 1 )
    end

    --add to UI
    local perk_ui = EntityCreateNew( "" )
    EntityAddComponent( perk_ui, "UIIconComponent", { 
        name = data.ui_name,
        description = data.ui_description,
        icon_sprite_file = data.ui_icon
    })
    EntityAddChild( target, perk_ui )
end

function teleport( entity_id, to_x, to_y )
    -- local from_x, from_y = EntityGetTransform( entity_id )
    -- local dir_x = to_x - from_x
    -- local dir_y = to_y - from_y
    -- dir_x, dir_y = vec_normalize( dir_x, dir_y )
    -- EntitySetTransform( entity_id, to_x + dir_x * 20, to_y + dir_y * 20 )
    EntitySetTransform( entity_id, to_x, to_y )

    -- reset velocity
    local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
    if exists( vcomp ) then
        ComponentSetValueVector2( vcomp, "mVelocity", 0, 0 )
    end
    
    -- play teleport effects
    EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
    GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/teleport/destroy", x, y )
end

function shuffle_table( t )
  local tbl = {}
    for i = 1, #t do
        tbl[i] = t[i]
    end
    for i = #tbl, 2, -1 do
        local rnd = Random( 1, i )
        tbl[i], tbl[rnd] = tbl[rnd], tbl[i]
    end
    return tbl
end

function is_in_holy_mountain( entity_id )
    local x, y = EntityGetTransform( entity_id )
    local biome_name = BiomeMapGetName( x, y )
    return string.find( biome_name, "holy" )
end

function share_perk_with_enemy( perk_data, entity_who_picked, entity_item )
    -- fetch perk info ---------------------------------------------------

    local pos_x, pos_y = EntityGetTransform( entity_who_picked )

    local perk_id = perk_data.id
    
    -- add game effect
    if perk_data.game_effect ~= nil then
        local game_effect_comp = GetGameEffectLoadTo( entity_who_picked, perk_data.game_effect, true )
        if game_effect_comp ~= nil then
            ComponentSetValue( game_effect_comp, "frames", "-1" )
        end
    end
    
    if perk_data.func_enemy ~= nil then
        perk_data.func_enemy( entity_item, entity_who_picked )
    elseif perk_data.func ~= nil then
        perk_data.func( entity_item, entity_who_picked )
    end
end

function EntitySetHerd( entity, herd_name )
    EntitySetValue( entity, "GenomeDataComponent", "herd_id", StringToHerdId( herd_name ) )
end
