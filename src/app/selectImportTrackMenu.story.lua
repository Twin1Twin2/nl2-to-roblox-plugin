
local RunService = game:GetService("RunService")

local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local selectImportTrackMenu = require(script.Parent.selectImportTrackMenu)

return function(frame: Frame): () -> ()
	local rootNode = plasma.new(frame)

	local heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime: number)
		plasma.start(rootNode, function()
			plasma.window("Select Track", function()
				selectImportTrackMenu(function(points, name)
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
		rootNode = nil -- remove node state
		heartbeatConnection:Disconnect()
	end
end