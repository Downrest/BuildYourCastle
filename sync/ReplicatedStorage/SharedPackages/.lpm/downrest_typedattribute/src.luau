local Signal = require("./packages/roblox/Signal")

local TypedAttribute = {}
local RunService = game:GetService("RunService")

local Signal = require("./packages/roblox/Signal")

local TypedAttribute = {}

export type TypedAttribute<type> = {
    Loaded: Signal.Signal<(initialValue: type) -> ()>;
    Changed: Signal.Signal<(newValue: type, previousValue: type) -> ()>;

    Get: (self: TypedAttribute<type>) -> type;
    Set: (self: TypedAttribute<type>, setValue: type) -> ();
    Reset: (self: TypedAttribute<type>) -> ();
    Emit: (self: TypedAttribute<type>) -> ();
    IsEqual: (self: TypedAttribute<type>, matchingValue: type) -> boolean;
}
type PrivateTypedAttribute<type> = {
    _parent: Instance;
    _type: string;
    _previousValue: type;
}

function TypedAttribute.new<type>(attributeName: string, defaultValue: type, parent: Instance?): TypedAttribute<type>
    local self = {}:: TypedAttribute<type> & PrivateTypedAttribute<type>

    self._parent = parent or script
    self._type = typeof(defaultValue)
    self._previousValue = defaultValue

    self.Changed = Signal.new<<(newValue: type, previousValue: type) -> ()>>():: any
    self.Loaded = Signal.new<<(initialValue: type) -> ()>>():: any

    function self.Get(self: TypedAttribute<type>): type
        self = (self:: TypedAttribute<type> & PrivateTypedAttribute<type>)

        return self._parent:GetAttribute(attributeName)
    end

    function self.Set(self: TypedAttribute<type>, setValue: type)
        self = (self:: TypedAttribute<type> & PrivateTypedAttribute<type>)
        
        local setType = typeof(setValue)
        assert(
            setType == self._type,
            `Attempted to set attribute to {setType} when the attribute is {self._type}`
        )

        self._parent:SetAttribute(attributeName, setValue)
    end

    function self.Reset(self: TypedAttribute<type>)
        self = (self:: TypedAttribute<type> & PrivateTypedAttribute<type>)

        self._parent:SetAttribute(attributeName, defaultValue)
    end

    function self.Emit(self: TypedAttribute<type>)
        self = (self:: TypedAttribute<type> & PrivateTypedAttribute<type>);

        (self.Changed:: any):Fire(self:Get(), self._previousValue)
    end

    function self.IsEqual(self: TypedAttribute<type>, matchingValue: type): boolean
        return (self:Get() == matchingValue)
    end

    -- init
    do
        self._parent:GetAttributeChangedSignal(attributeName):Connect(function()
            local previousValue = self._previousValue
            local newValue = self:Get()

            -- found out that GetAttributeChangedSignal() triggers when an attribute initially loads in
            if newValue == previousValue then
                (self.Loaded:: any):Fire(newValue)
            else
                (self.Changed:: any):Fire(newValue, previousValue)
                self._previousValue = newValue
            end
        end)

        if RunService:IsServer() then
            self._parent:SetAttribute(attributeName, defaultValue)
        end
    end

    return self
end

return TypedAttribute

