
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

local MIN_SIZE = Vector2.new(50, 50)
local MAX_SIZE = Vector2.new(1500, 500)

return plasma.widget(function(fn, options)
	options = options or {}

	local refs = plasma.useInstance(function(ref)
		plasma.create("Frame", {
			[ref] = "frame",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),

			plasma.create("ScrollingFrame", {
				[ref] = "container",
				BackgroundTransparency = 1,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				BorderSizePixel = 0,
				ScrollBarThickness = 6,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),

				plasma.create("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
				}),

				plasma.create("UIListLayout", {
					[ref] = "listLayout",

					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10),
				}),
			})
		})

		-- plasma.automaticSize(ref.container)
		plasma.automaticSize(ref.frame)

		return ref.container
	end)

	local scrollingFrame = refs.container :: ScrollingFrame
	local listLayout = refs.listLayout :: UIListLayout

	local canvasHeight = listLayout.AbsoluteContentSize.Y + 10

	plasma.useEffect(function()
		scrollingFrame.CanvasSize = UDim2.new(1, -6, 0, canvasHeight)
	end, canvasHeight)


	-- plasma.useEffect(function()
	-- 	refs.container:SetAttribute("maxSize", options.maxSize or MAX_SIZE)
	-- end, options.maxSize)

	-- plasma.useEffect(function()
	-- 	refs.container:SetAttribute("minSize", options.minSize or MIN_SIZE)
	-- end, options.minSize)

	plasma.scope(fn)

end)