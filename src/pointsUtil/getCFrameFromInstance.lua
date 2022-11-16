
local root = script.Parent.Parent
local modules = root.modules
local Result = require(modules.Result)

--- Converts an Instance to a CFrame
---
--- #### Valid Instances:
--- Instance | Conversion Method
--- --- | ---
--- CFrameValue | Uses .Value
--- Vector3Value | Converts .Value to a CFrame
--- BasePart | Use .CFrame
--- Attachment | Uses .WorldCFrame
--- Model | Uses :GetPivot()
---
--- An Instance can also be linked from an ObjectValue, but the depth is limited to 1
---
--- @function getCFrameFromInstance
--- @within Util
--- @param instance Instance
--- @return Result<CFrame, string>
return function(instance: Instance): Result.Result
	if typeof(instance) ~= "Instance" then
		return Result.err("value is not an Instance!")
	end

	if instance:IsA("ObjectValue") then
		if instance.Value == nil then
			return Result.err(("ObjectValue.Value is nil!"):format(instance:GetFullName()))
		end

		instance = instance.Value
	end

	if instance:IsA("CFrameValue") then
		return Result.ok(instance.Value)
	elseif instance:IsA("Vector3Value") then
		return Result.ok(CFrame.new(instance.Value))
	elseif instance:IsA("BasePart") then
		return Result.ok(instance.CFrame)
	elseif instance:IsA("Attachment") then
		return Result.ok(instance.WorldCFrame)
	elseif instance:IsA("Model") then
		return Result.ok(instance:GetPivot())
	end

	return Result.err(("cannot get CFrame from Instance %s!"):format(instance.ClassName))
end
