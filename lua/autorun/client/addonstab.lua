fb_addons_list = {
	workshop = {
		sprops = {
			id = "173482196",
			name = "SProps",
			desc = "More props to build with."
		},
		scifi1 = {
			id = "284266415",
			name = "Sci-Fi Models Megapack",
			desc = "Sci-Fi models.",
		},
		scifi2 = {
			id = "259383381",
			name = "Sci-Fi Shuttle Models",
			desc = "More Sci-Fi models",
		},
		sligwolf = {
			id = "147812851",
			name = "SligWolf's Model Pack",
			desc = "Misc models made by SligWolf",
		},
		wiremod = {
			id = "160250458",
			name = "Wiremod",
			desc = "Adds wiring, chips, logic and other stuff. SVN version updated more often.",
		},
		buu342base = {
			id = "271689250",
			name = "Buu342's Weapon Base",
			desc = "Weapon base for CSGO weapons and others."
		},
		buucsgo = {
			id = "239687689",
			name = "Buu342's CSGO Weapons",
			desc = "CSGO weapons, download for models."
		},
	},
	svn = {
		chatsounds = {
			url = "https://github.com/Metastruct/garrysmod-chatsounds/trunk",
			name = "Chatsounds",
			desc = "Adds fun to chatting. Size: ~1GB+"
		},
		acf = {
			url = "https://github.com/nrlulz/ACF/trunk",
			name = "ACF",
			desc = "Adds cannons, guns and motors. Size: ~1.5GB+",
		},
		acfcustom = {
			url = "https://github.com/bouletmarc/ACF_CustomMod/trunk",
			name = "ACF Custom Mod",
			desc = "Adds extra guns and motors to ACF. Size: ~80MB+",
		},
		wiremod = {
			url = "https://github.com/wiremod/wire/trunk",
			name = "Wiremod",
			desc = "Adds wiring, chips, logic and other stuff. More updated than Workshop. Size: ~100MB+"
		},
		wireextras = {
			url = "https://github.com/wiremod/wire-extras/trunk",
			name = "Wiremod Extras",
			desc = "Unofficial Wiremod stuff. Size: ~10MB+",
		},
		tdmcars = {
			url = "http://svn.code.sf.net/p/tdmcarssvn/code/trunk",
			name = "TDMCars",
			desc = "CAAAAAAAAAAAAAAAARS. Size: ~5GB+",
		},
	},
}

spawnmenu.AddCreationTab( "Addons", function()

	local scroll = vgui.Create("DScrollPanel")
	local text = vgui.Create("DLabel",scroll)
	text:SetText("These are addons that the server uses that aren't automatically downloaded due to their size. You can download them here.")
	text:Dock(TOP)

	local cat_ws = vgui.Create("DCollapsibleCategory",scroll)
	cat_ws:Dock(TOP)
	cat_ws:SetLabel("Workshop Addons")

	function cat_ws:Paint(w,h)
		draw.RoundedBox(4,0,0,w,20,Color(33,91,51))
	end

	for k,v in pairs(fb_addons_list.workshop) do
		local addon_panel = vgui.Create("DPanel",cat_ws)
		addon_panel:Dock(TOP)
		addon_panel:DockMargin(0,5,0,0)
		addon_panel:SetTall(100)

		local addon_name = vgui.Create("DLabel",addon_panel)
		addon_name:SetPos(5,5)
		addon_name:SetText(v.name)
		addon_name:SetFont("DermaLarge")
		addon_name:SetColor(color_black)
		addon_name:SizeToContents()

		local addon_desc = vgui.Create("DLabel",addon_panel)
		addon_desc:SetPos(5,42)
		addon_desc:SetText(v.desc)
		addon_desc:SetFont("DermaDefault")
		addon_desc:SetColor(color_black)
		addon_desc:SizeToContents()

		local addon_subscribe = vgui.Create("DButton",addon_panel)
		addon_subscribe:Dock(BOTTOM)
		addon_subscribe:DockMargin(5,5,5,5)
		if steamworks.IsSubscribed(v.id) then
			addon_subscribe:SetText("Subscribed")
			addon_subscribe:SetDisabled(true)
		else
			addon_subscribe:SetText("Subscribe")
			addon_subscribe:SetDisabled(false)
		end

		function addon_subscribe:DoClick()
			if steamworks.IsSubscribed(v.id) then return end
			steamworks.Download(v.id)
		end
	end

	local cat_svn = vgui.Create("DCollapsibleCategory",scroll)
	cat_svn:Dock(TOP)
	cat_svn:SetLabel("SVN Addons")

	function cat_svn:Paint(w,h)
		draw.RoundedBox(4,0,0,w,20,Color(33,91,51))
	end

	local svn_info = vgui.Create("DPanel",cat_svn)
	svn_info:Dock(TOP)
	svn_info:DockMargin(0,5,0,0)
	svn_info:SetTall(100)
	local svn_info_text = vgui.Create("DLabel",svn_info)
	svn_info_text:SetText[[An SVN client is a third-party application you need to install to download these addons. You can get an SVN client from: http://tortoisesvn.net/downloads.html
							To install these addons:
							● Create a new folder
							● Right Click > SVN > Checkout
							● Paste in the URL for the addon
							● Wait for it to download
							● Restart game if game is open]]
	svn_info_text:SizeToContents()
	svn_info_text:SetColor(color_black)
	svn_info_text:SetPos(5,5)

	for k,v in pairs(fb_addons_list.svn) do
		local addon_panel = vgui.Create("DPanel",cat_svn)
		addon_panel:Dock(TOP)
		addon_panel:DockMargin(0,5,0,0)
		addon_panel:SetTall(100)

		local addon_name = vgui.Create("DLabel",addon_panel)
		addon_name:SetPos(5,5)
		addon_name:SetText(v.name)
		addon_name:SetFont("DermaLarge")
		addon_name:SetColor(color_black)
		addon_name:SizeToContents()

		local addon_desc = vgui.Create("DLabel",addon_panel)
		addon_desc:SetPos(5,42)
		addon_desc:SetText(v.desc)
		addon_desc:SetFont("DermaDefault")
		addon_desc:SetColor(color_black)
		addon_desc:SizeToContents()

		local addon_url = vgui.Create("DTextEntry",addon_panel)
		addon_url:Dock(BOTTOM)
		addon_url:DockMargin(5,5,5,5)
		addon_url:AllowInput(false)
		addon_url:SetValue(v.url)
	end

	return scroll

end, "icon16/plugin.png", 250 )