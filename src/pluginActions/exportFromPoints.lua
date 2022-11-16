
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local nl2 = script.Parent.Parent.nl2
local export = require(nl2.export)

return function(points, scale, name)
	local exportInstance = export(points, scale)
	exportInstance.Name = name .. "_Export"
	exportInstance.Parent = workspace

	Selection:Set({exportInstance})
	ChangeHistoryService:SetWaypoint("ExportTrack")
end