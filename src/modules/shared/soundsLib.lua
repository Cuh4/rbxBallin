--------------------------------------------------------
-- [Module] Shared - Sounds Library
--------------------------------------------------------

---- // Dependencies
local assetsLibrary = require(game:GetService("ReplicatedStorage").Modules.shared.assetsLib)

---- // Library
-- // Declaration
soundsLibrary = {}

-- // Functions
function soundsLibrary:play(soundName: string, parent: Instance, looping: boolean?, volume: number?, customAttributes: {[string] : any}?)
	-- retrieve the sound
	local sound: Sound = assetsLibrary:getAsset("Sounds", soundName)

	if not sound then
		error("Failed to find sound")
		return
	end

	-- clone it and move it to the appropriate location
	sound = sound:Clone()
	sound.Parent = parent

	-- change attributes
	sound.Looped = looping or false
	sound.Volume = volume or 1

	if customAttributes then
		for index, value in pairs(customAttributes) do
			sound[index] = value
		end
	end

	-- play it
	sound:Play()

	if looping then
		return sound
	end

	-- remove sound after successful playback
	sound.Ended:Connect(function()
		sound:Destroy()
	end)

	-- return sound
	return sound
end

-- // Return
return soundsLibrary