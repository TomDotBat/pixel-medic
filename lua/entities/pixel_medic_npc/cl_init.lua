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
    if not IsValid(npc) then return end

    if IsValid(PIXEL.MedicMenu) then
        PIXEL.MedicMenu:Remove()
        PIXEL.MedicMenu = nil
    end

    local frame = vgui.Create("PIXEL.Frame")
    PIXEL.MedicMenu = frame
    frame:SetTitle("Medic")
    frame:SetSize(PIXEL.Scale(260), PIXEL.Scale(124))
    frame:Center()
    frame:MakePopup()

    local buttonContainer = vgui.Create("Panel", frame)
    buttonContainer:Dock(BOTTOM)
    local btnPad = PIXEL.Scale(4)
    buttonContainer:DockMargin(btnPad, btnPad, btnPad, btnPad)
    buttonContainer.Paint = nil
    buttonContainer:SetHeight(frame:GetTall() * .22)

    local messageLabel = vgui.Create("PIXEL.Label", frame)
    messageLabel:SetText("Would you like medical assistance?\nHP: " .. DarkRP.formatMoney(npc.Config.HealthCost) .. "   AP: " .. DarkRP.formatMoney(npc.Config.ArmourCost))
    messageLabel:SetFont("Medic.Description")
    messageLabel:SetTextAlign(TEXT_ALIGN_CENTER)
    messageLabel:SetAutoHeight(true)
    messageLabel:SetAutoWrap(true)
    messageLabel:Center()
    messageLabel:Dock(FILL)
    messageLabel:DockMargin(0, 0, 0, 0)

    local healthButton = vgui.Create("PIXEL.TextButton", buttonContainer)
    healthButton:SetText("Buy Health")
    healthButton:SetWide(frame:GetWide() * .4)
    healthButton:Dock(LEFT)

    healthButton.DoClick = function()
        net.Start("PIXEL.Medic.GiveHealth")
        net.WriteEntity(npc)
        net.SendToServer()
        frame:Remove()
    end

    local armorButton = vgui.Create("PIXEL.TextButton", buttonContainer)
    armorButton:SetText("Buy Armor")
    armorButton:SetWide(frame:GetWide() * .4)
    armorButton:Dock(RIGHT)

    armorButton.DoClick = function()
        net.Start("PIXEL.Medic.GiveArmour")
        net.WriteEntity(npc)
        net.SendToServer()
        frame:Remove()
    end
end)