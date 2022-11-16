
local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local nl2 = root.nl2
local pointsFromSelection = require(nl2.pointsFromSelection)

local widgets = script.Parent.widgets
local selectedText = require(widgets.selectedText)
local button = require(widgets.button)
local acceptCancelButtons = require(widgets.acceptCancelButtons)

return plasma.widget(function(closeMenuCallback)
	local trackName, setTrackName = plasma.useState(nil)
	local trackPoints, setTrackPoints = plasma.useState(nil)

	plasma.label("Select Track To Export:")

	local selectedTrackText = "[NONE]"
	if trackName ~= nil then
		selectedTrackText = trackName
	end

	selectedText(selectedTrackText)

	if button("Load From Points"):clicked() then
		local pointsDataResult = pointsFromSelection()
		if pointsDataResult:isErr() then
			warn(("Unable to load from points! %s"):format(pointsDataResult:unwrapErr()))
			return
		end

		local pointsData = pointsDataResult:unwrap()

		setTrackName(pointsData.name)
		setTrackPoints(pointsData.points)
	end

	plasma.space()

	acceptCancelButtons(
		function()
			if trackPoints ~= nil then
				closeMenuCallback(trackPoints, trackName)
			end
		end,
		function()
			closeMenuCallback(nil)
		end
	)

	plasma.space()

	return {
	}
end)