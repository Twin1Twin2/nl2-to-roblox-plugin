
local RunService = game:GetService("RunService")

local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local widgets = script.Parent.widgets
local scrollingFrame = require(widgets.scrollingFrame)

local exportMenu = require(script.Parent.exportMenu)

return function(frame: Frame): () -> ()
	local rootNode = plasma.new(frame)

	local heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime: number)
		plasma.start(rootNode, function()
			scrollingFrame(function()
				exportMenu()
			end)
		end)
	end)

	return function()
		rootNode = nil -- remove node state
		heartbeatConnection:Disconnect()
	end
end