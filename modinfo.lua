-- This information tells other players more about the mod
name = "Mushroom Light range adjustment"
description = "Change the range of the mushroom light"
author = "MicheaBoab"
version = "2.0"

-- This lets other players know if your mod is out of date, update it to match the current version in the game

api_version = 10

dst_compatible = true

-- Can specify a custom icon for this mod!
icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = false

client_only_mod = false

server_filter_tags = {}

configuration_options = 
{
	--蘑菇灯
	{
		name = "",
		label = "蘑菇灯 󰀏",
		hover = "",
		default = 0,
		options = {
			{description = "", data = 0},
		},
	},
	{
		name = "mushroom_light_range_config",
		label = "亮度范围",
		hover = "Mushroom Light range config",
		options =	{
			{description = "X1.0", data = 1.0, hover = "Default"},
			{description = "X1.5", data = 1.5, hover = "X1.5"},
			{description = "X2.0", data = 2.0, hover = "X2.0"},
			{description = "X2.5", data = 2.5, hover = "X2.5"},
		},
		default = 1.0,
	},
}