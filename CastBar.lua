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

    function frame:ApplyStyle(style)
        -- style.font, style.texture, style.colors, etc.
        -- use LSM later if you want
    end

    return frame
end
