dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local parent_id = EntityGetParent( GetUpdatedEntityID() )

-- if the Unstable Nucleus is somehow removed from the Wand of Destruction, it explodes violently
if not EntityHasTag( parent_id, "d2d_wand_of_destruction" ) then
	local unstable_nucleus_card = GetUpdatedEntityID()

	-- destroy the card
	local x, y = EntityGetTransform( unstable_nucleus_card )
	EntityKill( unstable_nucleus_card )

	-- if the wand of destruction is nearby, spawn a nuke that instantly explodes
	-- (scan to prevent it from exploding if it accidentally spawns anywhere due to other mods)
	local nearby_wands = EntityGetInRadiusWithTag( x, y, 500, "d2d_wand_of_destruction" )
	if exists( nearby_wands ) and #nearby_wands > 0 then
		local nuke = EntityLoad( "data/entities/projectiles/deck/nuke_giga.xml", x, y )
		local proj_comp = EntityGetFirstComponentIncludingDisabled( nuke, "ProjectileComponent" )
		ComponentSetValue2( proj_comp, "lifetime", 1 )

		-- destroy the wand of destruction, too
		EntityKill( nearby_wands[1] )
	end
end
