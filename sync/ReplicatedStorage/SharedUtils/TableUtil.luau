local TableUtil = {}

--[[
	Returns a guaranteed table of `any`, whether it be a value or a table of values.
]]
function TableUtil.EnsureTable<T>(any: T): T
	any = (any:: {any})

	if typeof(any) ~= "table" then
		any = {any}
	end

	return any
end

function TableUtil.DeepCopy<T>(source: T): T
	source = (source:: {any})

	local deepCopy = {}

	for key, value in source do
		if typeof(value) == "table" then
			deepCopy[key] = TableUtil.DeepCopy(value)
		else
			deepCopy[key] = value
		end
	end
	
	return deepCopy
end

--[[
	Returns a boolean, true if one of the values from table `needle` is found in table `haystack`
]]
function TableUtil.MatchTableValues<T1, T2>(haystack: T1, needle: T2): boolean
	haystack = (haystack:: {any})
	needle = (needle:: {any})

	for _, needleValue in needle do
		if table.find(haystack, needleValue) then
			return true
		end
	end
	return false
end

--[[
	Returns a boolean, true if the table has both equivalent values in equivalent indices/order
]]
function TableUtil.IsTableEquivalent<T1, T2>(table1: T1, table2: T2): boolean
	table1 = (table1:: {any})
	table2 = (table2:: {any})

	for index2, value2 in table2 do
		if table1[index2] ~= value2 then
			return false
		end
	end
	return true
end

--[[
	Returns the amount of fields in a table, whether it be an array or a dictionary.
]]
function TableUtil.GetTableAmount<T>(source: T): number
	source = (source:: {any})

	local amount = 0

	for _ in source do
		amount += 1
	end

	return amount
end

--[[
	Insert all values of `inserting` into `source`.
]]
function TableUtil.InsertValues<T>(source: T, inserting: T)
	inserting = TableUtil.EnsureTable(inserting):: {any}

	for _, insert in inserting do
		table.insert(source, insert)
	end
end

--[[
	Returns values of a given source table, no guaranteed order for dictionaries.
]]
function TableUtil.GetValues<T>(source: T): T
	source = (source:: {any})

	local values = {}

	for _, value in source do
		table.insert(values, value)
	end

	return values
end

--[[
	Returns keys of a given source table, no guaranteed order for dictionaries.
]]
function TableUtil.GetKeys<T>(source: T): T
	source = (source:: {any})

	local keys = {}

	for key in source do
		table.insert(keys, key)
	end

	return keys
end

--[[
	Merges `...` into a single array `{...}` in descending order (the first parameters are in the first slot of the array).

	`...` can either be an arrays, non-tables, or both.
]]
function TableUtil.MergeArray<T>(...: T): T
	local parameters = {...}
	local merged = {}

	for _, value in parameters do
		if typeof(value) == "table" then
			table.move(value, 1, #value, #merged+1, merged)
		else
			table.insert(merged, value)
		end
	end

	return merged
end

return TableUtil