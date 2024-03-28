--------------------------------------------------------
-- [Client] Gameplay - Ballin' Handler
--------------------------------------------------------

---- // Types
type directionGetter = (CamCFrame: CFrame) -> Vector3

---- // Dependencies
local ballinLibrary = require(game:GetService("ReplicatedStorage").Modules.client.ballinLib)
local keybindsLibrary = require(game:GetService("ReplicatedStorage").Modules.client.keybindsLib)
local userInputService = game:GetService("UserInputService")

local jumpSound = require(script.Parent.Parent.sounds.jump)

---- // Variables
local player = game.Players.LocalPlayer

local keybinds : {[Enum.KeyCode]: directionGetter} = {
    [Enum.KeyCode.W] = function(CamCFrame: CFrame) return CamCFrame.LookVector end,
    [Enum.KeyCode.S] = function(CamCFrame: CFrame) return -CamCFrame.LookVector end,
    [Enum.KeyCode.A] = function(CamCFrame: CFrame) return -CamCFrame.RightVector end,
    [Enum.KeyCode.D] = function(CamCFrame: CFrame) return CamCFrame.RightVector end
}

local jumpKeybind = Enum.KeyCode.Space
local sprintKeybind = Enum.KeyCode.LeftShift

---- // Main
-- // ball setup
-- wait for character to laod
player.CharacterAdded:Wait()

-- set localplayer to be ballin'
ballinLibrary:setBallin()

-- // ball control
-- general movement
for keybind, getDirection in pairs(keybinds) do
    keybindsLibrary:setKeyCallback(keybind, function(isReleased)
        if isReleased then
            return
        end

        -- begin movement loop
        while task.wait(0) do
            -- end movement if player lets go of movement key
            if not userInputService:IsKeyDown(keybind) then
                return
            end

            -- get movement direction
            local camera = game.Workspace.CurrentCamera
            local movementDirection = getDirection(camera.CFrame) * 2

            -- move player in the aforementioned direction
            ballinLibrary:moveBallin(userInputService:IsKeyDown(sprintKeybind) and movementDirection * 2 or movementDirection)
        end
    end)
end

-- jumping
keybindsLibrary:setKeyCallback(jumpKeybind, function(isReleased)
    if isReleased then
        return
    end

    ballinLibrary:jumpBallin(7)
end)

-- // ball events
ballinLibrary.events.jump:connect(function()
    jumpSound:play()
end)