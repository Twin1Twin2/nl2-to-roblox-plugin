
local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local nl2 = root.nl2
local pointsFromSelection = require(nl2.pointsFromSelection)

local widgets = script.Parent.widgets

return plasma.widget(function(closeMenuCallback)
	local trackName, setTrackName = plasma.useState(nil)
	local trackPoints, setTrackPoints = plasma.useState(nil)

	local selectedText = "[NONE]"
	if trackName ~= nil then
		selectedText = trackName
	end

	plasma.button(selectedText)

	if plasma.button("Load From Points"):clicked() then
		local pointsDataResult = pointsFromSelection()
		if pointsDataResult:isErr() then
			warn(("Unable to load! %s"):format(pointsDataResult:unwrapErr()))
			return
		end

		local pointsData = pointsDataResult:unwrap()

		setTrackName(pointsData.name)
		setTrackPoints(pointsData.points)
	end

	plasma.space()

	plasma.row(function()
		if plasma.button("Cancel"):clicked() then
			closeMenuCallback(nil)
		end

		if plasma.button("Accept"):clicked() then
			if trackPoints ~= nil then
				closeMenuCallback(trackPoints, trackName)
			end
		end
	end)

	return {
	}
end)