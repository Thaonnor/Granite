--[[
-- Granite - Player cast bar module
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

local ADDON_NAME, ns = ...
local Granite = ns.Granite

function Granite:EnablePlayerModule()
    -- Create the bar
    self.playerBar = self.CastBar:Create("GranitePlayerCastBar", UIParent)
    self.playerBar:SetShown(self.db.profile.playerCastbarEnabled)

    -- Position
    self.playerBar:ClearAllPoints()
    self.playerBar:SetPoint("CENTER", UIParent, "CENTER", 0, -275)

    -- Apply saved test mode on startup
    if self.db.profile.playerCastbarTest and self.playerBar.SetTestMode then
        self.playerBar:SetTestMode(true)
    end

    -- Event driver
    local driver = CreateFrame("Frame")
    driver:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
    driver:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
    driver:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
    driver:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
    driver:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "player")

    -- Channel Events
    driver:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
    driver:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
    driver:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")

    -- Minimal handler: refresh bar from UnitCastingInfo / UnitChannelInfo
    driver:SetScript("OnEvent", function()
        if not Granite.db.profile.playerCastbarEnabled then
            Granite.playerBar:Hide()
            return
        end

        -- Guard (so test mode works)
        if Granite.playerBar._testMode then
            return
        end

        Granite:UpdatePlayerCastBar()
    end)

    -- Initial refresh (in case we're already casting on reload)
    self:UpdatePlayerCastBar()
end

function Granite:UpdatePlayerCastBar()
    local bar = self.playerBar
    if not bar then return end

    local name, _, texture, startMS, endMS = UnitCastingInfo("player")
    local isChannel = false

    if not name then
        name, _, texture, startMS, endMS = UnitChannelInfo("player")
        isChannel = name ~= nil
    end

    if not name then
        bar._casting = false
        if bar.StartFade then
            bar:StartFade()
        else
            bar:Hide()
        end
        return
    end

    bar:Show()
    bar._fading = false  -- Clear fade state
    bar:SetAlpha(1)      -- Reset to full opacity
    bar.Text:SetText(name)

    if bar.Icon then
        bar.Icon:SetTexture(texture)
        bar.Icon:SetShown(texture ~= nil)
    end

    -- Store timing so Cast Bar OnUpdate can drive progress
    bar._casting = true
    bar._startMS = startMS
    bar._endMS = endMS
    bar._isChannel = isChannel
end