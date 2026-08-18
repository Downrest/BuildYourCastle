local module = require("./.lpm/downrest_typedevent/src")
local Types = require("./.lpm/downrest_typedevent/src/Types")
type __lpm_Event_clientToServerSignature = Types.DefaultSignature
type __lpm_Event_serverToClientSignature = Types.DefaultSignature
type __lpm_ClientToServer_signature = Types.DefaultSignature
type __lpm_ServerToClient_signature = Types.DefaultSignature
export type Event<clientToServerSignature = __lpm_Event_clientToServerSignature, serverToClientSignature = __lpm_Event_serverToClientSignature> = module.Event<clientToServerSignature, serverToClientSignature>
export type ClientToServer<signature = __lpm_ClientToServer_signature> = module.ClientToServer<signature>
export type ServerToClient<signature = __lpm_ServerToClient_signature> = module.ServerToClient<signature>
return module
