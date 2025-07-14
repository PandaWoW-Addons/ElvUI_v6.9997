local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.pvp ~= true then return end
	
	-- Главное окно PVP
	if PVPUIFrame then
		PVPUIFrame:StripTextures()
		PVPUIFrame:SetTemplate("Transparent")
		if PVPUIFrameCloseButton then
			S:HandleCloseButton(PVPUIFrameCloseButton)
		end
		-- Вкладки PVP
		for i = 1, 2 do
			local tab = _G["PVPUIFrameTab"..i]
			if tab then
				S:HandleTab(tab)
			end
		end
		-- Кнопки категорий
		for i = 1, 4 do
			local button = _G["PVPQueueFrameCategoryButton"..i]
			if button then
				button:SetTemplate('Default')
				if button.Background then button.Background:Kill() end
				if button.Ring then button.Ring:Kill() end
				if button.Icon then
					button.Icon:Size(45)
					button.Icon:SetTexCoord(.15, .85, .15, .85)
					button:CreateBackdrop("Default")
					button.backdrop:SetOutside(button.Icon)
					button.backdrop:SetFrameLevel(button:GetFrameLevel())
					button.Icon:SetParent(button.backdrop)
				end
				button:StyleButton(nil, true)
			end
		end
	end
	
	if PVPUIFrame.LeftInset then
		PVPUIFrame.LeftInset:StripTextures()
		--PVPUIFrame.LeftInset:SetTemplate("Transparent")
	end
	
	if PVPUIFrame.Shadows then
		PVPUIFrame.Shadows:StripTextures()
	end
	
	for i=1, 2 do
		if _G["PVPUIFrameTab"..i] then
			S:HandleTab(_G["PVPUIFrameTab"..i])
		end
	end
	
	for i=1, 3 do
		local button = _G["PVPQueueFrameCategoryButton"..i]
		if button then
			button:SetTemplate('Default')
			if button.Background then button.Background:Kill() end
			if button.Ring then button.Ring:Kill() end
			if button.Icon then
				button.Icon:Size(45)
				button.Icon:SetTexCoord(.15, .85, .15, .85)
				button:CreateBackdrop("Default")
				button.backdrop:SetOutside(button.Icon)
				button.backdrop:SetFrameLevel(button:GetFrameLevel())
				button.Icon:SetParent(button.backdrop)
			end
			button:StyleButton(nil, true)
		end
	end
	
	--[[for i=1, 3 do
		local button = _G["PVPArenaTeamsFrameTeam"..i]
		button:SetTemplate('Default')
		button.Background:Kill()
		button:StyleButton()
	end]]
	
	-->>>HONOR FRAME
	if HonorFrameTypeDropDown then
		S:HandleDropDownBox(HonorFrameTypeDropDown)
	end
	
	if HonorFrame and HonorFrame.Inset then
		HonorFrame.Inset:StripTextures()
		--HonorFrame.Inset:SetTemplate("Transparent")
	end
	
	if HonorFrameSpecificFrameScrollBar then
		S:HandleScrollBar(HonorFrameSpecificFrameScrollBar)
	end
	
	if HonorFrameSoloQueueButton then
		S:HandleButton(HonorFrameSoloQueueButton, true)
	end
	
	if HonorFrameGroupQueueButton then
		S:HandleButton(HonorFrameGroupQueueButton, true)
	end
	
	if HonorFrame and HonorFrame.BonusFrame then
		HonorFrame.BonusFrame:StripTextures()
		
		if HonorFrame.BonusFrame.ShadowOverlay then
			HonorFrame.BonusFrame.ShadowOverlay:StripTextures()
		end
		
		if HonorFrame.BonusFrame.RandomBGButton then
			HonorFrame.BonusFrame.RandomBGButton:StripTextures()
			HonorFrame.BonusFrame.RandomBGButton:SetTemplate()
			HonorFrame.BonusFrame.RandomBGButton:StyleButton(nil, true)
			
			if HonorFrame.BonusFrame.RandomBGButton.SelectedTexture then
				HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:SetInside()
				HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:SetTexture(1, 1, 0, 0.1)
			end
		end
		
		if HonorFrame.BonusFrame.CallToArmsButton then
			HonorFrame.BonusFrame.CallToArmsButton:StripTextures()
			HonorFrame.BonusFrame.CallToArmsButton:SetTemplate()
			HonorFrame.BonusFrame.CallToArmsButton:StyleButton(nil, true)
			
			if HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture then
				HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:SetInside()
				HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:SetTexture(1, 1, 0, 0.1)
			end
		end
	end

	if HonorFrame and HonorFrame.BonusFrame and HonorFrame.BonusFrame.DiceButton then
		HonorFrame.BonusFrame.DiceButton:DisableDrawLayer("ARTWORK")
		HonorFrame.BonusFrame.DiceButton:SetHighlightTexture("")
	end

	if HonorFrame and HonorFrame.RoleInset then
		HonorFrame.RoleInset:StripTextures()
		
		if HonorFrame.RoleInset.DPSIcon and HonorFrame.RoleInset.DPSIcon.checkButton then
			S:HandleCheckBox(HonorFrame.RoleInset.DPSIcon.checkButton, true)
		end
		
		if HonorFrame.RoleInset.TankIcon and HonorFrame.RoleInset.TankIcon.checkButton then
			S:HandleCheckBox(HonorFrame.RoleInset.TankIcon.checkButton, true)
		end
		
		if HonorFrame.RoleInset.HealerIcon and HonorFrame.RoleInset.HealerIcon.checkButton then
			S:HandleCheckBox(HonorFrame.RoleInset.HealerIcon.checkButton, true)
		end
	end
	
	if HonorFrame and HonorFrame.RoleInset and HonorFrame.RoleInset.TankIcon then
		HonorFrame.RoleInset.TankIcon:DisableDrawLayer("ARTWORK")
		HonorFrame.RoleInset.TankIcon:DisableDrawLayer("OVERLAY")
		
		if LFDQueueFrameRoleButtonTank and LFDQueueFrameRoleButtonTank.background then
			HonorFrame.RoleInset.TankIcon.bg = HonorFrame.RoleInset.TankIcon:CreateTexture(nil, 'BACKGROUND')
			HonorFrame.RoleInset.TankIcon.bg:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
			HonorFrame.RoleInset.TankIcon.bg:SetTexCoord(LFDQueueFrameRoleButtonTank.background:GetTexCoord())
			HonorFrame.RoleInset.TankIcon.bg:SetPoint('CENTER')
			HonorFrame.RoleInset.TankIcon.bg:Size(80)
			HonorFrame.RoleInset.TankIcon.bg:SetAlpha(0.5)
		end
	end

	if HonorFrame and HonorFrame.RoleInset and HonorFrame.RoleInset.HealerIcon then
		HonorFrame.RoleInset.HealerIcon:DisableDrawLayer("ARTWORK")
		HonorFrame.RoleInset.HealerIcon:DisableDrawLayer("OVERLAY")
		
		if LFDQueueFrameRoleButtonHealer and LFDQueueFrameRoleButtonHealer.background then
			HonorFrame.RoleInset.HealerIcon.bg = HonorFrame.RoleInset.HealerIcon:CreateTexture(nil, 'BACKGROUND')
			HonorFrame.RoleInset.HealerIcon.bg:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
			HonorFrame.RoleInset.HealerIcon.bg:SetTexCoord(LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
			HonorFrame.RoleInset.HealerIcon.bg:SetPoint('CENTER')
			HonorFrame.RoleInset.HealerIcon.bg:Size(80)
			HonorFrame.RoleInset.HealerIcon.bg:SetAlpha(0.5)
		end
	end


	if HonorFrame and HonorFrame.RoleInset and HonorFrame.RoleInset.DPSIcon then
		HonorFrame.RoleInset.DPSIcon:DisableDrawLayer("ARTWORK")
		HonorFrame.RoleInset.DPSIcon:DisableDrawLayer("OVERLAY")
		
		if LFDQueueFrameRoleButtonDPS and LFDQueueFrameRoleButtonDPS.background then
			HonorFrame.RoleInset.DPSIcon.bg = HonorFrame.RoleInset.DPSIcon:CreateTexture(nil, 'BACKGROUND')
			HonorFrame.RoleInset.DPSIcon.bg:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
			HonorFrame.RoleInset.DPSIcon.bg:SetTexCoord(LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
			HonorFrame.RoleInset.DPSIcon.bg:SetPoint('CENTER')
			HonorFrame.RoleInset.DPSIcon.bg:Size(80)
			HonorFrame.RoleInset.DPSIcon.bg:SetAlpha(0.5)
		end
	end

	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(self)
		if self.bg then
			self.bg:SetDesaturated(true)
		end
	end)
	
	if HonorFrame and HonorFrame.BonusFrame then
		for i = 1, 2 do
			local b = HonorFrame.BonusFrame["WorldPVP"..i.."Button"]
			if b then
				b:StripTextures()
				b:SetTemplate()
				b:StyleButton(nil, true)
				if b.SelectedTexture then
					b.SelectedTexture:SetInside()
					b.SelectedTexture:SetTexture(1, 1, 0, 0.1)
				end
			end
		end
	end


	-->>>CONQUEST FRAME
	if ConquestFrame and ConquestFrame.Inset then
		ConquestFrame.Inset:StripTextures()
	end
	
	--CapProgressBar_Update(ConquestFrame.ConquestBar, 0, 0, nil, nil, 1000, 2200);
	if ConquestPointsBarLeft then ConquestPointsBarLeft:Kill() end
	if ConquestPointsBarRight then ConquestPointsBarRight:Kill() end
	if ConquestPointsBarMiddle then ConquestPointsBarMiddle:Kill() end
	if ConquestPointsBarBG then ConquestPointsBarBG:Kill() end
	if ConquestPointsBarShadow then ConquestPointsBarShadow:Kill() end
	
	if ConquestPointsBar and ConquestPointsBar.progress then
		ConquestPointsBar.progress:SetTexture(E["media"].normTex)
		ConquestPointsBar:CreateBackdrop('Default')
		ConquestPointsBar.backdrop:SetOutside(ConquestPointsBar, nil, E.PixelMode and -2 or -1)
	end
	
	if ConquestFrame then
		ConquestFrame:StripTextures()
		if ConquestFrame.ShadowOverlay then
			ConquestFrame.ShadowOverlay:StripTextures()
		end
	end
	
	if ConquestJoinButton then
		S:HandleButton(ConquestJoinButton, true)
	end


	local function handleButton(button)
		if button then
			button:StripTextures()
			button:SetTemplate()
			button:StyleButton(nil, true)
			if button.SelectedTexture then
				button.SelectedTexture:SetInside()
				button.SelectedTexture:SetTexture(1, 1, 0, 0.1)
			end
		end
	end

	if ConquestFrame then
		handleButton(ConquestFrame.RatedBG)
		handleButton(ConquestFrame.Arena2v2)
		handleButton(ConquestFrame.Arena3v3)
		handleButton(ConquestFrame.Arena5v5)

		if ConquestFrame.Arena3v3 and ConquestFrame.Arena2v2 then
			ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -2)
		end
		
		if ConquestFrame.Arena5v5 and ConquestFrame.Arena3v3 then
			ConquestFrame.Arena5v5:SetPoint("TOP", ConquestFrame.Arena3v3, "BOTTOM", 0, -2)
		end
	end

	-->>>WARGRAMES FRAME
	if WarGamesFrame then
		WarGamesFrame:StripTextures()
		
		if WarGamesFrame.RightInset then
			WarGamesFrame.RightInset:StripTextures()
		end
		
		if WarGameStartButton then
			S:HandleButton(WarGameStartButton, true)
		end
		
		if WarGamesFrameScrollFrameScrollBar then
			S:HandleScrollBar(WarGamesFrameScrollFrameScrollBar)
		end
		
		if WarGamesFrame.HorizontalBar then
			WarGamesFrame.HorizontalBar:StripTextures()
		end
	end

	if ConquestTooltip then
		ConquestTooltip:SetTemplate("Transparent")
	end
end
S:RegisterSkin('Blizzard_PVPUI', LoadSkin)