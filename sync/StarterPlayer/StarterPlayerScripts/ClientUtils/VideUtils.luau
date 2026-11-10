local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local VideUtils = {}

function VideUtils.scope(
    callback: (
        bin: Janitor.Janitor,
        cleanup: (cleanupCallback: () -> ()) -> ()
    ) -> ()
): () -> ()
    return Vide.root(function()
        local bin = Janitor.new()

        callback(bin, function(cleanupCallback: () -> ())
            bin:Add(cleanupCallback)
        end)

        Vide.cleanup(function()
            bin:Cleanup()
        end)
    end)
end

return VideUtils
