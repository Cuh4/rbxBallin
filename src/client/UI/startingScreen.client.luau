--------------------------------------------------------
-- [Client] UI - Starting Screen
--------------------------------------------------------

---- // Dependencies
local UILibrary = require(game:GetService("ReplicatedStorage").Modules.client.UILib)

local ambienceMusic = require(script.Parent.Parent.sounds.ambience)
local startMenuMusic = require(script.Parent.Parent.sounds.startMenu)

---- // Variables
local UI = UILibrary:getUI("StartingScreen", true)

local root: Frame = UI.Root
local startButton: TextButton = root.StartButton
local backgroundImage: ImageLabel = root.Background

---- // Main
-- Show UI
UILibrary:showUI("StartingScreen")

-- Play start menu music
local music = startMenuMusic:play()

-- Set up button callbacks
startButton.MouseButton1Click:Connect(function()
    -- stop music
    music:Stop()

    -- animate root away
    root:TweenPosition(UDim2.fromScale(0, -1), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.45)

    -- hide ui
    task.wait(0.45)
    UILibrary:hideUI("StartingScreen")

    -- play ambience music
    ambienceMusic:play()
end)

-- Animate background to music
while music.Playing do
    -- animation variables
    local duration = 0.01
    local xScale = 1
    local yScale = 1
    local loudness = music.PlaybackLoudness / 1000 -- 0 - 1

    -- animate
    backgroundImage:TweenSize(
        UDim2.fromScale(xScale + (loudness / 5), yScale + (loudness / 5)),
        Enum.EasingDirection.InOut,
        Enum.EasingStyle.Quad,
        duration
    )

    -- wait for animation to complete
    task.wait(duration)
end