
-- Lua API
local _G = _G

-- WoW API

local Update = function(self, event, unit, ...)
	if (not unit) or (unit ~= self.unit) then 
		return 
	end 
	local element = self.Totems
	if element.PreUpdate then
		element:PreUpdate(unit)
	end



	if element.PostUpdate then 
		return element:PostUpdate(unit)
	end
end 

local Proxy = function(self, ...)
	return (self.Totems.Override or Update)(self, ...)
end 

local ForceUpdate = function(element)
	return Proxy(element._owner, "Forced", element._owner.unit)
end

local Enable = function(self)
	local element = self.Totems
	if element then
		element._owner = self
		element.ForceUpdate = ForceUpdate

		return true 
	end
end 

local Disable = function(self)
	local element = self.Totems
	if element then
	end
end 

-- Register it with compatible libraries
for _,Lib in ipairs({ (Wheel("LibUnitFrame", true)), (Wheel("LibNamePlate", true)) }) do 
	Lib:RegisterElement("Totems", Enable, Disable, Proxy, 1)
end 
