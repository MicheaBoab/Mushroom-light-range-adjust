local range = GLOBAL.tonumber(GetModConfigData("mushroom_light_range_config"));
local switch = GetModConfigData("auto_on_off");

--GLOBAL.CHEATS_ENABLED = trueGLOBAL.require('debugkeys')

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

local function is_battery_type(item)
    return item:HasTag("lightbattery")
        or item:HasTag("spore")
        or item:HasTag("lightcontainer")
end

local function UpdatingLight(inst)
	-- 找主机
    if not GLOBAL.TheWorld.ismastersim then
        return inst
	end
	inst:ListenForEvent("itemget", function(inst) 
		local num_batteries = #inst.components.container:FindItems(is_battery_type)
		if num_batteries > 0 then
			if not GLOBAL.TheWorld.state.isnight then	
				--GLOBAL.TheNet:SystemMessage("night", false)
				
				inst.Light:Enable(false)
				inst.AnimState:ClearBloomEffectHandle()
				inst.AnimState:SetMultColour(.7, .7, .7, 1)
				inst.AnimState:PlayAnimation("turn_off")
				inst.AnimState:PushAnimation("idle", false)
				
				if POPULATING then
					GLOBAL.TheNet:SystemMessage("2")
					inst.AnimState:PlayAnimation("idle")
				elseif was_on then
					GLOBAL.TheNet:SystemMessage("3")
					inst.AnimState:PlayAnimation("turn_off")
					inst.AnimState:PushAnimation("idle", false)
				end
			end
			
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
		local num_batteries = #inst.components.container:FindItems(is_battery_type)
		if num_batteries > 0 then
			if not GLOBAL.TheWorld.state.isnight then	
				--GLOBAL.TheNet:SystemMessage("night", false)
				
				inst.Light:Enable(false)
				inst.AnimState:ClearBloomEffectHandle()
				inst.AnimState:SetMultColour(.7, .7, .7, 1)
				inst.AnimState:PlayAnimation("turn_off")
				inst.AnimState:PushAnimation("idle", false)
				
				if POPULATING then
					GLOBAL.TheNet:SystemMessage("2")
					inst.AnimState:PlayAnimation("idle")
				elseif was_on then
					GLOBAL.TheNet:SystemMessage("3")
					inst.AnimState:PlayAnimation("turn_off")
					inst.AnimState:PushAnimation("idle", false)
				end
			end
			
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
	if switch then 
	-- 白天 -> 关灯
		if GLOBAL.TheWorld.state.phase == "day" then
			inst:DoTaskInTime(5, function()
				if inst.components.container then
					local num_batteries = #inst.components.container:FindItems(is_battery_type)
					--GLOBAL.TheNet:SystemMessage(num_batteries, false)
					
					if num_batteries > 0 then
						inst.Light:Enable(false)
						inst.AnimState:ClearBloomEffectHandle()
						inst.AnimState:SetMultColour(.7, .7, .7, 1)
						inst.AnimState:PlayAnimation("turn_off")
						inst.AnimState:PushAnimation("idle", false)
						
						if POPULATING then
							GLOBAL.TheNet:SystemMessage("2")
							inst.AnimState:PlayAnimation("idle")
						elseif was_on then
							GLOBAL.TheNet:SystemMessage("3")
							inst.AnimState:PlayAnimation("turn_off")
							inst.AnimState:PushAnimation("idle", false)
						end
					end
				end
			end)
		end
		
		-- 晚上 -> 开灯
		if GLOBAL.TheWorld.state.phase == "night" then
			-- 如果包里有东西
			if inst.components.container then
				local num_batteries = #inst.components.container:FindItems(is_battery_type)
				--GLOBAL.TheNet:SystemMessage(num_batteries, false)
				
				if num_batteries > 0 then
					inst.Light:Enable(true)
					inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
					
					if POPULATING then
						inst.AnimState:PlayAnimation("idle_on")
					elseif not was_on or inst.onlywhite then
						inst.AnimState:PlayAnimation("turn_on")
						inst.AnimState:PushAnimation("idle_on", false)
					else
						inst.AnimState:PlayAnimation("colour_change")
						inst.AnimState:PushAnimation("idle_on", false)
					end
				end
			end		
		end
	end
end

local function Auto(inst, phase)
	inst:WatchWorldState("phase", PhaseChanged)
end

if range > 0 then
	AddPrefabPostInit("mushroom_light", UpdatingLight)
	AddPrefabPostInit("mushroom_light2", UpdatingLight)
end

	AddPrefabPostInit("mushroom_light", Auto)
	AddPrefabPostInit("mushroom_light2", Auto)