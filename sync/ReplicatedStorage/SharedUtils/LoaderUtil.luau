local LoaderUtil = {}

export type Source = {
    Init: (() -> ())?;
    Start: (() -> ())?;
}
type SourceData = {
    source: ModuleScript;
    sourceType: number
}
type Scope = {
    sources: {SourceData};
}

local SOURCE_TYPES = {
    Require = 1;
    Boot = 2;
}
local BOOT_METHODS = {
    Init = "Init";
    Start = "Start";
}

local scopes = { n = 0; }:: { n: number, [number]: Scope }

local function createSourceData(source: ModuleScript, sourceType: number): SourceData
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

local function getCurrentScope(): Scope
    local currentScope = scopes[scopes.n]
    assert(currentScope, "LoaderUtil has no active scope")
    return currentScope
end

local function pushRequireToScope(source: ModuleScript)
    local currentScope = getCurrentScope()
    table.insert(
        currentScope.sources,
        createSourceData(source, SOURCE_TYPES.Require)
    )
end

local function pushBootToScope(source: ModuleScript)
    local currentScope = getCurrentScope()
    table.insert(
        currentScope.sources,
        createSourceData(source, SOURCE_TYPES.Boot)
    )
end

local function executeModules(sources: {Source}, method: string)
    for _, source in sources do
        local methodFunction = (source:: {[any]: () -> ()})[method]
        if methodFunction then
            methodFunction()
        end
    end
end

local function processScopeModules(scope: Scope)
    local init = {}:: {Source}
    local start = {}:: {Source}

    for _, sourceData in scope.sources do
        local module = require(sourceData.source):: any

        if sourceData.sourceType == SOURCE_TYPES.Boot then
            table.insert(init, module)
            table.insert(start, module)
        end
    end

    executeModules(init, BOOT_METHODS.Init)
    executeModules(start, BOOT_METHODS.Start)
end

function LoaderUtil.scope(moduleCallback: () -> ())
    local scope = createScope()
    pushScope(scope)

    -- process modules within scope
    do
        moduleCallback()
        processScopeModules(scope)
    end
end

function LoaderUtil.Require(source: ModuleScript)
    pushRequireToScope(source)
end

function LoaderUtil.Boot(source: ModuleScript)
    pushBootToScope(source)
end

return LoaderUtil
