--------------------------------------------------------
-- [Client] Gameplay - Smooth Camera
--------------------------------------------------------

---- // Dependencies
local smoothCameraLibrary = require(game:GetService("ReplicatedStorage").Modules.client.smoothCameraLib)

---- // Variables
local player = game.Players.LocalPlayer

---- // Main
player.CharacterAdded:Wait()
smoothCameraLibrary:setSmoothCamera()