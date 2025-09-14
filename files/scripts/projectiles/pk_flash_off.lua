dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()

set_internal_int( get_player(), "pk_flash_id", -1 )