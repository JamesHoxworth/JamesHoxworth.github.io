if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop( "1947794080" )
end
 
if CLIENT then
	SWEP.PrintName = "Petition"
	SWEP.Slot = 6

	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.UseHands = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "A petition to ban trouble from Terrorist Town.\n \nClick to ask someone to sign your petition.\n \nNobody will sign it, but they will admire your commitment to social activism."
	};
	SWEP.Icon = "vgui/ttt/icon_petition.png"
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_DETECTIVE }  
SWEP.LimitedStock = true

SWEP.DrawAmmo = false
SWEP.Spawnable = false
SWEP.DrawCrosshair = false
SWEP.AllowDrop = false
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Secondary = SWEP.Primary
SWEP.Delay = 2

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/postal 2/weapons/clipboard.mdl"

for i = 1, 6 do
	local n = tostring(i)
	sound.Add( {
		name = "postal_petition_"..n,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 75,
		pitch = 100,
		sound = "postal_petition_swep/petition_"..n..".wav"
	} )
end

function SWEP:Initialize()
	self:SetHoldType( "pistol" )

	if SERVER then return end

	self.clipboard = ClientsideModel( self.WorldModel )
	self.clipboard:SetNoDraw( true )
end

function SWEP:OnRemove()
	self:SetHoldType( "pistol" )

	if SERVER then return end

	if ( self.clipboard and self.clipboard:IsValid() ) then
		self.clipboard:Remove()
	end
end

function SWEP:PreDrawViewModel( vm, wep, ply )
	render.SetBlend( 0 )
end

function SWEP:PostDrawViewModel( vm, wep, ply )
	render.SetBlend( 1 )

	local model = self.clipboard
	local bone_pos, bone_angle = vm:GetBonePosition( vm:LookupBone("ValveBiped.base") )

	model:SetPos( bone_pos + bone_angle:Up()*-9 + bone_angle:Forward()*-1 + bone_angle:Right()*-1.5 )
	bone_angle:RotateAroundAxis( bone_angle:Up(), -90 )
	bone_angle:RotateAroundAxis( bone_angle:Forward(), 200 )
	bone_angle:RotateAroundAxis( bone_angle:Right(), 10 )
	model:SetAngles( bone_angle )
	model:SetupBones()

	model:DrawModel()
end

function SWEP:DrawWorldModel()
	local ply = self:GetOwner()
	local model = self.clipboard

	local bone_index = ply:LookupBone("ValveBiped.Bip01_R_Hand")
	local bone_pos, bone_angle

	if ( bone_index ) then bone_pos, bone_angle = ply:GetBonePosition( bone_index ) end

	model:SetPos( bone_index and ( bone_pos + bone_angle:Up()*-1 + bone_angle:Forward()*4.4 + bone_angle:Right()*6 ) or ply:GetPos() )
	if ( bone_index ) then
		bone_angle:RotateAroundAxis( bone_angle:Up(), 180 )
		bone_angle:RotateAroundAxis( bone_angle:Forward(), 180 )
		bone_angle:RotateAroundAxis( bone_angle:Right(), -70 )

		model:SetAngles( bone_angle )
	end	
	model:SetupBones()

	model:DrawModel()
end

function SWEP:PrimaryAttack()
	if ( CLIENT ) then return end

	self._isound = self._isound and self._isound < 6 and self._isound + 1 or 1
	
	if ( self._lastsound ) then
		self.Owner:StopSound( self._lastsound )
	end

	local sound = "postal_petition_" .. tostring( self._isound )
	self.Owner:EmitSound( sound )
	self._lastsound = sound

	self:SetNextPrimaryFire( CurTime() + self.Delay )
end

function SWEP:SecondaryAttack()
	if ( CLIENT ) then return end
	self:PrimaryAttack()
	self:SetNextSecondaryFire( CurTime() + 1 )
end

function SWEP:Reload()

end
