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

function getInternalVariableValueIncludingDisabled(entity_id, variable_name, variable_type)
	local value = nil
	local components = EntityGetComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
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
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, variable_type, new_value )
			end
		end
	end
end

-- custom shorthand that quickly gets an internal int value
function get_internal_int( entity_id, variable_name )
	local value = nil
	local components = EntityGetComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
	if ( components ~= nil ) then
		for key,comp_id in pairs( components ) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				value = ComponentGetValue2( comp_id, "value_int" )
			end
		end
	end
	return value
end

-- custom variation that makes a variable if it doesn't exist yet
function set_internal_int( entity_id, variable_name, new_value )
	local variable_found = false
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, "value_int", new_value )
				variable_found = true
			end
		end
	end

	if not variable_found then
		addNewInternalVariable( entity_id, variable_name, "value_int", new_value )
	end
end

function get_internal_float( entity_id, variable_name )
	local value = nil
	local components = EntityGetComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
	if ( components ~= nil ) then
		for key,comp_id in pairs( components ) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				value = ComponentGetValue2( comp_id, "value_float" )
			end
		end
	end
	return value
end

function set_internal_float( entity_id, variable_name, new_value )
	local variable_found = false
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, "value_float", new_value )
				variable_found = true
			end
		end
	end

	if not variable_found then
		addNewInternalVariable( entity_id, variable_name, "value_float", new_value )
	end
end

function get_internal_bool( entity_id, variable_name )
	local value = nil
	local components = EntityGetComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
	if ( components ~= nil ) then
		for key,comp_id in pairs( components ) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				value = ComponentGetValue2( comp_id, "value_bool" )
			end
		end
	end
	return value
end

function set_internal_bool( entity_id, variable_name, new_value )
	local variable_found = false
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, "value_bool", new_value )
				variable_found = true
			end
		end
	end

	if not variable_found then
		addNewInternalVariable( entity_id, variable_name, "value_bool", new_value )
	end
end

-- custom shorthand that quickly gets an internal int value
function get_internal_string( entity_id, variable_name )
	local value = nil
	local components = EntityGetComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
	if ( components ~= nil ) then
		for key,comp_id in pairs( components ) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				value = ComponentGetValue2( comp_id, "value_string" )
			end
		end
	end
	return value
end

-- custom variation that makes a variable if it doesn't exist yet
function set_internal_string( entity_id, variable_name, new_value )
	local variable_found = false
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, "value_string", new_value )
				variable_found = true
			end
		end
	end

	if not variable_found then
		addNewInternalVariable( entity_id, variable_name, "value_string", new_value )
	end
end

function has_vscomp( entity_id, variable_name )
	local vcomps = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( vcomps ~= nil ) then
		for _,vcomp in pairs(vcomps) do 
			local var_name = ComponentGetValue2( vcomp, "name" )
			if( var_name == variable_name ) then
				return true
			end
		end
	end
	return false
end

-- very shorthand version of getting OR setting an internal int variable
function p_int( variable_name, delta )
	return var_int( get_player(), variable_name, delta )
end

function var_int( entity_id, variable_name, new_value )
	local new_value = new_value or nil

	local vcomps = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( vcomps ~= nil ) then
		for _,vcomp in pairs(vcomps) do 
			local var_name = ComponentGetValue2( vcomp, "name" )
			if( var_name == variable_name ) then
				if new_value ~= nil then
					ComponentSetValue2( vcomp, "value_int", new_value )
					return new_value
				end
			end
		end
	end

	if new_value ~= nil then
		addNewInternalVariable( entity_id, variable_name, "value_int", new_value )
		return new_value
	end
	return -1
end

function var_int_add( entity_id, variable_name, delta )
	local delta = delta or nil
	
	local vcomps = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( vcomps ~= nil ) then
		for _,vcomp in pairs(vcomps) do
			local var_name = ComponentGetValue2( vcomp, "name" )
			local var_value = ComponentGetValue2( vcomp, "value_int" )

			if var_name == variable_name then
				GamePrint( delta )
				if delta ~= nil then
					ComponentSetValue2( vcomp, "value_int", var_value + delta )
				end
				return var_value + delta
			end
		end
	end

	if delta ~= nil then
		addNewInternalVariable( entity_id, variable_name, "value_int", delta )
		return delta
	end
	return -1
end

-- custom variation that makes a variable if it doesn't exist yet
function append_internal_csv_list( entity_id, variable_name, added_value )
	local variable_found = false
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			local var_value = ComponentGetValue2( comp_id, "value_string" )
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, "value_string", var_value .. "," .. tostring( added_value ) )
				GamePrint( "total list: " .. var_value .. "," .. added_value )
				variable_found = true
			end
		end
	end

	if not variable_found then
		addNewInternalVariable( entity_id, variable_name, "value_string", added_value )
		GamePrint( "value added: " .. added_value )
	end
end

-- custom variation that makes a variable if it doesn't exist yet
function internal_csv_list_contains( entity_id, variable_name, sought_value )
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do
			local var_name = ComponentGetValue2( comp_id, "name" )
			local var_value = ComponentGetValue2( comp_id, "value_string" )
			if var_name == variable_name then
				GamePrint( "var_value: " .. tostring( var_value ) )

				local split_values = split_string( var_value, "," )
				for _,val in pairs( split_values ) do
					if val == tostring( sought_value ) then
						return true
					end
				end
			end
		end
	end
	return false
end

-- custom variation that makes a variable if it doesn't exist yet
function raise_internal_int( entity_id, variable_name, delta )
	local variable_found = false
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			local var_value = ComponentGetValue2( comp_id, "value_int" )
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, "value_int", var_value + delta )
				variable_found = true
			end
		end
	end

	if not variable_found then
		addNewInternalVariable( entity_id, variable_name, "value_int", delta )
	end
end

-- custom variation that makes a variable if it doesn't exist yet
function raise_internal_float( entity_id, variable_name, delta )
	local variable_found = false
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			local var_value = ComponentGetValue2( comp_id, "value_float" )
			if( var_name == variable_name ) then
				ComponentSetValue2( comp_id, "value_float", var_value + delta )
				variable_found = true
			end
		end
	end

	if not variable_found then
		addNewInternalVariable( entity_id, variable_name, "value_float", delta )
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

function has_lua( entity_id, tag )
	local comps = EntityGetComponentIncludingDisabled( entity_id, "LuaComponent", tag ) or {}
	return #comps > 0
end

function remove_lua( entity_id, tag )
	local comps = EntityGetComponentIncludingDisabled( entity_id, "LuaComponent", tag ) or {}
	for i = 1, #comps do
		EntityRemoveComponent( entity_id, comps[i] )
	end
end

function remove_shoteffect( entity_id, tag )
	local comps = EntityGetComponentIncludingDisabled( entity_id, "ShotEffectComponent", tag ) or {}
	for i = 1, #comps do
		EntityRemoveComponent( entity_id, comps[i] )
	end
end

function get_child_with_name( parent_id, name )
    local children = EntityGetAllChildren( parent_id )
    if children then
	    for i,child in ipairs( children ) do
	        local filename = EntityGetFilename( child )
	        if string.find( filename, name ) then
	            return child
	        end
	    end
	end

	return nil
end

function get_child_with_tag( parent_id, tag )
    local children = EntityGetAllChildren( parent_id, tag )
    for i,child in ipairs( children ) do
        local tags = EntityGetTags( child )
        if string.find( tags, tag ) then
            return child
        end
    end

	return nil
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



function multiply_move_speed( entity_id, effect_name, mtp_x, mtp_y )
    local character_platforming_component = EntityGetFirstComponentIncludingDisabled( entity_id, "CharacterPlatformingComponent" )

    if not mtp_y then mtp_y = mtp_x end

    local properties_to_change = {
        velocity_min_x = mtp_x,
        velocity_max_x = mtp_x,
	    jump_velocity_y = mtp_y,
	    jump_velocity_x = mtp_x,
	    fly_speed_max_up = mtp_y,
	    fly_speed_max_down = mtp_y,
	    fly_velocity_x = mtp_x
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
		    value_string = mtp_x .. "," .. mtp_y,
	    })
    end
end

function reset_move_speed( entity_id, effect_name )
    local character_platforming_component = EntityGetFirstComponentIncludingDisabled( entity_id, "CharacterPlatformingComponent")
    local var_store = get_variable_storage_component( entity_id, effect_name .. "_move_speed_mtp" )
    if not var_store then return end

    stored_mtp_value = ComponentGetValue2( var_store, "value_string" )
    local parsed = split_string( stored_mtp_value, ',' )
    local mtp_x = parsed[1]
    local mtp_y = parsed[2]

    local properties_to_change = {
        velocity_min_x = 1.0 / mtp_x,
        velocity_max_x = 1.0 / mtp_x,
	    jump_velocity_y = 1.0 / mtp_y,
	    jump_velocity_x = 1.0 / mtp_x,
	    fly_speed_max_up = 1.0 / mtp_y,
	    fly_speed_max_down = 1.0 / mtp_y,
	    fly_velocity_x = 1.0 / mtp_x
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

-- function remove_game_effect( entity_id, game_effect_name )
-- 	-- doesn't work :( return for now
-- 	return

-- 	if has_game_effect( entity_id, game_effect_name ) then
-- 		GamePrint( "test 1" )
-- 		for i,child_id in ipairs( EntityGetAllChildren( entity_id ) ) do
-- 			GamePrint( "test 2" )
-- 			local effect_comp = EntityGetComponent( child_id, "GameEffectComponent" )
-- 			if effect_comp ~= 0 then
-- 				local effect_name = ComponentGetValue2( effect_comp, "effect" )
-- 				GamePrint( "test 3: " .. effect_name )
-- 				if string.find( effect_name, game_effect_name ) then
-- 					GamePrint( "test 4" )
-- 					EntityKill( child_id )
-- 					GamePrint( "game effect removed: " .. effect_name )
-- 				end
-- 			end
-- 		end
-- 	end
-- end



function apply_random_curse( entity_id )
	-- local config_curses_enabled = ModSettingGet("D2DContentPack.enable_curses")
	-- if not config_curses_enabled then return end

    dofile_once( "data/scripts/perks/perk.lua" )
    dofile_once( "mods/D2DContentPack/files/scripts/perks.lua" )
    local x, y = EntityGetTransform( entity_id )

    local curses_not_picked_up = {}
	for k,v in ipairs( d2d_curses ) do
		if ( not has_perk( v.id ) ) then
			table.insert( curses_not_picked_up, v )
		end
	end

	if #curses_not_picked_up > 0 then
		local random_perk = curses_not_picked_up[ Random( 1, #curses_not_picked_up ) ]
    	local spawned_perk = perk_spawn( x, y, random_perk.id )
    	perk_pickup( spawned_perk, entity_id, EntityGetName( spawned_perk ), false, false )

		GamePrintImportant( GameTextGetTranslatedOrNot( random_perk.ui_name ), GameTextGetTranslatedOrNot( random_perk.ui_description ) )
	    GamePlaySound( "data/audio/Desktop/animals.bank", "animals/sheep/confused", x, y )
	end
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



function spawn_random_perk( x, y, dont_remove_others )
    dofile_once( "data/scripts/perks/perk_list.lua" )
    dofile_once( "data/scripts/perks/perk.lua" )

    local perk_ids_to_consider = {}
	for k,v in pairs( perk_list ) do
		if ( not v.not_in_default_perk_pool ) then
			table.insert( perk_ids_to_consider, v.id )
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


function remap( value, inMin, inMax, outMin, outMax )
    -- Guard against division by zero if the input range is degenerate.
    if inMax == inMin then
        error("Input range cannot have zero length")
    end

    -- Normalise the input value to a 0‑1 scale.
    local t = (value - inMin) / (inMax - inMin)

    -- Optionally clamp t to [0,1] so values outside the source range don’t extrapolate.
    -- Uncomment the next two lines if you want clamping:
    if t < 0 then t = 0 elseif t > 1 then t = 1 end

    -- Scale to the target range.
    return outMin + t * (outMax - outMin)
end




function to_roman_numerals( s )
	local map = { 
	    I = 1,
	    V = 5,
	    X = 10,
	    L = 50,
	    C = 100, 
	    D = 500, 
	    M = 1000,
	}
	local numbers = { 1, 5, 10, 50, 100, 500, 1000 }
	local chars = { "I", "V", "X", "L", "C", "D", "M" }

	s = tonumber(s)
    if not s or s ~= s then error"Unable to convert to number" end
    if s == math.huge then error"Unable to convert infinity" end
    s = math.floor(s)
    if s <= 0 then return s end
	local ret = ""
        for i = #numbers, 1, -1 do
        local num = numbers[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. chars[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = numbers[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. chars[j] .. chars[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
end

function fetch_spell_data( action_id )
	dofile_once( "data/scripts/gun/gun_actions.lua" )
	for k,v in pairs( actions ) do
		if ( v.id == action_id ) then
			return v
		end
	end

	return nil
end

function spawn_random_cat( x, y )
	local cats = { "cat_mocreeps", "cat_mocreeps_black", "cat_mocreeps", "cat_mocreeps_black", "cat_mocreeps_white", "cat_mocreeps_spoopy", "cat_mocreeps_spoopy_skittle", "cat_mocreeps_spoopy_frisky", "cat_mocreeps_spoopy_tiger" }
	cat_to_spawn = random_from_array( cats )

	-- local folder = "animals/cat_immortal/"
	local folder = "animals/"
	-- if not ModSettingGet( "Apotheosis.congacat_cat_immortal" ) then folder = "animals/" end
	local path = table.concat( { "mods/Apotheosis/data/entities/", folder, cat_to_spawn, ".xml" } )
	local cat = EntityLoad( path, x, y )

	EntityAddComponent( cat, "LuaComponent", 
	{ 
		script_damage_about_to_be_received = "mods/D2DContentPack/files/scripts/animals/cat_damage_incoming.lua",
		execute_every_n_frame = "-1",
	} )

	return cat
end

function try_find_luacomp( entity_id, script_type, script_name )
	local lcomps = EntityGetComponentIncludingDisabled( entity_id, "LuaComponent" )
	if lcomps ~= nil then
		for _,lcomp in pairs( lcomps ) do
			if string.find( ComponentGetValue2( lcomp, script_type ), script_name ) then
				return lcomp
			end
		end
	end
end

function make_serializable( entity_id )
	-- -- vvv this could work to make cats serializable?
	-- local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
	-- local xml_content = ModTextFileGetContent("data/entities/props/existing_entity.xml")
	-- local handler = xml2lua.parse(xml_content)
	-- if handler.root.Entity._attr.tags then
	--   handler.root.Entity._attr.tags = handler.root.Entity._attr.tags .. ",your_tag_name"
	-- else
	--   handler.root.Entity._attr.tags = "your_tag_name"
	-- end
	-- local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
	-- ModTextFileSetContent("data/entities/props/existing_entity.xml", xml_output)
end

function lift_all_curses( entity_id )
    dofile_once( "data/scripts/perks/perk.lua" )
    dofile_once( "mods/D2DContentPack/files/scripts/perks.lua" )

    -- local active_curses = EntityGetWithTag( "perk_entity" )
	-- for i,curse_entity_id in ipairs( active_curses or {} ) do
	-- 	GamePrint( "REMOVED(?) " .. curse_entity_id )

	-- 	EntityKill( curse_entity_id )
	-- 	GlobalsSetValue( v.id .. "_PICKUP_COUNT", "0" )
	-- 	-- EntityAddComponent2( perk_entity, "LifetimeComponent", { lifetime = 1 } )
	-- end

	local curse_entities = EntityGetWithTag( "d2d_curse_perk" )
	for i,curse_entity in ipairs( curse_entities or {} ) do
		EntityKill( curse_entity )
	end

	-- remove flags, reset pickup count
	for k,v in ipairs( d2d_curses or {} ) do
		if has_perk( v.id ) then
		    local perk = get_perk_with_id( perk_list, v.id )
		    local flag_name = get_perk_picked_flag_name( v.id )
			GlobalsSetValue( flag_name .. "_PICKUP_COUNT", "0" )
		    GameRemoveFlagRun( flag_name )
		end
	end

	-- remove all UI icons
    local perk_entities = EntityGetWithTag( "perk_entity" )
    for i,perk_entity in ipairs( perk_entities or {} ) do
    	GamePrint("checking for id " .. perk_entity)

    	local icon_comp = EntityGetFirstComponentIncludingDisabled( perk_entity, "UIIconComponent" )
    	if icon_comp then
	    	local icon_name = ComponentGetValue2( icon_comp, "name" )
	    	if string.find( icon_name, "d2d_curse" ) then
	        	EntityAddComponent2( perk_entity, "LifetimeComponent", { lifetime = 1 } )
	    	end
    	end
    end

    -- destroy all remaining cursed chests
    local cursed_chests = EntityGetWithTag( "cursed_chest" )
    for i,cursed_chest in ipairs( cursed_chests or {} ) do
    	EntityKill( cursed_chest )
    end
end

function set_controls_enabled(enabled)
	local player = EntityGetWithTag("player_unit")[1]
	if player then
		local controls_component = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
		ComponentSetValue2(controls_component, "enabled", enabled)
		for prop, val in pairs(ComponentGetMembers(controls_component) or {}) do
			if prop:sub(1, 11) == "mButtonDown" and not prop:find("DelayLine") then
				ComponentSetValue2(controls_component, prop, false)
			end
		end
	end
end

function is_within_bounds( entity_id, xl, xr, yt, yb )
	local x, y = EntityGetTransform( entity_id )
	return x > xl and x < xr and y > yt and y < yb
end


-- Returns a key-value table, where they keys are the material name and the values the damage.
function get_materials_that_damage( entity_id )
  local out = {}
  local damage_model_component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
  if damage_model_component then
    local materials_that_damage = ComponentGetValue2(damage_model_component, "materials_that_damage")
    materials_that_damage = stringsplit(materials_that_damage, ",")
    local materials_how_much_damage = ComponentGetValue2(damage_model_component, "materials_how_much_damage")
    materials_how_much_damage = stringsplit(materials_how_much_damage, ",")
    for i, v in ipairs(materials_that_damage) do
      out[v] = materials_how_much_damage[i]
    end
    return out
  end
end

-- <materials> should be a key-value table with the keys being the name of the material to change and the value the new damage.
-- For instance: change_materials_that_damage(entity_id, { lava = 0, new_material = 0.004 }) would make the entity immune to lava
-- and the material with name="new_material" would deal 0.004 damage.
function change_materials_that_damage( entity_id, materials )
  -- At the time of writing (1st of September 2020) changes to DamageModelComponent:materials_that_damage
  -- do not take effect. One of the ways to work around that is to remove and re-add the component with
  -- the changes applied and the same old values for everything else
  local damage_model_component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
  if damage_model_component then
    -- Retrieve and store all old values of the DamageModelComponent
    local old_values = {}
    local old_damage_multipliers = {}
    for k,v in pairs(ComponentGetMembers(damage_model_component)) do
      -- ComponentGetMembers does not return the value for ragdoll_fx_forced, ComponentGetValue2 is necessary
      if k == "ragdoll_fx_forced" then
        v = ComponentGetValue2(damage_model_component, k)
      end
      old_values[k] = v
    end
    for k,_ in pairs(ComponentObjectGetMembers(damage_model_component, "damage_multipliers")) do
      old_damage_multipliers[k] = ComponentObjectGetValue(damage_model_component, "damage_multipliers", k)
    end
    -- Build comma separated string
    old_values.materials_that_damage = ""
    old_values.materials_how_much_damage = ""
    local old_materials_that_damage = get_materials_that_damage(entity_id)
    for material, damage in pairs(materials) do
      old_materials_that_damage[material] = damage
    end
    for material, damage in pairs(old_materials_that_damage) do
      local comma = old_values.materials_that_damage == "" and "" or ","
      old_values.materials_that_damage = old_values.materials_that_damage .. comma .. material
      old_values.materials_how_much_damage = old_values.materials_how_much_damage .. comma .. damage
    end
    EntityRemoveComponent(entity_id, damage_model_component)
    damage_model_component = EntityAddComponent(entity_id, "DamageModelComponent", old_values)
    ComponentSetValue2(damage_model_component, "ragdoll_fx_forced", old_values.ragdoll_fx_forced)
    for k, v in pairs(old_damage_multipliers) do
      ComponentObjectSetValue(damage_model_component, "damage_multipliers", k, v)
    end
  end
end