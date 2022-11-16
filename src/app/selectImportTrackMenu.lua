
local root = script.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local nl2 = script.Parent.Parent.nl2
local importFromFile = require(nl2.importFromFile)
local importFromSelection = require(nl2.importFromSelection)

local widgets = script.Parent.widgets

return plasma.widget(function(closeMenuCallback)
	local trackName, setTrackName = plasma.useState(nil)
	local trackPoints, setTrackPoints = plasma.useState(nil)

	local loadingFile, setLoadingFile = plasma.useState(false)

	local selectedText = "[NONE]"
	if trackName ~= nil then
		selectedText = trackName
	end

	plasma.button(selectedText)

	if plasma.button("Load From File"):clicked() then
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

	if plasma.button("Load From Script"):clicked() then
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

	plasma.row(function()
		if plasma.button("Cancel"):clicked() then
			if loadingFile == true then
				return
			end

			closeMenuCallback(nil)
		end

		if plasma.button("Accept"):clicked() then
			if loadingFile == true then
				return
			end

			if trackPoints ~= nil then
				closeMenuCallback(trackPoints, trackName)
			end
		end
	end)

	return {
	}
end)