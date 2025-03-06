include("entities/darksasi/shared.lua")
resource.AddFile("materials/entities/darksasi/darksasi.png")

AddCSLuaFile()

function ENT:BehaveStart()
    -- Aggiungiamo un print per verificare che BehaveStart venga chiamata
    print("BehaveStart chiamato!")
    
    -- Creiamo la coroutine per eseguire RunBehaviour
    self.BehaveThread = coroutine.create(function() 
        print("Coroutine creata!") -- Verifica che la coroutine venga creata
        self:RunBehaviour() 
    end)
    
    -- Avviamo la coroutine
    local success, err = coroutine.resume(self.BehaveThread)
    if not success then
        print("Errore nell'avviare la coroutine: " .. err)
    else
        print("Coroutine avviata con successo!")
    end
end

function ENT:Initialize() -- "self" è l'entità

    self:SetModel( "models/props_c17/fence01a.mdl" )
    self:SetModelScale(5, 0)
    self:SetMaterial("entities/darksasi/darksasi")
    
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(Vector(-5, -5, 0), Vector(5, 5, 5)) 


    self:DeclareVariables()

    --self.triggerZone = self:CreateTriggerZone() nn funziona! :(
end

function ENT:DeclareVariables()
    self.Enemy = nil
    
    self.minChasingSpeed = 100
    self.maxChasingSpeed = 750
    self.chasingSpeed = self.minChasingSpeed

    self.killDistance = 10

    self.nextChatMessageTime = CurTime()
    self.chatMessageDelay = 25
end

function ENT:SetEnemy(ent)
    self.Enemy = ent
    -- print("New enemy: " .. self.Enemy:Nick())
end

function ENT:RemoveEnemy()
    self.Enemy = nil
    -- print("Lost enemy!")
end

function ENT:GetEnemy()
    if (self.Enemy) then
        print("Current enemy is: " .. self.Enemy:Nick())
    else
        print("No enemy!")
    end
    return self.Enemy
end

function ENT:CreateTriggerZone()
    local trigger = ents.Create("darksasi_triggerzone")
    trigger:SetPos(self:GetPos())
    trigger:SetParent(self)
    trigger:Spawn()
    return trigger
end

function ENT:RunBehaviour()
    while (true) do
    
        local player = self:GetNearestPlayer()

        if (player and IsValid(player)) then
            self:SetEnemy(player)
            self:ChaseEnemy()
            self:CheckForChatMessage()
        end

        coroutine.yield()
    end
end

function ENT:GetNearestPlayer()

    local players = player.GetAll()
    
    local closestDistance = 0
    local firstIteration = 0
    local closestPlayer = nil

    for _, ply in ipairs(players) do 

        local distance = ply:GetPos():Distance(self:GetPos())

        if (firstIteration == 0) then
            closestDistance = distance
            closestPlayer = ply
            firstIteration = 1
        end

        if (distance < closestDistance) then
            closestPlayer = ply
        end
    end

    return closestPlayer
end

function ENT:GetRandomPlayer()
    
    local players = player.GetAll()
    local randomNumber = math.random(0, player.GetCount())
    local counter = 0

    for _, ply in ipairs(players) do
        if (counter == randomNumber) then
            return ply
        end
        counter = counter + 1
    end

    return self.Enemy
end

function ENT:ChaseEnemy( options )

	local options = options or {}
	local path = Path( "Follow" )
	
    path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemy's position

	if ( !path:IsValid() ) then 
        return "failed" 
    end

	while ( path:IsValid() and self:GetEnemy() ) do
	
		if ( path:GetAge() > 0.1 ) then	-- Since we are following the player we have to constantly remake the path
			path:Compute(self, self.Enemy:GetPos()) -- Compute the path towards the enemy's position again
		end

		path:Update( self )	-- This function moves the bot along the path
		
		if ( options.draw ) then 
            path:Draw() 
        end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"
end

function ENT:LookAtEnemy()
    self.loco:FaceTowards(self.Enemy:GetPos())
end

function ENT:DamageEnemy()

    if (IsValid(self.Enemy) and self.Enemy:Health() <= 0) then
        self:KillEnemy()
        return
    end

    local damageInfo = DamageInfo() -- Oggetto che specifica il danno
    damageInfo:SetDamage(50)
    damageInfo:SetAttacker(self)
    damageInfo:SetInflictor(self)
    damageInfo:SetDamageType(DMG_BLAST)
    self.Enemy:TakeDamageInfo(damageInfo) -- Passiamo il danno alla vittima
end

function ENT:KillEnemy()
    print(self.Enemy:Nick() .. " è stato sasato!")
    self:SendDeathMessage()
    self:ResetSpeed()
    self.Enemy = nil
end

function ENT:ResetSpeed()
    self.chasingSpeed = 100
end

function ENT:SendDeathMessage()
    local message = "Sei stato sasato!"
    self.Enemy:PrintMessage(HUD_PRINTCENTER, message)
end

function ENT:CheckForChatMessage()
    if (self.nextChatMessageTime - CurTime() > 0) then
        return
    end

    self:SendChatMessage()
    self.nextChatMessageTime = CurTime() + self.chatMessageDelay
end

function ENT:SendChatMessage()
    local msg_number = math.random(1, 5)
    local ply = self:GetRandomPlayer()
    local message = ""

    if (!IsValid(ply)) then
        return
    end

    if (msg_number == 1) then
        message = ply:Nick() .. "...sento la tua paura."
    end

    if (msg_number == 2) then
        message = ply:Nick() .. " sto per smerdarti!"
    end

    if (msg_number == 3) then
        message = ply:Nick() .. ", sai cosa significa 'diventare un panzerotto'?"
    end

    if (msg_number == 4) then
        message = ply:Nick() .. " verrai sasato."
    end

    if (msg_number == 5) then
        message = ply:Nick() .. " E' FINITA"
    end

    if (ply == "Antonio") then
        message = "Ci può essere solo un Sasy..."
        player:PrintMessage(HUD_PRINTCENTER, message)
        return
    end

    if (ply == "nikkete") then
        message = "Nicooooolami ancora...."
        player:PrintMessage(HUD_PRINTCENTER, message)
        return
    end

    --if(player == "Enzo Becchino") then
        --message = "La tua carne nella mia bolognese gnam gnam..."
        --self.Enemy:PrintMessage(HUD_PRINTCENTER, message)
        --return
    --end

    --if(player == "fabry40") then
        --message = "Signor Fabrizio, sto venendo a sasarla."
        --self.Enemy:PrintMessage(HUD_PRINTCENTER, message)
        --return
    --end

    player:PrintMessage(HUD_PRINTTALK, message)
end

function ENT:OnRemove()
    if IsValid(self.triggerZone) then
        self.triggerZone:Remove()
    end

    PrintMessage(HUD_PRINTTALK, "DARK SASI RITORNERA'!!!!")
end