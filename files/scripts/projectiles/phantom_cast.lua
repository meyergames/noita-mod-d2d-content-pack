-- thanks Goki
local e = GetUpdatedEntityID()
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if not projectile then return end

local shooter = ComponentGetValue2( projectile, "mWhoShot" ) or 0
if not shooter or shooter == 0 then return end

local control = EntityGetFirstComponent( shooter,"ControlsComponent" )
if not control then return end
local tx, ty = ComponentGetValue2( control, "mMousePosition" )

EntityApplyTransform( e, tx, ty )
GamePlaySound( "data/audio/Desktop/player.bank", "player_projectiles/megalaser/launch", tx, ty )
