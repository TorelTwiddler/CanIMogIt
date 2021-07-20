local _, P = ...;

local _M = {  };
local _F = CreateFrame('FRAME');

local function OnEvent(self, event, addon)
	addon = addon:lower();
	local method = _M[addon];
	if method ~= nil then
		xpcall(method, geterrorhandler());
		_M[addon] = nil;
		if next(_M) == nil then
			_F:SetScript("OnEvent", nil);
			_F:UnregisterEvent("ADDON_LOADED");
		end
	end
end

function P:RegisterAddOnCallback(addon, method)
	if IsAddOnLoaded(addon) then
		xpcall(method, geterrorhandler());
	else
		_M[addon:lower()] = method;
		_F:RegisterEvent("ADDON_LOADED");
		_F:SetScript("OnEvent", OnEvent);
	end
end
