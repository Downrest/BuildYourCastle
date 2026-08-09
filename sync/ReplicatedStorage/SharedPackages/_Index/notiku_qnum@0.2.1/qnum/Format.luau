--!strict

local Constants = require(script.Parent.Constants)
local Types = require(script.Parent.Types)

type QNum = Types.QNum

local SuffixByIndex: { [number]: string } = {}
local IndexBySuffix: { [string]: number } = {}

local Format = {}

--[[
	Generates a suffix for a suffix index using American short-scale naming.

	Index examples:
		1   -> k       (thousand,   10^3)
		2   -> M       (million,    10^6)
		3   -> B       (billion,    10^9)
		4   -> T       (trillion,   10^12)
		5   -> Qd      (quadrillion, 10^15)
		11  -> Dc      (decillion,  10^33)
		12  -> UDc     (undecillion, 10^36)
		21  -> Vg      (vigintillion, 10^63)
		101 -> Ce      (centillion, 10^303)
		111 -> DcCe    (decicentillion, 10^333)

	For n >= 1000 (beyond nongentillion), falls back to scientific-like text.
]]
local function generateSuffix(index: number): string
	if index <= 0 then
		return ""
	end

	if index <= #Constants.SETS then
		return Constants.SETS[index]
	end

	-- n is the ordinal in the -illion sequence (million=1, billion=2, ...).
	local n = index - 1

	if n >= 1000 then
		return "e" .. tostring(index * 3)
	end

	local ones = n % 10
	local tens = math.floor(n / 10) % 10
	local hundreds = math.floor(n / 100) % 10

	local first = Constants.FIRST_ONES[ones + 1]
	local second = Constants.SECOND_ONES[tens + 1]
	local third = Constants.THIRD_ONES[hundreds + 1]

	return first .. second .. third
end

--[[
	Formats a QNum using scientific notation.

	Example:
		1.25e6
]]
function Format.toScientific(value: QNum, decimals: number?): string
	decimals = decimals or 2

	return string.format(
		"%." .. tostring(decimals) .. "fe%d",
		value.mantissa,
		value.exponent
	)
end

--[[
	Formats a QNum using generated suffixes.

	Example:
		1.25e6 -> 1.25M
]]
function Format.withSuffix(value: QNum, decimals: number?): string
	decimals = decimals or 2

	if value.mantissa == 0 then
		return "0"
	end

	local suffixIndex = math.floor(value.exponent / 3)

	if suffixIndex <= 0 then
		local normalNumber = value.mantissa * (10 ^ value.exponent)
		return string.format("%." .. tostring(decimals) .. "f", normalNumber)
	end

	local suffix = Format.getSuffix(suffixIndex)
	local suffixExponent = suffixIndex * 3
	local displayNumber = value.mantissa * (10 ^ (value.exponent - suffixExponent))

	return string.format(
		"%." .. tostring(decimals) .. "f%s",
		displayNumber,
		suffix
	)
end

--[[
	Formats a QNum for normal display.

	Small values are shown as regular whole numbers.
	Large values use suffix formatting.
]]
function Format.format(value: QNum, decimals: number?): string
	if value.exponent < 3 then
		local normalNumber = value.mantissa * (10 ^ value.exponent)
		return tostring(math.floor(normalNumber))
	end

	return Format.withSuffix(value, decimals)
end

--[[
	Returns the suffix for a given suffix index and caches the result.

	Useful for testing or custom UI.
]]
function Format.getSuffix(index: number): string
	local cached = SuffixByIndex[index]

	if cached then
		return cached
	end

	local suffix = generateSuffix(index)

	SuffixByIndex[index] = suffix
	IndexBySuffix[suffix] = index

	return suffix
end

-- Returns a suffix index by suffix string and uses the cache.
-- Example:
-- "k" -> 1
-- "M" -> 2
-- "B" -> 3
function Format.getSuffixIndex(suffix: string): number?
	local cached = IndexBySuffix[suffix]

	if cached then
		return cached
	end

	for index = 1, 100000 do
		local generatedSuffix = Format.getSuffix(index)

		if generatedSuffix == suffix then
			return index
		end
	end

	return nil
end

return Format
