-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

local GW = GW2_ADDON

local function SkinContainerFrame(frame)
    frame:GwStripTextures()
    GW.CreateFrameHeaderWithBody(frame, frame:GetTitleText(), "Interface/AddOns/GW2_UI/textures/character/worldmap-window-icon", {})
    frame.gwHeader:ClearAllPoints()
    frame.gwHeader:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, -25)
    frame.gwHeader:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -25)
    frame.gwHeader.windowIcon:ClearAllPoints()
    frame.gwHeader.windowIcon:SetPoint("CENTER", frame.gwHeader.BGLEFT, "LEFT", 21, -7)
    frame.CloseButton:GwSkinButton(true)
    frame.CloseButton:SetPoint("TOPRIGHT", 0, 7)
end

local skinners = {
    EditBox = function(frame)
        GW.SkinTextBox(frame.Middle, frame.Left, frame.Right)
    end,
    TabButton = function(frame, extraInfo)
        GW.HandleTabs(frame, true)

        for _, tab in pairs(extraInfo.tabs) do
            tab:HookScript("OnClick", function(self)
                for _, t in pairs(extraInfo.tabs) do
                    if t:GetName() ~= self:GetName() then
                        t.hover:SetAlpha(0)
                    end
                end
            end)
        end
    end,
    TrimScrollBar = function(frame)
        GW.HandleTrimScrollBar(frame)
    end,
    ContainerFrame = function(frame)
        SkinContainerFrame(frame)
    end,
    NavBar = function(frame)
        frame:GwStripTextures(true)
        frame:SetPoint("TOPLEFT", -18, -15)

        local p = frame:GetParent();
        p.tex = p:CreateTexture(nil, "BACKGROUND", nil, 0)
        p.tex:SetPoint("TOPLEFT", p, "TOPLEFT", -10, -6)
        p.tex:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 1)
        p.tex:SetTexture("Interface/AddOns/GW2_UI/textures/character/paperdollbg")
    end,
    NavBarButton = function(frame)
        frame:GwStripTextures()
        local r = {frame:GetRegions()}
        for _, c in pairs(r) do
            if c:GetObjectType() == "FontString" then
                c:SetTextColor(1, 1, 1, 1)
                c:SetShadowOffset(0, 0)
            end
        end
        frame.tex = frame:CreateTexture(nil, "BACKGROUND")
        frame.tex:SetPoint("LEFT", frame, "LEFT")
        frame.tex:SetPoint("TOP", frame, "TOP")
        frame.tex:SetPoint("BOTTOM", frame, "BOTTOM")
        frame.tex:SetPoint("RIGHT", frame, "RIGHT")
        frame.tex:SetTexture("Interface/AddOns/GW2_UI/textures/uistuff/buttonlightInner")
        frame.tex:SetAlpha(1)
    end,
    InsetFrame = function(frame)
        frame:Hide()

        local p = frame:GetParent();
        p.tex = p:CreateTexture(nil, "BACKGROUND", nil, 0)
        p.tex:SetPoint("TOPLEFT", p, "TOPLEFT", -10, -6)
        p.tex:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 1)
        p.tex:SetTexture("Interface/AddOns/GW2_UI/textures/character/paperdollbg")
    end,
}

local function SkinFrame(details)
    local func = skinners[details.frameType]
    if func then
        func(details.frame, details.extraInfo)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    ItemUpgradeTip:RegisterSkinListener(SkinFrame)

    for _, details in ipairs(ItemUpgradeTip:GetAllFrames()) do
        SkinFrame(details)
    end
end)
