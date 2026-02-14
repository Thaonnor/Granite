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

    if self.settingsCategory then return end -- don't double-register

    local addon = self -- capture for closures

    local category = Settings.RegisterVerticalLayoutCategory("Granite")

    local function GetValue()
        return addon.db and addon.db.profile and addon.db.profile.placeholderOption or true
    end

    local function SetValue(value)
        if addon.db and addon.db.profile then
            addon.db.profile.placeholderOption = value
        end
    end

    local setting = Settings.RegisterProxySetting(
        category, 
        "GRANITE_PLACEHOLDER_OPTION",
        Settings.VarType.Boolean, 
        "Placeholder option", 
        true, 
        GetValue, 
        SetValue
    )

    Settings.CreateCheckbox(category, setting)
    Settings.RegisterAddOnCategory(category)

    addon.settingsCategory = category
end
