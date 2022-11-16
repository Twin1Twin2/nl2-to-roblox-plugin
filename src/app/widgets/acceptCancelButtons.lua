
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local widgets = script.Parent
local button = require(widgets.button)
local buttonRow = require(widgets.buttonRow)

return plasma.widget(function(acceptPressed, cancelPressed)
	buttonRow(function()
		local cancelButton = button({
			text = "Cancel",
			bgColor = Color3.fromRGB(183, 28, 28),
		})
		if cancelButton:clicked() then
			cancelPressed()
		end

		local acceptButton = button({
			text = "Accept",
		})
		if acceptButton:clicked() then
			acceptPressed()
		end
	end)
end)