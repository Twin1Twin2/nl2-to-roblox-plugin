
local RunService = game:GetService("RunService")

local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local textInput = require(script.Parent.textInput)

return function(frame: Frame): () -> ()
	local rootNode = plasma.new(frame)

	local heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime: number)
		plasma.start(rootNode, function()
			local currentInput, setCurrentInput = plasma.useState("Enter Text Here")

			plasma.window("TextInput", function()
				textInput(currentInput):enterPressed(function(input: string)
					setCurrentInput(input)
				end)
			end)
		end)
	end)

	return function()
		rootNode = nil -- remove node state
		heartbeatConnection:Disconnect()
	end
end