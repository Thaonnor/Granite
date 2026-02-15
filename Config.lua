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

    -- Create & register root category first
    local root = Settings.RegisterVerticalLayoutCategory("Granite")
    Settings.RegisterAddOnCategory(root)

    -- Create subcategories under registered parent
    local general = Settings.RegisterVerticalLayoutSubcategory(root, "General")
    local player = Settings.RegisterVerticalLayoutSubcategory(root, "Player")

    -- ===========
    -- General
    -- ===========
    do
        local function GetEnabled()
            return addon.db.profile.enabled
        end

        local function SetEnabled(value)
            if addon.db and addon.db.profile then
                addon.db.profile.enabled = value
                if addon.ApplyAllSettings then addon:ApplyAllSettings() end
            end
        end

        local enabledSetting = Settings.RegisterProxySetting(
            general,
            "GRANITE_ENABLED",
            Settings.VarType.Boolean,
            "Enable Granite",
            true,
            GetEnabled,
            SetEnabled
        )

        Settings.CreateCheckbox(general, enabledSetting)
    end

    -- ===========
    -- Player
    -- ===========
    do
        local function GetPlayerEnabled()
            return addon.db.profile.playerCastbarEnabled
        end

        local function SetPlayerEnabled(value)
            local p = addon.db and addon.db.profile
            if p then
                p.playerCastbarEnabled = value
                if addon.playerBar then addon.playerBar:SetShown(value) end
            end
        end

        local playerEnabledSetting = Settings.RegisterProxySetting(
            player,
            "GRANITE_PLAYER_CASTBAR_ENABLED",
            Settings.VarType.Boolean,
            "Enable Player Cast Bar",
            true,
            GetPlayerEnabled,
            SetPlayerEnabled
        )

        Settings.CreateCheckbox(player, playerEnabledSetting)

        local function GetPlayerTest()
            return addon.db.profile.playerCastbarTest
        end

        local function SetPlayerTest(value)
            local p = addon.db and addon.db.profile
            if p then
                p.playerCastbarTest = value
                if addon.playerBar and addon.playerBar.SetTestMode then
                    addon.playerBar:SetTestMode(value)
                end
            end
        end

        local playerTestSetting = Settings.RegisterProxySetting(
            player,
            "GRANITE_PLAYER_CASTBAR_TEST",
            Settings.VarType.Boolean,
            "Show Test Cast",
            false,
            GetPlayerTest,
            SetPlayerTest
        )

        Settings.CreateCheckbox(player, playerTestSetting)

        -- Texture dropdown (only if LSM is available)
        if addon.LSM then
            local function GetPlayerTexture()
                return addon.db.profile.playerCastbarTexture or "Blizzard"
            end

            local function SetPlayerTexture(value)
                local p = addon.db and addon.db.profile
                if p then
                    p.playerCastbarTexture = value
                    if addon.playerBar and addon.ApplyPlayerBarStyle then
                        addon:ApplyPlayerBarStyle()
                    end
                end
            end

            local textureSetting = Settings.RegisterProxySetting(
                player,
                "GRANITE_PLAYER_CASTBAR_TEXTURE",
                Settings.VarType.String,
                "Bar Texture",
                "Blizzard",
                GetPlayerTexture,
                SetPlayerTexture
            )

            -- Build dropdown options from LSM
            local function GetTextureOptions()
                local container = Settings.CreateControlTextContainer()
                local textures = addon.LSM:List("statusbar")
                for _, textureName in ipairs(textures) do
                    container:Add(textureName, textureName)
                end
                return container:GetData()
            end

            Settings.CreateDropdown(player, textureSetting, GetTextureOptions, "Select a texture")
        end
    end

    -- Save root to avoid double-registering
    addon.settingsCategory = root
end
