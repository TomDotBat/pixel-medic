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

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Humans/Group03m/male_09.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
end

function ENT:AcceptInput(name, activator, caller)
	if name == "Use" and caller:IsPlayer() then
		net.Start("PIXEL.Medic.OpenMenu")
		net.WriteEntity(self)
		net.Send(caller)
	end
end

function ENT:OnTakeDamage()
	return false
end

local function isPlayerNearNpc(ply, npc)
	if not IsValid(npc) then
		return false
	end

	if not npc.IsPIXELMedicNPC then
		return false
	end

	if not npc.Config.MaxUseDistance or ply:GetPos():Distance(npc:GetPos()) > npc.Config.MaxUseDistance then
		return false
	end

	return true
end

net.Receive("PIXEL.Medic.GiveHealth", function(_, ply)
	local npc = net.ReadEntity()
	if not isPlayerNearNpc(ply, npc) then
		return
	end

	if not ply:canAfford(npc.Config.HealthCost) then
		DarkRP.notify(ply, 1, 4, "You can't afford that.")
		return
	end

	if ply:Health() < npc.Config.MaxHealth then
		ply:addMoney(-npc.Config.HealthCost)
		ply:SetHealth(npc.Config.MaxHealth)
		DarkRP.notify(ply, 0, 4, "Purchased health for " .. DarkRP.formatMoney(npc.Config.HealthCost) .. "!")
	else
		DarkRP.notify(ply, 1, 4, "You already have full health.")
	end
end)

net.Receive("PIXEL.Medic.GiveArmour", function(_, ply)
	local npc = net.ReadEntity()
	if not isPlayerNearNpc(ply, npc) then
		return
	end

	if not ply:canAfford(npc.Config.ArmourCost) then
		DarkRP.notify(ply, 1, 4, "You can't afford that.")
		return
	end

	if ply:Armor() < npc.Config.MaxArmour then
		ply:addMoney(-npc.Config.ArmourCost)
		ply:SetArmor(npc.Config.MaxArmour)
		DarkRP.notify(ply, 0, 4, "Purchased Armor for " .. DarkRP.formatMoney(npc.Config.ArmourCost) .. "!")
	else
		DarkRP.notify(ply, 1, 4, "You already have full armor.")
	end
end)

util.AddNetworkString("PIXEL.Medic.GiveHealth")
util.AddNetworkString("PIXEL.Medic.GiveArmour")
util.AddNetworkString("PIXEL.Medic.OpenMenu")