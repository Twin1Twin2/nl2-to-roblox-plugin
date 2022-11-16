
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(text: string)
	local refs = plasma.useInstance(function(ref)
		local style = plasma.useStyle()

		local textBox = plasma.create("TextBox", {
			[ref] = "textBox",

			BackgroundColor3 = style.bg1,
			BorderSizePixel = 0,
			Font = Enum.Font.SourceSans,
			Size = UDim2.new(1, -20, 0, 40),
			TextColor3 = style.textColor,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 21,
			TextEditable = false,

			plasma.create("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
		})

		return textBox
	end)

	local textBox = refs.textBox
	textBox.Text = text
end)