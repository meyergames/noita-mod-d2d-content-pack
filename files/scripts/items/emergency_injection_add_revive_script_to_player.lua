dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, name )
    EntityAddComponent2( entity_who_picked, "LuaComponent", {
      script_damage_received="mods/D2DContentPack/files/scripts/items/emergency_injection_try_revive.lua",
      execute_every_n_frame=-1,
    })
end
