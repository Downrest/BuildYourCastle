-- Per-place Daemon configuration
-- This file is sent to the Daemon when it connects.
-- https://azul-docs.vercel.app/advanced-usage/#per-place-daemon-configuration

return {
	pushMappings = {
		-- Mapping 1: Packages from the tool "Wally", in Rojo mode
		{
			source = "./Packages",
			destination = { "ReplicatedStorage", "SharedPackages" },
			destructive = true,
			rojoMode = true,
		},
	}
}
