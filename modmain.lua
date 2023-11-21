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
			local num_fulllights = #inst.components.container:FindItems(function(item) return item:HasTag("fulllighter") end)
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
			local num_fulllights = #inst.components.container:FindItems(function(item) return item:HasTag("fulllighter") end)
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


local function PhaseChanged(inst)
	-- 白天 -> 关灯
	if GLOBAL.TheWorld.state.phase == "day" then
		inst.Light:Enable(false)
		
		inst.AnimState:ClearBloomEffectHandle()
        inst.AnimState:SetMultColour(.7, .7, .7, 1)
		
        if POPULATING then
            inst.AnimState:PlayAnimation("idle")
        elseif was_on then
            inst.AnimState:PlayAnimation("turn_off")
            inst.AnimState:PushAnimation("idle", false)
            --inst.SoundEmitter:PlaySound(sound.toggle)
        end

		--GLOBAL.TheNet:SystemMessage("关灯", false)
	end
	
	-- 晚上 -> 开灯
	if GLOBAL.TheWorld.state.phase == "night" then
		inst.Light:Enable(true)
		inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

		if POPULATING then
            inst.AnimState:PlayAnimation("idle_on")
        elseif not was_on or inst.onlywhite then
            inst.AnimState:PlayAnimation("turn_on")
            inst.AnimState:PushAnimation("idle_on", false)
            --inst.SoundEmitter:PlaySound(sound.toggle)
        else
            inst.AnimState:PlayAnimation("colour_change")
            inst.AnimState:PushAnimation("idle_on", false)
            --inst.SoundEmitter:PlaySound(sound.toggle)
            --QueueSound(inst, 13 * FRAMES, sound.colour)
        end
		--GLOBAL.TheNet:SystemMessage("开灯", false)
	end
end

local function Auto(inst, phase)
	inst:WatchWorldState("phase", PhaseChanged)
end

if range > 0 then
	AddPrefabPostInit("mushroom_light", UpdatingLightRange)
	AddPrefabPostInit("mushroom_light2", UpdatingLightRange)
end

	AddPrefabPostInit("mushroom_light", Auto)
	AddPrefabPostInit("mushroom_light2", Auto)