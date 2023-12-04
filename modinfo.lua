-- This information tells other players more about the mod
name = "Mushroom Light range adjustment"
description = "Change the range of the mushroom light"
author = "MicheaBoab"
version = "3.0"

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
			{description = "X2.0", data = 2.0, hover = "X2.0"},
			{description = "X3.0", data = 3.0, hover = "X3.0"},
			{description = "X4.0", data = 4.0, hover = "X4.0"},
			{description = "X5.0", data = 5.0, hover = "X5.0"},
		},
		default = 1.0,
	},
	{
		name = "auto_on_off",
		label = "自动开关",
		hover = "Mushroom Light auto switch config",
		options =	{
			{description = "关 (Off)", data = 0, hover = "Default"},
			{description = "开 (On)", data = 1, hover = "On"},
		},
		default = 0,
	},
}