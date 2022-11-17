
local RunService = game:GetService("RunService")

local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local widgets = script.Parent.widgets
local scrollingFrame = require(widgets.scrollingFrame)

local selectExportTrackMenu = require(script.Parent.selectExportTrackMenu)

return function(frame: Frame): () -> ()
	local rootNode = plasma.new(frame)

	local heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime: number)
		plasma.start(rootNode, function()
			scrollingFrame(function()
				selectExportTrackMenu(function(points, name)
					if name then
						print("Closing menu with track: " .. name .. "; NumPoints = " .. tostring(#points))
					else
						print("Closing menu!")
					end
				end)
			end)
		end)
	end)

	return function()
		heartbeatConnection:Disconnect()

		plasma.start(rootNode, function() end)
		rootNode = nil -- remove node state
	end
end