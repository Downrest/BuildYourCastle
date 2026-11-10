local StateMachineUtil = {}

export type StateMachine<self = StateMachine> = {
    SetState: (self: self, stateName: string) -> ();
}
type PrivateStateMachine = StateMachine<PrivateStateMachine> & {
    _stateList: {[string]: State};
    _currentState: State?;
}

export type State<self = State> = {
    Enter: () -> ();
    Exit: () -> ();
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
            self._currentState.Exit()
        end

        state.Enter()
        self._currentState = state
    end

    return self
end

return StateMachineUtil
