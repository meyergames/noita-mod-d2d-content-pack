dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local wand = EZWand.GetHeldWand()

local max_charges = wand.manaMax
local source_wand_id = wand.entity_id
set_internal_int( entity_id, "max_charges", max_charges )
set_internal_int( get_player(), "pk_flash_id", entity_id )
set_internal_int( entity_id, "source_wand_id", source_wand_id )