local LoaderUtil = {}

export type Source = {
    Init: () -> ()?;
    Start: () -> ()?;
}

type SourceData = {
    source: Source; 
    sourceType: number
}
type Scope = {
    sources: {SourceData};
}

local scopes = { n = 1; }:: { n: number, [number]: Scope }

local SOURCE_TYPES = {
    Require = 1;
    Boot = 2;
}

local function createSourceData(source: Source, sourceType: number): SourceData
    return {
        source = source;
        sourceType = sourceType;
    }
end

local function createScope(): Scope
    return {
        sources = {}
    }
end

local function pushScope(scope: Scope)
    table.insert(scopes, scope)
    scopes.n += 1
end

local function getCurrentScope()
    return scopes[scopes.n]
end

local function pushRequireToScope(source: Source)
    local currentScope = getCurrentScope()
    table.insert(
        currentScope.sources, 
        createSourceData(source, SOURCE_TYPES.Require)
    )
end

local function pushBootToScope(source: Source)
    local currentScope = getCurrentScope()
    table.insert(
        currentScope.sources, 
        createSourceData(source, SOURCE_TYPES.Boot)
    )
end

local function processScopeModules(scope: Scope)
    local init = {}
    local start = {}

    for _, source in scope.sources do
        local module = require(source):: any

        if source.sourceType == SOURCE_TYPES.Boot then
            table.insert(init, module)
            table.insert(start, module)
        end
    end

    do
        for _, module in
    end
end

function LoaderUtil.scope(moduleCallback: () -> ())
    local scope = createScope()
    pushScope(scope)

    moduleCallback()
end

function LoaderUtil.Require(source: ModuleScript)
    pushRequireToScope(source:: Source)
end

function LoaderUtil.Boot(source: ModuleScript)
    pushBootToScope(source:: Source)

    -- if not requireOnly then
    --     if source.Init then
    --         source.Init()
    --     end
    -- end
end

return LoaderUtil
