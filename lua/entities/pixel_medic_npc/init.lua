AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( )
	self:SetModel("models/Humans/Group03m/male_09.mdl")
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		//self:EmitSound("vo/npc/male01/hi02.wav",self:GetPos())

		net.Start("PIXEL.Medic.OpenMenu")
		 net.WriteEntity(self)
		net.Send(caller)
	end
end

function ENT:OnTakeDamage()
	return false
end

net.Receive("PIXEL.Medic.GiveHealth", function(length, activator)
	local npc = net.ReadEntity()
	if !(npc and IsValid(npc)) then return end
	if npc:GetClass() != "pixel_medic_npc" then return end
	if !npc.Config.MaxUseDistance or activator:GetPos():Distance(npc:GetPos()) > npc.Config.MaxUseDistance then return end

	if !activator:canAfford(npc.Config.HealthCost) then
		DarkRP.notify(activator, 1, 4, "You can't afford that.")
		return ""
	end

	if activator:Health() < npc.Config.MaxHealth then
		activator:addMoney(-npc.Config.HealthCost)
		activator:SetHealth(npc.Config.MaxHealth)

		DarkRP.notify(activator, 0, 4, "Purchased health for " .. DarkRP.formatMoney(npc.Config.HealthCost) .. "!")
	else
		DarkRP.notify(activator, 1, 4, "You already have full health.")
	end
end)

net.Receive("PIXEL.Medic.GiveArmour", function(length, activator)
	local npc = net.ReadEntity()
	if !(npc and IsValid(npc)) then return end
	if npc:GetClass() != "pixel_medic_npc" then return end
	if !npc.Config.MaxUseDistance or activator:GetPos():Distance(npc:GetPos()) > npc.Config.MaxUseDistance then return end

	if !activator:canAfford(npc.Config.ArmourCost) then
		DarkRP.notify(activator, 1, 4, "You can't afford that.")
		return ""
	end

	if activator:Armor() < npc.Config.MaxArmour then
		activator:addMoney(-npc.Config.ArmourCost)
		activator:SetArmor(npc.Config.MaxArmour)

		DarkRP.notify(activator, 0, 4, "Purchased Armor for " .. DarkRP.formatMoney(npc.Config.ArmourCost) .. "!")
	else
		DarkRP.notify(activator, 1, 4, "You already have full armor.")
	end
end)

util.AddNetworkString("PIXEL.Medic.GiveHealth")
util.AddNetworkString("PIXEL.Medic.GiveArmour")
util.AddNetworkString("PIXEL.Medic.OpenMenu")