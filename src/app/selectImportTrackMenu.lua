
local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local nl2 = script.Parent.Parent.nl2
local importFromFile = require(nl2.importFromFile)
local importFromSelection = require(nl2.importFromSelection)

local widgets = script.Parent.widgets
local selectedText = require(widgets.selectedText)
local button = require(widgets.button)
local buttonRow = require(widgets.buttonRow)

return plasma.widget(function(closeMenuCallback)
	local trackName, setTrackName = plasma.useState(nil)
	local trackPoints, setTrackPoints = plasma.useState(nil)

	local loadingFile, setLoadingFile = plasma.useState(false)

	plasma.label("Select Track To Import:")

	local selectedTrackText = "[NONE]"
	if trackName ~= nil then
		selectedTrackText = trackName
	end

	selectedText(selectedTrackText)

	if button("Load From File"):clicked() then
		setLoadingFile(true)
		importFromFile()
			:andThen(function(importDataResult)
				if importDataResult:isErr() then
					warn(("Unable to load! %s"):format(importDataResult:unwrapErr()))
					return
				end
		
				local importData = importDataResult:unwrap()
		
				setTrackName(importData.name)
				setTrackPoints(importData.points)
			end)
			:finally(function()
				setLoadingFile(false)
			end)
	end

	if button("Load From Script"):clicked() then
		local importDataResult = importFromSelection()
		if importDataResult:isErr() then
			warn(("Unable to load! %s"):format(importDataResult:unwrapErr()))
			return
		end

		local importData = importDataResult:unwrap()

		setTrackName(importData.name)
		setTrackPoints(importData.points)
	end

	plasma.space()

	buttonRow(function()
		if button("Cancel"):clicked() then
			if loadingFile == true then
				return
			end

			closeMenuCallback(nil)
		end

		if button("Accept"):clicked() then
			if loadingFile == true then
				return
			end

			if trackPoints ~= nil then
				closeMenuCallback(trackPoints, trackName)
			end
		end
	end)

	plasma.space()

	return {
	}
end)