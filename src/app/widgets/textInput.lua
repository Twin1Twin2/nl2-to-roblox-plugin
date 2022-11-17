
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(text: string)
	local focused, setFocused = plasma.useState(false)
	local focusLost, setFocusLost = plasma.useState(false)

	local enterPressed, setEnterPressed = plasma.useState(false)

	local refs = plasma.useInstance(function(ref)
		local style = plasma.useStyle()

		local textBox = plasma.create("TextBox", {
			[ref] = "textBox",

			BackgroundColor3 = style.bg2,
			BorderSizePixel = 0,
			Font = Enum.Font.SourceSans,
			Size = UDim2.new(1, 0, 0, 40),
			TextColor3 = style.textColor,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 21,
			ClearTextOnFocus = false,

			plasma.create("UIPadding", {
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
			}),

			plasma.create("UICorner"),

			Focused = function()
				setFocused(true)
			end,
			FocusLost = function(wasEnterPressed: boolean)
				setEnterPressed(wasEnterPressed)
				setFocused(false)
				setFocusLost(true)
			end,
		})

		return textBox
	end)

	local textBox = refs.textBox
	if not focused and not enterPressed then
		textBox.Text = text
	end

	local handle = {
		focusLost = function(_self, callback: ((input: string, enterPressed: boolean) -> ()) | nil)
			if focusLost == false then
				return
			end

			local input = textBox.Text
			local currentEnterPressed = enterPressed

			setFocusLost(false)
			setEnterPressed(false)

			if callback then
				callback(input, currentEnterPressed)
			end

			return true
		end,
	}

	return handle
end)