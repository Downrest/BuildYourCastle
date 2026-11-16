local VectorUtil = {}

function VectorUtil.Average3(x: number, y: number, z: number): number
    return (x + y + z)/3
end

function VectorUtil.Average(...: number): number
    local list = {...}
    local average = 0

    for _, value in list do
        average += value
    end

    return average/#list
end

return VectorUtil
