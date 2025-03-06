AddCSLuaFile()
include("entities/darksasi_triggerzone/shared.lua")

function ENT:Initialize()
    self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    self:SetNoDraw(true)
    self:SetCollisionBounds(Vector(-500, -500, 0), Vector(500, 500, 1000))

    
end

function ENT:StartTouch(ent)
    print("Toccando qualcosa")
    if ent:IsPlayer() then
        print("Toccando giocatore! " .. ent:Nick())
        self:GetParent():SetEnemy(ent)
    end
end

function ENT:EndTouch(ent)
    if ent.IsPlayer() then
        self:GetParent():RemoveEnemy()
    end
end