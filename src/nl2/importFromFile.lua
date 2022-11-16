
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

		local name = file.Name:match("(.+)%..+$") -- taken from stack overflow. thx

		return Result.ok({
			name = name,
			points = pointsResult:unwrap(),
		})
	end)		
end