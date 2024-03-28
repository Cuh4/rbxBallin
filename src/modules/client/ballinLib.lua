--------------------------------------------------------
-- [Module] Client - Ballin' Library
--------------------------------------------------------

---- // Dependencies
local assetsLibrary = require(game:GetService("ReplicatedStorage").Modules.shared.assetsLib)
local eventsLibrary = require(game:GetService("ReplicatedStorage").Modules.shared.eventsLib)

---- // Library
-- // Declaration
ballinLibrary = {}

-- // Variables
ballinLibrary.player = game.Players.LocalPlayer
ballinLibrary.ballModel = assetsLibrary:getAsset("Models", "Ball") :: Part

-- // Configuration
ballinLibrary.configuration = {
	maxSpeed = 50
}

-- // Events
ballinLibrary.events = {
	jump = eventsLibrary:new(true),
	move = eventsLibrary:new(true)
}

-- // Functions
-- Returns the ballin' player's ball
function ballinLibrary:getBallin(): Part
	if not self.player.Character then
		error("Player has no character")
		return
	end

	return self.player.Character:FindFirstChild(self.ballModel.Name)
end

-- Clamp a number under the max speed
function ballinLibrary:limitSpeed(speed: number)
	return math.clamp(speed, -self.configuration.maxSpeed, self.configuration.maxSpeed)
end

-- Is the ballin' player touching the ground
function ballinLibrary:isGrounded()
	local ball = self:getBallin(self.player)

	if not ball then
		error("Player is not ballin'")
		return
	end

	local raycastParams = RaycastParams.new()
	raycastParams.RespectCanCollide = true -- prevent raycast hitting humanoid root part

	local result = game.Workspace:Raycast(
		ball.Position,
		Vector3.new(0, -ball.Size.Y / 2, 0),
		raycastParams
	)

	return result and result.Distance < (ball.Size.Y / 1.3) or false
end

-- Move the ballin' player
function ballinLibrary:moveBallin(direction: Vector3)
	local ball = self:getBallin(self.player)

	if not ball then
		error("Player is not ballin'")
		return
	end

	ball.AssemblyLinearVelocity += Vector3.new(direction.X, 0, direction.Z)
	self:limitBallin(self.player)

	ballinLibrary.events.move:fire(self.player, ball.AssemblyLinearVelocity)
end

-- Jump the ballin' player
function ballinLibrary:jumpBallin(jumpForce: number)
	local ball = self:getBallin(self.player)

	if not ball then
		error("Player is not ballin'")
		return
	end

	if not self:isGrounded(self.player) then
		warn("Player attempted to jump when not grounded")
		return
	end

	ball.AssemblyLinearVelocity += Vector3.new(0, jumpForce * 7, 0)
	self:limitBallin(self.player)

	ballinLibrary.events.jump:fire(self.player, jumpForce, ball.AssemblyLinearVelocity)
end

-- Limit the ballin' player's speed
function ballinLibrary:limitBallin()
	local ball = self:getBallin(self.player)

	if not ball then
		error("Player is not ballin'")
		return
	end

	ball.AssemblyLinearVelocity = Vector3.new(
		self:limitSpeed(ball.AssemblyLinearVelocity.X),
		ball.AssemblyLinearVelocity.Y,
		self:limitSpeed(ball.AssemblyLinearVelocity.Z)
	)
end

-- Set the local player to be ballin'
function ballinLibrary:setBallin()
	-- get the player's character
	local character = self.player.Character :: Model

	if not character then
		error("Player has no character")
		return
	end

	-- remove the player's bodyparts
	local toRemove = {
		["BasePart"] = true,
		["Accessory"] = true,
		["Shirt"] = true,
		["Pants"] = true,
		["BodyColors"] = true,
		["MeshPart"] = true
	}

	local exceptions = {
		["HumanoidRootPart"] = true
	}

	for _, bodyPart in pairs(character:GetChildren()) do
		if not toRemove[bodyPart.ClassName] then
			continue
		end

		if exceptions[bodyPart.Name] then
			continue
		end

		bodyPart:Destroy()
	end

	-- get main character parts
	local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart

	-- setup character
	humanoid.PlatformStand = true
	humanoidRootPart.CanCollide = false
	humanoidRootPart.Massless = true

	-- clone the ball asset
	local ball = self.ballModel:Clone()
	ball.CFrame = humanoidRootPart.CFrame
	ball.Parent = character

	-- weld to character
	local weld = Instance.new("WeldConstraint")
	weld.Parent = humanoidRootPart
	weld.Part0 = humanoidRootPart
	weld.Part1 = ball
end

-- // Return
return ballinLibrary