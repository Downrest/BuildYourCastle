local DialogueConfig = {}

local currentPlayer

function DialogueConfig.Init(player: Player)
    currentPlayer = player
end

DialogueConfig.TWEEN_TIME_PER_CHARACTER = 0.0325
DialogueConfig.DIALOGUE_COOLDOWN = 2.5
DialogueConfig.DIALOGUE_OPTIONS = {
    function()
        return `Welcome, {currentPlayer}! We've been waiting for you.`
    end;
    function()
        return `This was once a great castle, but now it's quiet. The people need a new ruler.`
    end;
    function()
        return `One day, this could all be yours!`
    end;
    function()
        return `Every great castle starts small. Let's build it together!`
    end;
}

return DialogueConfig
