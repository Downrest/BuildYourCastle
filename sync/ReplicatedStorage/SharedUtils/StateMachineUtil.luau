local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local StateMachineUtil = {}

export type StateMachine<self = StateMachine> = {
    SetState: (self: self, stateName: string) -> ();
}
type PrivateStateMachine = StateMachine<PrivateStateMachine> & {
    _stateList: {[string]: State};
    _currentState: State?;
}

export type State<self = State> = {
    Enter: (self: self) -> ();
    Exit: (self: self) -> ();
}
type PrivateState = State<PrivateState> & {
    _bin: Janitor.Janitor;
}
type StateLifecycles = {
    Enter: (bin: Janitor.Janitor) -> ();
    Exit: (bin: Janitor.Janitor) -> ();
}

function StateMachineUtil.stateMachine(stateList: {[string]: State})
    local self = {}:: PrivateStateMachine

    self._stateList = stateList
    self._currentState = nil

    function self.SetState(self: PrivateStateMachine, stateName: string)
        local state = self._stateList[stateName]; do
            assert(state, `Attempted to set state to {stateName}`)
        end

        if self._currentState then
            self._currentState:Exit()
        end

        state:Enter()
        self._currentState = state
    end

    return self
end

function StateMachineUtil.state(stateLifecycles: StateLifecycles): State
    local self = {}:: PrivateState

    self._bin = Janitor.new()

    function self.Enter(self: PrivateState)
        stateLifecycles.Enter(self._bin)
    end
    function self.Exit(self: PrivateState)
        stateLifecycles.Exit(self._bin)
        self._bin:Cleanup()
    end

    return self
end

return StateMachineUtil
