dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

if get_internal_bool( get_player(), "d2d_torch_electric_modifier_added" ) then return end

EntityAddComponent( get_player(), "ShotEffectComponent", 
{
    extra_modifier = "d2d_torch_electric",
} )

set_internal_bool( get_player(), "d2d_torch_electric_modifier_added", true )