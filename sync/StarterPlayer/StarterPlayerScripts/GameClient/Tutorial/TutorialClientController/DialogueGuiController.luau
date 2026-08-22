local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local TutorialClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.TutorialClientService)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local DialogueConfig = require(StarterPlayer.StarterPlayerScripts.GameClient.Tutorial.TutorialConfigs.DialogueConfig)

local DialogueGuiController = {}

DialogueGuiController.ReachedLastDialogue = Signal.new()
DialogueGuiController.EndedDialogue = Signal.new()
DialogueGuiController.NextDialogue = Signal.new()

local tutorialFolder = LocalPlayerUtil.playerGui.Tutorial
local dialogueGui = tutorialFolder.Dialogue
local bottomContainer = dialogueGui.BottomContainer
local backgroundFrame = bottomContainer.BackgroundFrame
local dialogueFrame = backgroundFrame.DialogueFrame
local dialogueText = dialogueFrame.DialogueText
local skipButton = dialogueFrame.Skip

local currentDialogueIndex = 1
local guiBin = {}
local perDialogueBin = {}

local SKIP_BUTTON_DEFAULTS = {
    position = skipButton.Position;
}
local BACKGROUND_FRAME_DEFAULTS = {
    position = backgroundFrame.Position;
}
local BACKGROUND_FRAME_DEFOCUSED_POSITION = UDim2.fromScale(
    BACKGROUND_FRAME_DEFAULTS.position.X.Scale, 
    (dialogueGui.AbsoluteSize.Y / backgroundFrame.AbsoluteSize.Y) * backgroundFrame.Size.Y.Scale
);
local DIALOGUE_OPTIONS_TOTAL = #DialogueConfig.DIALOGUE_OPTIONS

local frameFocusTween = TweenService:Create(
    backgroundFrame,
    TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
    {
        Position = BACKGROUND_FRAME_DEFAULTS.position;
    }
)
local frameDefocusTween = TweenService:Create(
    backgroundFrame,
    TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
    {
        Position = BACKGROUND_FRAME_DEFOCUSED_POSITION;
    }
)
local frameBounceTween = TweenService:Create(
    backgroundFrame,
    TweenInfo.new(.15, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 0, true),
    {
        Position = BACKGROUND_FRAME_DEFAULTS.position + UDim2.fromScale(.0025, 0)
    }
)

local skipFocusTween = TweenService:Create(
    skipButton,
    GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Rotation = 2.5;
        Position = SKIP_BUTTON_DEFAULTS.position + UDim2.fromScale(.005, 0);
    }
)
local skipDefocusTween = TweenService:Create(
    skipButton,
    GuiConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Rotation = 0;
        Position = SKIP_BUTTON_DEFAULTS.position;
    }
)
local skipProcessTween = TweenService:Create(
    skipButton,
    TweenInfo.new(.125, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 0, true),
    {
        Rotation = 6;
        Position = SKIP_BUTTON_DEFAULTS.position + UDim2.fromScale(.01, 0);
    }
)

local function unfocusBackgroundFrame()
    backgroundFrame.Position = BACKGROUND_FRAME_DEFOCUSED_POSITION
end

local function toggleSkipButton(isVisible: boolean)
    skipButton.Visible = isVisible
end

local function nextDialogue(skipAnimation: boolean?)
    CleanupUtil.Clean(perDialogueBin)

    currentDialogueIndex += 1; do 
        -- last dialogue signal
        if currentDialogueIndex == DIALOGUE_OPTIONS_TOTAL then
            DialogueGuiController.ReachedLastDialogue:Fire()
        end
    end

    local dialogueCallback = DialogueConfig.DIALOGUE_OPTIONS[currentDialogueIndex]; do
        -- dialogue ended signals
        if not dialogueCallback then
            DialogueGuiController.EndedDialogue:Fire()
            return
        end
    end

    local dialogueString = dialogueCallback()
    local dialogueStringLen, _ = utf8.len(dialogueString)
    local dialogueTweenDuration = (dialogueStringLen or 0) * DialogueConfig.TWEEN_TIME_PER_CHARACTER
    
    dialogueText.Text = dialogueString

    if not skipAnimation then
        CleanupUtil.InsertBin(perDialogueBin, TweenService:Create(
            dialogueText,
            TweenInfo.new(dialogueTweenDuration, Enum.EasingStyle.Linear),
            {
                MaxVisibleGraphemes = utf8.len(dialogueString);
            }
        )):Play()

        dialogueText.MaxVisibleGraphemes = 0
        frameBounceTween:Play()
    end

    CleanupUtil.InsertBin(perDialogueBin, task.delay(dialogueTweenDuration + DialogueConfig.DIALOGUE_COOLDOWN, function()
        DialogueGuiController.NextDialogue:Fire()
    end))
end

function DialogueGuiController.Init()
    dialogueGui.Enabled = true
    unfocusBackgroundFrame()
end

function DialogueGuiController.StartDialogue()
    -- init
    do
        currentDialogueIndex = 0
        toggleSkipButton(false)

        dialogueText.Text = ""

        -- frame tweening (in)
        do
            frameFocusTween:Play()
        end
    end

    -- after frame has fully focused!
    CleanupUtil.Clean(guiBin, frameFocusTween.Completed:Once(function()
        toggleSkipButton(true)

        -- dialogue
        do
            nextDialogue()
            CleanupUtil.InsertBin(guiBin, DialogueGuiController.NextDialogue:Connect(function()
                nextDialogue()
            end))

            CleanupUtil.InsertBin(guiBin, DialogueGuiController.EndedDialogue:Connect(function()
                frameDefocusTween:Play()
                CleanupUtil.InsertBin(guiBin, frameDefocusTween.Completed:Once(function()
                    DialogueGuiController.StopDialogue()
                end))
            end))
        end

        -- skip button
        do
            CleanupUtil.InsertBin(guiBin, skipButton.MouseEnter:Connect(function()
                skipFocusTween:Play()
            end))
            CleanupUtil.InsertBin(guiBin, skipButton.MouseLeave:Connect(function()
                skipDefocusTween:Play()
            end))
            CleanupUtil.InsertBin(guiBin, skipButton.Activated:Connect(function()
                skipProcessTween:Play()
                DialogueGuiController.NextDialogue:Fire()
            end))
            
            CleanupUtil.InsertBin(guiBin, DialogueGuiController.ReachedLastDialogue:Connect(function()
                toggleSkipButton(false)
            end))
        end
    end))
end

function DialogueGuiController.StopDialogue()
    TutorialClientService.HasTutorialEnded:Fire()

    CleanupUtil.Clean(guiBin)
    dialogueGui.Enabled = false
end

return DialogueGuiController
