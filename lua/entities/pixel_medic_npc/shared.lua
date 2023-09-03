--[[
    PIXEL Medic
    Copyright (C) 2023 Tom O'Sullivan (Tom.bat)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Medic NPC"
ENT.Category = "PIXEL Medic"
ENT.Author = "Tom."
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.IsPIXELMedicNPC = true

ENT.Config = {
    HealthCost = 2000,
    ArmourCost = 4500,
    MaxHealth = 100,
    MaxArmour = 100,
    MaxUseDistance = 400
}