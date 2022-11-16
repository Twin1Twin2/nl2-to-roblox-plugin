
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
local pointsToModel = require(nl2.pointsToModel)

local selectImportTrackMenu = require(script.Parent.selectImportTrackMenu)

local DEFAULT_SCALE = 3.937
local DEFAULT_DISTANCE = 0.5

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

	-- import settings:
	-- scale
	local scale, setScale = plasma.useState(DEFAULT_SCALE)

	plasma.label("Scale:")
	local scaleInputWidget = defaultableTextInput(tostring(scale))

	scaleInputWidget:focusLost(function(input: string)
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

	-- nl2 export distance between points
	local distance, setDistance = plasma.useState(DEFAULT_DISTANCE)

	plasma.label("Distance:")
	local distanceInputWidget = defaultableTextInput(tostring(distance))

	distanceInputWidget:focusLost(function(input: string)
		local newDistance = tonumber(input)
		if newDistance == nil then
			return
		end

		if newDistance <= 0 then
			return
		end

		setDistance(newDistance)
	end)

	if distanceInputWidget:resetClicked() then
		setScale(DEFAULT_DISTANCE)
	end

	plasma.space()

	-- import track button
	buttonRow(function()
		if button("Import"):clicked() then
			if props.selectedTrackPoints ~= nil then
				local model = pointsToModel(props.selectedTrackPoints, scale, distance)
				model.Name = props.selectedTrackName .. "_Import"
				model.Parent = workspace

				Selection:Set({model})
				ChangeHistoryService:SetWaypoint("ImportTrack")
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
		selectImportTrackMenu(function(points, name)
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