
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(options: table | string)
	local text = "DEFAULT TEXT"

	if type(options) == "table" then
		text = options.text or "DEFAULT TEXT"
	elseif type(options) == "string" then
		text = options
		options = {}
	else
		options = {}
	end

	local clicked, setClicked = plasma.useState(false)
	local refs = plasma.useInstance(function(ref)
		local style = plasma.useStyle()

		return plasma.create("TextButton", {
			[ref] = "button",
			BackgroundColor3 = options.bgColor or style.bg3,
			BorderSizePixel = options.borderSize or 0,
			BorderColor3 = options.borderColor or style.textColor,
			Font = Enum.Font.SourceSans,
			Size = UDim2.new(0, 100, 0, 40),
			TextColor3 = options.textColor or style.textColor,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 21,

			plasma.create("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),

			plasma.create("UICorner"),

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