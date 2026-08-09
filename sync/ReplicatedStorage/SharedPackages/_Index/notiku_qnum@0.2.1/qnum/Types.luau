--!strict

export type QNum = {
	mantissa: number,
	exponent: number,
}

export type QNumModule = {
	new: (mantissa: number?, exponent: number?) -> QNum,
	fromNumber: (numberValue: number) -> QNum,
	toNumber: (value: QNum) -> number,
	fromString: (value: string) -> QNum,

	add: (a: QNum, b: QNum) -> QNum,
	sub: (a: QNum, b: QNum) -> QNum,
	mul: (a: QNum, b: QNum) -> QNum,
	div: (a: QNum, b: QNum) -> QNum,
	pow: (a: QNum, power: number) -> QNum,

	eq: (a: QNum, b: QNum) -> boolean,
	gt: (a: QNum, b: QNum) -> boolean,
	lt: (a: QNum, b: QNum) -> boolean,
	gte: (a: QNum, b: QNum) -> boolean,
	lte: (a: QNum, b: QNum) -> boolean,

	format: (value: QNum, decimals: number?) -> string,
	toScientific: (value: QNum, decimals: number?) -> string,
	withSuffix: (value: QNum, decimals: number?) -> string,
	getSuffix: (index: number) -> string,

	clone: (value: QNum) -> QNum,
	normalize: (value: QNum) -> QNum,

	zero: QNum,
	one: QNum,
}

return {}
