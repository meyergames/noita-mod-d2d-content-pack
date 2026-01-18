dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

function exists( id )
    return id and id ~= 0
end

function determine_blink_dmg_mtp()
	-- first check the staff
    local wand = EZWand.GetHeldWand()
    if wand then
    	local tier = get_internal_int( wand.entity_id, "staff_of_time_tier" )
    	if tier == 3 then
    		return 0.02
    	elseif tier == 2 then
    		return 0.05
    	elseif tier == 1 then
    		return 0.10
    	end
    end

    -- if the spell is cast outside of the Staff of Time, check the player's fastest Time Trial completion this run
    if GameHasFlagRun( "d2d_time_trial_gold_this_run" ) then
    	return 0.02
    elseif GameHasFlagRun( "d2d_time_trial_silver_this_run" ) then
    	return 0.05
    else
    	return 0.10
    end
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

function multiply_proj_dmg( proj_id, mtp )
    local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
    if proj_comp then
        local old_dmg = ComponentGetValue2( proj_comp, "damage" )
        ComponentSetValue2( proj_comp, "damage", old_dmg * mtp )

        local old_expl_dmg = ComponentObjectGetValue2( proj_comp, "config_explosion", "damage" )
        if exists( old_expl_dmg ) then
            ComponentSetValue2( proj_comp, "config_explosion", "damage", old_expl_dmg * mtp )
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

function held_wand_contains_spell( player_entity_id, action_id )
    local held_wand = EZWand.GetHeldWand()
    local spells, always_casts = held_wand:GetSpells()
    
    for i,spell in ipairs( spells ) do
        if spell.action_id == action_id then
            return true
        end
    end
    for i,always_cast in ipairs( always_casts ) do
        if always_cast.action_id == action_id then
            return true
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
                    GamePrint( new_sprite_file )
                    ComponentSetValue2( iconcomp, "icon_sprite_file", new_sprite_file )
                    ComponentSetValue2( iconcomp, "name", GameTextGetTranslatedOrNot( comp_name ) .. " (spent)" )
                end
            end
        end
    end
end