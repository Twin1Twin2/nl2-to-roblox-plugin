
local StudioService = game:GetService("StudioService")

local import = require(script.Parent.import)

local modules = script.Parent.Parent.modules
local Result = require(modules.Result)
local Promise = require(modules.Promise)

return function()
	return Promise.try(function()
		return StudioService:PromptImportFile({"csv"})
	end):andThen(function(file)
		if file == nil then
			return Result.err("Unable to load file")
		end

		local source = file:GetBinaryContents()

		local pointsResult = import(source)
		if pointsResult:isErr() then
			return pointsResult
		end

		return Result.ok({
			name = file.Name,
			points = pointsResult:unwrap(),
		})
	end)		
end