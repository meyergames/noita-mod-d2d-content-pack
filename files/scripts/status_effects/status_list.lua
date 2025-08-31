d2d_status_effects = 
{
    {
		id="VIRAL_INFECTION",
		ui_name="Viral Infection",
		ui_description="Seek medical attention. NOW.",
		ui_icon="mods/RiskRewardBundle/files/gfx/ui_gfx/status_effects/viral_infection_012.png",
		protects_from_fire=false,
		effect_entity="mods/RiskRewardBundle/files/entities/misc/status_effects/effect_virus.xml",
        -- effect_permanent=true,
    },

    {
		id="VIRAL_INFECTION_WEAK",
		ui_name="Borrowed Time",
		ui_description="Maybe medical attention wasn't quite enough.",
		ui_icon="mods/RiskRewardBundle/files/gfx/ui_gfx/status_effects/borrowed_time_012.png",
		protects_from_fire=false,
		effect_entity="mods/RiskRewardBundle/files/entities/misc/status_effects/effect_virus_weak.xml",
        effect_permanent=true,
    },
}

if(status_effects ~= nil)then
	for k, v in pairs(d2d_status_effects)do
		table.insert(status_effects, v)
	end
end
