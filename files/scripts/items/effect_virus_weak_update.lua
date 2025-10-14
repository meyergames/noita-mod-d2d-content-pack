dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)
local x, y = EntityGetTransform( owner )

local dcomps = EntityGetComponent( owner, "DamageModelComponent" )
if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
    for i,damagemodel in ipairs( dcomps ) do
        local max_hp = ComponentGetValue2( damagemodel, "max_hp" )
        local damage = max_hp * 0.0075 * GlobalsGetValue( "viruses_half_cured" )

        EntityInflictDamage( owner, damage * 0.04, "NONE", "viral infection (weakened)", "NO_RAGDOLL_FILE", 0, 0, entity_id, x, y, 0)
    end
end
