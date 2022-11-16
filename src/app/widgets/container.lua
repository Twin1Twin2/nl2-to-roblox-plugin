
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(fn, options)
	options = options or {}

	local padding = options.padding or 10

	local refs = plasma.useInstance(function(ref)
		return plasma.create("Frame", {
			[ref] = "frame",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),

			plasma.create("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),

			plasma.create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = options.direction or Enum.FillDirection.Vertical,
				Padding = UDim.new(0, padding),
			}),
		})
	end)

	plasma.scope(fn)

	return refs.frame
end)