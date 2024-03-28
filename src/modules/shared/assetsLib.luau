--------------------------------------------------------
-- [Module] Shared - Assets Library
--------------------------------------------------------

---- // Library
-- // Declaration
assetsLibrary = {
	assetsPath = game:GetService("ReplicatedStorage"):WaitForChild("Assets")
}

-- // Functions
function assetsLibrary:getAsset(category: string, name: string): Instance
	local categoryInstance = self.assetsPath:WaitForChild(category)

	if not categoryInstance then
		error("Failed to find asset category")
		return
	end

	local asset = categoryInstance:WaitForChild(name)

	if not asset then
		error("Failed to find asset")
		return
	end

	return asset
end

-- // Return
return assetsLibrary