local AtomicDataUtil = {}

function AtomicDataUtil.AttemptDataSetters(...: boolean): boolean
    local successBoolean = true
    local dataSetterResults = {...}

    for _, result in dataSetterResults do
        successBoolean = result

        if not successBoolean then
            break
        end
    end

    return successBoolean
end

return AtomicDataUtil
