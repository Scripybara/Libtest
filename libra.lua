--[[
    MODERN UI LIBRARY - SIMPLINESS REMASTERED
    Design: Modern Dark, Rounded, Smooth Animations
    Author: AI Assistant
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

--// Settings & Theme
local Theme = {
    Background = Color3.fromRGB(25, 25, 30),
    SectionBackground = Color3.fromRGB(35, 35, 40),
    TextColor = Color3.fromRGB(180, 180, 180),
    TextSelected = Color3.fromRGB(255, 255, 255), -- Yêu cầu: Chữ trắng khi chọn
    Accent = Color3.fromRGB(212, 108, 152), -- Màu hồng giống ảnh
    DarkOutline = Color3.fromRGB(50, 50, 55),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold
}

--// Utility Functions
local function Create(class, properties)
    local instance = Instance.new(class)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.15), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

--// UI Library Functions
function Library:CreateWindow(config)
    local Name = config.Name or "Simpliness"
    
    -- Main ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "SimplinessUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 400), -- Rộng hơn một chút cho thoáng
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 12)})
    Create("UIStroke", {Parent = MainFrame, Color = Theme.DarkOutline, Thickness = 1})

    -- Shadow (Optional aesthetics)
    local Shadow = Create("ImageLabel", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0,0,0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23,23,277,277)
    })

    -- Topbar
    local Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local Title = Create("TextLabel", {
        Parent = Topbar,
        Text = Name,
        TextColor3 = Theme.TextSelected,
        Font = Theme.FontBold,
        TextSize = 16,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Window Controls (Fake MacOS buttons)
    local ControlHolder = Create("Frame", {Parent = Topbar, Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(1, -70, 0, 0), BackgroundTransparency = 1})
    Create("UIListLayout", {Parent = ControlHolder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Center})
    for _, color in pairs({Color3.fromRGB(255, 95, 87), Color3.fromRGB(255, 189, 46), Color3.fromRGB(40, 201, 64)}) do
        local dot = Create("Frame", {Parent = ControlHolder, Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = color})
        Create("UICorner", {Parent = dot, CornerRadius = UDim.new(1, 0)})
    end

    MakeDraggable(Topbar, MainFrame)

    -- Tab Container
    local TabContainer = Create("Frame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 45),
        Size = UDim2.new(1, -30, 0, 30)
    })
    local TabListLayout = Create("UIListLayout", {Parent = TabContainer, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10)})

    -- Pages Container
    local Pages = Create("Frame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 85),
        Size = UDim2.new(1, -30, 1, -100),
        ClipsDescendants = true
    })

    local Window = {}
    local FirstTab = true

    function Window:Tab(text)
        local TabButton = Create("TextButton", {
            Parent = TabContainer,
            Text = text,
            Font = Theme.FontBold,
            TextSize = 14,
            TextColor3 = FirstTab and Theme.Accent or Theme.TextColor,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X
        })
        
        -- Underline for active tab
        local Underline = Create("Frame", {
            Parent = TabButton,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BorderSizePixel = 0,
            BackgroundTransparency = FirstTab and 0 or 1
        })

        local Page = Create("ScrollingFrame", {
            Parent = Pages,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = FirstTab
        })
        Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Create("UIPadding", {Parent = Page, PaddingRight = UDim.new(0, 5)})

        if FirstTab then FirstTab = false end

        TabButton.MouseButton1Click:Connect(function()
            -- Reset all tabs
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Theme.TextColor}):Play()
                    TweenService:Create(v:FindFirstChild("Frame"), TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                end
            end
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            
            -- Activate this tab
            TweenService:Create(TabButton, TweenInfo.new(0.3), {TextColor3 = Theme.Accent}):Play()
            TweenService:Create(Underline, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            Page.Visible = true
        end)

        local TabElements = {}

        --// SECTION (Optional visual grouping)
        function TabElements:Section(text)
            local SectionLabel = Create("TextLabel", {
                Parent = Page,
                Text = text,
                Font = Theme.FontBold,
                TextColor3 = Theme.TextSelected,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("UIPadding", {Parent = SectionLabel, PaddingTop = UDim.new(0, 5)})
        end

        --// TOGGLE
        function TabElements:Toggle(text, default, callback)
            local callback = callback or function() end
            local toggled = default or false

            local ToggleFrame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.SectionBackground,
                Size = UDim2.new(1, 0, 0, 38)
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 6)})
            
            local ToggleLabel = Create("TextLabel", {
                Parent = ToggleFrame,
                Text = text,
                Font = Theme.Font,
                TextSize = 14,
                TextColor3 = Theme.TextColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ToggleBtn = Create("TextButton", {
                Parent = ToggleFrame,
                Text = "",
                BackgroundColor3 = toggled and Theme.Accent or Theme.DarkOutline,
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -32, 0.5, -11),
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = ToggleBtn, CornerRadius = UDim.new(0, 4)})

            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                local targetColor = toggled and Theme.Accent or Theme.DarkOutline
                local targetText = toggled and Theme.TextSelected or Theme.TextColor
                
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(ToggleLabel, TweenInfo.new(0.2), {TextColor3 = targetText}):Play()
                callback(toggled)
            end)
            
            -- Run initial status
            if toggled then
                 ToggleLabel.TextColor3 = Theme.TextSelected
            end
        end

        --// SLIDER
        function TabElements:Slider(text, min, max, default, callback)
            local callback = callback or function() end
            local dragging = false
            local value = default or min

            local SliderFrame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.SectionBackground,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 6)})

            local Label = Create("TextLabel", {
                Parent = SliderFrame,
                Text = text,
                Font = Theme.Font,
                TextSize = 14,
                TextColor3 = Theme.TextColor,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                Text = tostring(value),
                Font = Theme.FontBold,
                TextSize = 14,
                TextColor3 = Theme.TextSelected,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -50, 0, 5),
                Size = UDim2.new(0, 40, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local SliderBar = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Theme.DarkOutline,
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 35)
            })
            Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

            local Fill = Create("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            
            local Knob = Create("Frame", {
                Parent = Fill,
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(1, -6, 0.5, -6)
            })
            Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1,0)})

            local Trigger = Create("TextButton", {
                Parent = SliderBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local function Update(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                Fill.Size = pos
                local newVal = math.floor(min + ((max - min) * pos.X.Scale))
                ValueLabel.Text = tostring(newVal)
                callback(newVal)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end

        --// DROPDOWN
        function TabElements:Dropdown(text, options, callback)
            local callback = callback or function() end
            local dropped = false
            
            local DropdownContainer = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.SectionBackground,
                Size = UDim2.new(1, 0, 0, 38),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = DropdownContainer, CornerRadius = UDim.new(0, 6)})
            
            local DropdownBtn = Create("TextButton", {
                Parent = DropdownContainer,
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38)
            })

            local Label = Create("TextLabel", {
                Parent = DropdownContainer,
                Text = text,
                Font = Theme.Font,
                TextSize = 14,
                TextColor3 = Theme.TextColor,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -40, 0, 38),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local SelectedText = Create("TextLabel", {
                Parent = DropdownContainer,
                Text = "Select...",
                Font = Theme.FontBold,
                TextSize = 14,
                TextColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -160, 0, 0),
                Size = UDim2.new(0, 120, 0, 38),
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Arrow = Create("ImageLabel", {
                Parent = DropdownContainer,
                Image = "rbxassetid://6034818372", -- Down Arrow
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0, 9),
                ImageColor3 = Theme.TextColor
            })

            local List = Create("ScrollingFrame", {
                Parent = DropdownContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 0), -- Dynamic
                CanvasSize = UDim2.new(0,0,0,0),
                ScrollBarThickness = 2
            })
            local ListLayout = Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
            Create("UIPadding", {Parent = List, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 5)})

            -- Add Options logic
            local function RefreshOptions()
                -- Clear old
                for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                
                for _, opt in pairs(options) do
                    local Item = Create("TextButton", {
                        Parent = List,
                        Text = opt,
                        Font = Theme.Font,
                        TextSize = 13,
                        TextColor3 = Theme.TextColor, -- Mặc định màu xám
                        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                        Size = UDim2.new(1, 0, 0, 25),
                        AutoButtonColor = true
                    })
                    Create("UICorner", {Parent = Item, CornerRadius = UDim.new(0, 4)})
                    
                    Item.MouseButton1Click:Connect(function()
                        SelectedText.Text = opt
                        callback(opt)
                        
                        -- ** LOGIC YÊU CẦU: Chữ được chọn sẽ màu trắng, các cái khác màu xám **
                        for _, otherBtn in pairs(List:GetChildren()) do
                            if otherBtn:IsA("TextButton") then
                                if otherBtn == Item then
                                    TweenService:Create(otherBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextSelected}):Play()
                                    otherBtn.Font = Theme.FontBold
                                else
                                    TweenService:Create(otherBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextColor}):Play()
                                    otherBtn.Font = Theme.Font
                                end
                            end
                        end
                        
                        -- Close dropdown after select
                        dropped = false
                        TweenService:Create(DropdownContainer, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    end)
                end
                
                -- Update Canvas
                List.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
            end
            
            RefreshOptions()

            DropdownBtn.MouseButton1Click:Connect(function()
                dropped = not dropped
                local count = #options
                local h = math.clamp(count * 29 + 10, 0, 150) -- Max height 150
                
                if dropped then
                    TweenService:Create(DropdownContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 40 + h)}):Play()
                    TweenService:Create(List, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, h)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    TweenService:Create(DropdownContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    TweenService:Create(List, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end
            end)
            
            -- Fix layout overlapping
            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                 Page.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 50)
            end)
        end

        -- Update Canvas Size Logic for the whole page
        Page.ChildAdded:Connect(function()
             Page.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 50)
        end)

        return TabElements
    end
    
    return Window
end

return Library
