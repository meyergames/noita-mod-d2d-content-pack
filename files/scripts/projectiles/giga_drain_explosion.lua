dofile_once("data/scripts/lib/utilities.lua")

--local entity_id    = GetUpdatedEntityID()
--local pos_x, pos_y = EntityGetTransform( entity_id )
--
--local how_many = 4
--local angle_inc = ( 2 * 3.14159 ) / how_many + math.rad(ProceduralRandomf( pos_x, pos_y, 30) - ProceduralRandomf( pos_x + 2.5532, pos_y + 59.8, 30))
--local theta = 0
--local length = 50
--
--for i=1,how_many do
--	local vel_x = math.cos( theta ) * length
--	local vel_y = math.sin( theta ) * length
--	theta = theta + angle_inc
--	
--	shoot_projectile( entity_id, "mods/D2DContentPack/files/entities/projectiles/deck/giga_drain_bubble.xml", pos_x, pos_y, vel_x, vel_y )
--end

local entity_id    = GetUpdatedEntityID()
local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if ( comp ~= nil ) then
	owner_id = ComponentGetValue2( comp, "mWhoShot" )
end

if ( owner_id ~= nil ) and ( owner_id ~= NULL_ENTITY ) and EntityGetIsAlive( owner_id ) then
    local damagemodel = EntityGetFirstComponentIncludingDisabled( owner_id, "DamageModelComponent")
    local hp = ComponentGetValue2( damagemodel, "hp" )
    local max_hp = ComponentGetValue2( damagemodel, "max_hp" )

    ComponentSetValue( damagemodel, "hp", math.min(hp + 0.04, max_hp) )
    GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
end
