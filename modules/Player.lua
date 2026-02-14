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
    self.playerBar = self.CastBar:Create("GranitePlayerCastBar", UIParent)
    self.playerBar:SetPoint("CENTER", 0, -200)
    self.playerBar:Show()

    -- Later: register events and drive updates
end
