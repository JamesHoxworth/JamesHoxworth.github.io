-- First some standard GMod stuff
if SERVER then
	AddCSLuaFile()
end

if CLIENT then
   SWEP.PrintName = "HK45C"
   SWEP.Slot = 1
   SWEP.Icon = "VGUI/ttt/icon_ttt_hk45"
   
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "A semi-automatic pistol."
   };
end

-- Always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

-- Standard GMod values
SWEP.HoldType = "pistol"

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Damage = 24
SWEP.Primary.Delay = 0.09
SWEP.Primary.Recoil = 0.35
SWEP.Primary.Cone = .025
SWEP.Primary.IronAccuracy = .015
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.ClipMax = 45
SWEP.Primary.Sound = Sound( "Weapon_hk45.Single" )
SWEP.Secondary.IronFOV = 55

-- Model properties
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ViewModel = Model( "models/weapons/ttt_hk45/v_ttt_hk45.mdl" )
SWEP.WorldModel = Model( "models/weapons/ttt_hk45/w_hk45c.mdl" )

SWEP.IronSightsPos = Vector(-2.32, 0, 0.86)
SWEP.IronSightsAng = Vector(0, 0, 0)

-- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_PISTOL

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = true

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, None.
SWEP.InLoadoutFor = { nil }

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false

-- Precache custom sounds
function SWEP:Initialize()
   self:SetHoldType( self.HoldType )
   util.PrecacheSound( "weapons/ttt_hk45/hk45-1.wav" )
end

-- Give the primary sound an alias
sound.Add ( {
   name = "Weapon_hk45.Single",
   channel = CHAN_USER_BASE + 10,
   volume = 1.0,
   sound = "weapons/ttt_hk45/hk45-1.wav"
} )

sound.Add({
	name = 			"Weapon_hk45.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_hk45/magout.mp3"
})

sound.Add({
	name = 			"Weapon_hk45.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_hk45/magin.mp3"
})

sound.Add({
	name = 			"Weapon_hk45.Release",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_hk45/sliderelease.mp3"
})

sound.Add({
	name = 			"Weapon_hk45.Slidepull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_hk45/slidepull.mp3"
})

sound.Add({
	name = 			"Weapon_hk45.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_hk45/draw.mp3"
})