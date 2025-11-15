local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mounts ~= true then return end

	-- Главное окно коллекций
	if CollectionsJournal then
		CollectionsJournal:StripTextures()
		CollectionsJournal:SetTemplate('Transparent')
		if CollectionsJournalCloseButton then
			S:HandleCloseButton(CollectionsJournalCloseButton)
		end
		
		-- Скрываем портрет/иконку в левом верхнем углу
		if CollectionsJournalPortrait then
			CollectionsJournalPortrait:SetAlpha(0)
			CollectionsJournalPortrait:Hide()
		end
		
		-- Скрываем все возможные варианты портрета
		local portraitNames = {
			"CollectionsJournalPortrait",
			"CollectionsJournalPortraitTexture",
			"CollectionsJournalIconTexture"
		}
		
		for _, name in pairs(portraitNames) do
			local portrait = _G[name]
			if portrait then
				portrait:SetAlpha(0)
				portrait:Hide()
			end
		end
		-- Функция обновления всех основных вкладок
		local function UpdateMainTabBorders()
			for i = 1, 5 do
				local tab = _G["CollectionsJournalTab"..i]
				if tab and tab.backdrop then
					local isSelected = PanelTemplates_GetSelectedTab(CollectionsJournal) == tab:GetID()
					if isSelected then
						tab.backdrop:SetBackdropBorderColor(1, 0.82, 0)
					else
						tab.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
					end
				end
			end
		end
		
		-- Вкладки коллекций
		for i = 1, 5 do
			local tab = _G["CollectionsJournalTab"..i]
			if tab and not tab.elvuiStyled then
				-- Скрываем иконки на вкладках
				for j = 1, tab:GetNumRegions() do
					local region = select(j, tab:GetRegions())
					if region and region:GetObjectType() == "Texture" then
						local drawLayer = region:GetDrawLayer()
						if drawLayer == "ARTWORK" or drawLayer == "OVERLAY" then
							region:SetAlpha(0)
							region:Hide()
						end
					end
				end
				
				-- Используем стандартную обработку вкладок ElvUI
				S:HandleTab(tab)
				
				-- Настраиваем текст чтобы не обрезался
				if tab.Text then
					tab.Text:ClearAllPoints()
					tab.Text:SetPoint('CENTER', tab, 'CENTER', 0, 2)
					tab.Text:SetJustifyH('CENTER')
				end
				
				-- Эффект при наведении (если есть backdrop после HandleTab)
				if tab.backdrop then
					tab:HookScript('OnEnter', function(self)
						if not self.backdrop then return end
						local isSelected = PanelTemplates_GetSelectedTab(CollectionsJournal) == self:GetID()
						if not isSelected then
							self.backdrop:SetBackdropBorderColor(1, 0.82, 0)
						end
					end)
					
					tab:HookScript('OnLeave', UpdateMainTabBorders)
					tab:HookScript('OnClick', function() E:Delay(0.05, UpdateMainTabBorders) end)
					tab:HookScript('OnShow', UpdateMainTabBorders)
				end
				
				tab.elvuiStyled = true
			end
		end
		
		UpdateMainTabBorders()
	end

	-- global
	if PetJournalParent then
		PetJournalParent:StripTextures()
		PetJournalParent:SetTemplate('Transparent')
		PetJournalParentPortrait:Hide()
		S:HandleTab(PetJournalParentTab1)
		S:HandleTab(PetJournalParentTab2)
		S:HandleCloseButton(PetJournalParentCloseButton)
	end

	-------------------------------
	--[[ mount journal (tab 1) ]]--
	-------------------------------

	MountJournal:StripTextures()
	MountJournal.LeftInset:StripTextures()
	MountJournal.RightInset:StripTextures()
	MountJournal.MountDisplay:StripTextures()
	MountJournal.MountDisplay.ShadowOverlay:StripTextures()
	MountJournal.MountCount:StripTextures()
	S:HandleButton(MountJournalMountButton, true)
	S:HandleEditBox(MountJournalSearchBox)
	S:HandleScrollBar(MountJournalListScrollFrameScrollBar)
	S:HandleRotateButton(MountJournal.MountDisplay.ModelFrame.RotateLeftButton)
	S:HandleRotateButton(MountJournal.MountDisplay.ModelFrame.RotateRightButton)

	for i = 1, #MountJournal.ListScrollFrame.buttons do
		S:HandleItemButton(_G["MountJournalListScrollFrameButton"..i])
	end

	-- Color in green icon border on selected mount
	local function ColorSelectedMount()
		for i = 1, #MountJournal.ListScrollFrame.buttons do
			local b = _G["MountJournalListScrollFrameButton"..i]
			local t = _G["MountJournalListScrollFrameButton"..i.."Name"]
			if b.selectedTexture:IsShown() then
				t:SetTextColor(1,1,0)
				b.backdrop:SetBackdropBorderColor(1, 1, 0)
			else
				t:SetTextColor(1, 1, 1)
				b.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end
	hooksecurefunc("MountJournal_UpdateMountList", ColorSelectedMount)

	-- bug fix when we scroll
	MountJournalListScrollFrame:HookScript("OnVerticalScroll", ColorSelectedMount)
	MountJournalListScrollFrame:HookScript("OnMouseWheel", ColorSelectedMount)

	-----------------------------
	--[[ pet journal (tab 2) ]]--
	-----------------------------

	PetJournalSummonButton:StripTextures()
	PetJournalFindBattle:StripTextures()
	S:HandleButton(PetJournalSummonButton)
	S:HandleButton(PetJournalFindBattle)
	PetJournalRightInset:StripTextures()
	PetJournalLeftInset:StripTextures()
	
	for i = 1, 3 do
		local f = _G["PetJournalLoadoutPet"..i.."HelpFrame"]
		f:StripTextures()
	end	
	
	PetJournalTutorialButton:Kill()
	PetJournal.PetCount:StripTextures()
	S:HandleEditBox(PetJournalSearchBox)
	PetJournalSearchBox:ClearAllPoints()
	PetJournalSearchBox:SetPoint("TOPLEFT", PetJournalLeftInset, "TOPLEFT", (E.PixelMode and 13 or 10), -9)
	PetJournalFilterButton:StripTextures(true)
	S:HandleButton(PetJournalFilterButton)
	PetJournalFilterButton:Height(E.PixelMode and 22 or 24)
	PetJournalFilterButton:ClearAllPoints()
	PetJournalFilterButton:SetPoint("TOPRIGHT", PetJournalLeftInset, "TOPRIGHT", -5, -(E.PixelMode and 8 or 7))
	PetJournalListScrollFrame:StripTextures()
	S:HandleScrollBar(PetJournalListScrollFrameScrollBar)
	
	for i = 1, #PetJournal.listScroll.buttons do
		local b = _G["PetJournalListScrollFrameButton"..i]
		S:HandleItemButton(b)
		b.dragButton.favorite:SetParent(b.backdrop)
		b.dragButton.levelBG:SetAlpha(0)
		b.dragButton.level:SetParent(b.backdrop)
	end



	local function ColorSelectedPet()
		local petButtons = PetJournal.listScroll.buttons;
		local isWild = PetJournal.isWild;

		for i = 1, #petButtons do
			local index = petButtons[i].index;
			if not index then break; end
			local b = _G["PetJournalListScrollFrameButton"..i]
			local t = _G["PetJournalListScrollFrameButton"..i.."Name"]
			local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle = C_PetJournal.GetPetInfoByIndex(index, isWild);

			if petID ~= nil then
				local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID);
				if b.selectedTexture:IsShown() then
					t:SetTextColor(1,1,0)
				else
					t:SetTextColor(1, 1, 1)
				end
				if rarity then
					local color = ITEM_QUALITY_COLORS[rarity-1]
					b.backdrop:SetBackdropBorderColor(color.r, color.g, color.b);
				else
					b.backdrop:SetBackdropBorderColor(1, 1, 0)
				end
			end
		end
	end	
	hooksecurefunc('PetJournal_UpdatePetList', ColorSelectedPet)
	PetJournalListScrollFrame:HookScript("OnVerticalScroll", ColorSelectedPet)
	PetJournalListScrollFrame:HookScript("OnMouseWheel", ColorSelectedPet)
	
	PetJournalAchievementStatus:DisableDrawLayer('BACKGROUND')
	
	S:HandleItemButton(PetJournalHealPetButton, true)
	E:RegisterCooldown(PetJournalHealPetButtonCooldown)
	PetJournalHealPetButton.texture:SetTexture([[Interface\Icons\spell_magic_polymorphrabbit]])
	PetJournalLoadoutBorder:StripTextures()
	for i=1, 3 do
		_G['PetJournalLoadoutPet'..i]:StripTextures()
		_G['PetJournalLoadoutPet'..i]:CreateBackdrop()
		_G['PetJournalLoadoutPet'..i].backdrop:SetAllPoints()
		_G['PetJournalLoadoutPet'..i].petTypeIcon:SetPoint('BOTTOMLEFT', 2, 2)
		

		_G['PetJournalLoadoutPet'..i].dragButton:SetOutside(_G['PetJournalLoadoutPet'..i..'Icon'])
		_G['PetJournalLoadoutPet'..i].dragButton:SetFrameLevel(_G['PetJournalLoadoutPet'..i].dragButton:GetFrameLevel() + 1)
		
		_G['PetJournalLoadoutPet'..i].hover = true;
		_G['PetJournalLoadoutPet'..i].pushed = true;
		_G['PetJournalLoadoutPet'..i].checked = true;
		S:HandleItemButton(_G['PetJournalLoadoutPet'..i])
		
		_G['PetJournalLoadoutPet'..i].backdrop:SetFrameLevel(_G['PetJournalLoadoutPet'..i].backdrop:GetFrameLevel() + 1)
		
		_G['PetJournalLoadoutPet'..i].setButton:StripTextures()
		_G['PetJournalLoadoutPet'..i..'HealthFrame'].healthBar:StripTextures()
		_G['PetJournalLoadoutPet'..i..'HealthFrame'].healthBar:CreateBackdrop('Default')
		_G['PetJournalLoadoutPet'..i..'HealthFrame'].healthBar:SetStatusBarTexture(E.media.normTex)
		_G['PetJournalLoadoutPet'..i..'XPBar']:StripTextures()
		_G['PetJournalLoadoutPet'..i..'XPBar']:CreateBackdrop('Default')	
		_G['PetJournalLoadoutPet'..i..'XPBar']:SetStatusBarTexture(E.media.normTex)		
		_G['PetJournalLoadoutPet'..i..'XPBar']:SetFrameLevel(_G['PetJournalLoadoutPet'..i..'XPBar']:GetFrameLevel() + 2)
		
		for index = 1, 3 do
			local f = _G['PetJournalLoadoutPet'..i..'Spell'..index]
			S:HandleItemButton(f)
			f.FlyoutArrow:SetTexture([[Interface\Buttons\ActionBarFlyoutButton]])
			_G['PetJournalLoadoutPet'..i..'Spell'..index..'Icon']:SetInside(f)
		end
	end

	PetJournalSpellSelect:StripTextures()
	for i=1, 2 do
		local btn = _G['PetJournalSpellSelectSpell'..i]
		S:HandleItemButton(btn)
		_G['PetJournalSpellSelectSpell'..i..'Icon']:SetInside(btn)
		_G['PetJournalSpellSelectSpell'..i..'Icon']:SetDrawLayer('BORDER')
	end
	
	PetJournalPetCard:StripTextures()
	PetJournalPetCard:SetTemplate('Default')
	PetJournalPetCardInset:StripTextures()
	
	PetJournalPetCardPetInfo.levelBG:SetAlpha(0)
	PetJournalPetCardPetInfoIcon:SetTexCoord(unpack(E.TexCoords))
	PetJournalPetCardPetInfo:CreateBackdrop()
	PetJournalPetCardPetInfo.favorite:SetParent(PetJournalPetCardPetInfo.backdrop)
	PetJournalPetCardPetInfo.backdrop:SetOutside(PetJournalPetCardPetInfoIcon)
	PetJournalPetCardPetInfoIcon:SetParent(PetJournalPetCardPetInfo.backdrop)
	PetJournalPetCardPetInfo.backdrop:SetFrameLevel(PetJournalPetCardPetInfo.backdrop:GetFrameLevel() + 2)
	PetJournalPetCardPetInfo.level:SetParent(PetJournalPetCardPetInfo.backdrop)

	local tt = PetJournalPrimaryAbilityTooltip
	tt.Background:SetTexture(nil)
	if tt.Delimiter1 then
		tt.Delimiter1:SetTexture(nil)
		tt.Delimiter2:SetTexture(nil)
	end
	tt.BorderTop:SetTexture(nil)
	tt.BorderTopLeft:SetTexture(nil)
	tt.BorderTopRight:SetTexture(nil)
	tt.BorderLeft:SetTexture(nil)
	tt.BorderRight:SetTexture(nil)
	tt.BorderBottom:SetTexture(nil)
	tt.BorderBottomRight:SetTexture(nil)
	tt.BorderBottomLeft:SetTexture(nil)
	tt:SetTemplate("Transparent")
	
	for i=1, 6 do
		local frame = _G['PetJournalPetCardSpell'..i]
		frame:SetFrameLevel(frame:GetFrameLevel() + 2)
		frame:DisableDrawLayer('BACKGROUND')
		frame:CreateBackdrop('Default')
		frame.backdrop:SetAllPoints()
		frame.icon:SetTexCoord(unpack(E.TexCoords))
		frame.icon:SetInside(frame.backdrop)
	end

	PetJournalPetCardHealthFrame.healthBar:StripTextures()
	PetJournalPetCardHealthFrame.healthBar:CreateBackdrop('Default')
	PetJournalPetCardHealthFrame.healthBar:SetStatusBarTexture(E.media.normTex)
	PetJournalPetCardXPBar:StripTextures()
	PetJournalPetCardXPBar:CreateBackdrop('Default')	
	PetJournalPetCardXPBar:SetStatusBarTexture(E.media.normTex)

	-----------------------------
	--[[ toy box (tab 3) ]]--
	-----------------------------

	if ToyBox then
		ToyBox:StripTextures()
		ToyBox.iconsFrame:StripTextures()
		
		-- Поисковая строка
		if ToyBox.searchBox then
			S:HandleEditBox(ToyBox.searchBox)
		end
		
		-- Кнопка фильтра
		if ToyBox.FilterButton then
			ToyBox.FilterButton:StripTextures(true)
			S:HandleButton(ToyBox.FilterButton)
		end
		
		-- Прокрутка
		if ToyBox.iconsFrame.scrollBar then
			S:HandleScrollBar(ToyBox.iconsFrame.scrollBar)
		end
		
		-- Кнопки навигации
		if ToyBox.PagingFrame then
			ToyBox.PagingFrame:StripTextures()
			if ToyBox.PagingFrame.PrevPageButton then
				S:HandleNextPrevButton(ToyBox.PagingFrame.PrevPageButton)
				SquareButton_SetIcon(ToyBox.PagingFrame.PrevPageButton, 'LEFT')
			end
			if ToyBox.PagingFrame.NextPageButton then
				S:HandleNextPrevButton(ToyBox.PagingFrame.NextPageButton)
				SquareButton_SetIcon(ToyBox.PagingFrame.NextPageButton, 'RIGHT')
			end
		end
		
		-- Кнопки игрушек
		if ToyBox.iconsFrame.buttons then
			for i = 1, #ToyBox.iconsFrame.buttons do
				local button = ToyBox.iconsFrame.buttons[i]
				if button then
					S:HandleItemButton(button)
					if button.iconTexture then
						button.iconTexture:SetInside(button.backdrop)
					end
				end
			end
		end
		
		-- Прогресс бар
		if ToyBox.progressBar then
			ToyBox.progressBar:StripTextures()
			ToyBox.progressBar:CreateBackdrop('Default')
			ToyBox.progressBar:SetStatusBarTexture(E.media.normTex)
		end
	end

	-----------------------------
	--[[ heirlooms journal (tab 4) ]]--
	-----------------------------

	if HeirloomsJournal then
		HeirloomsJournal:StripTextures()
		
		-- Поисковая строка
		if HeirloomsJournal.SearchBox then
			S:HandleEditBox(HeirloomsJournal.SearchBox)
		end
		
		-- Кнопка фильтра
		if HeirloomsJournal.FilterButton then
			HeirloomsJournal.FilterButton:StripTextures(true)
			S:HandleButton(HeirloomsJournal.FilterButton)
		end
		
		-- Прокрутка
		if HeirloomsJournal.iconsFrame then
			HeirloomsJournal.iconsFrame:StripTextures()
			if HeirloomsJournal.iconsFrame.scrollBar then
				S:HandleScrollBar(HeirloomsJournal.iconsFrame.scrollBar)
			end
		end
		
		-- Кнопки навигации
		if HeirloomsJournal.PagingFrame then
			HeirloomsJournal.PagingFrame:StripTextures()
			if HeirloomsJournal.PagingFrame.PrevPageButton then
				S:HandleNextPrevButton(HeirloomsJournal.PagingFrame.PrevPageButton)
				SquareButton_SetIcon(HeirloomsJournal.PagingFrame.PrevPageButton, 'LEFT')
			end
			if HeirloomsJournal.PagingFrame.NextPageButton then
				S:HandleNextPrevButton(HeirloomsJournal.PagingFrame.NextPageButton)
				SquareButton_SetIcon(HeirloomsJournal.PagingFrame.NextPageButton, 'RIGHT')
			end
		end
		
		-- Кнопки реликвий
		if HeirloomsJournal.iconsFrame then
			-- Кнопки реликвий
			if HeirloomsJournal.iconsFrame.buttons then
				for i = 1, #HeirloomsJournal.iconsFrame.buttons do
					local button = HeirloomsJournal.iconsFrame.buttons[i]
					if button then
						S:HandleItemButton(button)
						if button.iconTexture then
							button.iconTexture:SetInside(button.backdrop)
						end
					end
				end
			end
		end
		
		-- Прогресс бар
		if HeirloomsJournal.progressBar then
			HeirloomsJournal.progressBar:StripTextures()
			HeirloomsJournal.progressBar:CreateBackdrop('Default')
			HeirloomsJournal.progressBar:SetStatusBarTexture(E.media.normTex)
		end
	end

	-----------------------------
	--[[ wardrobe collection (tab 5) ]]--
	-----------------------------

	if WardrobeCollectionFrame then
		WardrobeCollectionFrame:StripTextures()
		
		-- Функция для избирательного удаления фоновых текстур
		local function StripBackgroundTextures(frame, skipButtons)
			if not frame then return end
			
			local frameName = frame:GetName() or ""
			
			-- Пропускаем кнопки навигации
			if skipButtons and (string.find(frameName, "Button") or frame:GetObjectType() == "Button") then
				return
			end
			
			-- Убираем только фоновые текстуры, не трогая иконки
			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region and region:GetObjectType() == "Texture" then
					local texturePath = region:GetTexture()
					local drawLayer = region:GetDrawLayer()
					
					-- Убираем только фоновые текстуры (BACKGROUND, BORDER)
					-- Не трогаем ARTWORK и OVERLAY (там иконки)
					if drawLayer == "BACKGROUND" or drawLayer == "BORDER" then
						if texturePath and (
							string.find(texturePath, "Background") or 
							string.find(texturePath, "Parchment") or
							string.find(texturePath, "Marble") or
							string.find(texturePath, "UI-Frame") or
							not string.find(texturePath, "Icon")
						) then
							region:SetTexture(nil)
							region:SetAlpha(0)
						end
					end
				end
			end
			
			-- Обрабатываем дочерние фреймы
			local children = {frame:GetChildren()}
			for _, child in pairs(children) do
				if child and child.GetObjectType then
					local childType = child:GetObjectType()
					local childName = child:GetName() or ""
					
					-- Не обрабатываем модели и кнопки навигации
					if childType ~= "PlayerModel" and childType ~= "DressUpModel" then
						-- Пропускаем кнопки навигации (PrevPageButton, NextPageButton)
						if not (string.find(childName, "PageButton") or string.find(childName, "PagingFrame")) then
							StripBackgroundTextures(child, true)
						end
					end
				end
			end
		end
		
		-- Применяем избирательную очистку
		StripBackgroundTextures(WardrobeCollectionFrame, false)
		
		-- Поисковая строка
		if WardrobeCollectionFrame.SearchBox then
			S:HandleEditBox(WardrobeCollectionFrame.SearchBox)
		end
		
		-- Кнопка фильтра
		if WardrobeCollectionFrame.FilterButton then
			WardrobeCollectionFrame.FilterButton:StripTextures(true)
			S:HandleButton(WardrobeCollectionFrame.FilterButton)
		end
		
		-- Модель персонажа справа
		if WardrobeCollectionFrame.ModelFrame then
			WardrobeCollectionFrame.ModelFrame:StripTextures()
		end
		
		-- Панель с предметами (Items tab)
		if WardrobeCollectionFrame.ItemsCollectionFrame then
			WardrobeCollectionFrame.ItemsCollectionFrame:StripTextures()
			
			-- Навигация по страницам
			if WardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame then
				local paging = WardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame
				paging:StripTextures()
				
				if paging.PrevPageButton then
					S:HandleNextPrevButton(paging.PrevPageButton)
					SquareButton_SetIcon(paging.PrevPageButton, 'LEFT')
				end
				if paging.NextPageButton then
					S:HandleNextPrevButton(paging.NextPageButton)
					SquareButton_SetIcon(paging.NextPageButton, 'RIGHT')
				end
			end
			
			-- Кнопки предметов трансмогрификации
			if WardrobeCollectionFrame.ItemsCollectionFrame.Models then
				for i = 1, #WardrobeCollectionFrame.ItemsCollectionFrame.Models do
					local model = WardrobeCollectionFrame.ItemsCollectionFrame.Models[i]
					if model then
						model:StripTextures()
						model:CreateBackdrop('Default')
						model.backdrop:SetAllPoints()
					end
				end
			end
			
			-- Прокрутка списка
			if WardrobeCollectionFrame.ItemsCollectionFrame.SlotsFrame then
				WardrobeCollectionFrame.ItemsCollectionFrame.SlotsFrame:StripTextures()
			end
		end
		
		-- Панель с наборами (Sets tab)
		if WardrobeCollectionFrame.SetsCollectionFrame then
			WardrobeCollectionFrame.SetsCollectionFrame:StripTextures()
			
			-- Левая панель со списком наборов
			if WardrobeCollectionFrame.SetsCollectionFrame.LeftInset then
				WardrobeCollectionFrame.SetsCollectionFrame.LeftInset:StripTextures()
			end
			
			-- Правая панель с деталями
			if WardrobeCollectionFrame.SetsCollectionFrame.RightInset then
				WardrobeCollectionFrame.SetsCollectionFrame.RightInset:StripTextures()
			end
			
			-- Прокрутка наборов
			if WardrobeCollectionFrame.SetsCollectionFrame.ListContainer then
				WardrobeCollectionFrame.SetsCollectionFrame.ListContainer:StripTextures()
				
				if WardrobeCollectionFrame.SetsCollectionFrame.ListContainer.scrollBar then
					S:HandleScrollBar(WardrobeCollectionFrame.SetsCollectionFrame.ListContainer.scrollBar)
				end
			end
			
			-- Детали набора справа
			if WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame then
				WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame:StripTextures()
				
				-- Модель набора
				if WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.ModelFadeTexture then
					WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.ModelFadeTexture:Hide()
				end
				
				-- Иконки предметов набора
				for i = 1, 10 do
					local slot = WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame["slot"..i]
					if slot then
						slot:StripTextures()
						slot:StyleButton(false)
						slot:CreateBackdrop('Default')
						slot.backdrop:SetAllPoints()
						
						if slot.Icon then
							slot.Icon:SetTexCoord(unpack(E.TexCoords))
							slot.Icon:SetInside(slot.backdrop)
						end
					end
				end
			end
		end
		
		-- Панель с воплощениями (Incarnations tab)
		-- Попробуем несколько вариантов названий фреймов
		local incarnationFrames = {
			WardrobeCollectionFrame.SetsTransmogFrame,
			_G["WardrobeCollectionFrameSetsTransmogFrame"],
		}
		
		for _, frame in pairs(incarnationFrames) do
			if frame then
				frame:StripTextures()
				
				-- Кнопки навигации
				if frame.PagingFrame then
					local paging = frame.PagingFrame
					paging:StripTextures()
					
					if paging.PrevPageButton then
						S:HandleNextPrevButton(paging.PrevPageButton)
						SquareButton_SetIcon(paging.PrevPageButton, 'LEFT')
					end
					if paging.NextPageButton then
						S:HandleNextPrevButton(paging.NextPageButton)
						SquareButton_SetIcon(paging.NextPageButton, 'RIGHT')
					end
				end
				
				-- Кнопки воплощений
				if frame.Models then
					for i = 1, #frame.Models do
						local model = frame.Models[i]
						if model then
							model:StripTextures()
							model:CreateBackdrop('Default')
							model.backdrop:SetAllPoints()
						end
					end
				end
				
				break
			end
		end
		
		-- Прогресс бар
		if WardrobeCollectionFrame.progressBar then
			WardrobeCollectionFrame.progressBar:StripTextures()
			WardrobeCollectionFrame.progressBar:CreateBackdrop('Default')
			WardrobeCollectionFrame.progressBar:SetStatusBarTexture(E.media.normTex)
		end
		
		-- Функция обновления всех вкладок
		local function UpdateAllTabBorders()
			for i = 1, 3 do
				local tab = _G["WardrobeCollectionFrameTab"..i]
				if tab and tab.backdrop then
					local isSelected = PanelTemplates_GetSelectedTab(WardrobeCollectionFrame) == tab:GetID()
					if isSelected then
						tab.backdrop:SetBackdropBorderColor(1, 0.82, 0)
					else
						tab.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
					end
				end
			end
		end
		
		-- Вкладки внутри Wardrobe (Items/Sets/Incarnations)
		for i = 1, 3 do
			local tab = _G["WardrobeCollectionFrameTab"..i]
			if tab and not tab.elvuiStyled then
				-- Убираем стандартные текстуры
				tab:StripTextures()
				
				-- Создаём фон
				tab:CreateBackdrop('Default')
				tab.backdrop:SetAllPoints()
				
				-- Стилизуем как кнопку
				tab:StyleButton(true)
				
				-- Настраиваем текст
				if tab.Text then
					tab.Text:ClearAllPoints()
					tab.Text:SetPoint('CENTER', tab, 'CENTER', 0, 0)
					tab.Text:SetJustifyH('CENTER')
				end
				
				-- Добавляем эффект при наведении
				tab:HookScript('OnEnter', function(self)
					if not self.backdrop then return end
					-- Только если вкладка не выбрана, подсвечиваем при наведении
					local isSelected = PanelTemplates_GetSelectedTab(WardrobeCollectionFrame) == self:GetID()
					if not isSelected then
						self.backdrop:SetBackdropBorderColor(1, 0.82, 0)
					end
				end)
				
				tab:HookScript('OnLeave', function(self)
					UpdateAllTabBorders()
				end)
				
				-- Обновляем все вкладки при клике
				tab:HookScript('OnClick', function(self)
					E:Delay(0.05, UpdateAllTabBorders)
				end)
				
				-- Обновляем при показе
				tab:HookScript('OnShow', UpdateAllTabBorders)
				
				tab.elvuiStyled = true
			end
		end
		
		-- Первоначальное обновление
		UpdateAllTabBorders()
	end

	-----------------------------
	--[[ Wardrobe Frame (окно трансмогрификации у NPC) ]]--
	-----------------------------

	if WardrobeFrame then
		-- Убираем ВСЕ текстуры
		WardrobeFrame:StripTextures(true)
		
		-- Создаём чёрный полупрозрачный фон ElvUI
		WardrobeFrame:CreateBackdrop("Transparent")
		WardrobeFrame.backdrop:SetAllPoints()
		
		-- Скрываем портрет/иконку
		if WardrobeFramePortrait then
			WardrobeFramePortrait:SetAlpha(0)
			WardrobeFramePortrait:Hide()
		end
		
		-- Кнопка закрытия
		if WardrobeFrameCloseButton then
			S:HandleCloseButton(WardrobeFrameCloseButton)
		end
		
		-- Левая панель (трансмог)
		if WardrobeTransmogFrame then
			WardrobeTransmogFrame:StripTextures(true)
			
			if WardrobeTransmogFrame.ModelFrame then
				WardrobeTransmogFrame.ModelFrame:StripTextures()
			end
		end
		
		-- Правая панель (коллекция предметов)
		if WardrobeCollectionFrame then
			WardrobeCollectionFrame:StripTextures(true)
		end
	end
end

S:RegisterSkin("Blizzard_Collections", LoadSkin)