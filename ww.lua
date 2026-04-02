--[[
    ww ULTRA LIGHT MENU
    Jujutsu Shenanigans / Roblox
    Menu key: INSERT (меняем в Misc)
    Красный круг — закрыть меню, зелёный — перемещение
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- === НАСТРОЙКИ ===
local Settings = {
    CurrentTab = "Combat",
    MenuKey = Enum.KeyCode.Insert,
    -- Aimbot
    AimbotEnabled = true,
    AimbotFOV = 150,
    AimbotSmoothness = 0.35,
    AimbotRadius = 5,
    AimbotExtraDist = 1,
    IgnoreWalls = true,
    HitboxScale = 0.3,
    BackTrackMax = 6,
    BackTrackMin = 2.7,
    -- Movement
    WalkSpeed = 16,
    JumpPower = 50,
    -- Visuals
    RenderFOV = 80,
    ESPEnabled = true,
    ESPBoxes = true,
    ESPNames = true,
    ESPHealth = true,
    PostFXSat = 0,
    PostFXBright = 0,
}

-- === ЭФФЕКТЫ ===
local Blur = Instance.new("BlurEffect")
Blur.Name = "MenuBlur"
Blur.Size = 0
Blur.Parent = Lighting
local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "MenuDarken"
ColorCorrection.Brightness = 0
ColorCorrection.Contrast = 0
ColorCorrection.Saturation = 0
ColorCorrection.Parent = Lighting

local function SetBackgroundEffect(enabled)
    if enabled then
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 12}):Play()
        TweenService:Create(ColorCorrection, TweenInfo.new(0.3), {Brightness = -0.2, Contrast = 0.1}):Play()
    else
        TweenService:Create(Blur, TweenInfo.new(0.2), {Size = 0}):Play()
        TweenService:Create(ColorCorrection, TweenInfo.new(0.2), {Brightness = 0, Contrast = 0}):Play()
    end
end

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "wwUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ========== ПЕРЕТАСКИВАЕМЫЙ ВИДЖЕТ ВРЕМЕНИ И FPS ==========
local InfoWidget = Instance.new("Frame")
InfoWidget.Size = UDim2.new(0, 140, 0, 45)
InfoWidget.Position = UDim2.new(0, 15, 1, -60)
InfoWidget.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
InfoWidget.BackgroundTransparency = 0.1
InfoWidget.BorderSizePixel = 1
InfoWidget.BorderColor3 = Color3.fromRGB(184, 134, 255)
InfoWidget.Parent = ScreenGui
InfoWidget.ZIndex = 5
InfoWidget.Active = true
InfoWidget.Draggable = true

local WidgetCorner = Instance.new("UICorner")
WidgetCorner.CornerRadius = UDim.new(0, 8)
WidgetCorner.Parent = InfoWidget

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(1, 0, 0.5, 0)
TimeLabel.Position = UDim2.new(0, 8, 0, 3)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "--:--:--"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.Font = Enum.Font.GothamBold
TimeLabel.TextSize = 13
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = InfoWidget

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 0.5, 0)
FPSLabel.Position = UDim2.new(0, 8, 0.5, -2)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: --"
FPSLabel.TextColor3 = Color3.fromRGB(184, 134, 255)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 12
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = InfoWidget

local lastTime = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        FPSLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = now
    end
    local t = os.date("*t")
    TimeLabel.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end)

-- ========== KEYSTROKES (Minecraft стиль, перетаскиваемый) ==========
local KeystrokeFrame = Instance.new("Frame")
KeystrokeFrame.Size = UDim2.new(0, 200, 0, 130)
KeystrokeFrame.Position = UDim2.new(1, -215, 1, -145)
KeystrokeFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
KeystrokeFrame.BackgroundTransparency = 0.15
KeystrokeFrame.BorderSizePixel = 1
KeystrokeFrame.BorderColor3 = Color3.fromRGB(100, 100, 140)
KeystrokeFrame.Parent = ScreenGui
KeystrokeFrame.ZIndex = 5
KeystrokeFrame.Active = true
KeystrokeFrame.Draggable = true

local KSCorner = Instance.new("UICorner")
KSCorner.CornerRadius = UDim.new(0, 8)
KSCorner.Parent = KeystrokeFrame

-- WASD
local keys = {
    {name="W", x=75, y=5},
    {name="A", x=30, y=45},
    {name="S", x=75, y=45},
    {name="D", x=120, y=45},
}
local keyButtons = {}
for _, k in ipairs(keys) do
    local btn = Instance.new("Frame")
    btn.Size = UDim2.new(0, 45, 0, 45)
    btn.Position = UDim2.new(0, k.x, 0, k.y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 80, 100)
    btn.Parent = KeystrokeFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = k.name
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Parent = btn
    keyButtons[k.name] = {frame=btn, label=label}
end

-- Space
local spaceBtn = Instance.new("Frame")
spaceBtn.Size = UDim2.new(0, 140, 0, 30)
spaceBtn.Position = UDim2.new(0, 30, 0, 95)
spaceBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
spaceBtn.BorderSizePixel = 1
spaceBtn.BorderColor3 = Color3.fromRGB(80, 80, 100)
spaceBtn.Parent = KeystrokeFrame
local spaceCorner = Instance.new("UICorner")
spaceCorner.CornerRadius = UDim.new(0, 8)
spaceCorner.Parent = spaceBtn
local spaceLabel = Instance.new("TextLabel")
spaceLabel.Size = UDim2.new(1, 0, 1, 0)
spaceLabel.BackgroundTransparency = 1
spaceLabel.Text = "SPACE"
spaceLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
spaceLabel.Font = Enum.Font.GothamBold
spaceLabel.TextSize = 12
spaceLabel.Parent = spaceBtn

-- Mouse LMB / RMB (circle)
local mouseL = Instance.new("Frame")
mouseL.Size = UDim2.new(0, 40, 0, 40)
mouseL.Position = UDim2.new(0, 10, 0, 5)
mouseL.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mouseL.BorderSizePixel = 1
mouseL.BorderColor3 = Color3.fromRGB(80, 80, 100)
mouseL.Parent = KeystrokeFrame
local mouseLCorner = Instance.new("UICorner")
mouseLCorner.CornerRadius = UDim.new(1, 0)
mouseLCorner.Parent = mouseL
local mouseLLabel = Instance.new("TextLabel")
mouseLLabel.Size = UDim2.new(1, 0, 1, 0)
mouseLLabel.BackgroundTransparency = 1
mouseLLabel.Text = "LMB"
mouseLLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
mouseLLabel.Font = Enum.Font.GothamBold
mouseLLabel.TextSize = 10
mouseLLabel.Parent = mouseL

local mouseR = Instance.new("Frame")
mouseR.Size = UDim2.new(0, 40, 0, 40)
mouseR.Position = UDim2.new(0, 150, 0, 5)
mouseR.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mouseR.BorderSizePixel = 1
mouseR.BorderColor3 = Color3.fromRGB(80, 80, 100)
mouseR.Parent = KeystrokeFrame
local mouseRCorner = Instance.new("UICorner")
mouseRCorner.CornerRadius = UDim.new(1, 0)
mouseRCorner.Parent = mouseR
local mouseRLabel = Instance.new("TextLabel")
mouseRLabel.Size = UDim2.new(1, 0, 1, 0)
mouseRLabel.BackgroundTransparency = 1
mouseRLabel.Text = "RMB"
mouseRLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
mouseRLabel.Font = Enum.Font.GothamBold
mouseRLabel.TextSize = 10
mouseRLabel.Parent = mouseR

local function HighlightKey(btn, active)
    local targetColor = active and Color3.fromRGB(184, 134, 255) or Color3.fromRGB(30, 30, 40)
    local borderColor = active and Color3.fromRGB(255, 200, 255) or Color3.fromRGB(80, 80, 100)
    TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = targetColor, BorderColor3 = borderColor}):Play()
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then HighlightKey(keyButtons["W"].frame, true)
    elseif input.KeyCode == Enum.KeyCode.A then HighlightKey(keyButtons["A"].frame, true)
    elseif input.KeyCode == Enum.KeyCode.S then HighlightKey(keyButtons["S"].frame, true)
    elseif input.KeyCode == Enum.KeyCode.D then HighlightKey(keyButtons["D"].frame, true)
    elseif input.KeyCode == Enum.KeyCode.Space then HighlightKey(spaceBtn, true)
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then HighlightKey(mouseL, true)
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then HighlightKey(mouseR, true)
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then HighlightKey(keyButtons["W"].frame, false)
    elseif input.KeyCode == Enum.KeyCode.A then HighlightKey(keyButtons["A"].frame, false)
    elseif input.KeyCode == Enum.KeyCode.S then HighlightKey(keyButtons["S"].frame, false)
    elseif input.KeyCode == Enum.KeyCode.D then HighlightKey(keyButtons["D"].frame, false)
    elseif input.KeyCode == Enum.KeyCode.Space then HighlightKey(spaceBtn, false)
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then HighlightKey(mouseL, false)
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then HighlightKey(mouseR, false)
    end
end)

-- ========== ОСНОВНОЕ МЕНЮ (с красным и зелёным кругами) ==========
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 750, 0, 500)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
MainFrame.Active = false
MainFrame.Draggable = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Кастомный заголовок с кругами
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
TitleBar.Active = false

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Название "ww"
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 60, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ww"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Зелёный круг — перетаскивание меню
local DragCircle = Instance.new("Frame")
DragCircle.Size = UDim2.new(0, 28, 0, 28)
DragCircle.Position = UDim2.new(1, -70, 0.5, -14)
DragCircle.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
DragCircle.BorderSizePixel = 0
DragCircle.Parent = TitleBar
local DragCircleCorner = Instance.new("UICorner")
DragCircleCorner.CornerRadius = UDim.new(1, 0)
DragCircleCorner.Parent = DragCircle

local draggingMain = false
local dragStartPos
local dragStartMouse
DragCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = true
        dragStartPos = MainFrame.Position
        dragStartMouse = input.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMouse
        MainFrame.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = false
    end
end)

-- Красный круг — просто закрыть меню (как INSERT)
local ExitCircle = Instance.new("Frame")
ExitCircle.Size = UDim2.new(0, 28, 0, 28)
ExitCircle.Position = UDim2.new(1, -35, 0.5, -14)
ExitCircle.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
ExitCircle.BorderSizePixel = 0
ExitCircle.Parent = TitleBar
local ExitCircleCorner = Instance.new("UICorner")
ExitCircleCorner.CornerRadius = UDim.new(1, 0)
ExitCircleCorner.Parent = ExitCircle
ExitCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MainFrame.Visible = false
        SetBackgroundEffect(false)
    end
end)

-- Левая панель
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 180, 1, -40)
LeftPanel.Position = UDim2.new(0, 0, 0, 40)
LeftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
LeftPanel.BackgroundTransparency = 0.2
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = MainFrame
local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 0)
LeftCorner.Parent = LeftPanel

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 40)
Logo.Position = UDim2.new(0, 0, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Text = "ww MENU"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 18
Logo.TextXAlignment = Enum.TextXAlignment.Center
Logo.Parent = LeftPanel

local tabs = {"Combat", "Movement", "Render", "Misc"}
local tabButtons = {}
local function CreateTabButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BackgroundTransparency = 0.8
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = LeftPanel
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 3, 1, -10)
    line.Position = UDim2.new(0, 0, 0, 5)
    line.BackgroundColor3 = Color3.fromRGB(184, 134, 255)
    line.BackgroundTransparency = 1
    line.BorderSizePixel = 0
    line.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if Settings.CurrentTab == name then return end
        Settings.CurrentTab = name
        for _, b in pairs(tabButtons) do
            b.btn.BackgroundTransparency = 0.8
            b.line.BackgroundTransparency = 1
            b.btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        btn.BackgroundTransparency = 0.6
        line.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        UpdateRightPanel()
    end)
    return {btn = btn, line = line}
end

local yOff = 65
for _, t in ipairs(tabs) do
    tabButtons[t] = CreateTabButton(t, yOff)
    yOff = yOff + 48
end
tabButtons["Combat"].btn.BackgroundTransparency = 0.6
tabButtons["Combat"].line.BackgroundTransparency = 0
tabButtons["Combat"].btn.TextColor3 = Color3.fromRGB(255, 255, 255)

local InfoBar = Instance.new("TextLabel")
InfoBar.Size = UDim2.new(1, -20, 0, 25)
InfoBar.Position = UDim2.new(0, 10, 1, -30)
InfoBar.BackgroundTransparency = 1
InfoBar.Text = "ww | UID: 1997"
InfoBar.TextColor3 = Color3.fromRGB(200, 200, 220)
InfoBar.Font = Enum.Font.Gotham
InfoBar.TextSize = 10
InfoBar.TextXAlignment = Enum.TextXAlignment.Left
InfoBar.Parent = LeftPanel

-- Правая панель
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -190, 1, -40)
RightPanel.Position = UDim2.new(0, 185, 0, 40)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

local ContentScroller = Instance.new("ScrollingFrame")
ContentScroller.Size = UDim2.new(1, 0, 1, 0)
ContentScroller.BackgroundTransparency = 1
ContentScroller.BorderSizePixel = 0
ContentScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroller.ScrollBarThickness = 6
ContentScroller.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ContentScroller.Parent = RightPanel

-- ========== ОКНО НАСТРОЕК АИМБОТА (компактное) ==========
local AimbotSettingsWindow = Instance.new("Frame")
AimbotSettingsWindow.Size = UDim2.new(0, 280, 0, 280)
AimbotSettingsWindow.Position = UDim2.new(0.5, -140, 0.5, -140)
AimbotSettingsWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
AimbotSettingsWindow.BackgroundTransparency = 0.05
AimbotSettingsWindow.BorderSizePixel = 2
AimbotSettingsWindow.BorderColor3 = Color3.fromRGB(184, 134, 255)
AimbotSettingsWindow.Visible = false
AimbotSettingsWindow.Parent = ScreenGui
AimbotSettingsWindow.ZIndex = 20
AimbotSettingsWindow.Active = true
AimbotSettingsWindow.Draggable = true

local WinCorner = Instance.new("UICorner")
WinCorner.CornerRadius = UDim.new(0, 10)
WinCorner.Parent = AimbotSettingsWindow

local WinTitle = Instance.new("TextLabel")
WinTitle.Size = UDim2.new(1, 0, 0, 32)
WinTitle.Position = UDim2.new(0, 0, 0, 0)
WinTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
WinTitle.Text = "⚙️ Aimbot Settings"
WinTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WinTitle.Font = Enum.Font.GothamBold
WinTitle.TextSize = 13
WinTitle.Parent = AimbotSettingsWindow

local WinCloseCircle = Instance.new("Frame")
WinCloseCircle.Size = UDim2.new(0, 22, 0, 22)
WinCloseCircle.Position = UDim2.new(1, -28, 0.5, -11)
WinCloseCircle.BackgroundColor3 = Color3.fromRGB(200, 60, 70)
WinCloseCircle.BorderSizePixel = 0
WinCloseCircle.Parent = WinTitle
local WinCloseCorner = Instance.new("UICorner")
WinCloseCorner.CornerRadius = UDim.new(1,0)
WinCloseCorner.Parent = WinCloseCircle
WinCloseCircle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        AimbotSettingsWindow.Visible = false
    end
end)

local function BuildAimbotWindow()
    for _, ch in pairs(AimbotSettingsWindow:GetChildren()) do
        if ch:IsA("Frame") and ch ~= WinTitle then ch:Destroy() end
    end
    local y = 45
    local function AddSlider(text, minV, maxV, getter, setter, suffix)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 45)
        frame.Position = UDim2.new(0, 10, 0, y)
        frame.BackgroundTransparency = 1
        frame.Parent = AimbotSettingsWindow
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220,220,240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.3, 0, 0, 20)
        valLabel.Position = UDim2.new(0.7, 0, 0, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(getter()) .. (suffix or "")
        valLabel.TextColor3 = Color3.fromRGB(184,134,255)
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 11
        valLabel.Parent = frame
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, 0, 0, 3)
        track.Position = UDim2.new(0, 0, 0, 25)
        track.BackgroundColor3 = Color3.fromRGB(50,50,65)
        track.BorderSizePixel = 0
        track.Parent = frame
        local fill = Instance.new("Frame")
        local percent = (getter() - minV) / (maxV - minV)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(184,134,255)
        fill.BorderSizePixel = 0
        fill.Parent = track
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 10, 0, 10)
        knob.Position = UDim2.new(percent, -5, 0.5, -5)
        knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        knob.BorderSizePixel = 0
        knob.Parent = track
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1,0)
        knobCorner.Parent = knob
        local dragging = false
        local curr = getter()
        local function Update(val)
            curr = math.clamp(val, minV, maxV)
            setter(curr)
            local p = (curr - minV) / (maxV - minV)
            fill.Size = UDim2.new(p, 0, 1, 0)
            knob.Position = UDim2.new(p, -5, 0.5, -5)
            valLabel.Text = string.format("%.1f", curr) .. (suffix or "")
        end
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local x = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                Update(minV + (maxV - minV) * x)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local x = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                Update(minV + (maxV - minV) * x)
            end
        end)
        y = y + 52
    end
    AddSlider("FOV Radius", 50, 300, function() return Settings.AimbotFOV end, function(v) Settings.AimbotFOV = v end, "")
    AddSlider("Smoothness", 0.1, 0.8, function() return Settings.AimbotSmoothness end, function(v) Settings.AimbotSmoothness = v end, "")
    AddSlider("Attack Radius", 0.5, 10, function() return Settings.AimbotRadius end, function(v) Settings.AimbotRadius = v end, "")
    AddSlider("Extra Distance", 0, 5, function() return Settings.AimbotExtraDist end, function(v) Settings.AimbotExtraDist = v end, "")
    -- чекбокс Ignore Walls
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = AimbotSettingsWindow
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Ignore Walls"
    label.TextColor3 = Color3.fromRGB(220,220,240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.Parent = frame
    local btn = Instance.new("Frame")
    btn.Size = UDim2.new(0, 35, 0, 18)
    btn.Position = UDim2.new(1, -40, 0.5, -9)
    btn.BackgroundColor3 = Settings.IgnoreWalls and Color3.fromRGB(184,134,255) or Color3.fromRGB(70,70,90)
    btn.BorderSizePixel = 0
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1,0)
    btnCorner.Parent = btn
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = Settings.IgnoreWalls and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circle.BorderSizePixel = 0
    circle.Parent = btn
    local circCorner = Instance.new("UICorner")
    circCorner.CornerRadius = UDim.new(1,0)
    circCorner.Parent = circle
    local state = Settings.IgnoreWalls
    local function Toggle()
        state = not state
        Settings.IgnoreWalls = state
        btn.BackgroundColor3 = state and Color3.fromRGB(184,134,255) or Color3.fromRGB(70,70,90)
        circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    end
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then Toggle() end
    end)
    y = y + 40
    AimbotSettingsWindow.Size = UDim2.new(0, 280, 0, y+15)
end

-- ========== ФУНКЦИИ ДЛЯ ПОСТРОЕНИЯ ОСНОВНОГО ИНТЕРФЕЙСА ==========
local function CreateSection(parent, title, yPos)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 120)
    section.Position = UDim2.new(0, 10, 0, yPos)
    section.BackgroundTransparency = 1
    section.Parent = parent
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    -- Шестерёнка настроек аимбота (только для секции Combat)
    if title == "Attack Aura" then
        local gearBtn = Instance.new("TextButton")
        gearBtn.Size = UDim2.new(0, 24, 0, 24)
        gearBtn.Position = UDim2.new(1, -28, 0, 0)
        gearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        gearBtn.Text = "⚙️"
        gearBtn.TextColor3 = Color3.fromRGB(255,255,255)
        gearBtn.Font = Enum.Font.GothamBold
        gearBtn.TextSize = 14
        gearBtn.Parent = section
        local gearCorner = Instance.new("UICorner")
        gearCorner.CornerRadius = UDim.new(1,0)
        gearCorner.Parent = gearBtn
        gearBtn.MouseButton1Click:Connect(function()
            BuildAimbotWindow()
            AimbotSettingsWindow.Visible = true
        end)
    end
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 28)
    line.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    line.Parent = section
    return section
end

local function CreateToggle(parent, yPos, text, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 38, 0, 19)
    toggleBtn.Position = UDim2.new(1, -43, 0.5, -9.5)
    toggleBtn.BackgroundColor3 = getter() and Color3.fromRGB(184, 134, 255) or Color3.fromRGB(70, 70, 90)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 15, 0, 15)
    circle.Position = getter() and UDim2.new(1, -17, 0.5, -7.5) or UDim2.new(0, 2, 0.5, -7.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBtn
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    local state = getter()
    local function Update()
        state = not state
        setter(state)
        local targetColor = state and Color3.fromRGB(184, 134, 255) or Color3.fromRGB(70, 70, 90)
        TweenService:Create(toggleBtn, TweenInfo.new(0.12), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.12), {Position = state and UDim2.new(1, -17, 0.5, -7.5) or UDim2.new(0, 2, 0.5, -7.5)}):Play()
    end
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Update() end
    end)
    return frame
end

local function CreateSlider(parent, yPos, text, minVal, maxVal, getter, setter, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(getter()) .. (suffix or "")
    valueLabel.TextColor3 = Color3.fromRGB(184, 134, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 3)
    track.Position = UDim2.new(0, 0, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    track.BorderSizePixel = 0
    track.Parent = frame
    local fill = Instance.new("Frame")
    local percent = (getter() - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(184, 134, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 11, 0, 11)
    knob.Position = UDim2.new(percent, -5.5, 0.5, -5.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    local dragging = false
    local currentVal = getter()
    local function Update(val)
        currentVal = math.clamp(val, minVal, maxVal)
        setter(currentVal)
        local p = (currentVal - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -5.5, 0.5, -5.5)
        valueLabel.Text = string.format("%.1f", currentVal) .. (suffix or "")
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local x = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            Update(minVal + (maxVal - minVal) * x)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            Update(minVal + (maxVal - minVal) * x)
        end
    end)
    return frame
end

function UpdateRightPanel()
    for _, ch in pairs(ContentScroller:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
    local y = 0
    local tab = Settings.CurrentTab
    if tab == "Combat" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 35)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.Text = "Combat"
        title.TextColor3 = Color3.fromRGB(255,255,255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = ContentScroller
        y = y + 40
        
        local aSec = CreateSection(ContentScroller, "Attack Aura", y)
        y = y + 70
        CreateToggle(aSec, 35, "Ignore Walls", function() return Settings.IgnoreWalls end, function(v) Settings.IgnoreWalls = v end)
        CreateSlider(aSec, 75, "Attack Radius", 0.5, 10, function() return Settings.AimbotRadius end, function(v) Settings.AimbotRadius = v end, "")
        CreateSlider(aSec, 125, "Extra Distance", 0, 5, function() return Settings.AimbotExtraDist end, function(v) Settings.AimbotExtraDist = v end, "")
        aSec.Size = UDim2.new(1, -20, 0, 175)
        y = y + 185
        
        local eSec = CreateSection(ContentScroller, "Entity Box", y)
        y = y + 70
        CreateSlider(eSec, 35, "Hitbox Scale", 0, 1, function() return Settings.HitboxScale end, function(v) Settings.HitboxScale = v end, "")
        eSec.Size = UDim2.new(1, -20, 0, 90)
        y = y + 100
        
        local bSec = CreateSection(ContentScroller, "Back Track", y)
        y = y + 70
        CreateSlider(bSec, 35, "Max Distance", 0, 10, function() return Settings.BackTrackMax end, function(v) Settings.BackTrackMax = v end, "")
        CreateSlider(bSec, 85, "Min Distance", 0, 5, function() return Settings.BackTrackMin end, function(v) Settings.BackTrackMin = v end, "")
        bSec.Size = UDim2.new(1, -20, 0, 135)
        y = y + 145
        
    elseif tab == "Movement" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 35)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.Text = "Movement"
        title.TextColor3 = Color3.fromRGB(255,255,255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = ContentScroller
        y = y + 40
        CreateSlider(ContentScroller, y, "Walk Speed", 10, 50, function() return Settings.WalkSpeed end, function(v) Settings.WalkSpeed = v; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end, "")
        y = y + 55
        CreateSlider(ContentScroller, y, "Jump Power", 30, 100, function() return Settings.JumpPower end, function(v) Settings.JumpPower = v; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end end, "")
        y = y + 55
    elseif tab == "Render" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 35)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.Text = "Render"
        title.TextColor3 = Color3.fromRGB(255,255,255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = ContentScroller
        y = y + 40
        CreateSlider(ContentScroller, y, "FOV", 60, 120, function() return Settings.RenderFOV end, function(v) Settings.RenderFOV = v; workspace.CurrentCamera.FieldOfView = v end, "°")
        y = y + 55
        CreateToggle(ContentScroller, y, "ESP Enabled", function() return Settings.ESPEnabled end, function(v) Settings.ESPEnabled = v end)
        y = y + 35
        CreateToggle(ContentScroller, y, "ESP Boxes", function() return Settings.ESPBoxes end, function(v) Settings.ESPBoxes = v end)
        y = y + 35
        CreateToggle(ContentScroller, y, "ESP Names", function() return Settings.ESPNames end, function(v) Settings.ESPNames = v end)
        y = y + 35
        CreateToggle(ContentScroller, y, "ESP Health", function() return Settings.ESPHealth end, function(v) Settings.ESPHealth = v end)
        y = y + 50
        CreateSlider(ContentScroller, y, "Saturation", -1, 1, function() return Settings.PostFXSat end, function(v) Settings.PostFXSat = v; ColorCorrection.Saturation = v end, "")
        y = y + 55
        CreateSlider(ContentScroller, y, "Brightness", -1, 1, function() return Settings.PostFXBright end, function(v) Settings.PostFXBright = v; ColorCorrection.Brightness = v end, "")
        y = y + 55
    elseif tab == "Misc" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 35)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.Text = "Misc"
        title.TextColor3 = Color3.fromRGB(255,255,255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = ContentScroller
        y = y + 40
        
        local bindFrame = Instance.new("Frame")
        bindFrame.Size = UDim2.new(1, -20, 0, 38)
        bindFrame.Position = UDim2.new(0, 10, 0, y)
        bindFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
        bindFrame.BackgroundTransparency = 0.5
        bindFrame.Parent = ContentScroller
        local bindCorner = Instance.new("UICorner")
        bindCorner.CornerRadius = UDim.new(0, 6)
        bindCorner.Parent = bindFrame
        local bindLabel = Instance.new("TextLabel")
        bindLabel.Size = UDim2.new(0.6, 0, 1, 0)
        bindLabel.Position = UDim2.new(0, 12, 0, 0)
        bindLabel.BackgroundTransparency = 1
        bindLabel.Text = "Menu Keybind"
        bindLabel.TextColor3 = Color3.fromRGB(220,220,240)
        bindLabel.Font = Enum.Font.Gotham
        bindLabel.TextSize = 12
        bindLabel.TextXAlignment = Enum.TextXAlignment.Left
        bindLabel.Parent = bindFrame
        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0, 70, 0, 28)
        keyBtn.Position = UDim2.new(1, -80, 0.5, -14)
        keyBtn.BackgroundColor3 = Color3.fromRGB(50,50,70)
        keyBtn.Text = Settings.MenuKey.Name
        keyBtn.TextColor3 = Color3.fromRGB(255,255,255)
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.TextSize = 12
        keyBtn.Parent = bindFrame
        local waiting = false
        keyBtn.MouseButton1Click:Connect(function()
            waiting = true
            keyBtn.Text = "..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if waiting and input.KeyCode ~= Enum.KeyCode.Unknown then
                    waiting = false
                    Settings.MenuKey = input.KeyCode
                    keyBtn.Text = input.KeyCode.Name
                    conn:Disconnect()
                end
            end)
            task.wait(5)
            if waiting then
                waiting = false
                keyBtn.Text = Settings.MenuKey.Name
            end
        end)
        y = y + 48
        
        local credits = Instance.new("TextLabel")
        credits.Size = UDim2.new(1, -20, 0, 25)
        credits.Position = UDim2.new(0, 10, 0, y)
        credits.BackgroundTransparency = 1
        credits.Text = "ww by WHITEWIN"
        credits.TextColor3 = Color3.fromRGB(184, 134, 255)
        credits.Font = Enum.Font.Gotham
        credits.TextSize = 11
        credits.TextXAlignment = Enum.TextXAlignment.Left
        credits.Parent = ContentScroller
        y = y + 30
    end
    ContentScroller.CanvasSize = UDim2.new(0, 0, 0, y + 30)
end

-- === ОТКРЫТИЕ МЕНЮ ПО БИНДУ ===
local menuOpen = false
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Settings.MenuKey then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
        SetBackgroundEffect(menuOpen)
        if menuOpen then
            UpdateRightPanel()
        end
    end
end)

-- Уведомление
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 280, 0, 35)
notify.Position = UDim2.new(0.5, -140, 0.85, 0)
notify.BackgroundColor3 = Color3.fromRGB(0,0,0)
notify.BackgroundTransparency = 0.3
notify.BorderSizePixel = 1
notify.BorderColor3 = Color3.fromRGB(184,134,255)
notify.Text = "ww MENU | INSERT"
notify.TextColor3 = Color3.fromRGB(255,255,255)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 13
notify.Parent = ScreenGui
local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 8)
notifyCorner.Parent = notify
task.wait(4)
notify:Destroy()

print("✅ ww UI loaded | Press " .. Settings.MenuKey.Name)