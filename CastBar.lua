--[[
-- Granite - Cast bar frame
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

-- Shared cast bar frame logic. Modules (Player, Target, etc.) create bars via this.
local ADDON_NAME, ns = ...
local Granite = ns.Granite

Granite.CastBar = {}

function Granite.CastBar:Create(name, parent)
    local frame = CreateFrame("Frame", name, parent or UIParent)
    frame:SetSize(300, 24)

    -- Statusbar (the fill)
    frame.Status = CreateFrame("StatusBar", nil, frame)
    frame.Status:SetAllPoints(true)

    -- Background
    frame.BG = frame:CreateTexture(nil, "BACKGROUND")
    frame.BG:SetAllPoints(true)

    -- Text
    frame.Text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.Text:SetPoint("LEFT", 6, 0)

    -- Icon (optional)
    frame.Icon = frame:CreateTexture(nil, "ARTWORK")
    frame.Icon:SetSize(24, 24)
    frame.Icon:SetPoint("RIGHT", frame, "LEFT", -6, 0)
    frame.Icon:Hide()

    function frame:ApplyStyle(style)
        -- style.font, style.texture, style.colors, etc.
        -- use LSM later if you want
    end

    function frame:SetTestMode(enabled)
        self._testMode = enabled and true or false
        if self._testMode then
            self:Show()

            -- Basic visuals so I can see it working
            self.Status:SetMinMaxValues(0, 1)
            self.Status:SetValue(0.35)
            self.Status:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")

            self.BG:SetColorTexture(0, 0, 0, 0.35)

            self.Text:SetText("Test Cast")

            self.Icon:SetTexture(136243) -- question mark icon
            self.Icon:Show()
        else
            self:Hide()
        end
    end

    frame:SetScript("OnUpdate", function(self, elapsed)
        if not self._testMode then return end
        
        -- lazy init (in case test mode was enabled before reload)
        self._testStart = self._testStart or GetTime()
        self._testDuration = self._testDuration or 3.0

        local t = GetTime() - self._testStart
        local dur = self._testDuration
        local p = (t % dur) / dur

        self.Status:SetMinMaxValues(0, 1)
        self.Status:SetValue(p)
    end)

    return frame
end
