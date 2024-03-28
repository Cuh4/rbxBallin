--------------------------------------------------------
-- [Module] Client - UI Library
--------------------------------------------------------

---- // Library
-- // Declaration
UILibrary = {}

-- // Variables
UILibrary.UIPath = game.Players.LocalPlayer.PlayerGui

-- // Functions
-- Retrieve UI. Raises an error if it doesn't exist
function UILibrary:getUI(name: string, shouldWait: boolean): ScreenGui
	local UI = self.UIPath:FindFirstChild(name)

	if not UI and not shouldWait then
		error("Could not find UI matching the name: "..name)
		return
	end

	if not UI and shouldWait then
		UI = self.UIPath:WaitForChild(name)
	end

	if not UI:IsA("ScreenGui") then
		error("Found UI matching the name, but it is not a ScreenGui")
		return
	end

	return UI
end

function UILibrary:showUI(name: string)
	local UI = self:getUI(name)
	UI.Enabled = true
end

function UILibrary:hideUI(name: string)
	local UI = self:getUI(name)
	UI.Enabled = false
end

function UILibrary:toggleUI(name: string)
	local UI = self:getUI(name)
	UI.Enabled = not UI.Enabled
end

-- // Return
return UILibrary