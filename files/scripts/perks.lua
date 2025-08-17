ctq_perks = {
	{
		id = "CTQ_TIME_TRIAL",
		ui_name = "Time Trial",
		ui_description = "The gods challenge you to a race.\nReach the next Holy Mountain within 60 seconds to be greatly rewarded.",
		ui_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_time_trial_016.png",
		perk_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_time_trial.png",
		stackable = STACKABLE_NO, -- doesn't work for now (smth with the effect's internal variable tracking)
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/cheytaq_first_mod/files/entities/misc/effect_runordie.xml" )
		end,
	},

	{
		id = "CTQ_RING_OF_LIFE",
		ui_name = "Ring Of Life",
		ui_description = "Teleport to safety upon reaching critical health.",
		ui_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_ringoflife_016.png",
		perk_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_ringoflife.png",
		stackable = STACKABLE_NO,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/cheytaq_first_mod/files/entities/misc/effect_ringoflife.xml" )
        end,
	},

--	{
--		id = "CTQ_STENDARI_ESSENCE",
--		ui_name = "Stendari Essence",
--		ui_description = "Fire heals you, but water damages you.",
--		ui_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_stendari_essence_016.png",
--		perk_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_stendari_essence.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = false,
--		usable_by_enemies = true,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/cheytaq_first_mod/files/entities/misc/effect_healing_fire.xml" )
--        end,
--	},

	{
		id = "CTQ_BOMBERMAN",
		ui_name = "Bomberman",
		ui_description = "You are infused with explosive power.\nDoes not work if you are immune to explosions.",
		ui_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_bomberman_016.png",
		perk_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_bomberman.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
--		remove_other_perks = { "PROTECTION_EXPLOSION" },
		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/cheytaq_first_mod/files/entities/misc/effect_bomberman.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_bomberman_boost",
			            } )
        end,
	},

	{
		id = "CTQ_THUNDERLORD",
		ui_name = "Thunderlord",
		ui_description = "You are infused with electric power.\nDoes not work if you are immune to electricity.",
		ui_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_thunderlord_016.png",
		perk_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_thunderlord.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
--		remove_other_perks = { "PROTECTION_ELECTRICITY" },
		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/cheytaq_first_mod/files/entities/misc/effect_energizer.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_thunderlord_boost",
			            } )
        end,
	},

	{
		id = "CTQ_PYRELORD",
		ui_name = "Pyrelord",
		ui_description = "You are infused with fiery power.\nDoes not work if you are immune to fire.",
		ui_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_pyrelord_016.png",
		perk_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_pyrelord.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
--		remove_other_perks = { "PROTECTION_ELECTRICITY" },
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/cheytaq_first_mod/files/entities/misc/effect_pyrelord.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_pyrelord_boost",
			            } )
        end,
	},

--	{
--		id = "CTQ_PANIC_MODE",
--		ui_name = "Panic Mode",
--		ui_description = "Upon taking heavy damage, gain a short burst of speed.",
--		ui_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_ringoflife_016.png",
--		perk_icon = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_ringoflife.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = true,
--		usable_by_enemies = false,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/cheytaq_first_mod/files/entities/misc/effect_ringoflife.xml" )
--        end,
--        _remove = function( entity_id )
--            -- do nothing
--		end,
--	},
}

function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

function AddSettingFlag(name)
    ModSettingSet(name, true)
  --  ModSettingSetNextValue(name, true)
end

function RemoveSettingFlag(name)
    ModSettingRemove(name)
end

if(perk_list ~= nil)then
	for k, v in pairs(ctq_perks)do
		table.insert(perk_list, v)
	end
end
