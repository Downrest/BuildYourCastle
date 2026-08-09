--!strict

local Core = require(script.Parent.Core)
local Types = require(script.Parent.Types)

type QNum = Types.QNum

local Operations = {}

--[[
	Adds two QNum values.

	If the exponent difference is too large, the smaller number is ignored.
	This is intentional because it would not meaningfully affect the result.
]]
function Operations.add(a: QNum, b: QNum): QNum
	local exponentDifference = a.exponent - b.exponent

	if exponentDifference > 15 then
		return Core.clone(a)
	elseif exponentDifference < -15 then
		return Core.clone(b)
	end

	if exponentDifference >= 0 then
		local mantissa = a.mantissa + b.mantissa / (10 ^ exponentDifference)
		return Core.new(mantissa, a.exponent)
	else
		local mantissa = a.mantissa / (10 ^ -exponentDifference) + b.mantissa
		return Core.new(mantissa, b.exponent)
	end
end

--[[
	Subtracts b from a.
]]
function Operations.sub(a: QNum, b: QNum): QNum
	return Operations.add(a, {
		mantissa = -b.mantissa,
		exponent = b.exponent,
	})
end

--[[
	Multiplies two QNum values.

	Formula:
		(a.mantissa * b.mantissa) e (a.exponent + b.exponent)
]]
function Operations.mul(a: QNum, b: QNum): QNum
	return Core.new(
		a.mantissa * b.mantissa,
		a.exponent + b.exponent
	)
end

--[[
	Divides a by b.

	Throws an error if b is zero.
]]
function Operations.div(a: QNum, b: QNum): QNum
	assert(b.mantissa ~= 0, "QNum division by zero")

	return Core.new(
		a.mantissa / b.mantissa,
		a.exponent - b.exponent
	)
end

--[[
	Raises a QNum to a regular numeric power.

	Example:
		(1e6)^2 -> 1e12
]]
function Operations.pow(a: QNum, power: number): QNum
	if a.mantissa == 0 then
		return Core.new(0, 0)
	end

	local newExponent = a.exponent * power
	local exponentWhole = math.floor(newExponent)
	local exponentFraction = newExponent - exponentWhole

	local newMantissa = (a.mantissa ^ power) * (10 ^ exponentFraction)

	return Core.new(newMantissa, exponentWhole)
end

return Operations
