local module = require("./.lpm/downrest_typedremote/src")
local Types = require("./.lpm/downrest_typedremote/src/Types")
type __lpm_Event_toClientSignature = Types.DefaultSignature
type __lpm_Event_toServerSignature = Types.DefaultSignature
type __lpm_ToClientEvent_signature = Types.DefaultSignature
type __lpm_ToServerEvent_signature = Types.DefaultSignature
type __lpm_Function_fromClientSignature = Types.DefaultSignature
type __lpm_Function_fromServerSignature = Types.DefaultSignature
type __lpm_FromClientFunction_signature = Types.DefaultSignature
type __lpm_FromServerFunction_signature = Types.DefaultSignature
export type Event<toClientSignature = __lpm_Event_toClientSignature, toServerSignature = __lpm_Event_toServerSignature> = module.Event<toClientSignature, toServerSignature>
export type ToClientEvent<signature = __lpm_ToClientEvent_signature> = module.ToClientEvent<signature>
export type ToServerEvent<signature = __lpm_ToServerEvent_signature> = module.ToServerEvent<signature>
export type Function<fromClientSignature = __lpm_Function_fromClientSignature, fromServerSignature = __lpm_Function_fromServerSignature> = module.Function<fromClientSignature, fromServerSignature>
export type FromClientFunction<signature = __lpm_FromClientFunction_signature> = module.FromClientFunction<signature>
export type FromServerFunction<signature = __lpm_FromServerFunction_signature> = module.FromServerFunction<signature>
return module
