local module = require("./.lpm/nowoshire_namedsignal/src")
local Types = require("./.lpm/nowoshire_namedsignal/src/Types")
type __lpm_Connection_Signature = Types.DefaultSignature
type __lpm_Signal_Signature = Types.DefaultSignature
export type Connection<Signature = __lpm_Connection_Signature> = module.Connection<Signature>
export type GenericConnection<Params...> = module.GenericConnection<Params...>
export type WrapConnection<OtherSignal> = module.WrapConnection<OtherSignal>
export type Signal<Signature = __lpm_Signal_Signature> = module.Signal<Signature>
export type GenericSignal<Params...> = module.GenericSignal<Params...>
export type WrapSignal<OtherSignal> = module.WrapSignal<OtherSignal>
return module
