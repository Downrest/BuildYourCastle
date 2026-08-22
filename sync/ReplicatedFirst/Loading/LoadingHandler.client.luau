local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

StarterPlayer:WaitForChild("StarterPlayerScripts")
local LoadingClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.LoadingClientService)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local loadingFolder = ReplicatedFirst.Loading
local loadingAssets = loadingFolder.LoadingAssets
local loadingGui = loadingAssets.Loading
local loadingContainer = loadingGui.LoadingContainer
local progressBar = loadingContainer.ProgressBar

local PROGRESS_BAR_DEFAULTS = {
    size = progressBar.Size;
}
local PRELOAD_ASSET = {}:: {any}; do
    table.insert(PRELOAD_ASSET, loadingGui)
    for _, asset in loadingGui:GetDescendants() do
        table.insert(PRELOAD_ASSET, asset)
    end
end
local PRELOAD_ASSET_AMOUNT = #PRELOAD_ASSET

local containerDefocusTween = TweenService:Create(
    loadingContainer,
    TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
    {
        Position = UDim2.fromScale(0, 1)
    }
)

local function updateProgressBar(ratio: number)
    TweenService:Create(
        progressBar,
        TweenInfo.new(.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {
            Size = UDim2.fromScale(
                ratio,
                PROGRESS_BAR_DEFAULTS.size.Y.Scale
            )
        }
    ):Play()
end

local function exitGui()
    containerDefocusTween:Play()
    containerDefocusTween.Completed:Once(function()
        loadingGui.Enabled = false
    end)
end

local function insertGui()
    loadingGui.Enabled = true
    loadingGui.Parent = LocalPlayerUtil.playerGui
end

do
    updateProgressBar(0)
    insertGui()

    for index, asset in PRELOAD_ASSET do
        ContentProvider:PreloadAsync({asset})
        updateProgressBar(index / PRELOAD_ASSET_AMOUNT)
    end

    -- has loaded
    do
        LoadingClientService.HasLoaded:Fire()
        exitGui()
    end
end