local RunService = game:GetService("RunService")

local Config = {}

Config.STREAM_SUFFIX = "Stream"
Config.HANDSHAKE_FUNCTION_SUFFIX = "Handshake"
Config.UPDATE_EVENT_SUFFIX = "Update"

Config.GLOBAL_REPLICA_ID = "Global"

Config.IS_SERVER = RunService:IsServer()

return Config