-- function to obtain a value from an internal variable contained in a variable storage component
-- entity_id is the id of the entity whose internal variables will be accessed
-- variable_name is the name of the internal variable to be accesses
-- variable_type is type indicator of the internal variable, which can be value_string, value_int or value_float
function getInternalVariableValue(entity_id, variable_name, variable_type)
	local value = nil
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if(var_name == variable_name) then
				value = ComponentGetValue2(comp_id, variable_type)
			end
		end
	end
	return value
end

-- function to set a value of an internal variable contained in a variable storage component of an entity with entity_id with name variable_name and type variable_type
-- entity_id is the id of the entity whose internal variables will be accessed
-- variable_name is the name of the internal variable to be accesses
-- variable_type is type indicator of the internal variable, which can be value_string, value_int or value_float
function setInternalVariableValue(entity_id, variable_name, variable_type, new_value)

	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name) then
				ComponentSetValue2( comp_id, variable_type, new_value )
			end
		end
	end
end

-- function to add new internal variables to an entity
-- entity_id is the id of the entity that will receive a new internal variable
-- variable_type is the type of variable being added, can be value_int, value_string or value_float
-- initial_value is the starting value of the variable being added, if none, must be provided as, e.g., 0, "", or 0.0
function addNewInternalVariable(entity_id, variable_name, variable_type, initial_value)
	if(variable_type == "value_int") then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name=variable_name,
			value_int=initial_value
		})
	elseif(variable_type == "value_string") then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name=variable_name,
			value_string=initial_value
		})
	elseif(variable_type == "value_float") then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name=variable_name,
			value_float=initial_value
		})
	elseif(variable_type == "value_bool") then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name=variable_name,
			value_bool=initial_value
		})
	end
end

function split_string(inputstr, sep)
  sep = sep or "%s"
  local t= {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function toboolean(str)
	return str == "1"
end

function get_player()
  return EntityGetWithTag("player_unit")[1]
end

function get_active_wand()
  local player = get_player()
  if not player then return nil end

  return EntityGetValue2(player, "Inventory2Component", "mActiveItem")
end










function has_perk( perk_id )
	return get_perk_pickup_count( perk_id ) > 0
end

function get_perk_pickup_count( perk_id )
    dofile_once("data/scripts/perks/perk_list.lua")

    local perk = get_perk_with_id( perk_list, perk_id )
    local flag_name = get_perk_picked_flag_name( perk_id )
    local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )

    return pickup_count
end


-- This method was originally written by Horscht for the "Removable perks" mod, slightly adjusted to better fit this mod's needs. Thank you Horscht! ---
function remove_perk( perk_id )
    dofile_once("data/scripts/perks/perk_list.lua")
    local player = EntityGetWithTag("player_unit")[1]
    if not player then return end
    
    local perk = get_perk_with_id( perk_list, perk_id )
    local flag_name = get_perk_picked_flag_name( perk_id )
    local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
    pickup_count = pickup_count - 1
	GlobalsSetValue(flag_name .. "_PICKUP_COUNT", tostring(pickup_count))
    
    -- Remove run flags if this is the last perk instance
    if pickup_count == 0 then
        GameRemoveFlagRun(flag_name)
--        for i,other_perk_id in ipairs(perk.remove_other_perks or {}) do
--            GameRemoveFlagRun(get_perk_picked_flag_name(other_perk_id))
--        end
    end
    local function kill_child_entity_with_game_effect(game_effect)
        if game_effect then
            local game_effect_component = GameGetGameEffect(player, game_effect)
            if game_effect_component then
                for i, child in ipairs(EntityGetAllChildren(player) or {}) do
                    for i2, component in ipairs(EntityGetComponentIncludingDisabled(child, "GameEffectComponent") or {}) do
                        if component == game_effect_component then
                            EntityKill(child)
                            return
                        end
                    end
                end
            end
        end
    end
    kill_child_entity_with_game_effect(perk.game_effect)
    kill_child_entity_with_game_effect(perk.game_effect2)
    if perk.particle_effect then
        kill_child_by_filename(player, ("data/entities/particles/perks/%s.xml"):format(perk.particle_effect))
    end

    local perk_entities = EntityGetWithTag( "perk_entity" )
    for i,perk_entity in ipairs(EntityGetWithTag( "perk_entity" ) or {}) do
        EntityAddComponent2( perk_entity, "LifetimeComponent", { lifetime = 1 } )
    end
end



function multiply_move_speed( entity_id, effect_name, mtp )
    local character_platforming_component = EntityGetFirstComponentIncludingDisabled( entity_id, "CharacterPlatformingComponent" )

    local properties_to_change = {
        velocity_min_x = mtp,
        velocity_max_x = mtp,
	    jump_velocity_y = mtp,
	    jump_velocity_x = mtp,
	    fly_speed_max_up = mtp,
	    fly_speed_max_down = mtp,
	    fly_velocity_x = mtp
    }

    if character_platforming_component then
	    local old_values = ""
	    for k, v in pairs(properties_to_change) do
		    local value = ComponentGetValue2(character_platforming_component, k)
		    local string_value = tostring(value)
		    if type(value) == "boolean" then
			    string_value = value and "1" or "0"
		    end
		    old_values = old_values .. k .. ":" .. type(value) .. "=" .. string_value
		    if next(properties_to_change, k) then
			    old_values = old_values .. ","
		    end
		    ComponentSetValue2(character_platforming_component, k, value * v)
	    end

	    EntityAddComponent2( entity_id, "VariableStorageComponent", {
		    name = effect_name .. "_move_speed_mtp",
		    value_string = mtp,
	    })
    end
end

function reset_move_speed( entity_id, effect_name )
    local character_platforming_component = EntityGetFirstComponentIncludingDisabled( entity_id, "CharacterPlatformingComponent")
    local var_store = get_variable_storage_component( entity_id, effect_name .. "_move_speed_mtp" )
    stored_mtp_value = ComponentGetValue2( var_store, "value_string" )

    local properties_to_change = {
        velocity_min_x = 1.0 / stored_mtp_value,
        velocity_max_x = 1.0 / stored_mtp_value,
	    jump_velocity_y = 1.0 / stored_mtp_value,
	    jump_velocity_x = 1.0 / stored_mtp_value,
	    fly_speed_max_up = 1.0 / stored_mtp_value,
	    fly_speed_max_down = 1.0 / stored_mtp_value,
	    fly_velocity_x = 1.0 / stored_mtp_value
    }

    if character_platforming_component then
	    local old_values = ""
	    for k, v in pairs(properties_to_change) do
		    local value = ComponentGetValue2(character_platforming_component, k)
		    local string_value = tostring(value)
		    if type(value) == "boolean" then
			    string_value = value and "1" or "0"
		    end
		    old_values = old_values .. k .. ":" .. type(value) .. "=" .. string_value
		    if next(properties_to_change, k) then
			    old_values = old_values .. ","
		    end
		    ComponentSetValue2( character_platforming_component, k, value * v )
	    end

        --remove the variable storage component
        EntityRemoveComponent( entity_id, var_store )
    end
end


function multiply_all_damage( entity_id, effect_name, mtp )
	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )

    local properties_to_change = {
        projectile = mtp,
        explosion = mtp,
	    melee = mtp,
	    ice = mtp,
	    slice = mtp,
	    electricity = mtp,
	    radioactive = mtp,
	    drill = mtp,
	    fire = mtp
    }

    if dcomp then
	    local old_values = ""
	    for k, v in pairs(properties_to_change) do
	    	local value = ComponentObjectGetValue2( dcomp, "damage_multipliers", k )
		    local string_value = tostring(value)
		    old_values = old_values .. k .. ":" .. type(value) .. "=" .. string_value
		    if next(properties_to_change, k) then
			    old_values = old_values .. ","
		    end
		    ComponentObjectSetValue2(dcomp, "damage_multipliers", k, value * v)
	    end

	    EntityAddComponent2( entity_id, "VariableStorageComponent", {
		    name = effect_name .. "_all_damage_mtp",
		    value_string = mtp,
	    })
    end
end

function reset_all_damage( entity_id, effect_name )
	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
    local var_store = get_variable_storage_component( entity_id, effect_name .. "_all_damage_mtp" )
    stored_mtp_value = ComponentGetValue2( var_store, "value_string" )

    local properties_to_change = {
        projectile = 1.0 / stored_mtp_value,
        explosion = 1.0 / stored_mtp_value,
	    melee = 1.0 / stored_mtp_value,
	    ice = 1.0 / stored_mtp_value,
	    slice = 1.0 / stored_mtp_value,
	    electricity = 1.0 / stored_mtp_value,
	    radioactive = 1.0 / stored_mtp_value,
	    drill = 1.0 / stored_mtp_value,
	    fire = 1.0 / stored_mtp_value
    }

    if character_platforming_component then
	    local old_values = ""
	    for k, v in pairs(properties_to_change) do
	    	local value = ComponentObjectGetValue2( dcomp, "damage_multipliers", k )
		    local string_value = tostring(value)
		    old_values = old_values .. k .. ":" .. type(value) .. "=" .. string_value
		    if next(properties_to_change, k) then
			    old_values = old_values .. ","
		    end
		    ComponentObjectSetValue2(dcomp, "damage_multipliers", k, value * v)
	    end

        --remove the variable storage component
        EntityRemoveComponent( entity_id, var_store )
    end
end




function distance_between( entity_a, entity_b )
	local ax, ay = EntityGetTransform( entity_a )
	local bx, by = EntityGetTransform( entity_b )

	return get_distance( ax, ay, bx, by )
end

function has_game_effect( entity_id, game_effect_name )
	return GameGetGameEffectCount( entity_id, game_effect_name ) > 0
end

function remove_game_effect( entity_id, game_effect_name )
	GamePrint( "remove_game_effect: not implemented" )
	-- return GameGetGameEffectCount( entity_id, game_effect_name ) > 0
end



function apply_random_curse( entity_id )
    dofile_once( "data/scripts/perks/perk.lua" )
    dofile_once( "mods/RiskRewardBundle/files/scripts/perks.lua" )
    local x, y = EntityGetTransform( entity_id )

    local curses_not_picked_up = {}
	for k,v in pairs( ctq_curses ) do
		if ( not has_perk( v.id ) ) then
			curses_not_picked_up[k] = v
		end
	end

    local stackable_curses = {}
	for k,v in pairs( ctq_curses ) do
		if ( v.stackable == STACKABLE_YES ) then
			stackable_curses[k] = v
		end
	end

	local random_perk
	if ( #curses_not_picked_up > 0 ) then
		random_perk = random_from_array( curses_not_picked_up )
	else
		random_perk = random_from_array( stackable_curses )
	end
    local spawned_perk = perk_spawn( x, y, random_perk.id )
    perk_pickup( spawned_perk, entity_id, EntityGetName( spawned_perk ), false, false )

    -- local curse_count = getInternalVariableValue( entity_id, "CURSE_COUNT", "value_int" )
    -- if curse_count then
    -- 	setInternalVariableValue( entity_id, "PLAYER_CURSE_COUNT", "value_int", curse_count + 1 )
    -- else
    -- 	addNewInternalVariable( entity_id, "PLAYER_CURSE_COUNT", "value_int", 1 )
    -- end

    GamePlaySound( "data/audio/Desktop/animals.bank", "animals/sheep/confused", x, y )
end


-- courtesy to gkbrkn for this function
function adjust_all_entity_damage( entity, callback )
    adjust_entity_damage( entity,
        function( current_damage ) return callback( current_damage ) end,
        function( current_damages )
            for type,current_damage in pairs( current_damages ) do
                if current_damage ~= 0 then
                    current_damages[type] = callback( current_damage )
                end
            end
            return current_damages
        end,
        function( current_damage ) return callback( current_damage ) end,
        function( current_damage ) return callback( current_damage ) end,
        function( current_damage ) return callback( current_damage ) end
    )
end



function spawn_random_perk( x, y )
    dofile_once( "data/scripts/perks/perk_list.lua" )
    dofile_once( "data/scripts/perks/perk.lua" )

    local perk_ids_to_consider = {}
	for k,v in pairs( perk_list ) do
		if ( not v.not_in_default_perk_pool ) then
			perk_ids_to_consider[k] = v.id
		end
	end

    perk_id_to_spawn = random_from_array( perk_ids_to_consider )
    local perk = perk_spawn( x, y, perk_id_to_spawn )
end


function spawn_perk( perk_id, x, y )
    dofile_once( "data/scripts/perks/perk_list.lua" )
    dofile_once( "data/scripts/perks/perk.lua" )

    local perk = perk_spawn( x, y, perk_id )
end


function spawn_random_perk_custom( x, y, perk_ids )
    dofile_once( "data/scripts/perks/perk_list.lua" )
    dofile_once( "data/scripts/perks/perk.lua" )

	for k,v in pairs( added_perk_ids ) do
		perk_ids_to_consider[k] = v
	end

    perk_id_to_spawn = random_from_array( perk_ids_to_consider )
    local perk = perk_spawn( x, y, perk_id_to_spawn )
end