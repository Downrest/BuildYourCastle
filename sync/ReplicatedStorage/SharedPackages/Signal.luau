local module = require("./.lpm/nowoshire_namedsignal/src")
export type Connection<Signature = (...any) -> ()> = module.Connection<Signature>
export type GenericConnection<Params...> = module.GenericConnection<Params...>
export type WrapConnection<OtherSignal> = module.WrapConnection<OtherSignal>
export type Signal<Signature = (...any) -> ()> = module.Signal<Signature>
export type GenericSignal<Params...> = module.GenericSignal<Params...>
export type WrapSignal<OtherSignal> = module.WrapSignal<OtherSignal>
return module
