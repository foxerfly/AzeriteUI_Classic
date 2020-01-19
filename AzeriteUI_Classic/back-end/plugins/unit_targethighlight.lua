-- Lua API
local _G = _G

-- WoW API
local UnitIsUnit = _G.UnitIsUnit

local Update = function(self, event, unit, ...)
	if (not unit) or (unit ~= self.unit) then 
		return 
	end 
	local element = self.TargetHighlight
	if element.PreUpdate then
		element:PreUpdate(unit)
	end

	-- Hide if the owner is too transparent
	if (self:GetAlpha() < 0.1) then 
		element:Hide()

	-- Don't highlight the focus frame as the current focus
	elseif element.showFocus and (unit ~= "focus") and UnitIsUnit("focus", unit) then 
		if element.colorFocus then 
			element:SetVertexColor(element.colorFocus[1], element.colorFocus[2], element.colorFocus[3], element.colorFocus[4])
		end
		element:Show()

	-- Don't highlight the target frame nor the tot frame as the current target
	elseif element.showTarget and (unit ~= "target") and (unit ~= "targettarget") and UnitIsUnit("target", unit) then 
		if element.colorTarget then 
			element:SetVertexColor(element.colorTarget[1], element.colorTarget[2], element.colorTarget[3], element.colorTarget[4])
		end
		element:Show()
	else
		element:Hide()
	end

	if element.PostUpdate then 
		return element:PostUpdate(unit)
	end
end 

local Proxy = function(self, ...)
	return (self.TargetHighlight.Override or Update)(self, ...)
end 

local ForceUpdate = function(element)
	return Proxy(element._owner, "Forced", element._owner.unit)
end

local Enable = function(self)
	local element = self.TargetHighlight
	if element then
		element._owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("PLAYER_TARGET_CHANGED", Proxy, true)
		self:RegisterEvent("GROUP_ROSTER_UPDATE", Proxy, true)

		return true 
	end
end 

local Disable = function(self)
	local element = self.TargetHighlight
	if element then
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		element:Hide()
	end
end 

-- Register it with compatible libraries
for _,Lib in ipairs({ (Wheel("LibUnitFrame", true)), (Wheel("LibNamePlate", true)) }) do 
	Lib:RegisterElement("TargetHighlight", Enable, Disable, Proxy, 6)
end 
