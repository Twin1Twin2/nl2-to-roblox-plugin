
local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local widgets = script.Parent.widgets
local defaultableTextInput = require(widgets.defaultableTextInput)
local selectedText = require(widgets.selectedText)
local button = require(widgets.button)
local buttonRow = require(widgets.buttonRow)

local pluginActions = script.Parent.Parent.pluginActions
local exportFromPoints = require(pluginActions.exportFromPoints)

local selectExportTrackMenu = require(script.Parent.selectExportTrackMenu)

local DEFAULT_SCALE = 0.25

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
		plasma.label("Current Track:")

		local selectedTrackNameText = if selectedTrackName then selectedTrackName else "[NONE]"
		selectedText(selectedTrackNameText)

		buttonRow(function()
			local clearTrackButton = button({
				text = "Clear Track",
				bgColor = Color3.fromRGB(183, 28, 28),
			})
			if clearTrackButton:clicked() then
				setSelectedTrackPoints(nil)
				setSelectedTrackName(nil)
			end

			if button("Set Track"):clicked() then
				setIsSelectingTrack(true)
			end
		end)

		plasma.space()

		local scale, setScale = plasma.useState(DEFAULT_SCALE)

		-- import settings:
		-- scale
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

		plasma.space()

		-- import track button
		buttonRow({
			height = 48,
			alignment = Enum.HorizontalAlignment.Center
		}, function()
			local buttonWidget = button({
				text = "EXPORT",
				height = 48,
				bgColor = Color3.fromRGB(0, 170, 255),
				paddingLeft = 40,
				paddingRight = 40,
			})

			if buttonWidget:clicked() then
				if selectedTrackPoints ~= nil then
					exportFromPoints(
						selectedTrackPoints,
						scale,
						selectedTrackName
					)
				end
			end
		end)

		plasma.space(10)
	end
end)