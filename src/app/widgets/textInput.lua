
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(text: string)
	local focused, setFocused = plasma.useState(false)
	local enterPressed, setEnterPressed = plasma.useState(false)

	local refs = plasma.useInstance(function(ref)
		local style = plasma.useStyle()

		local textBox = plasma.create("TextBox", {
			[ref] = "textBox",

			BackgroundColor3 = style.bg3,
			BorderSizePixel = 0,
			Font = Enum.Font.SourceSans,
			Size = UDim2.new(0, 100, 0, 40),
			TextColor3 = style.textColor,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 21,

			plasma.create("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),

			plasma.create("UICorner"),

			Focused = function()
				setFocused(true)
			end,
			FocusLost = function(wasEnterPressed: boolean)
				setEnterPressed(wasEnterPressed)
				setFocused(false)
			end,
		})

		return textBox
	end)

	local textBox = refs.textBox
	if not focused and not enterPressed then
		textBox.Text = text
	end

	local handle = {
		enterPressed = function(_self, callback: ((input: string) -> ()) | nil)
			if enterPressed then
				local input = textBox.Text

				setEnterPressed(false)

				if callback then
					callback(input)
				end

				return true
			end

			return false
		end
	}

	return handle
end)