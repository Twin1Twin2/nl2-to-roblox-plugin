
local Selection = game:GetService("Selection")

local importFromScript = require(script.Parent.importFromScript)

local modules = script.Parent.Parent.modules
local Result = require(modules.Result)

return function()
	local selection = Selection:Get()[1]

	if selection == nil then
		return Result.err("Nothing selected!")
	end

	if not (selection:IsA("ModuleScript") or selection:IsA("Script") or selection:IsA("LocalScript")) then
		return Result.err("Did not select a script!")
	end

	return importFromScript(selection)
end
