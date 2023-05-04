--[[Author informations]]--
SWEP.Author = "Zaratusa"
SWEP.Contact = "http://steamcommunity.com/profiles/76561198032479768"

if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("253737175")
else
	LANG.AddToLanguage("english", "m3s90_name", "M3S90")

	SWEP.PrintName = "m3s90_name"
	SWEP.Slot = 2
	SWEP.Icon = "vgui/ttt/icon_m3s90"

	-- client side model settings
	SWEP.UseHands = true -- should the hands be displayed
	SWEP.ViewModelFlip = false -- should the weapon be hold with the left or the right hand
	SWEP.ViewModelFOV = 58
end

-- always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

--[[Default GMod values]]--
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Delay = 1.4
SWEP.Primary.Recoil	= 7
SWEP.Primary.Cone = 0.1
SWEP.Primary.Damage = 8
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 8
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.NumShots = 13

--[[Model settings]]--
SWEP.HoldType = "shotgun"
SWEP.ViewModel = Model("models/weapons/cstrike/c_shot_m3super90.mdl")
SWEP.WorldModel	= Model("models/weapons/w_shot_m3super90.mdl")

SWEP.IronSightsPos = Vector(-7.65, -10, 3.4)
SWEP.IronSightsAng = Vector(-0.2, 0, 0)

--[[TTT config values]]--

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_HEAVY

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2,
-- then this gun can be spawned as a random weapon.
SWEP.AutoSpawnable = true

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_box_buckshot_ttt"

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false

SWEP.reloadtimer = 0

function SWEP:SetupDataTables()
	self:DTVar("Bool", 0, "reloading")
	return self.BaseClass.SetupDataTables(self)
end

function SWEP:CanPrimaryAttack()
	if (self:Clip1() <= 0) then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitSound("Weapon_Shotgun.Empty")
		return false
	end

	return true
end

function SWEP:SecondaryAttack()
	if ((not self.dt.reloading) and (not self.NoSights) and self.IronSightsPos) then
		self:SetNextSecondaryFire(CurTime() + 0.3)
		self:SetIronsights(not self:GetIronsights())
	end
end

function SWEP:Reload()
	if ((not self.dt.reloading) and IsFirstTimePredicted()
		and self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self:StartReload()
	end
end

function SWEP:StartReload()
	if (not self.dt.reloading) then
		self:SetIronsights(false)
		if (IsFirstTimePredicted()) then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			if (self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
				self.reloadtimer = CurTime() + self:SequenceDuration()
				self.dt.reloading = true
			end
		end
	end
end

function SWEP:Deploy()
	self.dt.reloading = false
	self.reloadtimer = 0
	return self.BaseClass.Deploy(self)
end

function SWEP:Think()
	if (self.dt.reloading and IsFirstTimePredicted()) then
		if (self.Owner:KeyDown(IN_ATTACK)) then
			self:FinishReload()
			return
		end

		if (self.reloadtimer <= CurTime()) then
			if (self.Owner:GetAmmoCount(self.Primary.Ammo)) <= 0 then
				self:FinishReload()
			elseif (self:Clip1() < self.Primary.ClipSize) then
				self:PerformReload()
			else
				self:FinishReload()
			end
		end
	end
end

function SWEP:PerformReload()
	-- Prevent normal shooting in between reloads
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if (self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self:SendWeaponAnim(ACT_VM_RELOAD)
		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self.reloadtimer = CurTime() + self:SequenceDuration()
	end
end

function SWEP:FinishReload()
	self.reloadtimer = CurTime() + self:SequenceDuration()
	self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
	self.dt.reloading = false
end

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	local att = dmginfo:GetAttacker()

	if (IsValid(att)) then
		local dist = victim:GetPos():Distance(att:GetPos())
		local d = math.max(0, dist - 140)

		-- Decay from 3.1 to 1 slowly as distance increases
		return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.25)))
	else
		return 3
	end
end
