local BuiltStateConfig = {}

export type BuildState = {
    Enter: () -> ();
    Exit: () -> ();
}

return BuiltStateConfig
