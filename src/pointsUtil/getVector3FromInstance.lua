

local root = script.Parent.Parent
local modules = root.modules
local Result = require(modules.Result)

--- Converts an Instance to a Vector3
---
--- #### Valid Instances:
--- Instance | Conversion Method
--- --- | ---
--- Vector3Value | Uses .Value
--- CFrameValue | Uses .Value.Position
--- BasePart | Use .Position
--- Attachment | Uses .WorldPosition
--- PVInstance | Uses :GetPivot()
---
--- An Instance can also be linked from an ObjectValue, but the depth is limited to 1
---
--- @function getVector3FromInstance
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

	if instance:IsA("Vector3Value") then
		return Result.ok(instance.Value)
	elseif instance:IsA("CFrameValue") then
		return Result.ok(instance.Value.Position)
	elseif instance:IsA("PVInstance") then
		return Result.ok(instance:GetPivot().CFrame)
	elseif instance:IsA("Attachment") then
		return Result.ok(instance.WorldPosition)
	end

	return Result.err("invalid Instance! ClassName = %s; Path = %s"):format(instance.ClassName, instance:GetFullName())
end