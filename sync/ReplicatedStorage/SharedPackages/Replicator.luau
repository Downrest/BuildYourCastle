local module = require("./.lpm/downrest_replicator/src")
export type Stream = module.Stream
export type Replica<data> = module.Replica<data>
return module
