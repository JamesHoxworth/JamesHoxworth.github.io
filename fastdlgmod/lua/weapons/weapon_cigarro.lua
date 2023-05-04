
--oy vey

if CLIENT then
	include('weapon_cigarrobase/cl_init.lua')
else
	include('weapon_cigarrobase/shared.lua')
end

if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("1517464837")
end 

SWEP.PrintName = "Cigarette"
SWEP.Instructions = "cancer"

SWEP.cigaAccentColor = nil

if CLIENT then
   SWEP.PrintName       = "Cigarette"
   SWEP.Slot            = 8

   SWEP.ViewModelFlip   = false

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "Q"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind               = WEAPON_SATAN
SWEP.AutoSpawnable = false
SWEP.InLoadoutFor = {ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE}
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true

SWEP.cigaID = 4
SWEP.ViewModel = "models/jellik/cigarette.mdl"
SWEP.WorldModel = "models/jellik/cigarette.mdl"

--me chupa
JuicycigaJuices = {
	{name = "Derby", color = Color(60,60,60,255)},
	{name = "Marlboro", color = Color(210,211,200,255)},
	{name = "Gudang", color = Color(255,158,158,255)},
	{name = "San Marino", color = Color(0,0,0,255)},
	{name = "Camel", color = Color(255,252,145,255)},
	{name = "Sobranie", color = Color(191,191,0,255)},
	{name = "Lucky Strike", color = Color(140,181,255,255)},
	{name = "Dunhill", color = Color(185,185,185,255)},
	{name = "Minister", color = Color(155,155,155,255)},
	{name = "Carlton", color = Color(133,133,133,255)},
	{name = "Black", color = Color(164,255,165,255)},
}

if SERVER then
	function SWEP:Initialize2()
		self.juiceID = 0
		timer.Simple(1.1, function() SendcigaJuice(self, JuicycigaJuices[self.juiceID+1]) end)
	end

	util.AddNetworkString("cigaTankColor")
	util.AddNetworkString("cigaMessage")
end

function SWEP:SecondaryAttack()
	if SERVER then
		if not self.juiceID then self.juiceID = 0 end
		self.juiceID = (self.juiceID + 1) % (#JuicycigaJuices)
		SendcigaJuice(self, JuicycigaJuices[self.juiceID+1])

		--Client hook isn't called in singleplayer
		if game.SinglePlayer() then	self.Owner:SendLua([[surface.PlaySound("weapons/smg1/switch_single.wav")]]) end
	else
		if IsFirstTimePredicted() then
			surface.PlaySound("weapons/smg1/switch_single.wav")
		end
	end
end

if SERVER then
	function SendcigaJuice(ent, tab)
		local col = tab.color
		if col then
			local min = math.min(col.r,col.g,col.b)*0.8
			col = (Vector(col.r-min, col.g-min, col.b-min)*1.0)/255.0
		else
			col = Vector(-1,-1,-1)
		end
		net.Start("cigaTankColor")
		net.WriteEntity(ent)
		net.WriteVector(col)
		net.Broadcast()

		if IsValid(ent.Owner) then
			net.Start("cigaMessage")
			net.WriteString("Trocado para "..tab.name.."")
			net.Send(ent.Owner)
		end
	end
else
	net.Receive("cigaTankColor", function()
		local ent = net.ReadEntity()
		local col = net.ReadVector()
		if IsValid(ent) then ent.cigaTankColor = col end
	end)

	cigaMessageDisplay = ""
	cigaMessageDisplayTime = 0

	net.Receive("cigaMessage", function()
		cigaMessageDisplay = net.ReadString()
		cigaMessageDisplayTime = CurTime()
	end)

	hook.Add("HUDPaint", "cigaDrawJuiceMessage", function()
		local alpha = math.Clamp((cigaMessageDisplayTime+3-CurTime())*1.5,0,1)
		if alpha == 0 then return end

		surface.SetFont("Trebuchet24")
		local w,h = surface.GetTextSize(cigaMessageDisplay)
		draw.WordBox(8, ((ScrW() - w)/2)-8, ScrH() - (h + 24), cigaMessageDisplay, "Trebuchet24", Color(0,0,0,128*alpha), Color(255,255,255,255*alpha))
	end)
end

function SWEP:Holster()
	if SERVER and IsValid(self.Owner) then
		Releaseciga(self.Owner)
	end
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:Holster()
	if SERVER and IsValid(self.Owner) then
		Releaseciga(self.Owner)
	end
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:PreDrop()
   if SERVER and IsValid(self.Owner) and self.Primary.Ammo != "none" then
      local ammo = self:Ammo1()

      -- Do not drop ammo if we have another gun that uses this type
      for _, w in pairs(self.Owner:GetWeapons()) do
         if IsValid(w) and w != self and w:GetPrimaryAmmoType() == self:GetPrimaryAmmoType() then
            ammo = 0
         end
      end

      self.StoredAmmo = ammo

      if ammo > 0 then
         self.Owner:RemoveAmmo(ammo, self.Primary.Ammo)
      end
   end

   if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end

SWEP.OnDrop = SWEP.Holster
SWEP.OnRemove = SWEP.Holster