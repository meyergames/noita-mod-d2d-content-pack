dofile_once("mods/RiskRewardBundle/files/scripts/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

--local parent_id = EntityGetParent( entity_id )
--
--local target_id = 0
--
--if ( parent_id ~= NULL_ENTITY ) then
--	target_id = parent_id
--else
--	target_id = entity_id
--end

local max_enemies_hit = 2

function collision_trigger( colliding_entity_id )
	local projectile_components = EntityGetComponent( entity_id, "ProjectileComponent" )
	
    GamePrint("Hit! 1/2")
	if( projectile_components == nil ) then return end
    GamePrint("Hit! 2/2")
	
	if ( #projectile_components > 0 ) then
        ComponentSetValue2( entity_id, "ProjectileComponent", function(comp,vars)
            GamePrint("Trying to register enemy hit...")
            local enemies_hit = getInternalVariableValue( entity_id, "enemies_hit", "value_int")
            if ( enemies_hit == nil ) then
                setInternalVariableValue( entity_id, "enemies_hit", "value_int", 1 )
                GamePrint("First enemy hit")
            else
                setInternalVariableValue( entity_id, "enemies_hit", "value_int", enemies_hit + 1)
                GamePrint("Enemy hit #" .. enemies_hit)
            end

            if ( enemies_hit == max_enemies_hit ) then
    			vars.on_collision_die = 1
            else
                vars.on_collision_die = 0
            end
            
		end)
	end
end
