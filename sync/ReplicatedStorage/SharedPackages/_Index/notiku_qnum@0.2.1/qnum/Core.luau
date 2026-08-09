--!strict

local Types = require(script.Parent.Types)

type QNum = Types.QNum

local Core = {}

--[[
	Normalizes a QNum value so its mantissa stays between 1 and 10.

	Examples:
		{ mantissa = 125, exponent = 3 } -> { mantissa = 1.25, exponent = 5 }
		{ mantissa = 0.5, exponent = 3 } -> { mantissa = 5, exponent = 2 }

	Zero is always normalized to:
		{ mantissa = 0, exponent = 0 }
]]
function Core.normalize(value: QNum): QNum
	local mantissa = value.mantissa
	local exponent = value.exponent

	if mantissa == 0 then
		return {
			mantissa = 0,
			exponent = 0,
		}
	end

	while math.abs(mantissa) >= 10 do
		mantissa /= 10
		exponent += 1
	end

	while math.abs(mantissa) < 1 do
		mantissa *= 10
		exponent -= 1
	end

	return {
		mantissa = mantissa,
		exponent = exponent,
	}
end

--[[
	Creates a new QNum from a mantissa and exponent.

	Example:
		Core.new(1.5, 6) represents 1.5e6.
]]
function Core.new(mantissa: number?, exponent: number?): QNum
	return Core.normalize({
		mantissa = mantissa or 0,
		exponent = exponent or 0,
	})
end

--[[
	Creates a QNum from a normal Roblox number.

	Example:
		Core.fromNumber(1250000) -> { mantissa = 1.25, exponent = 6 }
]]
function Core.fromNumber(numberValue: number): QNum
	if numberValue == 0 then
		return Core.new(0, 0)
	end

	local exponent = math.floor(math.log10(math.abs(numberValue)))
	local mantissa = numberValue / (10 ^ exponent)

	return Core.new(mantissa, exponent)
end

-- Converts scientific notation parts into a QNum.
-- Example:
-- Core.fromScientific(1.25, 6) -> 1.25e6
function Core.fromScientific(mantissa: number, exponent: number): QNum
	assert(typeof(mantissa) == "number", "QNum.fromScientific expected mantissa to be a number")
	assert(typeof(exponent) == "number", "QNum.fromScientific expected exponent to be a number")

	return Core.new(mantissa, exponent)
end

-- Converts a string into a QNum.
-- Supports normal numbers, scientific notation, and suffix notation.
function Core.fromString(text: string): QNum
	assert(typeof(text) == "string", "QNum.fromString expected a string, got " .. typeof(text))

	text = string.gsub(text, "%s+", "")

	local scientificMantissa, scientificExponent = string.match(
		text,
		"^([%+%-]?%d*%.?%d+)[eE]([%+%-]?%d+)$"
	)

	if scientificMantissa and scientificExponent then
		return Core.fromScientific(
			tonumber(scientificMantissa) :: number,
			tonumber(scientificExponent) :: number
		)
	end

	local normalNumber = tonumber(text)

	if normalNumber then
		return Core.fromNumber(normalNumber)
	end

	local numberPart, suffixPart = string.match(
		text,
		"^([%+%-]?%d+%.?%d*)(%a+)$"
	)

	assert(numberPart and suffixPart, "Invalid QNum string: " .. text)

	local Format = require(script.Parent.Format)
	local suffixIndex = Format.getSuffixIndex(suffixPart)

	assert(suffixIndex, "Unknown QNum suffix: " .. suffixPart)

	return Core.new(
		tonumber(numberPart) :: number,
		suffixIndex * 3
	)
end

--[[
	Creates a copy of a QNum.

	This prevents accidental mutation of the original value.
]]
function Core.clone(value: QNum): QNum
	return {
		mantissa = value.mantissa,
		exponent = value.exponent,
	}
end

--[[
	Converts a QNum back into a regular number.

	Warning:
		This can overflow or lose precision for extremely large values.
		Use this only for small values or temporary calculations.
]]
function Core.toNumber(value: QNum): number
	return value.mantissa * (10 ^ value.exponent)
end

return Core
