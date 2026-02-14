--[[
-- Granite - Modular casting bar for Retail WoW (12.0.1)
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
local Granite = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0")

ns.Granite = Granite

function Granite:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GraniteDB", {
        profile = {
            modules = { ["*"] = true },
            placeholderOption = true,
        },
    }, true)
    self:RegisterChatCommand("granite", "OnSlashCommand")
end

function Granite:OnSlashCommand(input)
    if input == "" or input == "config" then
        if self.settingsCategory then
            Settings.OpenToCategory(self.settingsCategory:GetID())
        else
            self:Print("Granite options will go here. Use /granite lock to unlock bars.")
        end
    elseif input == "lock" then
        self:Print("Lock/unlock will be implemented with the cast bars.")
    else
        self:Print("Usage: /granite [config|lock]")
    end
end

function Granite:OnEnable()
    self:Print("Granite loaded. Use /granite to configure.")
    self:RegisterSettings()

    local frame = CreateFrame("Frame", "GraniteTestFrame", UIParent)
    frame:SetSize(200, 20)
    frame:SetPoint("CENTER")
    frame:Show()

    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetColorTexture(1, 0, 0, 0.35) -- red, 35% alpha

    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    text:SetPoint("CENTER")
    text:SetText("Granite Test Frame")
end
