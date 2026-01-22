--[[
    LINORIA STYLE UI LIBRARY (REMAKE)
    Style: Minimalist, Groupboxes, Left Tabs
    Made by: AI Assistant
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

--// Theme Configuration
local Theme = {
    MainColor = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 255, 170), -- Màu xanh ngọc giống video (hoặc chỉnh lại)
    Outline = Color3.fromRGB(50, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    GroupHeader = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Code, -- Font kiểu hacker/code giống video
}

--// Utils
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:Window(title)
    local Window = {}
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LinoriaRemake"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Theme.MainColor
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.Size = UDim2.new(0, 600, 0, 450)
    
    -- Outline Decoration
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Main
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1
    
    -- Topbar (Title)
    local Topbar = Instance.new("Frame")
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 30)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Font = Theme.Font
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Decoration Line under Topbar
    local Line = Instance.new("Frame")
    Line.Parent = Topbar
    Line.BackgroundColor3 = Theme.Outline
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 0, 1, 0)
    Line.Size = UDim2.new(1, 0, 0, 1)

    MakeDraggable(Topbar, Main)

    -- Tab Holder (Left Side)
    local TabHolder = Instance.new("Frame")
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 0, 0, 31)
    TabHolder.Size = UDim2.new(0, 130, 1, -31)
    
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabHolder
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 0)

    -- Container Holder (Right Side)
    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Parent = Main
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Position = UDim2.new(0, 140, 0, 40)
    ContainerHolder.Size = UDim2.new(1, -150, 1, -50)

    local FirstTab = true

    function Window:Tab(name)
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabHolder
        TabBtn.BackgroundColor3 = Theme.MainColor
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.Font = Theme.Font
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.TextSize = 13
        
        -- Active Indicator Line
        local Indicator = Instance.new("Frame")
        Indicator.Parent = TabBtn
        Indicator.BackgroundColor3 = Theme.Accent
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(0, 0, 0, 0)
        Indicator.Size = UDim2.new(0, 2, 1, 0)
        Indicator.Visible = false

        -- Page (Container)
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContainerHolder
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        -- Layout for Columns (Left/Right)
        local LeftCol = Instance.new("Frame")
        LeftCol.Name = "LeftCol"
        LeftCol.Parent = Page
        LeftCol.BackgroundTransparency = 1
        LeftCol.Size = UDim2.new(0.48, 0, 1, 0)
        
        local RightCol = Instance.new("Frame")
        RightCol.Name = "RightCol"
        RightCol.Parent = Page
        RightCol.BackgroundTransparency = 1
        RightCol.Position = UDim2.new(0.52, 0, 0, 0)
        RightCol.Size = UDim2.new(0.48, 0, 1, 0)

        local LeftList = Instance.new("UIListLayout")
        LeftList.Parent = LeftCol
        LeftList.SortOrder = Enum.SortOrder.LayoutOrder
        LeftList.Padding = UDim.new(0, 10)
        
        local RightList = Instance.new("UIListLayout")
        RightList.Parent = RightCol
        RightList.SortOrder = Enum.SortOrder.LayoutOrder
        RightList.Padding = UDim.new(0, 10)

        -- Handle Tab Switching
        local function Activate()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play()
                    v.Frame.Visible = false
                end
            end
            for _, v in pairs(ContainerHolder:GetChildren()) do
                v.Visible = false
            end
            
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play()
            Indicator.Visible = true
            Page.Visible = true
        end

        if FirstTab then
            FirstTab = false
            Activate()
        end
        TabBtn.MouseButton1Click:Connect(Activate)

        local TabFuncs = {}

        -- GROUPBOX FUNCTION
        function TabFuncs:Group(text, side) -- side: "Left" or "Right"
            local ParentCol = (side == "Right") and RightCol or LeftCol
            
            local GroupBox = Instance.new("Frame")
            GroupBox.Parent = ParentCol
            GroupBox.BackgroundColor3 = Theme.MainColor
            GroupBox.BorderColor3 = Theme.Outline
            GroupBox.BorderSizePixel = 1
            GroupBox.Size = UDim2.new(1, 0, 0, 20) -- Height auto adjust
            
            -- Group Title (Overlapping Border)
            local GroupTitle = Instance.new("TextLabel")
            GroupTitle.Parent = GroupBox
            GroupTitle.BackgroundColor3 = Theme.MainColor -- Must match bg to hide border
            GroupTitle.BorderSizePixel = 0
            GroupTitle.Position = UDim2.new(0, 10, 0, -8)
            GroupTitle.Size = UDim2.new(0, 0, 0, 16) -- Width auto
            GroupTitle.Font = Theme.Font
            GroupTitle.Text = " " .. text .. " "
            GroupTitle.TextColor3 = Theme.Accent
            GroupTitle.TextSize = 13
            GroupTitle.AutomaticSize = Enum.AutomaticSize.X
            GroupTitle.ZIndex = 2

            local Container = Instance.new("Frame")
            Container.Parent = GroupBox
            Container.BackgroundTransparency = 1
            Container.Position = UDim2.new(0, 10, 0, 15)
            Container.Size = UDim2.new(1, -20, 1, -20)
            
            local List = Instance.new("UIListLayout")
            List.Parent = Container
            List.SortOrder = Enum.SortOrder.LayoutOrder
            List.Padding = UDim.new(0, 8)

            -- Auto resize groupbox
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                GroupBox.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 25)
            end)

            local Elements = {}

            -- TOGGLE
            function Elements:Toggle(text, default, callback)
                local toggled = default or false
                local callback = callback or function() end

                local ToggleFrame = Instance.new("TextButton")
                ToggleFrame.Parent = Container
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 20)
                ToggleFrame.Text = ""

                local Checkbox = Instance.new("Frame")
                Checkbox.Parent = ToggleFrame
                Checkbox.BackgroundColor3 = Theme.MainColor
                Checkbox.BorderColor3 = Theme.Outline
                Checkbox.Size = UDim2.new(0, 14, 0, 14)
                Checkbox.Position = UDim2.new(0, 0, 0.5, -7)

                local CheckInner = Instance.new("Frame")
                CheckInner.Parent = Checkbox
                CheckInner.BackgroundColor3 = Theme.Accent
                CheckInner.BorderSizePixel = 0
                CheckInner.Position = UDim2.new(0, 2, 0, 2)
                CheckInner.Size = UDim2.new(0, 10, 0, 10)
                CheckInner.Visible = toggled

                local Label = Instance.new("TextLabel")
                Label.Parent = ToggleFrame
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 20, 0, 0)
                Label.Size = UDim2.new(1, -20, 1, 0)
                Label.Font = Theme.Font
                Label.Text = text
                Label.TextColor3 = toggled and Theme.Text or Theme.TextDim
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                ToggleFrame.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    CheckInner.Visible = toggled
                    Label.TextColor3 = toggled and Theme.Text or Theme.TextDim
                    callback(toggled)
                end)
            end

            -- SLIDER
            function Elements:Slider(text, min, max, default, callback)
                local value = default or min
                local callback = callback or function() end
                local dragging = false

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Parent = Container
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 35)

                local Label = Instance.new("TextLabel")
                Label.Parent = SliderFrame
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.Font = Theme.Font
                Label.Text = text
                Label.TextColor3 = Theme.Text
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Parent = SliderFrame
                ValLabel.BackgroundTransparency = 1
                ValLabel.Size = UDim2.new(1, 0, 0, 15)
                ValLabel.Font = Theme.Font
                ValLabel.Text = tostring(value)
                ValLabel.TextColor3 = Theme.Text
                ValLabel.TextSize = 13
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                local SlideBg = Instance.new("Frame")
                SlideBg.Parent = SliderFrame
                SlideBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                SlideBg.BorderColor3 = Theme.Outline
                SlideBg.Position = UDim2.new(0, 0, 0, 18)
                SlideBg.Size = UDim2.new(1, 0, 0, 8)

                local Fill = Instance.new("Frame")
                Fill.Parent = SlideBg
                Fill.BackgroundColor3 = Theme.Accent
                Fill.BorderSizePixel = 0
                Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)

                local Trigger = Instance.new("TextButton")
                Trigger.Parent = SlideBg
                Trigger.BackgroundTransparency = 1
                Trigger.Size = UDim2.new(1, 0, 1, 0)
                Trigger.Text = ""

                local function Update(input)
                    local pos = math.clamp((input.Position.X - SlideBg.AbsolutePosition.X) / SlideBg.AbsoluteSize.X, 0, 1)
                    local newVal = math.floor(min + ((max - min) * pos))
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    ValLabel.Text = tostring(newVal)
                    callback(newVal)
                end

                Trigger.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true; Update(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
                end)
            end
            
            -- BUTTON
            function Elements:Button(text, callback)
                local callback = callback or function() end
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Parent = Container
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                ButtonFrame.BorderColor3 = Theme.Outline
                ButtonFrame.Size = UDim2.new(1, 0, 0, 22)
                ButtonFrame.Text = text
                ButtonFrame.TextColor3 = Theme.Text
                ButtonFrame.Font = Theme.Font
                ButtonFrame.TextSize = 13
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                    task.wait(0.1)
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                    callback()
                end)
            end

            return Elements
        end
        return TabFuncs
    end
    return Window
end

return Library
