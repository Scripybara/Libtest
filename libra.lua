--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝
    
    Modern UI Library v2.0
    Created for Roblox Executors
]]

local NexusUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════════
-- THEME CONFIGURATION
-- ═══════════════════════════════════════════════════════════════

local Theme = {
    -- Main Colors
    Primary = Color3.fromRGB(88, 101, 242),      -- Discord Blue
    Secondary = Color3.fromRGB(87, 242, 135),    -- Green Accent
    Accent = Color3.fromRGB(254, 231, 92),       -- Yellow
    
    -- Background Colors
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundSecondary = Color3.fromRGB(20, 20, 28),
    BackgroundTertiary = Color3.fromRGB(28, 28, 38),
    
    -- Element Colors
    ElementBackground = Color3.fromRGB(35, 35, 48),
    ElementBackgroundHover = Color3.fromRGB(45, 45, 60),
    ElementBorder = Color3.fromRGB(50, 50, 65),
    
    -- Text Colors
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    TextDark = Color3.fromRGB(120, 120, 135),
    
    -- Status Colors
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(254, 231, 92),
    Error = Color3.fromRGB(237, 66, 69),
    Info = Color3.fromRGB(88, 101, 242),
    
    -- Misc
    Divider = Color3.fromRGB(45, 45, 58),
    Shadow = Color3.fromRGB(0, 0, 0),
    
    -- Fonts
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham,
    
    -- Animation
    TweenSpeed = 0.2,
    TweenEasing = Enum.EasingStyle.Quart
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or Theme.TweenSpeed,
            style or Theme.TweenEasing,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Theme.ElementBorder,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

local function AddPadding(parent, padding)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        Parent = parent
    })
end

local function AddGradient(parent, colors, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new(colors),
        Rotation = rotation or 45,
        Parent = parent
    })
end

local function CreateRipple(button)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button
    })
    AddCorner(ripple, 100)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN LIBRARY
-- ═══════════════════════════════════════════════════════════════

function NexusUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "NexusUI"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 380)
    local windowTheme = config.Theme or "Dark"
    
    -- Destroy existing UI
    if game.CoreGui:FindFirstChild("NexusUI") then
        game.CoreGui:FindFirstChild("NexusUI"):Destroy()
    end
    
    -- Main ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "NexusUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game.CoreGui
    })
    
    -- Main Container
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Theme.Background,
        Size = windowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Theme.ElementBorder, 1)
    
    -- Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 4),
        Size = UDim2.new(1, 40, 1, 40),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = MainFrame
    })
    
    -- Open Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    Tween(MainFrame, {Size = windowSize, BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back)
    
    -- Top Bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Theme.BackgroundSecondary,
        Size = UDim2.new(1, 0, 0, 45),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    AddCorner(TopBar, 12)
    
    -- Fix TopBar corners
    local TopBarFix = Create("Frame", {
        Name = "Fix",
        BackgroundColor3 = Theme.BackgroundSecondary,
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    -- Title Container
    local TitleContainer = Create("Frame", {
        Name = "TitleContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Parent = TopBar
    })
    
    -- Logo/Icon
    local Logo = Create("Frame", {
        Name = "Logo",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = TitleContainer
    })
    AddCorner(Logo, 6)
    AddGradient(Logo, {Theme.Primary, Theme.Secondary}, 45)
    
    local LogoText = Create("TextLabel", {
        Name = "LogoText",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "N",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBlack,
        Parent = Logo
    })
    
    -- Title
    local Title = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        Text = windowTitle,
        TextColor3 = Theme.TextPrimary,
        TextSize = 15,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleContainer
    })
    
    -- Control Buttons
    local Controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 80, 0, 30),
        Position = UDim2.new(1, -90, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = TopBar
    })
    
    local ControlsLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = Controls
    })
    
    -- Minimize Button
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Theme.Warning,
        Size = UDim2.new(0, 18, 0, 18),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    AddCorner(MinimizeBtn, 9)
    
    local MinimizeIcon = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "−",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = MinimizeBtn
    })
    
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeIcon, {TextTransparency = 0}, 0.15)
        Tween(MinimizeBtn, {Size = UDim2.new(0, 22, 0, 22)}, 0.15)
    end)
    
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeIcon, {TextTransparency = 1}, 0.15)
        Tween(MinimizeBtn, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
    end)
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Theme.Error,
        Size = UDim2.new(0, 18, 0, 18),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    AddCorner(CloseBtn, 9)
    
    local CloseIcon = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "×",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = CloseBtn
    })
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseIcon, {TextTransparency = 0}, 0.15)
        Tween(CloseBtn, {Size = UDim2.new(0, 22, 0, 22)}, 0.15)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseIcon, {TextTransparency = 1}, 0.15)
        Tween(CloseBtn, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Tab Container (Left Side)
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Theme.BackgroundSecondary,
        Size = UDim2.new(0, 140, 1, -55),
        Position = UDim2.new(0, 0, 0, 50),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, -20),
        Position = UDim2.new(0, 5, 0, 10),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = TabContainer
    })
    
    local TabListLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabList
    })
    
    -- Content Container (Right Side)
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, -145, 1, -55),
        Position = UDim2.new(0, 145, 0, 50),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Dragging Functionality
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Minimize Functionality
    local minimized = false
    local originalSize = windowSize
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 45)}, 0.3)
            TabContainer.Visible = false
            ContentContainer.Visible = false
        else
            Tween(MainFrame, {Size = originalSize}, 0.3)
            task.delay(0.2, function()
                TabContainer.Visible = true
                ContentContainer.Visible = true
            end)
        end
    end)
    
    -- Window Object
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- ═══════════════════════════════════════════════════════════════
    -- TAB CREATION
    -- ═══════════════════════════════════════════════════════════════
    
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "rbxassetid://7733960981"
        
        local Tab = {}
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Theme.ElementBackground,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 38),
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        AddCorner(TabButton, 8)
        
        local TabIcon = Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = tabIcon,
            ImageColor3 = Theme.TextSecondary,
            Parent = TabButton
        })
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.new(0, 38, 0, 0),
            Text = tabName,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            Font = Theme.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        local Indicator = Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = Theme.Primary,
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundTransparency = 1,
            Parent = TabButton
        })
        AddCorner(Indicator, 2)
        
        -- Tab Content Page
        local TabPage = Create("ScrollingFrame", {
            Name = tabName .. "_Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentContainer
        })
        AddPadding(TabPage, 10)
        
        local PageLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = TabPage
        })
        
        -- Tab Selection
        local function SelectTab()
            -- Deselect all tabs
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(tab.Icon, {ImageColor3 = Theme.TextSecondary}, 0.2)
                Tween(tab.Label, {TextColor3 = Theme.TextSecondary}, 0.2)
                Tween(tab.Indicator, {BackgroundTransparency = 1}, 0.2)
                tab.Page.Visible = false
            end
            
            -- Select this tab
            Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
            Tween(TabIcon, {ImageColor3 = Theme.Primary}, 0.2)
            Tween(TabLabel, {TextColor3 = Theme.TextPrimary}, 0.2)
            Tween(Indicator, {BackgroundTransparency = 0}, 0.2)
            TabPage.Visible = true
            Window.ActiveTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.7}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        -- Store tab data
        Tab.Button = TabButton
        Tab.Icon = TabIcon
        Tab.Label = TabLabel
        Tab.Indicator = Indicator
        Tab.Page = TabPage
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab automatically
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        -- ═══════════════════════════════════════════════════════════════
        -- SECTION CREATION
        -- ═══════════════════════════════════════════════════════════════
        
        function Tab:CreateSection(name)
            local Section = Create("Frame", {
                Name = name or "Section",
                BackgroundColor3 = Theme.BackgroundTertiary,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = TabPage
            })
            AddCorner(Section, 10)
            AddStroke(Section, Theme.ElementBorder, 1, 0.5)
            
            local SectionTitle = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 5),
                Text = name or "Section",
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Theme.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })
            
            local SectionContent = Create("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 35),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Section
            })
            
            local ContentLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = SectionContent
            })
            
            local SectionPadding = Create("UIPadding", {
                PaddingBottom = UDim.new(0, 12),
                Parent = Section
            })
            
            local SectionObj = {}
            
            -- ═══════════════════════════════════════════════════════════════
            -- BUTTON
            -- ═══════════════════════════════════════════════════════════════
            
            function SectionObj:CreateButton(config)
                config = config or {}
                local buttonName = config.Name or "Button"
                local buttonCallback = config.Callback or function() end
                
                local Button = Create("TextButton", {
                    Name = buttonName,
                    BackgroundColor3 = Theme.ElementBackground,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(Button, 8)
                AddStroke(Button, Theme.ElementBorder, 1, 0.5)
                
                local ButtonLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Text = buttonName,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Theme.FontLight,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button
                })
                
                local ButtonIcon = Create("TextLabel", {
                    Name = "Icon",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -30, 0, 0),
                    Text = "→",
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    Font = Theme.Font,
                    Parent = Button
                })
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.ElementBackgroundHover}, 0.15)
                    Tween(ButtonIcon, {Position = UDim2.new(1, -25, 0, 0)}, 0.15)
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.ElementBackground}, 0.15)
                    Tween(ButtonIcon, {Position = UDim2.new(1, -30, 0, 0)}, 0.15)
                end)
                
                Button.MouseButton1Click:Connect(function()
                    CreateRipple(Button)
                    buttonCallback()
                end)
                
                return Button
            end
            
            -- ═══════════════════════════════════════════════════════════════
            -- TOGGLE
            -- ═══════════════════════════════════════════════════════════════
            
            function SectionObj:CreateToggle(config)
                config = config or {}
                local toggleName = config.Name or "Toggle"
                local toggleDefault = config.Default or false
                local toggleCallback = config.Callback or function() end
                
                local toggled = toggleDefault
                
                local Toggle = Create("TextButton", {
                    Name = toggleName,
                    BackgroundColor3 = Theme.ElementBackground,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = SectionContent
                })
                AddCorner(Toggle, 8)
                AddStroke(Toggle, Theme.ElementBorder, 1, 0.5)
                
                local ToggleLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Text = toggleName,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Theme.FontLight,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Toggle
                })
                
                local ToggleSwitch = Create("Frame", {
                    Name = "Switch",
                    BackgroundColor3 = Theme.ElementBorder,
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -52, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = Toggle
                })
                AddCorner(ToggleSwitch, 10)
                
                local ToggleKnob = Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Theme.TextPrimary,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = ToggleSwitch
                })
                AddCorner(ToggleKnob, 8)
                
                local function UpdateToggle()
                    if toggled then
                        Tween(ToggleSwitch, {BackgroundColor3 = Theme.Primary}, 0.2)
                        Tween(ToggleKnob, {Position = UDim2.new(1, -18, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
                    else
                        Tween(ToggleSwitch, {BackgroundColor3 = Theme.ElementBorder}, 0.2)
                        Tween(ToggleKnob, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
                    end
                end
                
                if toggleDefault then
                    UpdateToggle()
                end
                
                Toggle.MouseEnter:Connect(function()
                    Tween(Toggle, {BackgroundColor3 = Theme.ElementBackgroundHover}, 0.15)
                end)
                
                Toggle.MouseLeave:Connect(function()
                    Tween(Toggle, {BackgroundColor3 = Theme.ElementBackground}, 0.15)
                end)
                
                Toggle.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                    toggleCallback(toggled)
                end)
                
                local ToggleObj = {}
                
                function ToggleObj:Set(value)
                    toggled = value
                    UpdateToggle()
                    toggleCallback(toggled)
                end
                
                function ToggleObj:Get()
                    return toggled
                end
                
                return ToggleObj
            end
            
            -- ═══════════════════════════════════════════════════════════════
            -- SLIDER
            -- ═══════════════════════════════════════════════════════════════
            
            function SectionObj:CreateSlider(config)
                config = config or {}
                local sliderName = config.Name or "Slider"
                local sliderMin = config.Min or 0
                local sliderMax = config.Max or 100
                local sliderDefault = config.Default or sliderMin
                local sliderCallback = config.Callback or function() end
                
                local currentValue = sliderDefault
                
                local Slider = Create("Frame", {
                    Name = sliderName,
                    BackgroundColor3 = Theme.ElementBackground,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = SectionContent
                })
                AddCorner(Slider, 8)
                AddStroke(Slider, Theme.ElementBorder, 1, 0.5)
                
                local SliderLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -70, 0, 20),
                    Position = UDim2.new(0, 12, 0, 6),
                    Text = sliderName,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Theme.FontLight,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Slider
                })
                
                local SliderValue = Create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -60, 0, 6),
                    Text = tostring(currentValue),
                    TextColor3 = Theme.Primary,
                    TextSize = 13,
                    Font = Theme.Font,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Slider
                })
                
                local SliderBar = Create("Frame", {
                    Name = "Bar",
                    BackgroundColor3 = Theme.ElementBorder,
                    Size = UDim2.new(1, -24, 0, 6),
                    Position = UDim2.new(0, 12, 0, 34),
                    Parent = Slider
                })
                AddCorner(SliderBar, 3)
                
                local SliderFill = Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Theme.Primary,
                    Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0),
                    Parent = SliderBar
                })
                AddCorner(SliderFill, 3)
                AddGradient(SliderFill, {Theme.Primary, Theme.Secondary}, 0)
                
                local SliderKnob = Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Theme.TextPrimary,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 2,
                    Parent = SliderBar
                })
                AddCorner(SliderKnob, 7)
                
                local dragging = false
                
                local function UpdateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 0.5, 0)
                    currentValue = math.floor(sliderMin + (sliderMax - sliderMin) * pos.X.Scale)
                    
                    Tween(SliderKnob, {Position = pos}, 0.05)
                    Tween(SliderFill, {Size = UDim2.new(pos.X.Scale, 0, 1, 0)}, 0.05)
                    SliderValue.Text = tostring(currentValue)
                    sliderCallback(currentValue)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                local SliderObj = {}
                
                function SliderObj:Set(value)
                    currentValue = math.clamp(value, sliderMin, sliderMax)
                    local pos = (currentValue - sliderMin) / (sliderMax - sliderMin)
                    Tween(SliderKnob, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.2)
                    Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
                    SliderValue.Text = tostring(currentValue)
                    sliderCallback(currentValue)
                end
                
                function SliderObj:Get()
                    return currentValue
                end
                
                return SliderObj
            end
            
            -- ═══════════════════════════════════════════════════════════════
            -- DROPDOWN
            -- ═══════════════════════════════════════════════════════════════
            
            function SectionObj:CreateDropdown(config)
                config = config or {}
                local dropdownName = config.Name or "Dropdown"
                local dropdownOptions = config.Options or {}
                local dropdownDefault = config.Default or (dropdownOptions[1] or "Select")
                local dropdownCallback = config.Callback or function() end
                
                local selectedOption = dropdownDefault
                local opened = false
                
                local Dropdown = Create("Frame", {
                    Name = dropdownName,
                    BackgroundColor3 = Theme.ElementBackground,
                    Size = UDim2.new(1, 0, 0, 36),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(Dropdown, 8)
                AddStroke(Dropdown, Theme.ElementBorder, 1, 0.5)
                
                local DropdownButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    Parent = Dropdown
                })
                
                local DropdownLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, -12, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Text = dropdownName,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Theme.FontLight,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownButton
                })
                
                local DropdownSelected = Create("TextLabel", {
                    Name = "Selected",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, -30, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Text = selectedOption,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    Font = Theme.FontLight,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = DropdownButton
                })
                
                local DropdownArrow = Create("TextLabel", {
                    Name = "Arrow",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -28, 0, 0),
                    Text = "▼",
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 10,
                    Font = Theme.Font,
                    Rotation = 0,
                    Parent = DropdownButton
                })
                
                local DropdownContent = Create("Frame", {
                    Name = "Content",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, 40),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = Dropdown
                })
                
                local ContentLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    Parent = DropdownContent
                })
                
                for _, option in ipairs(dropdownOptions) do
                    local OptionButton = Create("TextButton", {
                        Name = option,
                        BackgroundColor3 = Theme.BackgroundTertiary,
                        Size = UDim2.new(1, 0, 0, 28),
                        Text = option,
                        TextColor3 = Theme.TextSecondary,
                        TextSize = 12,
                        Font = Theme.FontLight,
                        AutoButtonColor = false,
                        Parent = DropdownContent
                    })
                    AddCorner(OptionButton, 6)
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Theme.Primary, TextColor3 = Theme.TextPrimary}, 0.15)
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Theme.BackgroundTertiary, TextColor3 = Theme.TextSecondary}, 0.15)
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        DropdownSelected.Text = option
                        dropdownCallback(option)
                        
                        -- Close dropdown
                        opened = false
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        local contentHeight = #dropdownOptions * 32 + 8
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 44 + contentHeight)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    else
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    end
                end)
                
                local DropdownObj = {}
                
                function DropdownObj:Set(value)
                    selectedOption = value
                    DropdownSelected.Text = value
                    dropdownCallback(value)
                end
                
                function DropdownObj:Get()
                    return selectedOption
                end
                
                function DropdownObj:Refresh(options)
                    for _, child in pairs(DropdownContent:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, option in ipairs(options) do
                        local OptionButton = Create("TextButton", {
                            Name = option,
                            BackgroundColor3 = Theme.BackgroundTertiary,
                            Size = UDim2.new(1, 0, 0, 28),
                            Text = option,
                            TextColor3 = Theme.TextSecondary,
                            TextSize = 12,
                            Font = Theme.FontLight,
                            AutoButtonColor = false,
                            Parent = DropdownContent
                        })
                        AddCorner(OptionButton, 6)
                        
                        OptionButton.MouseEnter:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Theme.Primary, TextColor3 = Theme.TextPrimary}, 0.15)
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Theme.BackgroundTertiary, TextColor3 = Theme.TextSecondary}, 0.15)
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            DropdownSelected.Text = option
                            dropdownCallback(option)
                            
                            opened = false
                            Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                            Tween(DropdownArrow, {Rotation = 0}, 0.2)
                        end)
                    end
                end
                
                return DropdownObj
            end
            
            -- ═══════════════════════════════════════════════════════════════
            -- TEXTBOX
            -- ═══════════════════════════════════════════════════════════════
            
            function SectionObj:CreateTextBox(config)
                config = config or {}
                local textboxName = config.Name or "TextBox"
                local textboxPlaceholder = config.Placeholder or "Enter text..."
                local textboxDefault = config.Default or ""
                local textboxCallback = config.Callback or function() end
                
                local TextBoxFrame = Create("Frame", {
                    Name = textboxName,
                    BackgroundColor3 = Theme.ElementBackground,
                    Size = UDim2.new(1, 0, 0, 36),
                    Parent = SectionContent
                })
                AddCorner(TextBoxFrame, 8)
                AddStroke(TextBoxFrame, Theme.ElementBorder, 1, 0.5)
                
                local TextBoxLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.4, -12, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Text = textboxName,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Theme.FontLight,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = TextBoxFrame
                })
                
                local TextBoxInput = Create("TextBox", {
                    Name = "Input",
                    BackgroundColor3 = Theme.BackgroundTertiary,
                    Size = UDim2.new(0.55, -12, 0, 26),
                    Position = UDim2.new(0.45, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Text = textboxDefault,
                    PlaceholderText = textboxPlaceholder,
                    PlaceholderColor3 = Theme.TextDark,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 12,
                    Font = Theme.FontLight,
                    ClearTextOnFocus = false,
                    Parent = TextBoxFrame
                })
                AddCorner(TextBoxInput, 6)
                AddPadding(TextBoxInput, 8)
                
                TextBoxInput.Focused:Connect(function()
                    Tween(TextBoxFrame:FindFirstChild("UIStroke"), {Color = Theme.Primary}, 0.15)
                end)
                
                TextBoxInput.FocusLost:Connect(function(enterPressed)
                    Tween(TextBoxFrame:FindFirstChild("UIStroke"), {Color = Theme.ElementBorder}, 0.15)
                    textboxCallback(TextBoxInput.Text, enterPressed)
                end)
                
                local TextBoxObj = {}
                
                function TextBoxObj:Set(value)
                    TextBoxInput.Text = value
                end
                
                function TextBoxObj:Get()
                    return TextBoxInput.Text
                end
                
                return TextBoxObj
            end
            
            -- ═══════════════════════════════════════════════════════════════
            -- LABEL
            -- ═══════════════════════════════════════════════════════════════
            
            function SectionObj:CreateLabel(text)
                local Label = Create("TextLabel", {
                    Name = "Label",
                    BackgroundColor3 = Theme.ElementBackground,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = text or "Label",
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 12,
                    Font = Theme.FontLight,
                    Parent = SectionContent
                })
                AddCorner(Label, 6)
                
                local LabelObj = {}
                
                function LabelObj:Set(newText)
                    Label.Text = newText
                end
                
                return LabelObj
            end
            
            -- ═══════════════════════════════════════════════════════════════
            -- KEYBIND
            -- ═══════════════════════════════════════════════════════════════
            
            function SectionObj:CreateKeybind(config)
                config = config or {}
                local keybindName = config.Name or "Keybind"
                local keybindDefault = config.Default or Enum.KeyCode.E
                local keybindCallback = config.Callback or function() end
                
                local currentKey = keybindDefault
                local listening = false
                
                local Keybind = Create("TextButton", {
                    Name = keybindName,
                    BackgroundColor3 = Theme.ElementBackground,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = SectionContent
                })
                AddCorner(Keybind, 8)
                AddStroke(Keybind, Theme.ElementBorder, 1, 0.5)
                
                local KeybindLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Text = keybindName,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Theme.FontLight,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Keybind
                })
                
                local KeybindValue = Create("TextLabel", {
                    Name = "Value",
                    BackgroundColor3 = Theme.BackgroundTertiary,
                    Size = UDim2.new(0, 55, 0, 24),
                    Position = UDim2.new(1, -65, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Text = currentKey.Name,
                    TextColor3 = Theme.Primary,
                    TextSize = 11,
                    Font = Theme.Font,
                    Parent = Keybind
                })
                AddCorner(KeybindValue, 6)
                
                Keybind.MouseEnter:Connect(function()
                    Tween(Keybind, {BackgroundColor3 = Theme.ElementBackgroundHover}, 0.15)
                end)
                
                Keybind.MouseLeave:Connect(function()
                    Tween(Keybind, {BackgroundColor3 = Theme.ElementBackground}, 0.15)
                end)
                
                Keybind.MouseButton1Click:Connect(function()
                    listening = true
                    KeybindValue.Text = "..."
                    Tween(KeybindValue, {BackgroundColor3 = Theme.Primary}, 0.15)
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeybindValue.Text = currentKey.Name
                        Tween(KeybindValue, {BackgroundColor3 = Theme.BackgroundTertiary}, 0.15)
                        listening = false
                    elseif not listening and input.KeyCode == currentKey and not gameProcessed then
                        keybindCallback()
                    end
                end)
                
                local KeybindObj = {}
                
                function KeybindObj:Set(key)
                    currentKey = key
                    KeybindValue.Text = key.Name
                end
                
                function KeybindObj:Get()
                    return currentKey
                end
                
                return KeybindObj
            end
            
            return SectionObj
        end
        
        return Tab
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- NOTIFICATIONS
    -- ═══════════════════════════════════════════════════════════════
    
    function Window:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or "This is a notification"
        local duration = config.Duration or 3
        local notifType = config.Type or "Info"
        
        local typeColors = {
            Info = Theme.Info,
            Success = Theme.Success,
            Warning = Theme.Warning,
            Error = Theme.Error
        }
        
        local NotifContainer = ScreenGui:FindFirstChild("NotifContainer")
        if not NotifContainer then
            NotifContainer = Create("Frame", {
                Name = "NotifContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 300, 1, 0),
                Position = UDim2.new(1, -20, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                Parent = ScreenGui
            })
            
            Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Parent = NotifContainer
            })
            
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 20),
                Parent = NotifContainer
            })
        end
        
        local Notification = Create("Frame", {
            Name = "Notification",
            BackgroundColor3 = Theme.Background,
            Size = UDim2.new(1, 0, 0, 70),
            Position = UDim2.new(1, 100, 0, 0),
            Parent = NotifContainer
        })
        AddCorner(Notification, 10)
        AddStroke(Notification, typeColors[notifType], 2)
        
        local NotifAccent = Create("Frame", {
            Name = "Accent",
            BackgroundColor3 = typeColors[notifType],
            Size = UDim2.new(0, 4, 1, -10),
            Position = UDim2.new(0, 8, 0, 5),
            Parent = Notification
        })
        AddCorner(NotifAccent, 2)
        
        local NotifTitle = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -30, 0, 20),
            Position = UDim2.new(0, 20, 0, 10),
            Text = title,
            TextColor3 = Theme.TextPrimary,
            TextSize = 14,
            Font = Theme.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notification
        })
        
        local NotifContent = Create("TextLabel", {
            Name = "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -30, 0, 35),
            Position = UDim2.new(0, 20, 0, 30),
            Text = content,
            TextColor3 = Theme.TextSecondary,
            TextSize = 12,
            Font = Theme.FontLight,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Parent = Notification
        })
        
        -- Slide in
        Tween(Notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        
        -- Progress bar
        local Progress = Create("Frame", {
            Name = "Progress",
            BackgroundColor3 = typeColors[notifType],
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 1, -3),
            Parent = Notification
        })
        
        Tween(Progress, {Size = UDim2.new(0, 0, 0, 3)}, duration)
        
        task.delay(duration, function()
            Tween(Notification, {Position = UDim2.new(1, 100, 0, 0), BackgroundTransparency = 1}, 0.3)
            task.delay(0.3, function()
                Notification:Destroy()
            end)
        end)
    end
    
    return Window
end

-- ═══════════════════════════════════════════════════════════════
-- RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════

return NexusUI
