
-- add spells to existing materials:
add_spells_to_effect( "magic_liquid_movement_faster", { "D2D_FLURRY", "D2D_RAMP_UP", "D2D_RAPIDFIRE_SALVO", "D2D_SPRAY_AND_PRAY" } )
add_spells_to_effect( "magic_liquid_faster_levitation", { "D2D_FIXED_ALTITUDE" } )
add_spells_to_effect( "gunpowder_unstable", { "D2D_QUICK_BURNER", "D2D_OVERCLOCK", "D2D_CHAOTIC_FACTOR", "D2D_UNSTABLE_NUCLEUS", "D2D_BANANA_BOMB_SUPER", "D2D_BANANA_BOMB_GIGA" } )
add_spells_to_effect( "magic_liquid_berserk", { "D2D_QUICK_BURNER", "D2D_BANANA_BOMB_SUPER", "D2D_BANANA_BOMB_GIGA" } )
add_spells_to_effect( "material_confusion", { "D2D_CHAOTIC_FACTOR" } )
add_spells_to_effect( "magic_liquid_teleportation", { "D2D_REWIND", "D2D_REWIND_ALT_FIRE", "D2D_BLINK" } )
add_spells_to_effect( "milk", { "D2D_SUMMON_CAT" } )
add_spells_to_effect( "magic_liquid_invisibility", { "D2D_SMOKE_BOMB", "D2D_SMOKE_BOMB_ALT_FIRE" } )
add_spells_to_effect( "cement", { "D2D_CONCRETE_WALL", "D2D_CONCRETE_WALL_ALT_FIRE" } )

-- add emergency injection effects:
append_effect("magic_liquid_infected_healthium", function(wand)

  -- while the wand is held, the player gains the following effect:
  -- > if their max HP is >25%, they take 1% max HP damage per second
  -- > if their max HP is <25%, they are healed for 1% max HP per second
  -- (i.e. health is gradually adjusted to 20%)
  local comp = EntityAddComponent( wand.entity_id, "LuaComponent", {
    _tags="enabled_in_hand",
    script_source_file="mods/D2DContentPack/files/scripts/aod/wand_effect_emergency_injection.lua",
    execute_every_n_frame="60",
    execute_on_added="0",
  } )
end )
add_spells_to_effect( "magic_liquid_infected_healthium", { "D2D_GIGA_DRAIN", "D2D_BOLT_CATCHER", "D2D_BOLT_CATCHER_ALT_FIRE", "HEAL_BULLET", "REGENERATION_FIELD", "ANTIHEAL" } )