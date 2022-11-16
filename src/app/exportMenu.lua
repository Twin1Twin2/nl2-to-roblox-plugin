
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local widgets = script.Parent.widgets
local defaultableTextInput = require(widgets.defaultableTextInput)
local selectedText = require(widgets.selectedText)
local button = require(widgets.button)
local buttonRow = require(widgets.buttonRow)

local nl2 = script.Parent.Parent.nl2
local export = require(nl2.export)

local selectExportTrackMenu = require(script.Parent.selectExportTrackMenu)

local DEFAULT_SCALE = 0.25

local importMenu = plasma.widget(function(props)
	local openSelectTrackMenu = props.openSelectTrackMenu

	plasma.label("Current Track:")

	local selectedTrackName = props.selectedTrackName or "[NONE]"
	selectedText(selectedTrackName)

	buttonRow(function()
		if button("Set Track"):clicked() then
			openSelectTrackMenu()
		end
	end)

	plasma.space()

	local scale, setScale = plasma.useState(DEFAULT_SCALE)

	-- import settings:
	-- scale
	plasma.label("Scale:")
	local scaleInputWidget = defaultableTextInput(tostring(scale))

	scaleInputWidget:enterPressed(function(input: string)
		local newScale = tonumber(input)
		if newScale == nil then
			return
		end

		if newScale <= 0 then
			return
		end

		setScale(newScale)
	end)

	if scaleInputWidget:resetClicked() then
		setScale(DEFAULT_SCALE)
	end

	plasma.space()

	-- import track button
	buttonRow(function()
		if button("Export"):clicked() then
			if props.selectedTrackPoints ~= nil then
				local exportInstance = export(props.selectedTrackPoints, scale)
				exportInstance.Name = props.selectedTrackName .. "_Export"
				exportInstance.Parent = workspace

				Selection:Set({exportInstance})
				ChangeHistoryService:SetWaypoint("ExportTrack")
			end
		end
	end)

	plasma.space(10)

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