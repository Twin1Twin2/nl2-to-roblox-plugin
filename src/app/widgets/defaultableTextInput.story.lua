
local RunService = game:GetService("RunService")

local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local container = require(script.Parent.container)
local defaultableTextInput = require(script.Parent.defaultableTextInput)

return function(frame: Frame): () -> ()
	local rootNode = plasma.new(frame)

	local heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime: number)
		plasma.start(rootNode, function()
			local currentInput, setCurrentInput = plasma.useState("Enter Text Here")

			container(function()
				local widget = defaultableTextInput(currentInput)

				widget:focusLost(function(input: string)
					setCurrentInput(input)
				end)

				if widget:resetClicked() then
					setCurrentInput("Enter Text Here")
				end
			end)
		end)
	end)

	return function()
		rootNode = nil -- remove node state
		heartbeatConnection:Disconnect()
	end
end