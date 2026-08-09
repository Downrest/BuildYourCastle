-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2026-04-30 23:48:47
-- Luau version 7, Types version 3
-- Time taken: 0.000958 seconds

while wait() do
	local var2 = tick() % 2.5 / 2.5
	local tbl = {}
	for i = 1, 7 do
		z = Color3.fromHSV(var2 - (i - 1) / 6, 1, 1) -- Setting global
		if var2 - (i - 1) / 6 < 0 then
			z = Color3.fromHSV(var2 - (i - 1) / 6 + 1, 1, 1) -- Setting global
		end
		table.insert(tbl, ColorSequenceKeypoint.new((i - 1) / 6, z))
	end
	script.Parent.Color = ColorSequence.new(tbl)
end