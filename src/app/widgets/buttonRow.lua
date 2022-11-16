
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(fn)
	local refs = plasma.useInstance(function(ref)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 40)
		frame.BackgroundTransparency = 1

		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		uiListLayout.Padding = UDim.new(0, 10)
		uiListLayout.Parent = frame

		ref.frame = frame

		-- plasma.automaticSize(frame)

		return frame
	end)

	plasma.scope(fn)
end)