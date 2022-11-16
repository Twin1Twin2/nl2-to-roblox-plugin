
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(text: string)
	local clicked, setClicked = plasma.useState(false)
	local refs = plasma.useInstance(function(ref)
		local style = plasma.useStyle()

		return plasma.create("TextButton", {
			[ref] = "button",
			BackgroundColor3 = style.bg3,
			BorderSizePixel = 1,
			BorderColor3 = style.textColor,
			Font = Enum.Font.SourceSans,
			Size = UDim2.new(0, 100, 0, 40),
			TextColor3 = style.textColor,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 21,

			plasma.create("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),

			Activated = function()
				setClicked(true)
			end,
		})
	end)

	local instance = refs.button

	instance.Text = text

	local handle = {
		clicked = function()
			if clicked then
				setClicked(false)
				return true
			end

			return false
		end,
	}

	return handle
end)