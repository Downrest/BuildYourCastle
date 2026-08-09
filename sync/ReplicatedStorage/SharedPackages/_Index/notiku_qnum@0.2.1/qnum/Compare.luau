--!strict

local Types = require(script.Parent.Types)

type QNum = Types.QNum

local Compare = {}

--[[
	Returns true if both QNums have the same mantissa and exponent.
]]
function Compare.eq(a: QNum, b: QNum): boolean
	return a.mantissa == b.mantissa and a.exponent == b.exponent
end

--[[
	Returns true if a is greater than b.
]]
function Compare.gt(a: QNum, b: QNum): boolean
	if a.exponent ~= b.exponent then
		return a.exponent > b.exponent
	end

	return a.mantissa > b.mantissa
end

--[[
	Returns true if a is less than b.
]]
function Compare.lt(a: QNum, b: QNum): boolean
	if a.exponent ~= b.exponent then
		return a.exponent < b.exponent
	end

	return a.mantissa < b.mantissa
end

--[[
	Returns true if a is greater than or equal to b.
]]
function Compare.gte(a: QNum, b: QNum): boolean
	return Compare.gt(a, b) or Compare.eq(a, b)
end

--[[
	Returns true if a is less than or equal to b.
]]
function Compare.lte(a: QNum, b: QNum): boolean
	return Compare.lt(a, b) or Compare.eq(a, b)
end

return Compare
