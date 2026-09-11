local LoaderUtil = {}

export type Module = {
    Init: () -> ()?;
}

function LoaderUtil.Boot(source: ModuleScript, requireOnly: boolean?): any
    local module = require(source):: Module

    if not requireOnly then
        if module.Init then
            module.Init()
        end
    end

    return module
end

return LoaderUtil
