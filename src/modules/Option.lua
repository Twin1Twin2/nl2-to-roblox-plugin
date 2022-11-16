
--- Lua implementation of Rust's Option Enum
--- @class Option

local Option = {}
Option.__index = Option

--- @tag Constructor
--- @param value any?
--- @return Option
function Option.new(value: any?): Option
	local self = setmetatable({}, Option)

	self._value = value

	return self
end

--- Creates a `None` Option
--- @return Option
function Option.none(): Option
	return Option.new()
end

--- Creates a `Some` Option
--- @param value any
--- @return Option
function Option.some(value: any): Option
	return Option.new(value)
end

--- Wraps a value in a Option
--- @param value any
--- @return Option
function Option.wrap(value: any): Option
	return Option.new(value)
end

--- Returns true if Option is a `None`
--- @return boolean
function Option:isNone(): boolean
	return self._value == nil
end

--- Returns true if Option is a `Some`
--- @return boolean
function Option:isSome(): boolean
	return self._value ~= nil
end

--- Returns true if value is equal to the contained value
--- @param value any
--- @return boolean
function Option:contains(value: any): boolean
	return self._value == value
end

--- Unwraps and returns the value if is a `Some`.
--- Otherwise, throws an error with the given message
--- @param msg string
--- @return any
function Option:expect(msg: string, level: number?): any
	if level == nil then
		level = 2
	elseif level > 0 then
		level = level + 1
	end

	if self:isNone() then
		error(msg, level)
	else
		return self._value
	end
end

--- Unwraps and returns the value if is a `Some`.
--- Otherwise, throws an error
--- @return any
function Option:unwrap(): any
	return self:expect("Attempted to unwrap a `None` value!", 2)
end

--- Like unwrap, but returns the given default value instead of erroring
--- @param default any
--- @return any
function Option:unwrapOr(default: any): any
	if self:isSome() then
		return self._value
	else
		return default
	end
end

--- Like unwrapOr, but returns the value returned by the given function
--- @param func () -> any
--- @return any
function Option:unwrapOrElse(func: () -> any): any
	if self:isSome() then
		return self._value
	else
		return func()
	end
end

--- Maps the Option's value to a new one returned by the mapping function
--- then returns a new Option containing it.
--- Returns a `None` if isNone()
--- @param func () -> any
--- @return Option
function Option:map(func: (value: any) -> any)
	return self:isSome() and Option:some(func(self._value)) or Option:none()
end

--- Like map, but if `None`, returns the default value
--- @param default any
--- @param func () -> any
--- @return Option
function Option:mapOr(default: any, func: (value: any) -> any)
	local result

	if self:isSome() then
		result = func(self._value)
	else
		result = default
	end

	return result
end

--- Like map, but if `None`, returns the value returned by the default function
--- @param default () -> any
--- @param func () -> any
--- @return Option
function Option:mapOrElse(default: () -> any, func: (value: any) -> any)
	local _result

	if self:isSome() then
		_result = func(self._value)
	else
		_result = default()
	end

	return _result
end

export type Option = typeof(Option.new())

return Option