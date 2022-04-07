include("shared.lua")

function ENT:Initialize()
    self.AutomaticFrameAdvance = true
end

function ENT:Draw()
    self:DrawModel()
    PIXEL.DrawNPCOverhead(self, "Medic", nil, nil, 0.04)
end

PIXEL.RegisterFont("Medic.Description", "Open Sans SemiBold", 18)

net.Receive("PIXEL.Medic.OpenMenu", function()
    local npc = net.ReadEntity()
    if not (npc and IsValid(npc)) then return end

    if IsValid(PIXEL.MedicMenu) then
        PIXEL.MedicMenu:Remove()
        PIXEL.MedicMenu = nil
    end

    local frame = vgui.Create("PIXEL.Frame")
    frame:SetTitle("Medic")
    frame:SetSize(PIXEL.Scale(260), PIXEL.Scale(124))
    frame:Center()
    frame:MakePopup()

    local btns = vgui.Create("Panel", frame)
    btns:Dock(BOTTOM)

    local btnPad = PIXEL.Scale(4)
    btns:DockMargin(btnPad, btnPad, btnPad, btnPad)
    btns.Paint = nil
    btns:SetHeight(frame:GetTall() * .22)

    local subtext = vgui.Create("PIXEL.Label", frame)
    subtext:SetText("Would you like medical assistance?\nHP: " .. DarkRP.formatMoney(npc.Config.HealthCost) .. "   AP: " .. DarkRP.formatMoney(npc.Config.ArmourCost))
    subtext:SetFont("Medic.Description")
    subtext:SetTextAlign(TEXT_ALIGN_CENTER)
    subtext:SetAutoHeight(true)
    subtext:SetAutoWrap(true)
    subtext:Center()
    subtext:Dock(FILL)
    subtext:DockMargin(0, 0, 0, 0)

    local button_health = vgui.Create("PIXEL.TextButton", btns)
    button_health:SetText("Buy Health")
    button_health:SetWide(frame:GetWide() * .4)
    button_health:Dock(LEFT)

    button_health.DoClick = function()
        net.Start("PIXEL.Medic.GiveHealth")
        net.WriteEntity(npc)
        net.SendToServer()
        frame:Remove()
    end

    local button_disable = vgui.Create("PIXEL.TextButton", btns)
    button_disable:SetText("Buy Armor")
    button_disable:SetWide(frame:GetWide() * .4)
    button_disable:Dock(RIGHT)

    button_disable.DoClick = function()
        net.Start("PIXEL.Medic.GiveArmour")
        net.WriteEntity(npc)
        net.SendToServer()
        frame:Remove()
    end
end)

PIXEL.MedicMenu = frame