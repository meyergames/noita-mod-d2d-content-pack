dofile_once("mods/RiskRewardBundle/files/scripts/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local parent_id = EntityGetParent( entity_id )

local target_id = 0

if ( parent_id ~= NULL_ENTITY ) then
	target_id = parent_id
else
	target_id = entity_id
end

local max_enemies_hit = 2

if ( target_id ~= NULL_ENTITY ) then
	local projectile_components = EntityGetComponent( target_id, "ProjectileComponent" )
	
	if( projectile_components == nil ) then return end
	
	if ( #projectile_components > 0 ) then
		edit_component( target_id, "ProjectileComponent", function(comp,vars)
            local enemies_hit = getInternalVariableValue( entity_id, "enemies_hit", "value_int")
            if ( enemies_hit == nil ) then
                setInternalVariableValue( parent_id, "enemies_hit", "value_int", 1 )
            else
                setInternalVariableValue( parent_id, "enemies_hit", "value_int", enemies_hit + 1)
            end

            if ( enemies_hit == max_enemies_hit ) then
    			vars.on_collision_die = 1
            else
                vars.on_collision_die = 0
            end
            
		end)
	end
end

function collision_trigger( colliding_entity_id )
	local projectile_components = EntityGetComponent( target_id, "ProjectileComponent" )
	
	if( projectile_components == nil ) then return end
	
	if ( #projectile_components > 0 ) then
		edit_component( target_id, "ProjectileComponent", function(comp,vars)
            local enemies_hit = getInternalVariableValue( entity_id, "enemies_hit", "value_int")
            if ( enemies_hit == nil ) then
                setInternalVariableValue( parent_id, "enemies_hit", "value_int", 1 )
            else
                setInternalVariableValue( parent_id, "enemies_hit", "value_int", enemies_hit + 1)
            end

            if ( enemies_hit == max_enemies_hit ) then
    			vars.on_collision_die = 1
            else
                vars.on_collision_die = 0
            end
            
		end)
	end
end
