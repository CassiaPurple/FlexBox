AddCSLuaFile()

SWEP.PrintName = "Customizable AK47"
SWEP.Author = "Flex"
SWEP.Category = "Flex's Weapons"
SWEP.Base = "flex_custom_base"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.HoldType = "ar2"
SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true
SWEP.DrawCrosshair = false

SWEP.Primary.ClipSize = 24
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 2.25
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage = 2.5
SWEP.Primary.Delay = 0.1
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Cone = 1.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IronSightsPos 		= Vector(6.0816, -7.8745, 2.5074)
SWEP.IronSightsAng 		= Vector(2.4511, -0.0486, 0)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)

	draw.SimpleText("b", "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)
	-- Draw a CS:S select icon

	self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
	-- Print weapon information
end