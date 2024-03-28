--------------------------------------------------------
-- [Module] Client - Smooth Camera Library
--------------------------------------------------------

---- // Variables
local tweenService = game:GetService("TweenService")

---- // Library
-- // Declaration
smoothCameraLibrary = {}

-- // Functions
function smoothCameraLibrary:setSmoothCamera(offset: Vector3|nil, easeStyle: Enum.EasingStyle|nil, followDelay: number|nil, useAsynchronously: boolean|nil)
	-- defaults
	offset = offset or Vector3.new(0, 2.5, 0)
	easeStyle = easeStyle or Enum.EasingStyle.Quad
	followDelay = followDelay or 0.05
	useAsynchronously = useAsynchronously or false

	-- main smooth camera code
	local function instantiate()
		-- get localplayer and their character
		local player = game.Players.LocalPlayer
		local character = player.Character

		if not character then
			error("Player has no character")
			return
		end

		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		-- get camera
		local camera = workspace.CurrentCamera

		-- setup camera part
		local cameraPart = Instance.new("Part")
		cameraPart.Name = "SmoothCameraTrack"
		cameraPart.Transparency = 1
		cameraPart.Anchored = true
		cameraPart.CanCollide = false
		cameraPart.Parent = character

		-- make camera follow part
		camera.CameraSubject = cameraPart

		-- make camera part track character
		while task.wait() do
			local tween = tweenService:Create(
				cameraPart,
				TweenInfo.new(followDelay, easeStyle, Enum.EasingDirection.InOut),
				{
					Position = humanoidRootPart.Position
				}
			)

			tween:Play()
		end
	end

	-- start smooth camera bits and bobs
	if useAsynchronously then
		task.spawn(instantiate)
	else
		instantiate()
	end
end

-- // Return
return smoothCameraLibrary