--!strict

local Core = require(script.Core)
local Operations = require(script.Operations)
local Compare = require(script.Compare)
local Format = require(script.Format)
local Types = require(script.Types)

export type QNumValue = {
	mantissa: number,
	exponent: number,
}

local QNum = {}
QNum.__index = QNum

-- Creates a new QNum value.
function QNum.new(mantissa: number?, exponent: number?): QNumValue
	local value = Core.new(mantissa, exponent)
	return setmetatable(value, QNum) :: any
end

-- Creates a QNum from a regular Roblox number.
function QNum.fromNumber(numberValue: number): QNumValue
	local value = Core.fromNumber(numberValue)
	return setmetatable(value, QNum) :: any
end

-- Creates a QNum from a string.
function QNum.fromString(text: string): QNumValue
	local value = Core.fromString(text)
	return setmetatable(value, QNum) :: any
end

-- Adds two QNums.
function QNum.add(a: QNumValue, b: QNumValue): QNumValue
	return setmetatable(Operations.add(a, b), QNum) :: any
end

-- Subtracts b from a.
function QNum.sub(a: QNumValue, b: QNumValue): QNumValue
	return setmetatable(Operations.sub(a, b), QNum) :: any
end

-- Multiplies two QNums.
function QNum.mul(a: QNumValue, b: QNumValue): QNumValue
	return setmetatable(Operations.mul(a, b), QNum) :: any
end

-- Divides a by b.
function QNum.div(a: QNumValue, b: QNumValue): QNumValue
	return setmetatable(Operations.div(a, b), QNum) :: any
end

-- Raises a QNum to a numeric power.
function QNum.pow(a: QNumValue, power: number): QNumValue
	return setmetatable(Operations.pow(a, power), QNum) :: any
end

-- Returns true if a equals b.
function QNum.eq(a: QNumValue, b: QNumValue): boolean
	return Compare.eq(a, b)
end

-- Returns true if a is greater than b.
function QNum.gt(a: QNumValue, b: QNumValue): boolean
	return Compare.gt(a, b)
end

-- Returns true if a is less than b.
function QNum.lt(a: QNumValue, b: QNumValue): boolean
	return Compare.lt(a, b)
end

-- Returns true if a is greater than or equal to b.
function QNum.gte(a: QNumValue, b: QNumValue): boolean
	return Compare.gte(a, b)
end

-- Returns true if a is less than or equal to b.
function QNum.lte(a: QNumValue, b: QNumValue): boolean
	return Compare.lte(a, b)
end

-- Formats a QNum for display.
function QNum.format(value: QNumValue, decimals: number?): string
	return Format.format(value, decimals)
end

-- Formats a QNum using scientific notation.
function QNum.toScientific(value: QNumValue, decimals: number?): string
	return Format.toScientific(value, decimals)
end

-- Formats a QNum using suffix notation.
function QNum.withSuffix(value: QNumValue, decimals: number?): string
	return Format.withSuffix(value, decimals)
end

-- Returns a generated suffix by suffix index.
function QNum.getSuffix(index: number): string
	return Format.getSuffix(index)
end

-- Returns the index by suffix.
function QNum.getSuffixIndex(suffix: string): number?
	return Format.getSuffixIndex(suffix)
end

-- Clones a QNum.
function QNum.clone(value: QNumValue): QNumValue
	return setmetatable(Core.clone(value), QNum) :: any
end

-- Normalizes a QNum.
function QNum.normalize(value: QNumValue): QNumValue
	return setmetatable(Core.normalize(value), QNum) :: any
end

-- Converts a QNum back to a regular number.
function QNum.toNumber(value: QNumValue): number
	return Core.toNumber(value)
end

-- Object-style addition.
function QNum:Add(other: QNumValue): QNumValue
	return QNum.add(self, other)
end

-- Object-style subtraction.
function QNum:Sub(other: QNumValue): QNumValue
	return QNum.sub(self, other)
end

-- Object-style multiplication.
function QNum:Mul(other: QNumValue): QNumValue
	return QNum.mul(self, other)
end

-- Object-style division.
function QNum:Div(other: QNumValue): QNumValue
	return QNum.div(self, other)
end

-- Object-style power.
function QNum:Pow(power: number): QNumValue
	return QNum.pow(self, power)
end

-- Object-style formatting.
function QNum:Format(decimals: number?): string
	return QNum.format(self, decimals)
end

-- Supports QNum + QNum.
function QNum.__add(a: QNumValue, b: QNumValue): QNumValue
	return QNum.add(a, b)
end

-- Supports QNum - QNum.
function QNum.__sub(a: QNumValue, b: QNumValue): QNumValue
	return QNum.sub(a, b)
end

-- Supports QNum * QNum.
function QNum.__mul(a: QNumValue, b: QNumValue): QNumValue
	return QNum.mul(a, b)
end

-- Supports QNum / QNum.
function QNum.__div(a: QNumValue, b: QNumValue): QNumValue
	return QNum.div(a, b)
end

-- Supports QNum ^ number.
function QNum.__pow(a: QNumValue, power: number): QNumValue
	return QNum.pow(a, power)
end

-- Supports QNum == QNum.
function QNum.__eq(a: QNumValue, b: QNumValue): boolean
	return QNum.eq(a, b)
end

-- Supports QNum < QNum.
function QNum.__lt(a: QNumValue, b: QNumValue): boolean
	return QNum.lt(a, b)
end

-- Supports QNum <= QNum.
function QNum.__le(a: QNumValue, b: QNumValue): boolean
	return QNum.lte(a, b)
end

-- Supports tostring(QNum).
function QNum.__tostring(value: QNumValue): string
	return QNum.format(value)
end

QNum.zero = QNum.new(0, 0)
QNum.one = QNum.new(1, 0)

return QNum
