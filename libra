--[[ 
    UI LIBRARY SOURCE
    Copy toàn bộ code này và upload lên GitHub/Pastebin.
    Lấy link RAW.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- Settings
local Settings = {
	MainColor = Color3.fromRGB(25, 25, 25),
	SecondaryColor = Color3.fromRGB(35, 35, 35),
	AccentColor = Color3.fromRGB(255, 255, 255),
	TextColor = Color3.fromRGB(150, 150, 150),
	SelectedTextColor = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamMedium
}

function Library:Destroy()
    if CoreGui:FindFirstChild("CustomLibrary") then
        CoreGui:FindFirstChild("CustomLibrary"):Destroy()
    end
end

function Library:CreateWindow(hubName)
    -- Xóa GUI cũ nếu có
    Library:Destroy()

	local ScreenGui = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Sidebar = Instance.new("Frame")
	local TabContainer = Instance.new("ScrollingFrame")
	local UIListLayout_Tabs = Instance.new("UIListLayout")
	local ContentArea = Instance.new("Frame")
	local TitleLabel = Instance.new("TextLabel")
	
	-- Bảo vệ GUI (ẩn khỏi danh sách thông thường)
	if syn and syn.protect_gui then 
        syn.protect_gui(ScreenGui) 
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end

	ScreenGui.Name = "CustomLibrary"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Draggable Logic
	local function MakeDraggable(topbarobject, object)
		local Dragging, DragInput, DragStart, StartPosition
		local function Update(input)
			local Delta = input.Position - DragStart
			object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
		topbarobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true; DragStart = input.Position; StartPosition = object.Position
				input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
			end
		end)
		topbarobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
		end)
		UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then Update(input) end end)
	end

	-- Main Frame Setup
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Settings.MainColor
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
	MainFrame.Size = UDim2.new(0, 650, 0, 450)
	MainFrame.ClipsDescendants = true
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = MainFrame
	MakeDraggable(MainFrame, MainFrame)

	-- Sidebar
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.BackgroundColor3 = Settings.MainColor
	Sidebar.BackgroundTransparency = 1
	Sidebar.Size = UDim2.new(0, 180, 1, 0)
	
	TitleLabel.Name = "Title"
	TitleLabel.Parent = Sidebar
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 20, 0, 20)
	TitleLabel.Size = UDim2.new(0, 140, 0, 30)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = hubName or "HUB NAME"
	TitleLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
	TitleLabel.TextSize = 18
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	TabContainer.Name = "TabContainer"
	TabContainer.Parent = Sidebar
	TabContainer.Active = true
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 0, 0, 60)
	TabContainer.Size = UDim2.new(1, 0, 1, -60)
	TabContainer.ScrollBarThickness = 0
	
	UIListLayout_Tabs.Parent = TabContainer
	UIListLayout_Tabs.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_Tabs.Padding = UDim.new(0, 5)

	ContentArea.Name = "ContentArea"
	ContentArea.Parent = MainFrame
	ContentArea.BackgroundTransparency = 1
	ContentArea.Position = UDim2.new(0, 190, 0, 10)
	ContentArea.Size = UDim2.new(0, 450, 1, -20)

    -- Toggle UI Keybind (RightControl)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

	local Tabs = {}
	local FirstTab = true
	local Window = {}

	function Window:CreateTab(name, iconId)
		local TabButton = Instance.new("TextButton")
		local TabIcon = Instance.new("ImageLabel")
		local TabTitle = Instance.new("TextLabel")
		local Indicator = Instance.new("Frame")
		
		local Page = Instance.new("ScrollingFrame")
		local PageLayout = Instance.new("UIListLayout")
		local PagePadding = Instance.new("UIPadding")

		Page.Name = name .. "_Page"
		Page.Parent = ContentArea
		Page.BackgroundTransparency = 1
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
		Page.Visible = false
		
		PageLayout.Parent = Page
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 10)
		PageLayout.FillDirection = Enum.FillDirection.Vertical
		PagePadding.Parent = Page
		PagePadding.PaddingTop = UDim.new(0, 5)
		PagePadding.PaddingLeft = UDim.new(0, 5)

		TabButton.Name = name
		TabButton.Parent = TabContainer
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 0, 40)
		TabButton.Text = ""
		
		Indicator.Name = "Indicator"
		Indicator.Parent = TabButton
		Indicator.BackgroundColor3 = Settings.AccentColor
		Indicator.Position = UDim2.new(0, 0, 0.25, 0)
		Indicator.Size = UDim2.new(0, 3, 0.5, 0)
		Indicator.BackgroundTransparency = 1
		Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

		TabIcon.Name = "Icon"
		TabIcon.Parent = TabButton
		TabIcon.BackgroundTransparency = 1
		TabIcon.Position = UDim2.new(0, 20, 0.5, -10)
		TabIcon.Size = UDim2.new(0, 20, 0, 20)
		TabIcon.Image = iconId or "rbxassetid://6034509923"
		TabIcon.ImageColor3 = Settings.TextColor

		TabTitle.Name = "Title"
		TabTitle.Parent = TabButton
		TabTitle.BackgroundTransparency = 1
		TabTitle.Position = UDim2.new(0, 55, 0, 0)
		TabTitle.Size = UDim2.new(0, 100, 1, 0)
		TabTitle.Font = Settings.Font
		TabTitle.Text = name
		TabTitle.TextColor3 = Settings.TextColor
		TabTitle.TextSize = 14
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left

		TabButton.MouseButton1Click:Connect(function()
			for _, item in pairs(Tabs) do
				TweenService:Create(item.Title, TweenInfo.new(0.3), {TextColor3 = Settings.TextColor}):Play()
				TweenService:Create(item.Icon, TweenInfo.new(0.3), {ImageColor3 = Settings.TextColor}):Play()
				TweenService:Create(item.Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				item.Page.Visible = false
			end
			TweenService:Create(TabTitle, TweenInfo.new(0.3), {TextColor3 = Settings.SelectedTextColor}):Play()
			TweenService:Create(TabIcon, TweenInfo.new(0.3), {ImageColor3 = Settings.SelectedTextColor}):Play()
			TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
			Page.Visible = true
		end)
		
		table.insert(Tabs, {Button = TabButton, Title = TabTitle, Icon = TabIcon, Indicator = Indicator, Page = Page})

		if FirstTab then
			FirstTab = false
			TabTitle.TextColor3 = Settings.SelectedTextColor
			TabIcon.ImageColor3 = Settings.SelectedTextColor
			Indicator.BackgroundTransparency = 0
			Page.Visible = true
		end

		local TabFunctions = {}
		function TabFunctions:CreateSection(sectionName)
			local SectionFrame = Instance.new("Frame")
			local SectionContainer = Instance.new("Frame")
			local SectionListLayout = Instance.new("UIListLayout")

			SectionFrame.Name = "Section"
			SectionFrame.Parent = Page
			SectionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			SectionFrame.Size = UDim2.new(0.95, 0, 0, 0)
			Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 4)
			local Stroke = Instance.new("UIStroke", SectionFrame)
            Stroke.Color = Color3.fromRGB(45, 45, 45); Stroke.Thickness = 1
			
			local Title = Instance.new("TextLabel", SectionFrame)
            Title.Text = string.upper(sectionName); Title.Font = Settings.Font; Title.TextSize = 11; Title.TextColor3 = Color3.fromRGB(180, 180, 180)
            Title.Size = UDim2.new(1, -20, 0, 25); Title.Position = UDim2.new(0, 10, 0, 2); Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

			SectionContainer.Parent = SectionFrame; SectionContainer.BackgroundTransparency = 1
			SectionContainer.Position = UDim2.new(0, 10, 0, 30); SectionContainer.Size = UDim2.new(1, -20, 0, 0)
			
			SectionListLayout.Parent = SectionContainer; SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder; SectionListLayout.Padding = UDim.new(0, 5)
			SectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				SectionContainer.Size = UDim2.new(1, -20, 0, SectionListLayout.AbsoluteContentSize.Y)
				SectionFrame.Size = UDim2.new(0.95, 0, 0, SectionListLayout.AbsoluteContentSize.Y + 40)
			end)

			local SectionFunctions = {}
			function SectionFunctions:AddToggle(text, default, callback)
				local toggled = default or false
				local ToggleBtn = Instance.new("TextButton", SectionContainer)
                ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Size = UDim2.new(1, 0, 0, 30); ToggleBtn.Text = ""
				local Label = Instance.new("TextLabel", ToggleBtn)
                Label.Text = text; Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.Font = Settings.Font; Label.TextSize = 13; Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.7, 0, 1, 0); Label.TextXAlignment = Enum.TextXAlignment.Left
				local Box = Instance.new("Frame", ToggleBtn)
                Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Box.Position = UDim2.new(1, -25, 0.5, -10); Box.Size = UDim2.new(0, 20, 0, 20)
				Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
				local BoxStroke = Instance.new("UIStroke", Box); BoxStroke.Color = Color3.fromRGB(60, 60, 60)
				local Checkmark = Instance.new("ImageLabel", Box); Checkmark.Image = "rbxassetid://6031094667"; Checkmark.Size = UDim2.new(1,0,1,0); Checkmark.BackgroundTransparency = 1; Checkmark.ImageColor3 = Settings.AccentColor

				local function Update()
					if toggled then 
                        TweenService:Create(Checkmark, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
                        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Settings.AccentColor}):Play()
                    else 
                        TweenService:Create(Checkmark, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60,60,60)}):Play()
                    end
					pcall(callback, toggled)
				end
				ToggleBtn.MouseButton1Click:Connect(function() toggled = not toggled; Update() end)
				Update()
			end

            function SectionFunctions:AddSlider(text, min, max, default, callback)
                local value = default or min
                local SliderFrame = Instance.new("Frame", SectionContainer); SliderFrame.BackgroundTransparency = 1; SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                local Label = Instance.new("TextLabel", SliderFrame); Label.Text = text; Label.TextColor3 = Color3.fromRGB(200,200,200); Label.Font = Settings.Font; Label.TextSize = 13; Label.Size = UDim2.new(0.7,0,0,20); Label.BackgroundTransparency = 1; Label.TextXAlignment = Enum.TextXAlignment.Left
                local ValueLabel = Instance.new("TextLabel", SliderFrame); ValueLabel.Text = tostring(value); ValueLabel.TextColor3 = Color3.fromRGB(150,150,150); ValueLabel.Font = Settings.Font; ValueLabel.TextSize = 13; ValueLabel.Size = UDim2.new(0.3,-5,0,20); ValueLabel.Position = UDim2.new(0.7,0,0,0); ValueLabel.BackgroundTransparency = 1; ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                local SliderBar = Instance.new("Frame", SliderFrame); SliderBar.BackgroundColor3 = Color3.fromRGB(40,40,40); SliderBar.Position = UDim2.new(0,0,0,30); SliderBar.Size = UDim2.new(1,-5,0,4); Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1,0)
                local SliderFill = Instance.new("Frame", SliderBar); SliderFill.BackgroundColor3 = Settings.AccentColor; SliderFill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0); Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1,0)
                local Knob = Instance.new("Frame", SliderFill); Knob.BackgroundColor3 = Color3.fromRGB(255,255,255); Knob.Position = UDim2.new(1,-6,0.5,-6); Knob.Size = UDim2.new(0,12,0,12); Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)
                local SliderBtn = Instance.new("TextButton", SliderBar); SliderBtn.BackgroundTransparency = 1; SliderBtn.Size = UDim2.new(1,0,1,20); SliderBtn.Position = UDim2.new(0,0,0,-10); SliderBtn.Text = ""

                local dragging = false
                local function Update(input)
                    local p = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(p,0,1,0)}):Play()
                    value = math.floor(min + ((max - min) * p))
                    ValueLabel.Text = tostring(value)
                    pcall(callback, value)
                end
                SliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; Update(input) end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
                UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end end)
            end

            function SectionFunctions:AddDropdown(text, options, callback)
                local DropFrame = Instance.new("Frame", SectionContainer); DropFrame.BackgroundTransparency = 1; DropFrame.Size = UDim2.new(1,0,0,45); DropFrame.ZIndex = 2
                local Title = Instance.new("TextLabel", DropFrame); Title.Text = text; Title.Font = Settings.Font; Title.TextSize = 12; Title.TextColor3 = Color3.fromRGB(150,150,150); Title.Size = UDim2.new(1,0,0,15); Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left
                local DropBtn = Instance.new("TextButton", DropFrame); DropBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); DropBtn.Position = UDim2.new(0,0,0,18); DropBtn.Size = UDim2.new(1,-5,0,25); DropBtn.Text = ""; Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0,4); Instance.new("UIStroke", DropBtn).Color = Color3.fromRGB(50,50,50)
                local DropLabel = Instance.new("TextLabel", DropBtn); DropLabel.Text = options[1] or "None"; DropLabel.Font = Settings.Font; DropLabel.TextSize = 13; DropLabel.TextColor3 = Color3.fromRGB(255,255,255); DropLabel.Position = UDim2.new(0,10,0,0); DropLabel.Size = UDim2.new(1,-30,1,0); DropLabel.BackgroundTransparency = 1; DropLabel.TextXAlignment = Enum.TextXAlignment.Left
                local OptionList = Instance.new("Frame", DropFrame); OptionList.BackgroundColor3 = Color3.fromRGB(35,35,35); OptionList.Position = UDim2.new(0,0,0,45); OptionList.Size = UDim2.new(1,-5,0,0); OptionList.Visible = false; OptionList.ClipsDescendants = true; Instance.new("UICorner", OptionList).CornerRadius = UDim.new(0,4)
                local OptionLayout = Instance.new("UIListLayout", OptionList); OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                local isOpen = false
                DropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        for _,v in pairs(OptionList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                        for _,opt in pairs(options) do
                            local OptBtn = Instance.new("TextButton", OptionList); OptBtn.BackgroundColor3 = Color3.fromRGB(35,35,35); OptBtn.Size = UDim2.new(1,0,0,25); OptBtn.Text = opt; OptBtn.Font = Settings.Font; OptBtn.TextColor3 = Color3.fromRGB(180,180,180); OptBtn.TextSize = 13; OptBtn.BorderSizePixel = 0
                            OptBtn.MouseEnter:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) end); OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(35,35,35) end)
                            OptBtn.MouseButton1Click:Connect(function() isOpen = false; DropLabel.Text = opt; OptionList.Visible = false; DropFrame.Size = UDim2.new(1,0,0,45); pcall(callback, opt) end)
                        end
                        OptionList.Visible = true
                        TweenService:Create(OptionList, TweenInfo.new(0.2), {Size = UDim2.new(1,-5,0,#options*25)}):Play()
                        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,45+(#options*25))}):Play()
                    else
                        OptionList.Visible = false; DropFrame.Size = UDim2.new(1,0,0,45)
                    end
                end)
            end
			return SectionFunctions
		end
		return TabFunctions
	end
	return Window
end

return Library
