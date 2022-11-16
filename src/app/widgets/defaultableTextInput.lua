
local root = script.Parent.Parent.Parent
local packages = root.packages
local plasma = require(packages.plasma)

return plasma.widget(function(text: string)
	local focused, setFocused = plasma.useState(false)
	local enterPressed, setEnterPressed = plasma.useState(false)

	local clicked, setClicked = plasma.useState(false)

	local refs = plasma.useInstance(function(ref)
		local style = plasma.useStyle()

		local frame = plasma.create("Frame", {
			BackgroundColor3 = style.bg3,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 40),

			plasma.create("TextBox", {
				[ref] = "textBox",

				BackgroundColor3 = style.bg2,
				BorderSizePixel = 0,
				Font = Enum.Font.SourceSans,
				Size = UDim2.new(1, -40, 0, 40),
				TextColor3 = style.textColor,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 21,

				plasma.create("UIPadding", {
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20),
				}),

				Focused = function()
					setFocused(true)
				end,
				FocusLost = function(wasEnterPressed: boolean)
					setEnterPressed(wasEnterPressed)
					setFocused(false)
				end,
			}),

			plasma.create("ImageButton", {
				[ref] = "button",
				BackgroundColor3 = style.bg3,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 40, 0, 40),
				AutomaticSize = Enum.AutomaticSize.X,

				Image = "rbxassetid://7746261027",

				Activated = function()
					setClicked(true)
				end,
			})
		})

		return frame
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
		end,
		resetClicked = function(_self)
			if clicked then
				setClicked(false)
				return true
			end

			return false
		end,
	}

	return handle
end)