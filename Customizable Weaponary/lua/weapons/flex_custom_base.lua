AddCSLuaFile()

if SERVER then
	util.AddNetworkString("flex_custom_recoil")
	util.AddNetworkString("flex_custom_damage")
	util.AddNetworkString("flex_custom_clipsize")

	net.Receive("flex_custom_recoil",function()
		local ply = net.ReadEntity()
		print("Recieved: ")
		print(ply)
		local rec = net.ReadFloat()
		ply.GetActiveWeapon().Primary.Recoil = rec
		--ply:TakeMoney(150)
	end)

	net.Receive("flex_custom_damage",function()
		local ply = net.ReadEntity()
		local dmg = net.ReadFloat()
		ply.GetActiveWeapon().Primary.Damage = dmg
		--ply:TakeMoney(325)
	end)

	net.Receive("flex_custom_clipsize",function(ply)
		local clip = net.ReadFloat()
		ply.GetActiveWeapon().Primary.ClipSize = clip
		ply.GetActiveWeapon().Primary.DefaultClip = clip
		--ply:TakeMoney(100)
	end)
end

if CLIENT then
	surface.CreateFont("CSKillIcons", {font = "csd", size = ScreenScale(30), weight = 500, antialias = true, additive = true})
	surface.CreateFont("CSSelectIcons", {font = "csd", size = ScreenScale(60), weight = 500, antialias = true, additive = true})
	surface.CreateFont("HLSelectIcons", {font = "HalfLife2", size = ScreenScale(60), weight = 500, antialias = true, additive = true})
end

SWEP.PrintName = "Flex's Customizable Weapon Base"
SWEP.Author = "Flex"
SWEP.Category = "Flex's Weapons"

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.UseHands = true
SWEP.DrawCrosshair = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = -1
SWEP.Primary.Delay = 0
SWEP.Primary.Cone = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Attachments = {}

local CurTime = CurTime -- 20% optimization for the think loop
local IRONSIGHT_TIME = 0.15
local CUSTOM_CURTIME = CurTime()
local CUSTOM_TIME = 0.7 + CUSTOM_CURTIME

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self:SetIronsights(false)
	end
end

function SWEP:Deploy()
	self:SetIronsights(false)

	self.Weapon:SendWeaponAnim(ACT_VM_DEPLOY)
	
	CUSTOM_CURTIME = CurTime()
	CUSTOM_TIME = 0.7 + CUSTOM_CURTIME
	self.Owner:ChatPrint("Press Alt+B to open customization window.")
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:RecoilPower()

	self:ShootEffects()
	self:FireBullets(Bullet)
	self:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	self:EmitSound("")
end

function SWEP:GetViewModelPosition(pos, ang)
	if SERVER then return Vector(0,0,0), Angle(0,0,0) end

	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetNWBool("Ironsights")

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end

function SWEP:SetIronsights(b)
	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("Ironsights")
end

function SWEP:IronSight()
	if self.Owner:KeyPressed(IN_ATTACK2) then
		self.Owner:SetFOV( 65, 0.15 )
		self:SetIronsights(true, self.Owner)
		if CLIENT then return end
	end

	if self.Owner:KeyReleased(IN_ATTACK2) then
		self.Owner:SetFOV( 0, 0.15 )
		self:SetIronsights(false, self.Owner)
		if CLIENT then return end
	end
end

function CustomizationUI()
	if CLIENT then
		local weapon = LocalPlayer():GetActiveWeapon()
		cus_frame = cus_frame or NULL
		if IsValid(cus_frame) then return end
				
		cus_frame = vgui.Create("DFrame")
		cus_frame:SetSize(550,600)
		cus_frame:Center()
		cus_frame:SetTitle("")
		cus_frame:SetDraggable(false)
		cus_frame:MakePopup()
		
		cus_frame.btnMaxim:SetVisible(false)
		cus_frame.btnMinim:SetVisible(false)
		
		function cus_frame.btnClose.Paint()
			draw.RoundedBox(0,0,0,32,8,Color(180,0,0))
			draw.RoundedBox(0,0,8,32,8,Color(160,0,0))
			draw.DrawText("r","marlett",8,0,color_white)
		end
		
		function cus_frame.Paint()
			draw.RoundedBox(4,0,0,cus_frame:GetWide(),cus_frame:GetTall(),color_black)
		end
		
		local title = vgui.Create("DLabel",cus_frame)
		title:SetPos(20,2)
		title:SetText("Gun Customization")
		title:SetColor(color_white)
		title:SizeToContents()
		
		local icon = vgui.Create("DImage",cus_frame)
		icon:SetPos(2,2)
		icon:SetImage("icon16/gun.png")
		icon:SizeToContents()
		
		local bgpanel = vgui.Create("DScrollPanel",cus_frame)
		bgpanel:SetPos(5,24)
		bgpanel:SetSize(cus_frame:GetWide()-10,cus_frame:GetTall()-29)
		
		function bgpanel.Paint()
			draw.RoundedBox(4,0,0,bgpanel:GetWide(),bgpanel:GetTall(),color_white)	
		end
		
		--RECOIL--
		local rec_pan = vgui.Create("DPanel",bgpanel)
		rec_pan:SetPos(5,5)
		rec_pan:SetSize(bgpanel:GetWide()-10,48)
		
		function rec_pan.Paint()
			draw.RoundedBoxEx(4,0,0,rec_pan:GetWide(),rec_pan:GetTall()/2,Color(128,255,128),true,true,false,false)
			draw.RoundedBoxEx(4,0,rec_pan:GetTall()/2,rec_pan:GetWide(),rec_pan:GetTall()/2,Color(96,224,96),false,false,true,true)
		end

		local rec_label = vgui.Create("DLabel",rec_pan)
		rec_label:SetPos(5,5)
		rec_label:SetColor(color_black)
		
		function rec_label.Think()
			rec_label:SetText("Recoil: "..weapon.Primary.Recoil)
			rec_label:SizeToContents()
		end
		
		local rec_slider = vgui.Create("DNumSlider",rec_pan)
		rec_slider:SetPos(5,20)
		rec_slider:SetSize(250,32)
		rec_slider:SetText("Recoil")
		rec_slider:SetMin(0.75)
		rec_slider:SetMax(2.25)
		rec_slider:SetValue(weapon.Primary.Recoil)
		
		local rec_buy = vgui.Create("DButton",rec_pan)
		rec_buy:SetSize(38,38)
		rec_buy:SetPos(rec_pan:GetWide()-43,5)
		rec_buy:SetText("Buy")
		
		function rec_buy.DoClick()
			if rec_slider:GetValue() == weapon.Primary.Recoil then LocalPlayer():ChatPrint("You have not changed the recoil value, not buying.") return end
			net.Start("flex_custom_recoil")
				net.WriteEntity(LocalPlayer())
				net.WriteFloat(rec_slider:GetValue())
			net.SendToServer()
		end
		
		--DAMAGE--
		local dmg_pan = vgui.Create("DPanel",bgpanel)
		dmg_pan:SetPos(5,5+48+5)
		dmg_pan:SetSize(bgpanel:GetWide()-10,48)
		
		function dmg_pan.Paint()
			draw.RoundedBoxEx(4,0,0,dmg_pan:GetWide(),dmg_pan:GetTall()/2,Color(128,255,128),true,true,false,false)
			draw.RoundedBoxEx(4,0,dmg_pan:GetTall()/2,dmg_pan:GetWide(),dmg_pan:GetTall()/2,Color(96,224,96),false,false,true,true)
		end

		local dmg_label = vgui.Create("DLabel",dmg_pan)
		dmg_label:SetPos(5,5)
		dmg_label:SetColor(color_black)
		
		function dmg_label.Think()
			dmg_label:SetText("Damage: "..weapon.Primary.Damage)
			dmg_label:SizeToContents()
		end
		
		local dmg_slider = vgui.Create("DNumSlider",dmg_pan)
		dmg_slider:SetPos(5,20)
		dmg_slider:SetSize(250,32)
		dmg_slider:SetText("Damage")
		dmg_slider:SetMin(2.5)
		dmg_slider:SetMax(5)
		dmg_slider:SetValue(weapon.Primary.Damage)
		
		local dmg_buy = vgui.Create("DButton",dmg_pan)
		dmg_buy:SetSize(38,38)
		dmg_buy:SetPos(dmg_pan:GetWide()-43,5)
		dmg_buy:SetText("Buy")
		
		function dmg_buy.DoClick()
			if dmg_slider:GetValue() == weapon.Primary.Damage then LocalPlayer():ChatPrint("You have not changed the damage value, not buying.") return end
			net.Start("flex_custom_damage")
				net.WriteEntity(LocalPlayer())
				net.WriteFloat(dmg_slider:GetValue())
			net.SendToServer()
		end
		
		--CLIP SIZE--
		local clip_pan = vgui.Create("DPanel",bgpanel)
		clip_pan:SetPos(5,5+48+5+48+5)
		clip_pan:SetSize(bgpanel:GetWide()-10,48)
		
		function clip_pan.Paint()
			draw.RoundedBoxEx(4,0,0,clip_pan:GetWide(),clip_pan:GetTall()/2,Color(128,255,128),true,true,false,false)
			draw.RoundedBoxEx(4,0,clip_pan:GetTall()/2,clip_pan:GetWide(),clip_pan:GetTall()/2,Color(96,224,96),false,false,true,true)
		end

		local clip_label = vgui.Create("DLabel",clip_pan)
		clip_label:SetPos(5,5)
		clip_label:SetColor(color_black)
		
		function clip_label.Think()
			clip_label:SetText("Clip Size: "..weapon.Primary.ClipSize)
			clip_label:SizeToContents()
		end
		
		local clip_slider = vgui.Create("DNumSlider",clip_pan)
		clip_slider:SetPos(5,20)
		clip_slider:SetSize(250,32)
		clip_slider:SetText("Clip Size")
		clip_slider:SetMin(24)
		clip_slider:SetMax(48)
		clip_slider:SetDecimals(0)
		clip_slider:SetValue(weapon.Primary.ClipSize)
		
		local clip_buy = vgui.Create("DButton",clip_pan)
		clip_buy:SetSize(38,38)
		clip_buy:SetPos(clip_pan:GetWide()-43,5)
		clip_buy:SetText("Buy")
		
		function clip_buy.DoClick()
			if clip_slider:GetValue() == weapon.Primary.ClipSize then LocalPlayer():ChatPrint("You have not changed the clip size value, not buying.") return end
			net.Start("flex_custom_clipsize")
				net.WriteEntity(LocalPlayer())
				net.WriteFloat(clip_slider:GetValue())
			net.SendToServer()
		end

		--ATTACHMENTS--
		if not weapon == "flex_custom_tf2_smg" then
			local reddot_pan = vgui.Create("DPanel",bgpanel)
			reddot_pan:SetPos(5,5+48+5+48+5+48+5)
			reddot_pan:SetSize(bgpanel:GetWide()-10,48)
			
			function reddot_pan.Paint()
				draw.RoundedBoxEx(4,0,0,reddot_pan:GetWide(),reddot_pan:GetTall()/2,Color(128,255,128),true,true,false,false)
				draw.RoundedBoxEx(4,0,reddot_pan:GetTall()/2,reddot_pan:GetWide(),reddot_pan:GetTall()/2,Color(96,224,96),false,false,true,true)
			end

			local reddot_label = vgui.Create("DLabel",reddot_pan)
			reddot_label:SetPos(5,5)
			reddot_label:SetColor(color_black)
			reddot_label:SetText("Red Dot Sight")
			reddot_label:SizeToContents()
			
			local reddot_buy = vgui.Create("DButton",reddot_pan)
			reddot_buy:SetSize(38,38)
			reddot_buy:SetPos(reddot_pan:GetWide()-43,5)
			reddot_buy:SetText("Buy")
			
			function reddot_buy.DoClick()
				net.Start("flex_custom_reddot")
					net.WriteEntity(LocalPlayer())
					net.WriteTable(reddot_color:GetValue())
				net.SendToServer()
			end
		end

		--TF2 SMG--
		if weapon == "flex_custom_tf2_smg" then
			local goldsmg_pan = vgui.Create("DPanel",bgpanel)
			goldsmg_pan:SetPos(5,5+48+5+48+5+48+5)
			goldsmg_pan:SetSize(bgpanel:GetWide()-10,48)
			
			function goldsmg_pan.Paint()
				draw.RoundedBoxEx(4,0,0,goldsmg_pan:GetWide(),goldsmg_pan:GetTall()/2,Color(128,255,128),true,true,false,false)
				draw.RoundedBoxEx(4,0,goldsmg_pan:GetTall()/2,goldsmg_pan:GetWide(),goldsmg_pan:GetTall()/2,Color(96,224,96),false,false,true,true)
			end

			local goldsmg_label = vgui.Create("DLabel",goldsmg_pan)
			goldsmg_label:SetPos(5,5)
			goldsmg_label:SetColor(color_black)
			goldsmg_label:SetText("Golden SMG")
			goldsmg_label:SizeToContents()
			
			local goldsmg_buy = vgui.Create("DButton",goldsmg_pan)
			goldsmg_buy:SetSize(38,38)
			goldsmg_buy:SetPos(goldsmg_pan:GetWide()-43,5)
			goldsmg_buy:SetText("Buy")
			
			function goldsmg_buy.DoClick()
				net.Start("flex_custom_goldsmg") 
					net.WriteEntity(LocalPlayer())
				net.SendToServer()
			end
		end
	end
end

function SWEP:Customization()
	if CLIENT then
	CUSTOM_CURTIME = CurTime()
		if input.IsKeyDown(KEY_LALT) and input.IsKeyDown(KEY_B) and CUSTOM_CURTIME > CUSTOM_TIME then
			CUSTOM_TIME = 0.7 + CUSTOM_CURTIME
			CustomizationUI()
		end
	end
end

function SWEP:Think()
	self:IronSight()
	self:Customization()
end

function SWEP:RecoilPower()
	if !IsValid(self.Owner) then return end

	if not self.Owner:IsOnGround() then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
			-- Put normal recoil when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil), math.Rand(-1,1) * (self.Primary.Recoil), 0))
			-- Punch the screen 1x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil * 2.5, self.Primary.NumShots, self.Primary.Cone)
			-- Recoil * 2.5

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil * 2.5), math.Rand(-1,1) * (self.Primary.Recoil * 2.5), 0))
			-- Punch the screen * 2.5
		end

	elseif self.Owner:KeyDown(bit.bor(IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT)) then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil / 2, self.Primary.NumShots, self.Primary.Cone)
			-- Put recoil / 2 when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 1.5), math.Rand(-1,1) * (self.Primary.Recoil / 1.5), 0))
			-- Punch the screen 1.5x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil * 1.5, self.Primary.NumShots, self.Primary.Cone)
			-- Recoil * 1.5

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil * 1.5), math.Rand(-1,1) * (self.Primary.Recoil * 1.5), 0))
			-- Punch the screen * 1.5
		end

	elseif self.Owner:Crouching() then
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, 0, self.Primary.NumShots, self.Primary.Cone)
			-- Put 0 recoil when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 3), math.Rand(-1,1) * (self.Primary.Recoil / 3), 0))
			-- Punch the screen 3x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil / 2, self.Primary.NumShots, self.Primary.Cone)
			-- Recoil / 2

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 2), math.Rand(-1,1) * (self.Primary.Recoil / 2), 0))
			-- Punch the screen / 2
		end
	else
		if (self:GetIronsights() == true) then
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil / 6, self.Primary.NumShots, self.Primary.Cone)
			-- Put recoil / 4 when you're in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil / 2), math.Rand(-1,1) * (self.Primary.Recoil / 2), 0))
			-- Punch the screen 2x less hard when you're in ironsigh mod
		else
			self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
			-- Put normal recoil when you're not in ironsight mod

			self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * self.Primary.Recoil, math.Rand(-1,1) *self.Primary.Recoil, 0))
			-- Punch the screen
		end
	end
end

function SWEP:CSShootBullet(dmg, recoil, numbul, cone)

	numbul 		= numbul or 1
	cone 			= cone or 0.01

	local bullet 	= {}
	bullet.Num  	= numbul
	bullet.Src 		= self.Owner:GetShootPos()       					-- Source
	bullet.Dir 		= self.Owner:GetAimVector()      					-- Dir of bullet
	bullet.Spread 	= Vector(cone, cone, 0)     						-- Aim Cone
	bullet.Tracer 	= 1       									-- Show a tracer on every x bullets
	bullet.Force 	= 0.5 * dmg     								-- Amount of force to give to phys objects
	bullet.Damage 	= dmg										-- Amount of damage to give to the bullets
	bullet.Callback 	= HitImpact

	self.Owner:FireBullets(bullet)					-- Fire the bullets
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)      	-- View model animation
	self.Owner:MuzzleFlash()        					-- Crappy muzzle light

	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

	if ((game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT)) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end
end