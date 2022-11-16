
local Selection = game:GetService("Selection")

local root = script.Parent.Parent

local modules = root.modules
local Result = require(modules.Result)

local pointsUtil = require(root.pointsUtil)

return function()
	local selection = Selection:Get()[1]

	if selection == nil then
		return Result.err("Nothing selected!")
	end

	local pointsResult = pointsUtil.getCFramePointsFromInstance(selection)
	if pointsResult:isErr() then
		return pointsResult
	end

	return Result.ok({
		name = selection.Name,
		points = pointsResult:unwrap(),
	})
end
