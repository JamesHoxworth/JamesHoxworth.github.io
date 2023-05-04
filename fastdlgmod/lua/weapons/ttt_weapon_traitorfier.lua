if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_traitorfier2.png")
	resource.AddFile("sound/uhh.wav")
end

if CLIENT then
  SWEP.Icon = "VGUI/ttt/icon_traitorfier2.png"
	SWEP.PrintName = "Traitorfier"
	SWEP.Slot = 6
	SWEP.SlotPos = 6
	SWEP.EquipMenuData = {
	type = "Utility",
	desc = "Use the blood of a Traitor and \nturn those pesky Innocents into Traitors!"
	}
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "knife"

SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.5

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 65
SWEP.ViewModel = Model( "models/weapons/cstrike/c_knife_t.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_knife_t.mdl" )
SWEP.UseHands = true

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

SWEP.IsSilent = true
SWEP.DeploySpeed = 4
SWEP.FiresUnderwater = true
SWEP.AllowDrop = true

function SWEP:PrimaryAttack() --Leftclick
	if ( SERVER ) then
		local p = self.Owner
		if p:GetRole() != ROLE_TRAITOR then return end
		tgt = p:GetEyeTrace().Entity
		if (!tgt:IsPlayer() && !tgt:IsRagdoll()) then return end --Didn't look at a Player
			dis = p:GetPos():Distance(tgt:GetPos())
			if (dis > 100) then return end

				if (self.activated) then
					if !tgt:IsPlayer() then return end
					TraitorChanger(tgt,p)
					else
					if ( tgt:IsRagdoll() && tgt.was_role == ROLE_TRAITOR) then
						p:PrintMessage( HUD_PRINTCENTER, "You took a sample of traitor blood, wait 5s to use it..." )
						timer.Simple(5,function()
						self.activated = true
				 		p:PrintMessage( HUD_PRINTCENTER, "You can now use the blood sample..." )
						end)
			 		end
				end
	end
end

function SWEP:SecondaryAttack() --Rightclick
	if ( CLIENT ) then return end
	local p = self.Owner
	local h = p:Health()

	if p:GetRole() != ROLE_TRAITOR then return end
	if self.activated == true then return end
	if (h <= 65) then return
		else
		p:SetHealth(h-65)
			if math.random(1, 5) == 5 then
				sound.Play("uhh.wav", p:GetPos())
				else
				sound.Play("vo/npc/male01/pain02.wav", p:GetPos())
			end
			p:PrintMessage( HUD_PRINTCENTER, "You took a sample of your traitor blood, wait 30s to use it..." )
			timer.Simple(35,function()
			p:PrintMessage( HUD_PRINTCENTER, "You can now use the blood sample..." )
			self.activated = true
			end)
	end
end


function TraitorChanger(tgt,p) --Fucntion to change a !Traitor to a Traitor
		if math.random(1, 10) > 7 then
			p:StripWeapon("ttt_weapon_traitorfier")
			if tgt:Health() <= 20 then
				tgt:Kill()
				else
				tgt:SetHealth(tgt:Health()-20)
				p:PrintMessage( HUD_PRINTCENTER, "It didn't work..." )
				sound.Play("vo/npc/male01/pain02.wav", tgt:GetPos())
			end
			else
			if tgt:GetRole() != ROLE_TRAITOR then
				tgt:SetRole(ROLE_TRAITOR)
				SendFullStateUpdate()
				p:StripWeapon("ttt_weapon_traitorfier")
				if tgt:Health() <= 20 then
					tgt:Kill()
					else
					p:PrintMessage( HUD_PRINTCENTER, "IT WORKED" )
					tgt:SetHealth(tgt:Health()-20)
					tgt:PrintMessage( HUD_PRINTCENTER, "YOU ARE NOW A TRAITOR" )
					sound.Play( "vo/ravenholm/madlaugh04.wav", tgt:GetPos())
				end
			end
		end
end

--If init isn't loading{

if (SERVER) then

  hook.Add("TTTOrderedEquipment","TraitorfierOrder",function(ply,equipment,is_item) --only Traitor can buy
      if is_item == ttt_weapon_traitorfier then
        if ply:GetRole() != ROLE_TRAITOR then
          ply:StripWeapon("ttt_weapon_traitorfier")
          ply:SetCredits(ply:GetCredits()+1)
          SendFullStateUpdate()
        end
      end
  end)

  hook.Add("DoPlayerDeath","TraitorfierCreateKnifeOnDeath",function(ply) --Drop prop knife on death
    local knife = ents.Create( "prop_physics" )
    if IsValid(ply:GetWeapon("ttt_weapon_traitorfier")) then
      if ( !IsValid( knife ) ) then return end
        knife:SetModel( "models/weapons/w_knife_t.mdl" )
        knife.CanPickup = false
        knife:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        knife:SetPos(ply:GetPos() + Vector(0, 0, 5))
        knife:Spawn()
    end
  end)

  hook.Add("DoPlayerDeath","TraitorfierDeath",function(ply) --Strip Traitorfier on death
  IsValid(ply:StripWeapon("ttt_weapon_traitorfier")) end)

end
--}
