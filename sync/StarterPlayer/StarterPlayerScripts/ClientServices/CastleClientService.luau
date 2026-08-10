local CastleClientService = {}

local ISLAND_ORIENTATIONS = {
    [1] = CFrame.Angles(0, math.rad(-90), 0);
    [2] = CFrame.Angles(0, math.rad(0), 0);
    [3] = CFrame.Angles(0, math.rad(90), 0);
    [4] = CFrame.Angles(0, math.rad(-180), 0);
}

function CastleClientService.RenderPlayerIslands()
    for _, orientation in ISLAND_ORIENTATIONS do
        
    end
end

return CastleClientService
