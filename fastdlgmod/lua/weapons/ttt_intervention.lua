-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile()
end

if CLIENT then
   SWEP.PrintName = "Intervention"
   SWEP.Slot = 6
   SWEP.Icon = "VGUI/ttt/icon_ttt_intervention"
   
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "A very powerful sniper rifle."
   };
end

-- Always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

-- Standard GMod values
SWEP.HoldType = "rpg"

SWEP.Primary.Ammo = "357"
SWEP.Primary.Delay = 1
SWEP.Primary.Recoil = 0.6
SWEP.Primary.Damage = 80
SWEP.Primary.Cone = .01
SWEP.Primary.IronAccuracy = .0001
SWEP.HeadshotMultiplier = 4
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.ClipMax = 60
SWEP.Primary.Sound = Sound( "Weapon_intervention.Single" )
SWEP.Secondary.Sound = Sound("Default.Zoom")

-- Model properties
SWEP.UseHands = true
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 70
SWEP.ViewModel = Model( "models/weapons/ttt_intervention/v_ttt_intervention.mdl" )
SWEP.WorldModel = Model( "models/weapons/ttt_intervention/w_snip_int.mdl" )

SWEP.IronSightsPos = Vector (2.2263, -0.0007, 0.115)
SWEP.IronSightsAng = Vector (0, 0, 0)

-- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_EQUIP1

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = false

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_357_ttt"

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = { ROLE_DETECTIVE }

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = true

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
   self:SetHoldType(self.HoldType)
   util.PrecacheSound( "weapons/ttt_intervention/intervention-1.wav" )
end

-- Give the primary sound an alias
sound.Add ( {
   name = "Weapon_intervention.Single",
   channel = CHAN_USER_BASE + 10,
   volume = 1.0,
   sound = "weapons/ttt_intervention/intervention-1.wav"
} )

sound.Add({
	name = 			"Weapon_intervention.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_intervention/intervention_clipout.mp3"
})

sound.Add({
	name = 			"Weapon_intervention.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_intervention/intervention_clipin.mp3"
})

sound.Add({
	name = 			"Weapon_intervention.Bolt",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_intervention/intervention_bolt.mp3"
})

sound.Add({
	name = 			"Weapon_intervention.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ttt_intervention/intervention_deploy.mp3"
})

-------------------------------------------------------
--------------------START SNIPER THINGS----------------
-------------------------------------------------------

function SWEP:SetZoom(state)
   if CLIENT then
      return
   elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
      if state then
         self.Owner:SetFOV(20, 0.3)
      else
         self.Owner:SetFOV(0, 0.2)
      end
   end
end

function SWEP:PrimaryAttack( worldsnd )
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   if SERVER then
      self:SetZoom(bIronsights)
   else
      self:EmitSound(self.Secondary.Sound)
   end

   self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   self:SetZoom( false )
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end