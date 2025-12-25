local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local HttpService = game:GetService("HttpService")
local SETTINGS_FILE = "pixells/px_settings.json"

local Settings = {
    SpeedBoost = false,
    InfJump = false,
    AutoDestroyTurret = false,
    AutoStealHighest = false,
    Aimbot = false,
    
    InstantCloneKey = Enum.KeyCode.V,
    TPHighestKey = Enum.KeyCode.T,
    UIToggleKey = Enum.KeyCode.C,
    SpeedBoostKey = Enum.KeyCode.Q
}

local function SaveSettings()
    pcall(function()
        local data = {}
        for k, v in pairs(Settings) do
            if typeof(v) == "EnumItem" then
                data[k] = {type = "KeyCode", value = v.Name}
            else
                data[k] = v
            end
        end
        writefile(SETTINGS_FILE, HttpService:JSONEncode(data))
    end)
end

local function LoadSettings()
    pcall(function()
        if isfile and isfile(SETTINGS_FILE) then
            local data = HttpService:JSONDecode(readfile(SETTINGS_FILE))
            for k, v in pairs(data) do
                if type(v) == "table" and v.type == "KeyCode" then
                    Settings[k] = Enum.KeyCode[v.value]
                else
                    Settings[k] = v
                end
            end
        end
    end)
end

LoadSettings()

local CurrentTab = "Main"
local UIVisible = true

local Theme = {
    Background = Color3.fromRGB(10, 10, 14),
    TopBar = Color3.fromRGB(6, 6, 10),
    Secondary = Color3.fromRGB(18, 18, 24),
    Tertiary = Color3.fromRGB(28, 28, 36),
    Hover = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDim = Color3.fromRGB(180, 180, 190),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(100, 100, 115),
    Border = Color3.fromRGB(40, 40, 50),
    Success = Color3.fromRGB(80, 220, 100),
    Danger = Color3.fromRGB(255, 80, 80)
}

local function Tween(obj, props, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PIXELLS"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 360, 0, 400)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
AddCorner(MainFrame, 12)
AddStroke(MainFrame, Theme.Border, 1)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Theme.TopBar
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
AddCorner(TopBar, 12)

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 15)
TopBarFix.Position = UDim2.new(0, 0, 1, -15)
TopBarFix.BackgroundColor3 = Theme.TopBar
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 80, 1, 0)
Logo.Position = UDim2.new(0, 14, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "PIXELLS"
Logo.TextColor3 = Theme.Accent
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 15
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TopBar

local VersionBg = Instance.new("Frame")
VersionBg.Size = UDim2.new(0, 32, 0, 16)
VersionBg.Position = UDim2.new(0, 90, 0.5, -8)
VersionBg.BackgroundColor3 = Theme.Tertiary
VersionBg.Parent = TopBar
AddCorner(VersionBg, 4)

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 1, 0)
Version.BackgroundTransparency = 1
Version.Text = "v1.0"
Version.TextColor3 = Theme.TextDim
Version.Font = Enum.Font.Gotham
Version.TextSize = 10
Version.Parent = VersionBg

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 6, 0, 6)
StatusDot.Position = UDim2.new(1, -70, 0.5, -3)
StatusDot.BackgroundColor3 = Theme.Success
StatusDot.Parent = TopBar
AddCorner(StatusDot, 3)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 40, 1, 0)
StatusLabel.Position = UDim2.new(1, -62, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "READY"
StatusLabel.TextColor3 = Theme.TextDim
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = TopBar



local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 38)
TabBar.Position = UDim2.new(0, 8, 0, 42)
TabBar.BackgroundColor3 = Theme.TopBar
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
AddCorner(TabBar, 6)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 4)
TabPadding.PaddingRight = UDim.new(0, 4)
TabPadding.Parent = TabBar

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -16, 1, -130)
Content.Position = UDim2.new(0, 8, 0, 84)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = Theme.AccentDim
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.Parent = Content

local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 32)
Footer.Position = UDim2.new(0, 0, 1, -32)
Footer.BackgroundColor3 = Theme.TopBar
Footer.BorderSizePixel = 0
Footer.Parent = MainFrame
AddCorner(Footer, 12)

local FooterFix = Instance.new("Frame")
FooterFix.Size = UDim2.new(1, 0, 0, 15)
FooterFix.Position = UDim2.new(0, 0, 0, 0)
FooterFix.BackgroundColor3 = Theme.TopBar
FooterFix.BorderSizePixel = 0
FooterFix.Parent = Footer

local FooterLine = Instance.new("Frame")
FooterLine.Size = UDim2.new(1, 0, 0, 1)
FooterLine.Position = UDim2.new(0, 0, 0, 0)
FooterLine.BackgroundColor3 = Theme.Border
FooterLine.BorderSizePixel = 0
FooterLine.Parent = Footer

local FooterText = Instance.new("TextLabel")
FooterText.Size = UDim2.new(0, 100, 1, 0)
FooterText.Position = UDim2.new(0, 12, 0, 0)
FooterText.BackgroundTransparency = 1
FooterText.Text = "pixells.sbs"
FooterText.TextColor3 = Theme.TextDim
FooterText.Font = Enum.Font.Gotham
FooterText.TextSize = 9
FooterText.TextXAlignment = Enum.TextXAlignment.Left
FooterText.Parent = Footer

local KeyHints = Instance.new("Frame")
KeyHints.Size = UDim2.new(0, 120, 0, 20)
KeyHints.Position = UDim2.new(1, -130, 0.5, -10)
KeyHints.BackgroundTransparency = 1
KeyHints.Parent = Footer

local KeyHintLayout = Instance.new("UIListLayout")
KeyHintLayout.FillDirection = Enum.FillDirection.Horizontal
KeyHintLayout.Padding = UDim.new(0, 6)
KeyHintLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
KeyHintLayout.Parent = KeyHints

local function CreateKeyHint(text, key)
    local hint = Instance.new("Frame")
    hint.Size = UDim2.new(0, 50, 0, 18)
    hint.BackgroundColor3 = Theme.Tertiary
    hint.Parent = KeyHints
    AddCorner(hint, 3)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = key .. " " .. text
    label.TextColor3 = Theme.TextDim
    label.Font = Enum.Font.Gotham
    label.TextSize = 9
    label.Parent = hint
end

CreateKeyHint("toggle", "C")

local Tabs = {"Main", "Stealer", "Settings"}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local tab = Instance.new("TextButton")
    tab.Name = tabName
    tab.Size = UDim2.new(0, 105, 0, 30)
    tab.BackgroundColor3 = tabName == CurrentTab and Theme.Accent or Color3.new(0, 0, 0)
    tab.BackgroundTransparency = tabName == CurrentTab and 0 or 1
    tab.Text = tabName:upper()
    tab.TextColor3 = tabName == CurrentTab and Theme.Background or Theme.TextDim
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 11
    tab.LayoutOrder = i
    tab.Parent = TabBar
    AddCorner(tab, 6)
    
    TabButtons[tabName] = tab
    
    tab.MouseButton1Click:Connect(function()
        CurrentTab = tabName
        for name, btn in pairs(TabButtons) do
            if name == tabName then
                Tween(btn, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0}, 0.2)
                btn.TextColor3 = Theme.Background
            else
                Tween(btn, {BackgroundTransparency = 1}, 0.2)
                btn.TextColor3 = Theme.TextDim
            end
        end
        RenderContent()
    end)
    
    tab.MouseEnter:Connect(function()
        if tabName ~= CurrentTab then
            Tween(tab, {BackgroundColor3 = Theme.Tertiary, BackgroundTransparency = 0}, 0.15)
            tab.TextColor3 = Theme.Text
        end
    end)
    
    tab.MouseLeave:Connect(function()
        if tabName ~= CurrentTab then
            Tween(tab, {BackgroundTransparency = 1}, 0.15)
            tab.TextColor3 = Theme.TextDim
        end
    end)
end

local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 28)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 3, 0, 3)
    dot.Position = UDim2.new(0, 4, 0.5, -1)
    dot.BackgroundColor3 = Theme.Accent
    dot.Parent = section
    AddCorner(dot, 2)
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -15, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = title
    text.TextColor3 = Theme.TextDim
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.GothamBold
    text.TextSize = 10
    text.Parent = section
    
    return section
end

local function CreateToggle(parent, label, settingKey)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = Theme.Secondary
    container.Parent = parent
    AddCorner(container, 8)
    
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(container, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        end
    end)
    container.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
        end
    end)
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.7, -10, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = Theme.Text
    text.Font = Enum.Font.GothamMedium
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = container
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -48, 0.5, -9)
    toggleBg.BackgroundColor3 = Settings[settingKey] and Theme.Accent or Theme.Tertiary
    toggleBg.Parent = container
    AddCorner(toggleBg, 9)
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 14, 0, 14)
    toggleKnob.Position = Settings[settingKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    toggleKnob.BackgroundColor3 = Settings[settingKey] and Theme.Background or Theme.TextDim
    toggleKnob.Parent = toggleBg
    AddCorner(toggleKnob, 7)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container
    
    btn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        SaveSettings()
        
        if Settings[settingKey] then
            Tween(toggleBg, {BackgroundColor3 = Theme.Accent}, 0.25)
            Tween(toggleKnob, {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Theme.Background}, 0.25)
        else
            Tween(toggleBg, {BackgroundColor3 = Theme.Tertiary}, 0.25)
            Tween(toggleKnob, {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Theme.TextDim}, 0.25)
        end
        
    end)
    
    return container
end

local function CreateButton(parent, label, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = Theme.Secondary
    container.Parent = parent
    AddCorner(container, 8)
    
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(container, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        end
    end)
    container.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
        end
    end)
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.7, -10, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = Theme.Text
    text.Font = Enum.Font.GothamMedium
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = container
    
    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0, 50, 0, 22)
    runBtn.Position = UDim2.new(1, -62, 0.5, -11)
    runBtn.BackgroundColor3 = Theme.Accent
    runBtn.Text = "RUN"
    runBtn.TextColor3 = Theme.Background
    runBtn.Font = Enum.Font.GothamBold
    runBtn.TextSize = 10
    runBtn.Parent = container
    AddCorner(runBtn, 5)
    
    runBtn.MouseButton1Click:Connect(function()
        Tween(runBtn, {BackgroundColor3 = Theme.Success}, 0.1)
        task.wait(0.1)
        Tween(runBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
        if callback then callback() end
    end)
    
    runBtn.MouseEnter:Connect(function()
        runBtn.BackgroundTransparency = 0.15
    end)
    runBtn.MouseLeave:Connect(function()
        runBtn.BackgroundTransparency = 0
    end)
    
    return container
end

local function CreateKeybind(parent, label, settingKey)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = Theme.Secondary
    container.Parent = parent
    AddCorner(container, 8)
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.6, 0, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = Theme.Text
    text.Font = Enum.Font.GothamMedium
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = container
    
    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 50, 0, 22)
    keyBtn.Position = UDim2.new(1, -62, 0.5, -11)
    keyBtn.BackgroundColor3 = Theme.Tertiary
    keyBtn.Text = Settings[settingKey].Name
    keyBtn.TextColor3 = Theme.AccentDim
    keyBtn.Font = Enum.Font.GothamMedium
    keyBtn.TextSize = 10
    keyBtn.Parent = container
    AddCorner(keyBtn, 5)
    AddStroke(keyBtn, Theme.Border, 1)
    
    local listening = false
    
    keyBtn.MouseButton1Click:Connect(function()
        if not listening then
            listening = true
            keyBtn.Text = "..."
            keyBtn.TextColor3 = Theme.Accent
            
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Settings[settingKey] = input.KeyCode
                    SaveSettings()
                    keyBtn.Text = input.KeyCode.Name
                    keyBtn.TextColor3 = Theme.AccentDim
                    listening = false
                    conn:Disconnect()
                end
            end)
        end
    end)
    
    keyBtn.MouseEnter:Connect(function()
        if not listening then
            Tween(keyBtn, {BackgroundColor3 = Theme.Hover}, 0.15)
        end
    end)
    keyBtn.MouseLeave:Connect(function()
        if not listening then
            Tween(keyBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        end
    end)
    
    return container
end

function RenderContent()
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if CurrentTab == "Main" then
        CreateButton(Content, "Desync", function() end)
        CreateButton(Content, "FPS Boost", function()
            if not _G.Ignore then _G.Ignore = {} end
            if _G.SendNotifications == nil then _G.SendNotifications = false end
            if _G.ConsoleLogs == nil then _G.ConsoleLogs = false end
            
            if not _G.Settings then
                _G.Settings = {
                    Players = {["Ignore Me"] = true, ["Ignore Others"] = true, ["Ignore Tools"] = true},
                    Meshes = {NoMesh = false, NoTexture = false, Destroy = false},
                    Images = {Invisible = true, Destroy = false},
                    Explosions = {Smaller = true, Invisible = false, Destroy = false},
                    Particles = {Invisible = true, Destroy = false},
                    TextLabels = {LowerQuality = false, Invisible = false, Destroy = false},
                    MeshParts = {LowerQuality = true, Invisible = false, NoTexture = false, NoMesh = false, Destroy = false},
                    Other = {
                        ["FPS Cap"] = true,
                        ["No Camera Effects"] = true,
                        ["No Clothes"] = true,
                        ["Low Water Graphics"] = true,
                        ["No Shadows"] = true,
                        ["Low Rendering"] = true,
                        ["Low Quality Parts"] = true,
                        ["Low Quality Models"] = true,
                        ["Reset Materials"] = true,
                        ["Lower Quality MeshParts"] = true,
                        ClearNilInstances = false
                    }
                }
            end
            
            local Players, Lighting, StarterGui, MaterialService = game:GetService("Players"), game:GetService("Lighting"), game:GetService("StarterGui"), game:GetService("MaterialService")
            local ME, CanBeEnabled = Players.LocalPlayer, {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}
            
            local function PartOfCharacter(Inst)
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= ME and v.Character and Inst:IsDescendantOf(v.Character) then return true end
                end
                return false
            end
            
            local function DescendantOfIgnore(Inst)
                for _, v in pairs(_G.Ignore) do
                    if Inst:IsDescendantOf(v) then return true end
                end
                return false
            end
            
            local function CheckIfBad(Inst)
                if not Inst:IsDescendantOf(Players) and (_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Inst) or not _G.Settings.Players["Ignore Others"]) and (_G.Settings.Players["Ignore Me"] and ME.Character and not Inst:IsDescendantOf(ME.Character) or not _G.Settings.Players["Ignore Me"]) and (_G.Settings.Players["Ignore Tools"] and not Inst:IsA("BackpackItem") and not Inst:FindFirstAncestorWhichIsA("BackpackItem") or not _G.Settings.Players["Ignore Tools"]) and (_G.Ignore and not table.find(_G.Ignore, Inst) and not DescendantOfIgnore(Inst) or (not _G.Ignore or type(_G.Ignore) ~= "table" or #_G.Ignore <= 0)) then
                    pcall(function()
                        if Inst:IsA("DataModelMesh") then
                            if Inst:IsA("SpecialMesh") then
                                if _G.Settings.Meshes.NoMesh then Inst.MeshId = "" end
                                if _G.Settings.Meshes.NoTexture then Inst.TextureId = "" end
                            end
                            if _G.Settings.Meshes.Destroy then Inst:Destroy() end
                        elseif Inst:IsA("FaceInstance") then
                            if _G.Settings.Images.Invisible then Inst.Transparency = 1 Inst.Shiny = 1 end
                            if _G.Settings.Images.Destroy then Inst:Destroy() end
                        elseif Inst:IsA("ShirtGraphic") then
                            if _G.Settings.Images.Invisible then Inst.Graphic = "" end
                            if _G.Settings.Images.Destroy then Inst:Destroy() end
                        elseif table.find(CanBeEnabled, Inst.ClassName) then
                            if _G.Settings.Particles and _G.Settings.Particles.Invisible then Inst.Enabled = false end
                            if _G.Settings.Particles and _G.Settings.Particles.Destroy then Inst:Destroy() end
                        elseif Inst:IsA("PostEffect") and _G.Settings.Other["No Camera Effects"] then
                            Inst.Enabled = false
                        elseif Inst:IsA("Explosion") then
                            if _G.Settings.Explosions.Smaller then Inst.BlastPressure = 1 Inst.BlastRadius = 1 end
                            if _G.Settings.Explosions.Invisible then Inst.Visible = false end
                            if _G.Settings.Explosions.Destroy then Inst:Destroy() end
                        elseif Inst:IsA("Clothing") or Inst:IsA("SurfaceAppearance") or Inst:IsA("BaseWrap") then
                            if _G.Settings.Other["No Clothes"] then Inst:Destroy() end
                        elseif Inst:IsA("BasePart") and not Inst:IsA("MeshPart") then
                            if _G.Settings.Other["Low Quality Parts"] then Inst.Material = Enum.Material.Plastic Inst.Reflectance = 0 end
                        elseif Inst:IsA("Model") then
                            if _G.Settings.Other["Low Quality Models"] then Inst.LevelOfDetail = 1 end
                        elseif Inst:IsA("MeshPart") then
                            if _G.Settings.MeshParts.LowerQuality then Inst.RenderFidelity = 2 Inst.Reflectance = 0 Inst.Material = Enum.Material.Plastic end
                            if _G.Settings.MeshParts.Invisible then Inst.Transparency = 1 end
                            if _G.Settings.MeshParts.NoTexture then Inst.TextureID = "" end
                            if _G.Settings.MeshParts.Destroy then Inst:Destroy() end
                        end
                    end)
                end
            end
            
            pcall(function()
                local terrain = workspace:FindFirstChildOfClass("Terrain")
                if terrain and _G.Settings.Other["Low Water Graphics"] then
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 0
                    if sethiddenproperty then sethiddenproperty(terrain, "Decoration", false) end
                end
            end)
            
            pcall(function()
                if _G.Settings.Other["No Shadows"] then
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    Lighting.ShadowSoftness = 0
                    if sethiddenproperty then sethiddenproperty(Lighting, "Technology", 2) end
                end
            end)
            
            pcall(function()
                if _G.Settings.Other["Low Rendering"] then
                    settings().Rendering.QualityLevel = 1
                    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
                end
            end)
            
            pcall(function()
                if _G.Settings.Other["Reset Materials"] then
                    for _, v in pairs(MaterialService:GetChildren()) do v:Destroy() end
                    MaterialService.Use2022Materials = false
                end
            end)
            
            pcall(function()
                if _G.Settings.Other["FPS Cap"] and setfpscap then
                    setfpscap(1e6)
                end
            end)
            
            local descendants = game:GetDescendants()
            local batchSize = 200
            coroutine.wrap(function()
                for i, v in pairs(descendants) do
                    pcall(function() CheckIfBad(v) end)
                    if i % batchSize == 0 then
                        task.wait()
                    end
                end
            end)()
            
            local function stripPlayer(char)
                if not char then return end
                pcall(function()
                    for _, item in pairs(char:GetChildren()) do
                        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("Accessory") then
                            item:Destroy()
                        end
                    end
                end)
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then stripPlayer(player.Character) end
                player.CharacterAdded:Connect(stripPlayer)
            end
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(stripPlayer)
            end)
            
            game.DescendantAdded:Connect(function(value)
                task.wait(0.5)
                pcall(function() CheckIfBad(value) end)
            end)
        end)
        CreateButton(Content, "Anti Bee", function() end)
        CreateButton(Content, "Anti Ragdoll", function() end)
        CreateButton(Content, "X-Ray", function()
            local Workspace = game:GetService("Workspace")
            local Players = game:GetService("Players")
            local localPlayer = Players.LocalPlayer
            
            local plots = Workspace:FindFirstChild("Plots")
            local xrayFolders = {"Decorations", "CashPad", "Model", "Slope",}
            
            local function isInXrayFolder(obj)
                local current = obj.Parent
                while current and current ~= plots do
                    if current.Name == "Laser" then
                        return false
                    end
                    for _, folderName in ipairs(xrayFolders) do
                        if current.Name == folderName then
                            return true
                        end
                    end
                    current = current.Parent
                end
                return false
            end
            
            local function applyPlotTransparency(obj)
                if obj:IsA("BasePart") and isInXrayFolder(obj) then
                    pcall(function()
                        obj.Transparency = 0.7
                        obj.CastShadow = false
                        obj.Material = Enum.Material.ForceField
                    end)
                end
            end
            
            if plots then
                for _, plot in pairs(plots:GetChildren()) do
                    for _, part in pairs(plot:GetDescendants()) do
                        applyPlotTransparency(part)
                    end
                end
                plots.DescendantAdded:Connect(function(obj)
                    task.defer(function()
                        applyPlotTransparency(obj)
                    end)
                end)
            end
            
            local function applyPlayerESP(player)
                local function addHighlight(char)
                    if not char then return end
                    local old = char:FindFirstChild("ESPHighlight")
                    if old then old:Destroy() end
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    if player == localPlayer then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = char
                        
                        task.spawn(function()
                            local hue = 0
                            while highlight and highlight.Parent do
                                hue = (hue + 0.01) % 1
                                pcall(function()
                                    highlight.FillColor = Color3.fromHSV(hue, 1, 1)
                                end)
                                task.wait(0.03)
                            end
                        end)
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = char
                    end
                end
                if player.Character then addHighlight(player.Character) end
                player.CharacterAdded:Connect(addHighlight)
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                applyPlayerESP(player)
            end
            Players.PlayerAdded:Connect(applyPlayerESP)
            
            local function createTimerESP(plot)
                pcall(function()
                    local purchases = plot:FindFirstChild("Purchases")
                    if not purchases then return end
                    local plotBlock = purchases:FindFirstChild("PlotBlock")
                    if not plotBlock then return end
                    local main = plotBlock:FindFirstChild("Main")
                    if not main then return end
                    local originalGui = main:FindFirstChild("BillboardGui")
                    if not originalGui then return end
                    local originalTime = originalGui:FindFirstChild("RemainingTime")
                    if not originalTime then return end
                    
                    local existing = main:FindFirstChild("TimerESP")
                    if existing then existing:Destroy() end
                    
                    local espGui = Instance.new("BillboardGui")
                    espGui.Name = "TimerESP"
                    espGui.AlwaysOnTop = true
                    espGui.Size = UDim2.new(0, 150, 0, 60)
                    espGui.StudsOffset = Vector3.new(0, 10, 0)
                    espGui.MaxDistance = math.huge
                    espGui.Adornee = main
                    espGui.Parent = main
                    
                    local espText = Instance.new("TextLabel")
                    espText.Size = UDim2.new(1, 0, 1, 0)
                    espText.BackgroundTransparency = 1
                    espText.TextColor3 = Color3.fromRGB(0, 255, 255)
                    espText.TextStrokeTransparency = 0
                    espText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    espText.TextScaled = true
                    espText.Font = Enum.Font.GothamBlack
                    espText.Text = originalTime.Text
                    espText.Parent = espGui
                    
                    originalTime:GetPropertyChangedSignal("Text"):Connect(function()
                        espText.Text = originalTime.Text
                    end)
                end)
            end
            
            if plots then
                for _, plot in pairs(plots:GetChildren()) do
                    createTimerESP(plot)
                end
                plots.ChildAdded:Connect(function(plot)
                    task.defer(createTimerESP, plot)
                end)
                plots.DescendantAdded:Connect(function(obj)
                    if obj.Name == "RemainingTime" or obj.Name == "BillboardGui" then
                        local plot = obj:FindFirstAncestorOfClass("Model")
                        if plot and plot.Parent == plots then
                            task.defer(createTimerESP, plot)
                        end
                    end
                end)
            end
            
            local function findLocalUserPlot()
                if not plots then return nil end
                local userName = localPlayer.Name
                local displayName = localPlayer.DisplayName
                
                for _, plot in pairs(plots:GetChildren()) do
                    local success, result = pcall(function()
                        local plotSign = plot:FindFirstChild("PlotSign")
                        if plotSign then
                            local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
                            if surfaceGui then
                                local frame = surfaceGui:FindFirstChild("Frame")
                                if frame then
                                    local textLabel = frame:FindFirstChild("TextLabel")
                                    if textLabel then
                                        local ownerName = textLabel.Text
                                        if ownerName:find(userName) or ownerName:find(displayName) then
                                            return true
                                        end
                                    end
                                end
                            end
                            local yourBase = plotSign:FindFirstChild("YourBase", true)
                            if yourBase and yourBase:IsA("GuiObject") and yourBase.Enabled then
                                return true
                            end
                        end
                        return false
                    end)
                    if success and result then return plot end
                end
                return nil
            end
            
            local userPlot = findLocalUserPlot()
            if userPlot then
                local character = localPlayer.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local plotSign = userPlot:FindFirstChild("PlotSign")
                    if hrp and plotSign then
                        local playerAttachment = Instance.new("Attachment")
                        playerAttachment.Name = "LaserPlayerAttachment"
                        playerAttachment.Parent = hrp
                        
                        local plotAttachment = Instance.new("Attachment")
                        plotAttachment.Name = "LaserPlotAttachment"
                        plotAttachment.Position = Vector3.new(0, 3, 0)
                        plotAttachment.Parent = plotSign
                        
                        local beam = Instance.new("Beam")
                        beam.Name = "PlayerToPlotLaser"
                        beam.Attachment0 = playerAttachment
                        beam.Attachment1 = plotAttachment
                        beam.FaceCamera = true
                        beam.Width0 = 0.75
                        beam.Width1 = 0.75
                        beam.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
                            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
                            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 127, 255)),
                            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(139, 0, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
                        })
                        beam.Transparency = NumberSequence.new(0)
                        beam.LightEmission = 3
                        beam.Brightness = 3
                        beam.Texture = "rbxassetid://241511723"
                        beam.TextureMode = Enum.TextureMode.Wrap
                        beam.TextureLength = 1
                        beam.TextureSpeed = 5
                        beam.Parent = hrp
                    end
                end
            end
            
            local function parse_money(txt)
                if not txt then return 0 end
                local num, suf = txt:gsub("[,%s$]", ""):match("([%d%.]+)([KMB]?)")
                num = tonumber(num)
                if not num then return 0 end
                if suf == "K" then num = num * 1e3
                elseif suf == "M" then num = num * 1e6
                elseif suf == "B" then num = num * 1e9 end
                return num
            end
            
            local function format_money(n)
                if n >= 1e9 then return string.format("$%.1fB/s", n / 1e9)
                elseif n >= 1e6 then return string.format("$%.1fM/s", n / 1e6)
                elseif n >= 1e3 then return string.format("$%.1fK/s", n / 1e3)
                else return "$" .. tostring(math.floor(n)) .. "/s" end
            end
            
            local espGui = PlayerGui:FindFirstChild("HighestESP")
            if espGui then espGui:Destroy() end
            
            espGui = Instance.new("ScreenGui")
            espGui.Name = "HighestESP"
            espGui.ResetOnSpawn = false
            espGui.Parent = PlayerGui
            
            local hudFrame = Instance.new("Frame")
            hudFrame.Size = UDim2.new(0, 280, 0, 40)
            hudFrame.Position = UDim2.new(0.5, -140, 0, 10)
            hudFrame.BackgroundColor3 = Theme.Background
            hudFrame.BackgroundTransparency = 0.5
            hudFrame.BorderSizePixel = 0
            hudFrame.Parent = espGui
            AddCorner(hudFrame, 20)
            AddStroke(hudFrame, Theme.Border, 1)
            
            local hudText = Instance.new("TextLabel")
            hudText.Size = UDim2.new(1, 0, 1, 0)
            hudText.BackgroundTransparency = 1
            hudText.TextColor3 = Theme.Accent
            hudText.Font = Enum.Font.GothamBold
            hudText.TextSize = 14
            hudText.Text = "Scanning..."
            hudText.Parent = hudFrame
            
            local espHighlight, espBeam, espLabel, playerAtt, targetAtt, lastBest = nil, nil, nil, nil, nil, nil
            
            local function cleanupESP()
                pcall(function() if espHighlight then espHighlight:Destroy() end end)
                pcall(function() if espBeam then espBeam:Destroy() end end)
                pcall(function() if espLabel then espLabel:Destroy() end end)
                pcall(function() if playerAtt then playerAtt:Destroy() end end)
                pcall(function() if targetAtt then targetAtt:Destroy() end end)
            end
            
            local function updateESP()
                local debris = workspace:FindFirstChild("Debris")
                if not debris then return end
                
                local bestMoney, bestTemplate, bestName, bestPart = 0, nil, "", nil
                
                for _, item in pairs(debris:GetChildren()) do
                    if item.Name == "FastOverheadTemplate" then
                        local animalOverhead = item:FindFirstChild("AnimalOverhead")
                        if animalOverhead then
                            local generation = animalOverhead:FindFirstChild("Generation")
                            if generation then
                                local m = parse_money(generation.Text)
                                if m > bestMoney then
                                    bestMoney = m
                                    bestTemplate = item
                                    
                                    local foh = item:FindFirstChild("__foh_transform")
                                    if foh and foh:IsA("Motor6D") then
                                        bestPart = foh.Part1 or foh.Part0
                                    end
                                    
                                    local dn = animalOverhead:FindFirstChild("DisplayName")
                                    if dn then bestName = dn.Text or item.Name end
                                end
                            end
                        end
                    end
                end
                
                if bestMoney > 0 then
                    hudText.Text = bestName .. " • " .. format_money(bestMoney)
                else
                    hudText.Text = "No pets found"
                    cleanupESP()
                    lastBest = nil
                    return
                end
                
                if not bestTemplate or bestTemplate == lastBest then return end
                lastBest = bestTemplate
                cleanupESP()
                
                local char = Player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local targetPart = nil
                if bestPart then
                    if bestPart:IsA("BasePart") then
                        targetPart = bestPart
                    elseif bestPart:IsA("Model") then
                        targetPart = bestPart:FindFirstChildWhichIsA("BasePart", true)
                    end
                end
                
                local model = targetPart and (targetPart:FindFirstAncestorOfClass("Model") or targetPart.Parent)
                
                espHighlight = Instance.new("Highlight")
                espHighlight.FillColor = Color3.fromRGB(255, 255, 255)
                espHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                espHighlight.FillTransparency = 0.2
                espHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                espHighlight.Parent = model or bestTemplate
                
                -- Add floating label above the pet
                if targetPart then
                    local labelGui = Instance.new("BillboardGui")
                    labelGui.Name = "HighestPetLabel"
                    labelGui.AlwaysOnTop = true
                    labelGui.Size = UDim2.new(0, 200, 0, 50)
                    labelGui.StudsOffset = Vector3.new(0, 4, 0)
                    labelGui.MaxDistance = math.huge
                    labelGui.Adornee = targetPart
                    labelGui.Parent = targetPart
                    
                    local petLabel = Instance.new("TextLabel")
                    petLabel.Size = UDim2.new(1, 0, 1, 0)
                    petLabel.BackgroundTransparency = 1
                    petLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    petLabel.TextStrokeTransparency = 0
                    petLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    petLabel.TextScaled = true
                    petLabel.Font = Enum.Font.GothamBlack
                    petLabel.Text = bestName .. "\n" .. format_money(bestMoney)
                    petLabel.Parent = labelGui
                    
                    espLabel = labelGui
                end
                
                if targetPart then
                    playerAtt = Instance.new("Attachment", hrp)
                    targetAtt = Instance.new("Attachment", targetPart)
                    
                    espBeam = Instance.new("Beam")
                    espBeam.Attachment0 = playerAtt
                    espBeam.Attachment1 = targetAtt
                    espBeam.FaceCamera = true
                    espBeam.Width0 = 1
                    espBeam.Width1 = 1
                    espBeam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                    espBeam.Transparency = NumberSequence.new(0)
                    espBeam.LightEmission = 3
                    espBeam.Brightness = 5
                    espBeam.Texture = "rbxassetid://241511723"
                    espBeam.TextureMode = Enum.TextureMode.Wrap
                    espBeam.TextureSpeed = 6
                    espBeam.Parent = hrp
                end
            end
            
            task.defer(updateESP)
            
            local debris = workspace:FindFirstChild("Debris")
            if debris then
                debris.ChildAdded:Connect(function() task.defer(updateESP) end)
                debris.ChildRemoved:Connect(function() task.defer(updateESP) end)
            end
            
            Player.CharacterAdded:Connect(function()
                task.wait(1)
                cleanupESP()
                lastBest = nil
                task.defer(updateESP)
            end)
        end)
        CreateToggle(Content, "Speed Boost", "SpeedBoost")
        CreateToggle(Content, "Infinite Jump", "InfJump")
        
    elseif CurrentTab == "Stealer" then
        CreateToggle(Content, "Auto Destroy Turret", "AutoDestroyTurret")
        CreateButton(Content, "TP to Highest", function() end)
        CreateToggle(Content, "Auto Steal Highest", "AutoStealHighest")
        CreateToggle(Content, "Aimbot", "Aimbot")
        
    elseif CurrentTab == "Settings" then
        CreateSection(Content, "SERVER")
        CreateButton(Content, "Server Hop", function()
            local TeleportService = game:GetService("TeleportService")
            TeleportService:Teleport(game.PlaceId)
        end)
        CreateButton(Content, "Rejoin Server", function()
            local TeleportService = game:GetService("TeleportService")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end)
        
        CreateSection(Content, "KEYBINDS")
        CreateKeybind(Content, "Instant Clone", "InstantCloneKey")
        CreateKeybind(Content, "TP to Highest", "TPHighestKey")
        CreateKeybind(Content, "Show/Hide UI", "UIToggleKey")
        CreateKeybind(Content, "Speed Boost", "SpeedBoostKey")
    end
    
    task.wait()
    Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
end

local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Settings.UIToggleKey then
        UIVisible = not UIVisible
        MainFrame.Visible = UIVisible
    end
    
    if input.KeyCode == Settings.InstantCloneKey then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Net = require(ReplicatedStorage:WaitForChild("Packages").Net)
        
        local function findCloner()
            local backpack = Player:FindFirstChild("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and item.Name:find("Cloner") then return item end
                end
            end
            local char = Player.Character
            if char then
                for _, item in pairs(char:GetChildren()) do
                    if item:IsA("Tool") and item.Name:find("Cloner") then return item end
                end
            end
            return nil
        end
        
        local cloner = findCloner()
        if cloner then
            local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid:EquipTool(cloner) end
        end
        Net:RemoteEvent("UseItem"):FireServer()
        Net:RemoteEvent("QuantumCloner/OnTeleport"):FireServer()
    end
end)

RenderContent()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage:WaitForChild("Packages").Net)

local function getClosestPlayer()
    local closest = nil
    local closestDist = math.huge
    
    local char = Player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local targetHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if targetHRP and humanoid and humanoid.Health > 0 then
                local dist = (hrp.Position - targetHRP.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = plr.Character
                end
            end
        end
    end
    
    return closest
end

local function hookTool(tool)
    tool.Activated:Connect(function()
        if not Settings.Aimbot then return end
        local target = getClosestPlayer()
        if target then
            local targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
            if targetPart then
                Net:RemoteEvent("UseItem"):FireServer(targetPart.Position, targetPart)
            end
        end
    end)
end

local function scanTools()
    local char = Player.Character
    if char then
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") then hookTool(item) end
        end
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then hookTool(child) end
        end)
    end
    
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then hookTool(item) end
        end
        backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then hookTool(child) end
        end)
    end
end

scanTools()

Player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    scanTools()
end)
