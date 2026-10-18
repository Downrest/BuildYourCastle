local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local TweenInfoUtil = require(ReplicatedStorage.SharedUtils.TweenInfoUtil)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local GuiController = {}

local playerGui = LocalPlayerUtil.playerGui

local interfaceGui = playerGui.Interface
local leftContainer = interfaceGui.LeftContainer
local leftButtonFrame = leftContainer.LeftButtonFrame
local indexButton = leftButtonFrame.Index
local indexButtonIcon = indexButton.Icon

local indexGui = playerGui.Index
local indexContainer = indexGui.IndexContainer
local listContainer = indexContainer.ListContainer
local indexClose = indexContainer.Close
local indexFrameIcon = indexContainer.IndexIcon
local indexDiscovered = indexContainer.IndexDiscovered
local indexTitle = indexContainer.IndexTitle

local INDEX_BUTTON_DEFAULT = {
    size = indexButton.Size;
}
local INDEX_BUTTON_ICON_DEFAULT = {
    size = indexButtonIcon.Size;
    rotation = indexButtonIcon.Rotation;
}
local INDEX_CLOSE_DEFAULT = {
    size = indexClose.Size;
    position = indexClose.Position;
}
local INDEX_FRAME_ICON_DEFAULT = {
    size = indexFrameIcon.Size;
    position = indexFrameIcon.Position;
}
local INDEX_DISCOVERED_DEFAULT = {
    size = indexDiscovered.Size;
    position = indexDiscovered.Position;
}
local INDEX_TITLE_DEFAULT = {
    size = indexTitle.Size;
    position = indexTitle.Position;
}
local INDEX_CONTAINER_DEFAULT = {
    size = indexContainer.Size;
    position = indexContainer.Position;
}
local INDEX_CONTAINER_DEFOCUS_POSITION = INDEX_CONTAINER_DEFAULT.position + UDim2.fromScale(0, 1)

local INDEX_MOUNT_TWEEN_INFO = TweenInfo.new(
    GuiConfig.MENU_FOCUS_TWEEN_INFO.Time,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.In,
    0,
    true
)

--[[
    INTERFACE BUTTON
]]
local indexButtonIconFocusTween = TweenService:Create(
    indexButtonIcon,
    GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = INDEX_BUTTON_ICON_DEFAULT.size + UDim2.fromScale(.15, .15);
        Rotation = 10;
    }
)
local indexButtonFocusTween = TweenService:Create(
    indexButton,
    GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = INDEX_BUTTON_DEFAULT.size + UDim2.fromScale(.075, .075)
    }
)
local indexButtonIconDefocusTween = TweenService:Create(
    indexButtonIcon,
    GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = INDEX_BUTTON_ICON_DEFAULT.size;
        Rotation = INDEX_BUTTON_ICON_DEFAULT.rotation;
    }
)
local indexButtonDefocusTween = TweenService:Create(
    indexButton,
    GuiConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = INDEX_BUTTON_DEFAULT.size
    }
)

--[[
    FRAME
]]
local indexContainerFocusTween = TweenService:Create(
    indexContainer,
    GuiConfig.MENU_FOCUS_TWEEN_INFO,
    {
        Position = INDEX_CONTAINER_DEFAULT.position
    }
)
local indexContainerDefocusTween = TweenService:Create(
    indexContainer,
    GuiConfig.MENU_DEFOCUS_TWEEN_INFO,
    {
        Position = INDEX_CONTAINER_DEFOCUS_POSITION
    }
)
local indexFrameIconMountTween = TweenService:Create(
    indexFrameIcon,
    INDEX_MOUNT_TWEEN_INFO,
    {
        Position = INDEX_FRAME_ICON_DEFAULT.position - UDim2.fromScale(.02, 0);
        Rotation = 25;
    }
)
local indexTitleMountTween = TweenService:Create(
    indexTitle,
    INDEX_MOUNT_TWEEN_INFO,
    {
        Position = INDEX_TITLE_DEFAULT.position - UDim2.fromScale(.015, 0)
    }
)
local indexCloseTriggerTween = TweenService:Create(
    indexClose,
    TweenInfo.new(
        .015,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out,
        0,
        true
    ),
    {
        Size = INDEX_CLOSE_DEFAULT.size + UDim2.fromScale(.15, .15)
    }
)
local indexCloseFocusTween = TweenService:Create(
    indexClose,
    GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = INDEX_CLOSE_DEFAULT.size + UDim2.fromScale(.025, .025)
    }
)
local indexCloseDefocusTween = TweenService:Create(
    indexClose,
    GuiConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = INDEX_CLOSE_DEFAULT.size
    }
)

local guiBin = Janitor.new()

local isIndexVisible = false

function GuiController.ToggleIndex(isVisible: boolean)
    if isVisible then
        indexContainerFocusTween:Play()

        -- mount tween
        do
            indexFrameIconMountTween:Play()
            indexTitleMountTween:Play()
        end
    else
        indexContainerDefocusTween:Play()
    end
end

function GuiController.Mount()
    do
        indexGui.Enabled = true
        indexContainer.Position = INDEX_CONTAINER_DEFOCUS_POSITION
    end

    -- index button
	do
        guiBin:Add(indexButton.MouseEnter:Connect(function()
            indexButtonIconFocusTween:Play()
            indexButtonFocusTween:Play()
        end))
    
        guiBin:Add(indexButton.MouseLeave:Connect(function()
            indexButtonIconDefocusTween:Play()
            indexButtonDefocusTween:Play()
        end))
    
        guiBin:Add(indexButton.Activated:Connect(function()
            isIndexVisible = not isIndexVisible
    
            GuiController.ToggleIndex(isIndexVisible)
        end))
	end

    -- index frame
    do
        -- index close
        do
            guiBin:Add(indexClose.MouseEnter:Connect(function()
                indexCloseFocusTween:Play()
            end))
        
            guiBin:Add(indexClose.MouseLeave:Connect(function()
                indexCloseDefocusTween:Play()
            end))
        
            guiBin:Add(indexClose.Activated:Connect(function()
                isIndexVisible = not isIndexVisible
        
                indexCloseTriggerTween:Play()
                GuiController.ToggleIndex(isIndexVisible)
            end))
        end
    end
end

function GuiController.Dismount()
    indexGui.Enabled = false
	guiBin:Cleanup()
end


return GuiController
