
local import = require(script.Parent.import)

local modules = script.Parent.Parent.modules
local Result = require(modules.Result)

return function(script: Script)
	local source = script.Source

	local pointsResult = import(source)
	if pointsResult:isErr() then
		return pointsResult
	end

	return Result.ok({
		name = script.Name,
		points = pointsResult:unwrap(),
	})
end
