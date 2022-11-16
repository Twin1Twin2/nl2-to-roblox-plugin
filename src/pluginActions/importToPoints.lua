
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local nl2 = script.Parent.Parent.nl2
local pointsToModel = require(nl2.pointsToModel)

return function(points: {CFrame}, scale: number, distance: number, name: string)
	local model = pointsToModel(points, scale, distance)
	model.Name = name .. "_Import"
	model.Parent = workspace

	Selection:Set({model})
	ChangeHistoryService:SetWaypoint("ImportTrack")
end