-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile()
end

if CLIENT then
   SWEP.PrintName = "AAC Honey Badger"
   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/icon_ttt_honeybadger"
   
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "A ."
   };
end

-- Always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

-- Standard GMod values
SWEP.HoldType = "ar2"

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Delay = 0.082
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Damage = 24
SWEP.Primary.Cone = .023
SWEP.Primary.IronAccuracy = .014 
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.Sound = Sound( "Weapon_honeybadger.Single" )

-- Model properties
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.ViewModel = Model( "models/weapons/ttt_honeybadger/v_ttt_honeybadger.mdl" )
SWEP.WorldModel = Model( "models/weapons/ttt_honeybadger/w_aac_honeybadger.mdl" )

SWEP.IronSightsPos = Vector(-3.096, -3.695, 0.815)
SWEP.IronSightsAng = Vector(0.039, 0, 0)

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
   util.PrecacheSound( "weapons/ttt_honeybadger/honeybadger-1.wav" )
end

-- Give the primary sound an alias
sound.Add ( {
   name = "Weapon_honeybadger.Single",
   channel = CHAN_USER_BASE + 10,
   volume = 1.0,
   sound = "weapons/ttt_honeybadger/honeybadger-1.wav"
} )

sound.Add({
	name = 			"Weapon_honeybadger.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_honeybadger/magout.mp3"
})

sound.Add({
	name = 			"Weapon_honeybadger.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_honeybadger/magin.mp3"
})

sound.Add({
	name = 			"Weapon_honeybadger.Boltcatch",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_honeybadger/boltcatch.mp3"
})

sound.Add({
	name = 			"Weapon_honeybadger.Boltforward",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_honeybadger/boltforward.mp3"
})

sound.Add({
	name = 			"Weapon_honeybadger.Boltback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_honeybadger/boltback.mp3"
})