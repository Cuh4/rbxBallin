--------------------------------------------------------
-- [Module] Client - Keybinds Library
--------------------------------------------------------

---- // Types
type keyCallback = (isReleased: boolean) -> nil

---- // Variables
local userInputService = game:GetService("UserInputService")

---- // Library
-- // Declaration
keybindsLibrary = {}

-- // Functions
function keybindsLibrary:setKeyCallback(key: Enum.KeyCode, callback: keyCallback)
	userInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end

		if input.KeyCode == key then
			callback(false)
		end
	end)

	userInputService.InputEnded:Connect(function(input, processed)
		if processed then
			return
		end

		if input.KeyCode == key then
			callback(true)
		end
	end)
end

-- // Return
return keybindsLibrary