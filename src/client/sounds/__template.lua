--------------------------------------------------------
-- [Client] Sounds - Template
--------------------------------------------------------

---- // Dependencies
local soundsLibrary = require(game:GetService("ReplicatedStorage").Modules.shared.soundsLib)

---- // Library
-- // Declaration
template = {}

-- // Functions
function template:construct(soundName: string, parent: Instance, looping: boolean?, volume: number?, customAttributes: {[string] : any}?)
    local soundHolder = {}
    soundHolder.soundPath = parent

    function soundHolder:play(): Sound
        self.sound = soundsLibrary:play(soundName, self.soundPath, looping, volume, customAttributes)
        return self.sound
    end

    function soundHolder:stop()
        if not self.sound then
            error("No sound to stop")
            return
        end

        self.sound:Stop()
    end

    return soundHolder
end

-- // Return
return template