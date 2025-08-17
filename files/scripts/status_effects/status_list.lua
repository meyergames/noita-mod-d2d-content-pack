ctq_status_effects = 
{
    {
		id="VIRAL_INFECTION",
		ui_name="Virus",
		ui_description="Seek medical attention. NOW.",
		ui_icon="mods/cheytaq_first_mod/files/gfx/ui_gfx/status_indicators/borrowed_time_12px.png",
		protects_from_fire=false,
		effect_entity="mods/cheytaq_first_mod/files/entities/misc/effect_virus.xml",
        --effect_permanent=true,
    },

    {
		id="VIRAL_INFECTION_WEAK",
		ui_name="Traces of a virus",
		ui_description="Maybe medical attention wasn't quite enough.",
		ui_icon="mods/cheytaq_first_mod/files/gfx/ui_gfx/status_indicators/borrowed_time_12px.png",
		protects_from_fire=false,
		effect_entity="mods/cheytaq_first_mod/files/entities/misc/effect_virus_weak.xml",
        effect_permanent=true,
    },
}

if(status_effects ~= nil)then
	for k, v in pairs(ctq_status_effects)do
		table.insert(status_effects, v)
	end
end
