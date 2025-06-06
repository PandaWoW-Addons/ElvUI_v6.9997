local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	LootHistoryFrame:SetFrameStrata('HIGH')
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.loot ~= true then return end
	local frame = MissingLootFrame

	frame:StripTextures()
	frame:CreateBackdrop("Default")

	S:HandleCloseButton(MissingLootFramePassButton)

	local function SkinButton()
		local numItems = GetNumMissingLootItems()

		for i = 1, numItems do
			local slot = _G["MissingLootFrameItem"..i]
			local icon = slot.icon

			S:HandleItemButton(slot, true)

			local texture, name, count, quality = GetMissingLootItemInfo(i);
			local color = (GetItemQualityColor(quality)) or (unpack(E.media.bordercolor))
			icon:SetTexture(texture)
			frame:SetBackdropBorderColor(color)
		end
		
		local numRows = ceil(numItems / 2);
		MissingLootFrame:SetHeight(numRows * 43 + 38 + MissingLootFrameLabel:GetHeight());
	end
	hooksecurefunc("MissingLootFrame_Show", SkinButton)
	
	-- loot history frame
	LootHistoryFrame:StripTextures()
	S:HandleCloseButton(LootHistoryFrame.CloseButton)
	LootHistoryFrame:StripTextures()
	LootHistoryFrame:SetTemplate('Transparent')
	S:HandleCloseButton(LootHistoryFrame.ResizeButton)
	LootHistoryFrame.ResizeButton.text:SetText("v v v v")
	LootHistoryFrame.ResizeButton:SetTemplate()
	LootHistoryFrame.ResizeButton:Width(LootHistoryFrame:GetWidth())
	LootHistoryFrame.ResizeButton:Height(19)
	LootHistoryFrame.ResizeButton:ClearAllPoints()
	LootHistoryFrame.ResizeButton:Point("TOP", LootHistoryFrame, "BOTTOM", 0, -2)
	LootHistoryFrameScrollFrame:StripTextures()
	S:HandleScrollBar(LootHistoryFrameScrollFrameScrollBar)

	local function UpdateLoots(self)
		local numItems = C_LootHistory.GetNumItems()
		for i=1, numItems do
			local frame = LootHistoryFrame.itemFrames[i]

			if not frame.isSkinned then
				local Icon = frame.Icon:GetTexture()
				frame:StripTextures()
				frame.Icon:SetTexture(Icon)
				frame.Icon:SetTexCoord(unpack(E.TexCoords))

				-- create a backdrop around the icon
				frame:CreateBackdrop("Default")
				frame.backdrop:SetOutside(frame.Icon)
				frame.Icon:SetParent(frame.backdrop)

				frame.isSkinned = true
			end
		end
	end
	hooksecurefunc("LootHistoryFrame_FullUpdate", UpdateLoots)

	--masterloot
	MasterLooterFrame:StripTextures()
	MasterLooterFrame:SetTemplate()
	MasterLooterFrame:SetFrameStrata('FULLSCREEN_DIALOG')
	
	hooksecurefunc("MasterLooterFrame_Show", function()
		local b = MasterLooterFrame.Item
		if b then
			local i = b.Icon
			local icon = i:GetTexture()
			local c = ITEM_QUALITY_COLORS[LootFrame.selectedQuality]

			b:StripTextures()
			i:SetTexture(icon)
			i:SetTexCoord(unpack(E.TexCoords))
			b:CreateBackdrop()
			b.backdrop:SetOutside(i)
			b.backdrop:SetBackdropBorderColor(c.r, c.g, c.b)
		end

		for i=1, MasterLooterFrame:GetNumChildren() do
			local child = select(i, MasterLooterFrame:GetChildren())
			if child and not child.isSkinned and not child:GetName() then
				if child:GetObjectType() == "Button" then
					if child:GetPushedTexture() then
						S:HandleCloseButton(child)
					else
						child:SetTemplate()
						child:StyleButton()
					end
					child.isSkinned = true
				end
			end
		end
	end) 
	
	-- Скин для BonusRollFrame
	BonusRollFrame:StripTextures()
	BonusRollFrame:SetTemplate('Transparent')
	BonusRollFrame.PromptFrame.Icon:SetTexCoord(unpack(E.TexCoords))
	BonusRollFrame.PromptFrame.IconBackdrop = CreateFrame("Frame", nil, BonusRollFrame.PromptFrame)
	BonusRollFrame.PromptFrame.IconBackdrop:SetFrameLevel(BonusRollFrame.PromptFrame.IconBackdrop:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.IconBackdrop:SetOutside(BonusRollFrame.PromptFrame.Icon)
	BonusRollFrame.PromptFrame.IconBackdrop:SetTemplate()	
	BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(1, 1, 1)
	BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(1, 1, 1)
	
	-- Создаем держатель для BonusRollFrame и мувер для него
	local BRF = CreateFrame("Frame", "ElvUIBonusRollFrameHolder", E.UIParent)
	BRF:Size(BonusRollFrame:GetWidth(), BonusRollFrame:GetHeight())
	BRF:Point("CENTER", E.UIParent, "CENTER", 0, 0)
	BRF:SetFrameStrata("HIGH")
	BonusRollFrame:ClearAllPoints()
	BonusRollFrame:SetPoint("CENTER", BRF, "CENTER")
	BonusRollFrame:SetClampedToScreen(true)
	BonusRollFrame:SetMovable(true)
	E:CreateMover(BRF, "BonusRollFrameMover", L["Bonus Roll Frame"], nil, nil, nil, "ALL,GENERAL")
	
	-- Хук на появление фрейма, чтобы он всегда появлялся в нужном месте
	hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
		BonusRollFrame:ClearAllPoints()
		BonusRollFrame:SetPoint("CENTER", BRF, "CENTER")
	end)
end

S:RegisterSkin("ElvUI", LoadSkin)