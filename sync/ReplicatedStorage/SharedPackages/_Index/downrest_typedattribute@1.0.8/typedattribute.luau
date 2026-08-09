local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(script.Parent.Signal)

local TypedAttribute = {}

export type TypedAttribute<type> = {
    Changed: Signal.Signal<(previousValue: type, newValue: type) -> ()>;

    Get: (self: TypedAttribute<type>) -> type;
    Set: (self: TypedAttribute<type>, setValue: type) -> ();
}
type PrivateTypedAttribute<type> = {
    _type: string;
    _previousValue: type;
}

function TypedAttribute.new<type>(attributeName: string, defaultValue: type): TypedAttribute<type>
    local self = {}:: TypedAttribute<type> & PrivateTypedAttribute<type>

    self._type = typeof(defaultValue)
    self._previousValue = defaultValue

    self.Changed = Signal.new<<(previousValue: type, newValue: type) -> ()>>(); do
        script:GetAttributeChangedSignal(attributeName):Connect(function()
            local previousValue = self._previousValue
            local newValue = self:Get()

            self.Changed:Fire(previousValue, newValue)
            self._previousValue = newValue
        end)
    end

    script:SetAttribute(attributeName, defaultValue)

    function self.Get(self: TypedAttribute<type>): type
        self = (self:: TypedAttribute<type> & PrivateTypedAttribute<type>)

        return script:GetAttribute(attributeName)
    end

    function self.Set(self: TypedAttribute<type>, setValue: type)
        self = (self:: TypedAttribute<type> & PrivateTypedAttribute<type>)
        
        local setType = typeof(setValue)
        assert(
            setType == self._type,
            `Attempted to set attribute to {setType} when the attribute is {self._type}`
        )

        script:SetAttribute(attributeName, setValue)
    end

    return self
end

return TypedAttribute
