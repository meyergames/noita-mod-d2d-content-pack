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

function player_take_max_hp_dmg( ratio, can_kill )
	GamePrint( "<function not implemented>" )
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

        -- local damage_by_types = ComponentObjectGetMembers( proj_comp, "damage_by_type" )
        -- if exists( damage_by_types ) then
        --     local damage_by_types_fixed = {}
        --     for type,_ in pairs( damage_by_types ) do
        --         damage_by_types_fixed[type] = ComponentObjectGetValue2( proj_id, "damage_by_type", type )
        --         GamePrint( "type count: " .. #damage_by_types_fixed )
        --     end
        --     for type,old_dmg in pairs( damage_by_types_fixed ) do
        --         GamePrint( "type: " .. type )
        --         if exists( old_dmg ) then
        --             GamePrint( "old_dmg: " .. old_dmg )
        --             ComponentObjectSetValue2( projectile, "damage_by_type", type, old_dmg * 2 )
        --         end
        --     end
        -- end
    end
end