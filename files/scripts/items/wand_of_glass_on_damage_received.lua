dofile_once( "data/scripts/lib/utilities.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	local wand = EZWand.GetHeldWand()
	local is_glass = get_internal_int( wand.entity_id, "is_glass" ) == 1

	local responsible_entity_tags = EntityGetTags( entity_thats_responsible )
	local responsible_entity_is_mortal = responsible_entity_tags and string.find( responsible_entity_tags, "mortal" )

	if is_glass and ( responsible_entity_is_mortal or projectile_thats_responsible ~= 0 ) and damage > 0 then
		-- play breaking sound
		local x, y = EntityGetTransform( GetUpdatedEntityID() )
		GamePrintImportant( "The Staff of Glass shattered")
		GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/damage", x, y )

		-- drop all spells
        local mx, my = DEBUG_GetMouseWorld()
        local spells, attached_spells = wand:GetSpells()
        for i,spell in ipairs( spells ) do
        	-- CreateItemActionEntity( spell.id, x, y )
	        local px, py = EntityGetFirstHitboxCenter( get_player() )
	        local spell_card_id = CreateItemActionEntity( spell.action_id, px, py )
	        local vel_comp = EntityGetFirstComponentIncludingDisabled( spell_card_id, "VelocityComponent" )
	        if vel_comp then
				local dx, dy = mx - px, my - py
				local dist = math.sqrt( dx * dx + dy * dy )
				dist = math.min( dist, 100 )
				dist = dist + Random( 5, 10 )
				local dir = math.atan2( dy, dx )
				dir = dir + Randomf( math.rad( -20 ), math.rad( 20 ) )
				local vx, vy = math.cos( dir ) * dist, math.sin( dir ) * dist
				ComponentSetValue2( vel_comp, "mVelocity", vx, vy )
				EntitySetComponentsWithTagEnabled( spell_card_id, "enabled_in_world", true )
				EntitySetComponentsWithTagEnabled( spell_card_id, "enabled_in_inventory", false )
				EntitySetComponentsWithTagEnabled( spell_card_id, "item_unidentified", false )
        	end
        end

        -- delete wand
        wand:PlaceAt( x, y )
        EntityKill( wand.entity_id )
	end
end