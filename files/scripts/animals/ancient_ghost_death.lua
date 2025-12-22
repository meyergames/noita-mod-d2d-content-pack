if not HasFlagPersistent( "d2d_spell_unlocked_projectile_morph" ) then
	GamePrintImportant( "Secrets of morphing have been unlocked to you" )
end

AddFlagPersistent( "d2d_spell_unlocked_projectile_morph" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
dofile_once( "mods/D2DContentPack/files/scripts/actions.lua" )
-- CreateItemActionEntity( "D2D_PROJECTILE_MORPH", x, y )

-- local nearby_wands = EntityGetInRadiusWithTag( x, y, 10, "wand" )
-- if nearby_wands and #nearby_wands > 0 then
-- 	for i,nearby_wand in ipairs( nearby_wands ) do
-- 		local owner = EntityGetParent( nearby_wand )
-- 		if not owner or owner == 0 then
-- 			EntityKill( nearby_wand )
-- 		end
-- 	end
-- end

-- make sure the staff becomes visible
-- local children = EntityGetAllChildren( proj_source )
-- for k=1,#children do
-- 	child = children[k]
-- 	-- show all wands
--     if EntityGetName( child ) == "inventory_quick" then
--         local inventory_items = EntityGetAllChildren( child )
--         if( inventory_items ~= nil ) then
--             for z=1, #inventory_items do

--             	-- for the ghost: SHOW the staff
--             	item = inventory_items[z]

--             	if item then
--             		local sprite_comps = EntityGetComponent( item, "SpriteComponent" )
--             		if sprite_comps and #sprite_comps > 0 then
-- 		            	for i,item_sprite_comp in ipairs( sprite_comps ) do
-- 							ComponentSetValue2( item_sprite_comp, "visible", true )
-- 		            	end
-- 		            end
-- 	            end

-- 	            -- for the lurker: DESTROY the staff
-- 	            EntityKill( item )
--             end
--         end
--     end
-- end

dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
spawn_ancient_staff( x, y )