local range = GLOBAL.tonumber(GetModConfigData("mushroom_light_range_config"));

local light_str =
{
    {radius = 2.5 * range, falloff = .85, intensity = 0.75},
    {radius = 3.25 * range, falloff = .85, intensity = 0.75},
    {radius = 4.25 * range, falloff = .85, intensity = 0.75},
    {radius = 5.5 * range, falloff = .85, intensity = 0.75},
}

local fulllight_light_str =
{
    radius = 5.5 * range, falloff = 0.85, intensity = 0.75
}


local function UpdatingLightRange(inst)
	-- 找主机
    if not GLOBAL.TheWorld.ismastersim then
        return inst
	end
	inst:ListenForEvent("itemget", function(inst) 
		local num_batteries = #inst.components.container:FindItems(function(item) return item:HasTag("lightbattery") or item:HasTag("spore") or item:HasTag("lightcontainer") end)
		if num_batteries > 0 then
			local num_fulllights = #inst.components.container:FindItems(function(item) return item:HasTag("lightbattery") or item:HasTag("spore") or item:HasTag("lightcontainer") end)
			if num_fulllights > 0 then
				inst.Light:SetRadius(fulllight_light_str.radius)
				inst.Light:SetFalloff(fulllight_light_str.falloff)
				inst.Light:SetIntensity(fulllight_light_str.intensity)
			else
				inst.Light:SetRadius(light_str[num_batteries].radius)
				inst.Light:SetFalloff(light_str[num_batteries].falloff)
				inst.Light:SetIntensity(light_str[num_batteries].intensity)
			end
		end
	end)
	
	inst:ListenForEvent("itemlose", function(inst)
		local num_batteries = #inst.components.container:FindItems(function(item) return item:HasTag("lightbattery") or item:HasTag("spore") or item:HasTag("lightcontainer") end)
		if num_batteries > 0 then
			local num_fulllights = #inst.components.container:FindItems(function(item) return item:HasTag("lightbattery") or item:HasTag("spore") or item:HasTag("lightcontainer") end)
			if num_fulllights > 0 then
				inst.Light:SetRadius(fulllight_light_str.radius)
				inst.Light:SetFalloff(fulllight_light_str.falloff)
				inst.Light:SetIntensity(fulllight_light_str.intensity)
			else
				inst.Light:SetRadius(light_str[num_batteries].radius)
				inst.Light:SetFalloff(light_str[num_batteries].falloff)
				inst.Light:SetIntensity(light_str[num_batteries].intensity)
			end
		end
	end)
end

if range > 0 then
	AddPrefabPostInit("mushroom_light", UpdatingLightRange)
	AddPrefabPostInit("mushroom_light2", UpdatingLightRange)
end