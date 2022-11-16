
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local widgets = script.Parent.widgets
local textInput = require(widgets.textInput)

local nl2 = script.Parent.Parent.nl2
local export = require(nl2.export)

local selectExportTrackMenu = require(script.Parent.selectExportTrackMenu)

local DEFAULT_SCALE = 0.25

local importMenu = plasma.widget(function(props)
	local openSelectTrackMenu = props.openSelectTrackMenu

	plasma.label("Current Track:")

	local selectedTrackName = props.selectedTrackName or "[NONE]"

	if plasma.button(selectedTrackName):clicked() then
		openSelectTrackMenu()
	end

	plasma.space()

	local scale, setScale = plasma.useState(DEFAULT_SCALE)

	-- import settings:
	-- scale
	plasma.label("Scale:")
	textInput(tostring(scale)):enterPressed(function(input: string)
		local newScale = tonumber(input)
		if newScale == nil then
			return
		end

		if newScale <= 0 then
			return
		end

		setScale(newScale)
	end)

	plasma.space()

	-- import track button
	if plasma.button("Export"):clicked() then
		if props.selectedTrackPoints ~= nil then
			local exportInstance = export(props.selectedTrackPoints, scale)
			exportInstance.Name = props.selectedTrackName .. "_Export"
			exportInstance.Parent = workspace

			Selection:Set({exportInstance})
			ChangeHistoryService:SetWaypoint("ExportTrack")
		end
	end

	return {

	}
end)

return plasma.widget(function()
	-- selected track
	local selectedTrackPoints, setSelectedTrackPoints = plasma.useState(nil)
	local selectedTrackName, setSelectedTrackName = plasma.useState(nil)

	local isSelectingTrack, setIsSelectingTrack = plasma.useState(false)

	if isSelectingTrack == true then
		selectExportTrackMenu(function(points, name)
			if points ~= nil then
				setSelectedTrackPoints(points)
				setSelectedTrackName(name)
			end

			setIsSelectingTrack(false)
		end)
	else
		importMenu({
			selectedTrackPoints = selectedTrackPoints,
			selectedTrackName = selectedTrackName,
			openSelectTrackMenu = function()
				setIsSelectingTrack(true)
			end
		})
	end
end)