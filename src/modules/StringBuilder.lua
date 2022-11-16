
local MAX_CHARACTERS = 200000

local StringBuilder = {}
StringBuilder.__index = StringBuilder
StringBuilder.ClassName = "StringBuilder"

StringBuilder.GLOBAL_MAX_CHARACTERS = MAX_CHARACTERS

function StringBuilder.new(maxCharacters: number | nil)
	maxCharacters = maxCharacters or MAX_CHARACTERS

	assert(type(maxCharacters) == "number",
		"Arg [1] is not a number!")

	local self = setmetatable({}, StringBuilder)

	self.strings = {}
	self.maxCharacters = maxCharacters
	self.numberOfCharacters = 0


	return self
end

function StringBuilder:Destroy()
	self.strings = nil

	setmetatable(self, nil)
end

function StringBuilder:build()
	return table.concat(self.strings)
end

function StringBuilder:buildWithFormat(formatString: string)
	assert(type(formatString) == "string",
		"Arg [1] is not a string!")

	return formatString:format(table.unpack(self.strings))
end

function StringBuilder:_append(str: string)
	self.numberOfCharacters = #str + self.numberOfCharacters
	table.insert(self.strings, str)
end

function StringBuilder:tryAppend(str: string)
	assert(type(str) == "string",
		"Arg [1] is not a string!")

	local newNumCharacters = #str + self.numberOfCharacters
	if newNumCharacters >= self.maxCharacters then
		return false
	end

	self:_append(str)

	return true
end

function StringBuilder:append(str: string)
	assert(type(str) == "string",
		"Arg [1] is not a string!")

	local success = self:tryAppend(str)
	assert(success,
		("Unable to append string: Reached builder's Max Character Limit! Limit = %d; Current Length = %s; New String Length = %d"):format(
			self.maxCharacters,
			self.numberOfCharacters,
			#str
		))

	return self
end


return StringBuilder