AddCSLuaFile()

ENT.Type = "nextbot"
ENT.Base = "base_nextbot"
ENT.Category = "Categoria Sasata"
ENT.PrintName = "Dark Sasi"
ENT.Spawnable = true

resource.AddFile("materials/darksasi/darksasi.png")

function ENT:Initialize()
end

local NPC = {
    Name = "Dark Sasi",
    Class = "darksasi",
    Category = "Categoria Sasata",
    Model = "models/hunter/plates/plate1x1.mdl",
    Icon = "materials/entities/darksasi/darksasi.png"
}

list.Set("SpawnableEntities", "darksasi", NPC)