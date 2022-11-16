--!strict

--- Lua implementation of Rust languages's Result enum
--- @class Result

local Result = {}
Result.__index = Result

--- Default constructor
--- @param value any | nil
--- @param err any | nil
--- @return Result
function Result.new(value: any, err: any)
	assert(value ~= nil or err ~= nil, "A value must be passed to either \"ok\" or \"err\" args")

	local self = setmetatable({}, Result)

	self._value = value
	self._err = err

	return self
end

--- Constructs a new `Ok` Result
--- @param value any
--- @return Result
function Result.ok(value: any): Result
	assert(value ~= nil, "A value must be passed to Result.ok()!")

	return Result.new(value, nil)
end

--- Constructs a new `Err` Result
--- @param value any
--- @return Result
function Result.err(value: any): Result
	assert(value ~= nil, "A value must be passed to Result.err()!")

	return Result.new(nil, value)
end

--- Returns true if Result is an `Ok` value
--- @return boolean
function Result:isOk(): boolean
	return self._value ~= nil
end

--- Returns true if Result is an `Err` value
--- @return boolean
function Result:isErr(): boolean
	return self._err ~= nil
end

--- Returns true if value is equal to the `Ok` value
--- @param value any
--- @return boolean
function Result:contains(value: any): boolean
	return self._value == value
end

--- Returns true if value is equal to the `Err` value
--- @param err any
--- @return boolean
function Result:containsErr(err: any): boolean
	return self._err == err
end

--- Unwraps and returns the `Ok` value,
--- but throws an error with the given msg
--- appended with the `Err` value if an `Err`.
--- ```lua
--- local errResult = Result.err("An error message")
--- errResult:expect("Something happened")
--- -- outputs error: "Something happened: An error message"
--- ```
--- @param msg string
--- @param level number?
--- @return any
--- @error msg
function Result:expect(msg: string, level: number?): any
	if level == nil then
		level = 2
	elseif level > 0 then
		level = level + 1
	end

	if self:isOk() then
		return self._value
	else
		error(msg .. ": " .. tostring(self._err), level)
	end
end

--- If Result is `Ok`, returns the `Ok` value.
--- Otherwise throws an error
--- @return any
--- @error msg
function Result:unwrap(): any
	return self:expect("Attempted to use unwrap() on an `Err` value", 2)
end

--- unwrap(), but returns the given default
--- if an `Err` value instead of erroring
--- @param default any
--- @return any
function Result:unwrapOr(default: any): any
	if self:isOk() then
		return self._value
	else
		return default
	end
end

--- unwrap(), but calls and returns the given func
--- if an `Err` value instead of erroring
--- @param func () -> any
--- @return any
function Result:unwrapOrElse(func: () -> any): any
	if self:isOk() then
		return self._value
	else
		return func()
	end
end

--- If Result is `Err`, returns the `Err` value.
--- Otherwise throws an error
--- @param msg string
--- @param level number?
--- @return any
--- @error msg
function Result:expectErr(msg: string, level: number?): any
	if level == nil then
		level = 2
	elseif level > 0 then
		level = level + 1
	end

	if self:isErr() then
		return self._err
	else
		error(msg .. ": " .. tostring(self._value), level)
	end
end

--- If Result is `Err`, returns the `Err` value.
--- Otherwise throws an error
--- @return any
--- @error msg
function Result:unwrapErr(): any
	return self:expectErr("Attempted to use unwrapErr() on an `Ok` value", 2)
end

export type Result = typeof(Result.new())

return Result