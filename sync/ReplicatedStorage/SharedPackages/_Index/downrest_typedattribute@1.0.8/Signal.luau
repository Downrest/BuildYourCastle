local REQUIRED_MODULE = require(script.Parent.Parent["nowoshire_namedsignal@2.3.2"]["namedsignal"])
export type Connection<Signature > = REQUIRED_MODULE.Connection<Signature >
export type GenericConnection<Params...> = REQUIRED_MODULE.GenericConnection<Params...>
export type WrapConnection<OtherSignal> = REQUIRED_MODULE.WrapConnection<OtherSignal>
export type Signal<Signature > = REQUIRED_MODULE.Signal<Signature >
export type GenericSignal<Params...> = REQUIRED_MODULE.GenericSignal<Params...>
export type WrapSignal<OtherSignal> = REQUIRED_MODULE.WrapSignal<OtherSignal>
return REQUIRED_MODULE
