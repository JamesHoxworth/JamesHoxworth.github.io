-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile()
end

if CLIENT then
   SWEP.PrintName = "HK MP5"
   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/icon_ttt_mp5"
   
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "A submachine gun developed in the 1960s."
   };
end

-- Always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

-- Standard GMod values
SWEP.HoldType = "ar2"


SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Delay = 0.1
SWEP.Primary.Recoil = 0.15
SWEP.Primary.Damage = 22
SWEP.Primary.Cone = .023
SWEP.Primary.IronAccuracy = .013
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.Sound = Sound( "Weapon_mp5.Single" )
SWEP.Secondary.IronFOV = 55

-- Model properties
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 70
SWEP.ViewModel = Model( "models/weapons/ttt_mp5/v_ttt_mp5.mdl" )
SWEP.WorldModel = Model( "models/weapons/ttt_mp5/w_hk_mp5.mdl" )

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(2.549, -0.927, 1.09)
SWEP.IronSightsAng = Vector(0.125, -0.071, 0)

-- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_HEAVY

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = true

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

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
   util.PrecacheSound( "weapons/ttt_mp5/mp5-1.wav" )
end

-- Give the primary sound an alias
sound.Add ( {
   name = "Weapon_mp5.Single",
   channel = CHAN_USER_BASE + 10,
   volume = 1.0,
   sound = "weapons/ttt_mp5/mp5-1.wav"
} )

sound.Add({
	name = 			"Weapon_mp5.magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/magout.mp3"
})

sound.Add({
	name = 			"Weapon_mp5.magin1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/magin1.mp3"
})

sound.Add({
	name = 			"Weapon_mp5.magin2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/magin2.mp3"
})

sound.Add({
	name = 			"Weapon_mp5.foley",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/foley.mp3"
})

sound.Add({
	name = 			"Weapon_mp5.boltback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/boltback.mp3"
})

sound.Add({
	name = 			"Weapon_mp5.boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/boltslap.mp3"
})

sound.Add({
	name = 			"Weapon_mp5.cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/cloth.mp3"
})

sound.Add({
	name = 			"Weapon_mp5.safety",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_mp5/safety.mp3"
})