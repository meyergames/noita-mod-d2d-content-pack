ctq_perks = {
	{
		id = "CTQ_TIME_TRIAL",
		ui_name = "$perk_riskreward_time_trial",
		ui_description = "$perk_riskreward_time_trial_description",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_time_trial_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_time_trial.png",
		stackable = STACKABLE_NO, -- doesn't work for now (smth with the effect's internal variable tracking)
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_time_trial.xml" )
		end,
	},

	{
		id = "CTQ_RING_OF_LIFE",
		ui_name = "$perk_riskreward_ring_of_life",
		ui_description = "$perk_riskreward_ring_of_life_description",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ringoflife_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ringoflife.png",
		stackable = STACKABLE_NO,
		one_off_effect = true,
		usable_by_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_ringoflife.xml" )
        end,
	},

--	{
--		id = "CTQ_STENDARI_ESSENCE",
--		ui_name = "Stendari Essence",
--		ui_description = "Fire heals you, but water damages you.",
--		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_stendari_essence_016.png",
--		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_stendari_essence.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = false,
--		usable_by_enemies = true,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_healing_fire.xml" )
--        end,
--	},

	{
		id = "CTQ_BOMBERMAN",
		ui_name = "$perk_riskreward_bomberman",
		ui_description = "$perk_riskreward_bomberman_description",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_bomberman_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_bomberman.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
--		remove_other_perks = { "PROTECTION_EXPLOSION" },
		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_bomberman.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_bomberman_boost",
			            } )
        end,
	},

	{
		id = "CTQ_THUNDERLORD",
		ui_name = "$perk_riskreward_thunderlord",
		ui_description = "$perk_riskreward_thunderlord_description",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_thunderlord_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_thunderlord.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
--		remove_other_perks = { "PROTECTION_ELECTRICITY" },
		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_energizer.xml" )
            EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			            { 
				            extra_modifier = "ctq_thunderlord_boost",
			            } )
        end,
	},

	{
		id = "CTQ_PYRELORD",
		ui_name = "$perk_riskreward_pyrelord",
		ui_description = "$perk_riskreward_pyrelord_description",
		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_pyrelord_016.png",
		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_pyrelord.png",
		stackable = STACKABLE_YES,
		one_off_effect = false,
		usable_by_enemies = true,
--		remove_other_perks = { "PROTECTION_ELECTRICITY" },
		func = function( entity_perk_item, entity_who_picked, item_name )
            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_pyrelord.xml" )
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
--		ui_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ringoflife_016.png",
--		perk_icon = "mods/RiskRewardBundle/files/gfx/ui_gfx/perk_ringoflife.png",
--		stackable = STACKABLE_NO,
--		one_off_effect = true,
--		usable_by_enemies = false,
--		func = function( entity_perk_item, entity_who_picked, item_name )
--            LoadGameEffectEntityTo( entity_who_picked, "mods/RiskRewardBundle/files/entities/misc/effect_ringoflife.xml" )
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

-- for _, perk in ipairs(perk_list) do
--     perk.display_name = GameTextGetTranslatedOrNot(perk.ui_name)
--     perk.display_description = GameTextGetTranslatedOrNot(perk.ui_description)
-- end