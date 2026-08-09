local REQUIRED_MODULE = require(script.Parent._Index["downrest_typedevent@1.0.4"]["typedevent"])
export type Event<
	clientToServerSignature ,
	serverToClientSignature 	> = REQUIRED_MODULE.Event<	clientToServerSignature ,
	serverToClientSignature >
export type ClientToServer<signature > = REQUIRED_MODULE.ClientToServer<signature >
export type ServerToClient<signature > = REQUIRED_MODULE.ServerToClient<signature >
return REQUIRED_MODULE
