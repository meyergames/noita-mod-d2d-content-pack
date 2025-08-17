dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
--local owner = EntityGetParent(entity_id)
local owner = get_player()
local x, y = EntityGetTransform( owner )

local dcomps = EntityGetComponent( owner, "DamageModelComponent" )
if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
    for i,damagemodel in ipairs( dcomps ) do
        local max_hp = ComponentGetValue2( damagemodel, "max_hp" )
        local damage = max_hp * 0.0167

        EntityInflictDamage( owner, damage, "NONE", "viral infection", "NO_RAGDOLL_FILE", 0, 0, entity_id, x, y, 0)
        
        local rand = Random( 0, 4 )
        if ( rand == 0 ) then
            EntityLoad( "data/entities/particles/vomit.xml", x, y )
        end

        local old_update_count = getInternalVariableValue( owner, "virus_update_count", "value_int" )
        if ( old_update_count ~= nil ) then
            local new_update_count = old_update_count + 1
            setInternalVariableValue( owner, "virus_update_count", "value_int", new_update_count )

            -- make trip intensity scale with effect duration
--            local demcomp = EntityGetComponent( entity_id, "DrugEffectModifierComponent" )
--            if ( demcomp ~= nil ) then
--                GamePrint( "Updating trip effects..." )
--                local fx_add = ComponentObjectGetValue2( demcomp, "fx_add" );
--                fx_add.distortion_amount = math.min(0.5 + (new_update_count * 0.01), 1.0)
--                fx_add.distortion_amount = math.min(0.4 + (new_update_count * 0.012), 1.0)
--            end

            -- gradually spawn more and more illusions as the effect persists
            if ( ModIsEnabled("Apotheosis") and new_update_count > 10 ) then
                local rand = Random( 0, 100 )
                if ( rand + ((new_update_count-10)*1.6) > 80 ) then
                    dofile("mods/Apotheosis/files/scripts/misc/psychotic_illusion_populator.lua")
                end
            end
        end
    end
end
