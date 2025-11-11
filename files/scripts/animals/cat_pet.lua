dofile_once( "data/scripts/lib/utilities.lua" )

EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "enabled_if_charmed", true )

local old_interacting = interacting
function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local x, y = EntityGetTransform( entity_interacted )
	local animate = true

	local trigger_player_heal = false
	
	edit_component( entity_interacted, "VelocityComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mVelocity", 0, 0 )
	end)

	edit_component( entity_interacted, "CharacterDataComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mVelocity", 0, 0 )
	end)
	
	edit_component( entity_who_interacted, "VelocityComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mVelocity", 0, 0 )
	end)

	edit_component( entity_who_interacted, "CharacterDataComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mVelocity", 0, 0 )
	end)
	
	SetRandomSeed( x + y + entity_interacted, y + GameGetFrameNum() )
	local rnd = Random( 1, 20 )
	
	if ( rnd <= 6 ) then
		EntitySetComponentsWithTagEnabled( entity_interacted, "enabled_if_charmed", false )

		GamePrint( "$ui_apotheosis_cat_pet_01" )
		GamePlaySound( "mods/Apotheosis/mocreeps_audio.bank", "mocreeps_audio/kittycat/voc_attack_purr_01", x, y )

		trigger_player_heal = true
	elseif ( rnd <= 12 ) then
		EntitySetComponentsWithTagEnabled( entity_interacted, "enabled_if_charmed", false )

		if Random(1,10) == 1 then
			GamePlaySound( "mods/Apotheosis/mocreeps_audio.bank", "mocreeps_audio/kittycat/snake_meow_01", x, y )
			GamePrint( "$ui_apotheosis_cat_pet_05" )
		else
			GamePlaySound( "mods/Apotheosis/mocreeps_audio.bank", "mocreeps_audio/kittycat/sora_meow_01", x, y )
			GamePrint( "$ui_apotheosis_cat_pet_02" )
		end

		trigger_player_heal = true
	elseif ( rnd <= 18 ) then
		EntitySetComponentsWithTagEnabled( entity_interacted, "enabled_if_charmed", false )
		
		GamePrint( "$ui_apotheosis_cat_pet_03" )
		animate = false
	else
		EntitySetComponentsWithTagEnabled( entity_interacted, "enabled_if_charmed", false )
		
		GamePrint( "$ui_apotheosis_cat_pet_04" )
		trigger_player_heal = true
	end

	if animate then
		GamePlayAnimation( entity_interacted, "pet", 42, "stand", 0 )
	end
	GameEntityPlaySound( entity_who_interacted, "pet" )

	local can_be_triggered_now = has_perk( "D2D_FELINE_AFFECTION" )
								 and get_internal_int( entity_interacted, "feline_affection_granted" ) == nil

	if trigger_player_heal and can_be_triggered_now then
		-- count towards spawning the Cat Radar perk
		raise_internal_int( entity_who_interacted, "cats_petted", 1 )
		cats_petted = get_internal_int( entity_who_interacted, "cats_petted" )
		-- if cats_petted == 10 then
			-- spawn_perk( "D2D_CAT_RADAR", x, y )
		if cats_petted == 10 then
			CreateItemActionEntity( "D2D_CATS_TO_DAMAGE", x, y )
		end

		-- try to heal the player, OR (if they are full health) count towards spawning the Summon Cat spell
		local p_dcomp = EntityGetFirstComponentIncludingDisabled( entity_who_interacted, "DamageModelComponent" )
		local p_hp = ComponentGetValue2( p_dcomp, "hp" )
		local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
		local is_health_missing = p_hp < p_max_hp
		if is_health_missing then
			LoadGameEffectEntityTo( entity_who_interacted, "mods/D2DContentPack/files/entities/misc/status_effects/effect_regeneration_short.xml" )
		end

		if cats_petted > 1 then
			GamePrint( "You have petted " .. cats_petted .. " cats" )
		else
			GamePrint( "You have petted " .. cats_petted .. " cat" )
		end

		-- "teleport" the cat away
		EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
		EntityKill( entity_interacted )
	end
end