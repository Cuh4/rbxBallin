--------------------------------------------------------
-- [Module] Shared - Events Library
--------------------------------------------------------

---- // Library
-- // Declaration
eventsLibrary = {}

-- // Functions
function eventsLibrary:new(callbacksAsync: boolean)
	local event = {
		isAsync = callbacksAsync,
		callbacks = {}
	}

	function event:fire(...)
		for _, callback in pairs(self.callbacks) do
			if self.isAsync then
				task.spawn(callback, ...)
			else
				callback(...)
			end
		end
	end

	function event:connect(callback: () -> any)
		table.insert(self.callbacks, callback)
	end

	return event
end

-- // Return
return eventsLibrary