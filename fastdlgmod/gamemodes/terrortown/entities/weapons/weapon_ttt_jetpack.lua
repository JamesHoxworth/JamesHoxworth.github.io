CreateConVar("ttt_jetpack_force",12,{FCVAR_ARCHIVE},"Change the upward force of the jetpack (default 12, can't fly below 11)")
if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("materials/VGUI/ttt/lykrast/icon_jetpack.vmt")
end

if( CLIENT ) then
    SWEP.PrintName = "Jet Pack";
    SWEP.Slot = 7;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = false;
    SWEP.Icon = "VGUI/ttt/lykrast/icon_jetpack";
 
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Select it and press Jump to propel upward.\n\nBeware the landing."
   };

end

SWEP.Author= "Lykrast"


SWEP.Base = "weapon_tttbase"
SWEP.Spawnable= false
SWEP.AdminSpawnable= true
SWEP.HoldType = "normal"
 
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
 
SWEP.ViewModelFOV= 10
SWEP.ViewModelFlip= false
SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel      = "models/maxofs2d/thruster_propeller.mdl"
 
 --- PRIMARY FIRE ---
SWEP.Primary.Delay= 1
SWEP.Primary.Recoil= 0
SWEP.Primary.Damage= 0
SWEP.Primary.NumShots= 1
SWEP.Primary.Cone= 0
SWEP.Primary.ClipSize= -1
SWEP.Primary.DefaultClip= -1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo         = "none"
SWEP.NoSights = true

function SWEP:PrimaryAttack()
   return false
end

function SWEP:Think()

if ( self.Owner:KeyDown(IN_JUMP) ) then
   self.Owner:SetVelocity(self.Owner:GetUp() * GetConVarNumber("ttt_jetpack_force"))

end

end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
   end
   return true
end

function SWEP:DrawWorldModel()
   if not IsValid(self.Owner) then
      self:DrawModel()
   end
end

function SWEP:DrawWorldModelTranslucent()
end