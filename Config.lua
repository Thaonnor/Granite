--[[
-- Granite - Config (options UI)
-- Copyright (C) 2025 Thaonnor
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY. See the COPYING file for full license text.
]]

-- Registers the addon options with the Blizzard Settings panel (Escape > System > Settings).
-- Granite.lua calls Granite:RegisterSettings() from OnEnable; this file implements it.

local ADDON_NAME, ns = ...
local Granite = ns.Granite

function Granite:RegisterSettings()
    if not Settings then return end
    local category, layout = Settings.RegisterVerticalLayoutCategory("Granite")

    local function GetValue()
        return self.db.profile.placeholderOption
    end

    local function SetValue(value)
        self.db.profile.placeholderOption = value
    end

    local setting = Settings.RegisterProxySetting(category, "GRANITE_PLACEHOLDER_OPTION",
        Settings.VarType.Boolean, "Placeholder option", true, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting)

    Settings.RegisterAddOnCategory(category)
    self.settingsCategory = category
end
