
local GuiCreator = {}

GuiCreator.Elements = {
    ScreenGui = nil,
    MainFrame = nil,
    ContentFrame = nil,
    SidebarList = nil,
    Sections = {},
    CurrentSection = nil
}

GuiCreator.Settings = {
    Title = "Sexation V2",
    MainFrameSize = UDim2.new(0, 500, 0, 300),
    MinimizedSize = UDim2.new(0, 500, 0, 40),
    SidebarWidth = 150,
    TopBarHeight = 40,
    Colors = {
        Main = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Button = Color3.fromRGB(40, 40, 40),
        ButtonHover = Color3.fromRGB(60, 60, 60),
        ToggleOn = Color3.fromRGB(220, 20, 20),
        ToggleOff = Color3.fromRGB(40, 40, 40),
        Slider = Color3.fromRGB(40, 40, 40),
        SliderFill = Color3.fromRGB(220, 20, 20),
        InputBackground = Color3.fromRGB(40, 40, 40)
    }
}

local function applyRoundedCorners(frame, radius)
    if not frame then return end
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius or 4)
    uiCorner.Parent = frame
end

function GuiCreator:Initialize()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.Elements.ScreenGui = screenGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = self.Settings.Colors.Main
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -self.Settings.MainFrameSize.X.Offset/2, 0.5, -self.Settings.MainFrameSize.Y.Offset/2)
    mainFrame.Size = self.Settings.MainFrameSize
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    applyRoundedCorners(mainFrame, 6)
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = mainFrame
    
    self.Elements.MainFrame = mainFrame
    
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, self.Settings.TopBarHeight)
    topBar.Parent = mainFrame
    applyRoundedCorners(topBar, 6)
    
    local hubName = Instance.new("TextLabel")
    hubName.Name = "HubName"
    hubName.BackgroundTransparency = 1
    hubName.Position = UDim2.new(0, 10, 0, 0)
    hubName.Size = UDim2.new(0.85, 0, 1, 0)
    hubName.Font = Enum.Font.SourceSansBold
    hubName.Text = self.Settings.Title
    hubName.TextColor3 = self.Settings.Colors.Text
    hubName.TextSize = 18
    hubName.TextXAlignment = Enum.TextXAlignment.Left
    hubName.Parent = topBar
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Position = UDim2.new(1, -45, 0, 5)
    minimizeButton.Size = UDim2.new(0, 40, 0, 30)
    minimizeButton.Font = Enum.Font.SourceSans
    minimizeButton.Text = ""
    minimizeButton.TextColor3 = self.Settings.Colors.Text
    minimizeButton.TextSize = 14
    minimizeButton.Parent = topBar
    applyRoundedCorners(minimizeButton, 4)
    
    local minimizeIcon = Instance.new("TextLabel")
    minimizeIcon.Name = "MinimizeIcon"
    minimizeIcon.BackgroundTransparency = 1
    minimizeIcon.Size = UDim2.new(1, 0, 1, 0)
    minimizeIcon.Font = Enum.Font.SourceSansBold
    minimizeIcon.Text = "≡"
    minimizeIcon.TextColor3 = self.Settings.Colors.Text
    minimizeIcon.TextSize = 24
    minimizeIcon.Parent = minimizeButton
    
    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Name = "SidebarFrame"
    sidebarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sidebarFrame.BorderSizePixel = 0
    sidebarFrame.Position = UDim2.new(0, 5, 0, self.Settings.TopBarHeight + 5)
    sidebarFrame.Size = UDim2.new(0, self.Settings.SidebarWidth - 10, 1, -(self.Settings.TopBarHeight + 10))
    sidebarFrame.Parent = mainFrame
    applyRoundedCorners(sidebarFrame, 6)
    
    local sidebarList = Instance.new("Frame")
    sidebarList.Name = "SidebarList"
    sidebarList.BackgroundTransparency = 1
    sidebarList.Position = UDim2.new(0, 5, 0, 10)
    sidebarList.Size = UDim2.new(1, -10, 1, -20)
    sidebarList.Parent = sidebarFrame
    self.Elements.SidebarList = sidebarList
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.Position = UDim2.new(0, self.Settings.SidebarWidth + 5, 0, self.Settings.TopBarHeight + 5)
    contentFrame.Size = UDim2.new(1, -(self.Settings.SidebarWidth + 10), 1, -(self.Settings.TopBarHeight + 10))
    contentFrame.Parent = mainFrame
    applyRoundedCorners(contentFrame, 6)
    self.Elements.ContentFrame = contentFrame
    
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        if minimized then
            contentFrame.Visible = true
            sidebarFrame.Visible = true
            mainFrame.Size = self.Settings.MainFrameSize
            minimized = false
        else
            contentFrame.Visible = false
            sidebarFrame.Visible = false
            mainFrame.Size = self.Settings.MinimizedSize
            minimized = true
        end
    end)
    
    return self
end

function GuiCreator:AddSection(sectionName)
    if self.Elements.Sections[sectionName] then
        return self.Elements.Sections[sectionName]
    end
    
    local sectionButton = Instance.new("TextButton")
    sectionButton.Name = sectionName.."Button"
    sectionButton.BackgroundTransparency = 1
    sectionButton.Size = UDim2.new(1, 0, 0, 30)
    sectionButton.Font = Enum.Font.SourceSans
    sectionButton.Text = sectionName
    sectionButton.Font = Enum.Font.GothamBold
    sectionButton.TextColor3 = self.Settings.Colors.Text
    sectionButton.TextSize = 16
    sectionButton.TextXAlignment = Enum.TextXAlignment.Left
    
    local sectionCount = 0
    for _ in pairs(self.Elements.Sections) do
        sectionCount = sectionCount + 1
    end
    sectionButton.Position = UDim2.new(0, 0, 0, sectionCount * 40)
    sectionButton.Parent = self.Elements.SidebarList
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = sectionName.."Section"
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Size = UDim2.new(1, 0, 1, 0)
    sectionFrame.Visible = false
    sectionFrame.Parent = self.Elements.ContentFrame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = sectionFrame
    
    local section = {
        Button = sectionButton,
        Frame = sectionFrame,
        ScrollFrame = scrollFrame,
        Features = {},
        CanvasHeight = 0
    }
    
    self.Elements.Sections[sectionName] = section
    
    sectionButton.MouseButton1Click:Connect(function()
        self:SwitchToSection(sectionName)
    end)
    
    if sectionCount == 0 then
        self:SwitchToSection(sectionName)
    end
    
    return section
end

function GuiCreator:SwitchToSection(sectionName)
    for name, section in pairs(self.Elements.Sections) do
        section.Frame.Visible = false
        section.Button.Font = Enum.Font.SourceSans
    end
    
    local section = self.Elements.Sections[sectionName]
    if section then
        section.Frame.Visible = true
        section.Button.Font = Enum.Font.SourceSansBold
        self.Elements.CurrentSection = sectionName
    end
end

function GuiCreator:UpdateCanvasSize(section)
    section.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, section.CanvasHeight + 40)
end

function GuiCreator:AddFeature(sectionName, featureName, featureContent)
    local section = self.Elements.Sections[sectionName]
    if not section then
        section = self:AddSection(sectionName)
    end
    
    local feature
    
    if typeof(featureContent) == "string" then
        feature = Instance.new("TextLabel")
        feature.BackgroundTransparency = 1
        feature.Size = UDim2.new(1, -40, 0, 30)
        feature.Font = Enum.Font.Gotham
        feature.Text = featureContent
        feature.TextColor3 = self.Settings.Colors.Text
        feature.TextSize = 18
        feature.TextXAlignment = Enum.TextXAlignment.Left
    elseif typeof(featureContent) == "function" then
        feature = Instance.new("TextButton")
        feature.BackgroundColor3 = self.Settings.Colors.Button
        feature.BorderSizePixel = 0
        applyRoundedCorners(feature, 4)
        feature.Size = UDim2.new(0, 150, 0, 30)
        feature.Font = Enum.Font.Gotham
        feature.Text = featureName
        feature.TextColor3 = self.Settings.Colors.Text
        feature.TextSize = 16
        
        feature.MouseEnter:Connect(function()
            feature.BackgroundColor3 = self.Settings.Colors.ButtonHover
        end)
        
        feature.MouseLeave:Connect(function()
            feature.BackgroundColor3 = self.Settings.Colors.Button
        end)
        
        feature.MouseButton1Click:Connect(featureContent)
    elseif typeof(featureContent) == "boolean" then
        local toggleContainer = Instance.new("Frame")
        toggleContainer.BackgroundTransparency = 1
        toggleContainer.Size = UDim2.new(1, -40, 0, 30)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Position = UDim2.new(0, 0, 0, 0)
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.Font = Enum.Font.SourceSans
        toggleLabel.Text = featureName
        toggleLabel.TextColor3 = self.Settings.Colors.Text
        toggleLabel.TextSize = 16
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleContainer
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Position = UDim2.new(0.75, 0, 0, 5)
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Font = Enum.Font.SourceSans
        toggleButton.Text = featureContent and "ON" or "OFF"
        toggleButton.TextSize = 14
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.BackgroundColor3 = featureContent and self.Settings.Colors.ToggleOn or self.Settings.Colors.ToggleOff
        applyRoundedCorners(toggleButton, 10)
        toggleButton.Parent = toggleContainer
        
        local isOn = featureContent
        toggleButton.MouseButton1Click:Connect(function()
            isOn = not isOn
            toggleButton.Text = isOn and "ON" or "OFF"
            toggleButton.BackgroundColor3 = isOn and self.Settings.Colors.ToggleOn or self.Settings.Colors.ToggleOff
        end)
        
        feature = toggleContainer
    elseif typeof(featureContent) == "table" and featureContent.type == "slider" then
        local sliderContainer = Instance.new("Frame")
        sliderContainer.BackgroundTransparency = 1
        sliderContainer.Size = UDim2.new(1, -40, 0, 50)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.Font = Enum.Font.SourceSans
        sliderLabel.Text = featureName
        sliderLabel.TextColor3 = self.Settings.Colors.Text
        sliderLabel.TextSize = 16
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderContainer
        
        local min = featureContent.min or 0
        local max = featureContent.max or 100
        local default = featureContent.default or min
        local callback = featureContent.callback or function() end
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Name = "SliderTrack"
        sliderTrack.Position = UDim2.new(0, 0, 0, 25)
        sliderTrack.Size = UDim2.new(0.7, 0, 0, 10)
        sliderTrack.BackgroundColor3 = self.Settings.Colors.Slider
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Parent = sliderContainer
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = self.Settings.Colors.SliderFill
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderTrack
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "SliderButton"
        sliderButton.Size = UDim2.new(0, 16, 0, 16)
        sliderButton.Position = UDim2.new(sliderFill.Size.X.Scale, -8, 0, -3)
        sliderButton.BackgroundColor3 = self.Settings.Colors.SliderFill
        sliderButton.BorderSizePixel = 0
        sliderButton.Text = ""
        sliderButton.Parent = sliderTrack
        
        local valueDisplay = Instance.new("TextBox")
        valueDisplay.Name = "ValueDisplay"
        valueDisplay.Position = UDim2.new(0.75, 0, 0, 20)
        valueDisplay.Size = UDim2.new(0.25, -5, 0, 20)
        valueDisplay.BackgroundColor3 = self.Settings.Colors.InputBackground
        valueDisplay.BorderSizePixel = 1
        valueDisplay.Font = Enum.Font.SourceSans
        valueDisplay.Text = tostring(default)
        valueDisplay.TextColor3 = self.Settings.Colors.Text
        valueDisplay.TextSize = 14
        valueDisplay.Parent = sliderContainer
        
        local function updateSlider(value)
            local boundedValue = math.clamp(value, min, max)
            local scale = (boundedValue - min) / (max - min)
            
            sliderFill.Size = UDim2.new(scale, 0, 1, 0)
            sliderButton.Position = UDim2.new(scale, -8, 0, -3)
            valueDisplay.Text = tostring(math.round(boundedValue * 100) / 100)
            
            callback(boundedValue)
        end
        
        local dragging = false
        
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        sliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local mousePos = input.Position
                local relativeX = mousePos.X - sliderTrack.AbsolutePosition.X
                local sliderWidth = sliderTrack.AbsoluteSize.X
                local scale = math.clamp(relativeX / sliderWidth, 0, 1)
                local value = min + (max - min) * scale
                
                updateSlider(value)
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local relativeX = mousePos.X - sliderTrack.AbsolutePosition.X
                local sliderWidth = sliderTrack.AbsoluteSize.X
                local scale = math.clamp(relativeX / sliderWidth, 0, 1)
                local value = min + (max - min) * scale
                
                updateSlider(value)
            end
        end)
        
        valueDisplay.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local inputValue = tonumber(valueDisplay.Text)
                if inputValue then
                    updateSlider(inputValue)
                else
                    valueDisplay.Text = tostring(default)
                end
            end
        end)
        
        feature = sliderContainer
    elseif typeof(featureContent) == "table" and featureContent.type == "dropdown" then
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.BackgroundTransparency = 1
        dropdownContainer.Size = UDim2.new(1, -40, 0, 30)
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
        dropdownLabel.Size = UDim2.new(0.4, 0, 1, 0)
        dropdownLabel.Font = Enum.Font.SourceSans
        dropdownLabel.Text = featureName
        dropdownLabel.TextColor3 = self.Settings.Colors.Text
        dropdownLabel.TextSize = 16
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = dropdownContainer
        
        local options = featureContent.options or {}
        local default = featureContent.default or options[1] or ""
        local callback = featureContent.callback or function() end
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Name = "DropdownButton"
        dropdownButton.Position = UDim2.new(0.4, 5, 0, 0)
        dropdownButton.Size = UDim2.new(0.6, -5, 1, 0)
        dropdownButton.BackgroundColor3 = self.Settings.Colors.Button
        dropdownButton.BorderSizePixel = 1
        dropdownButton.Font = Enum.Font.SourceSans
        dropdownButton.Text = default
        dropdownButton.TextColor3 = self.Settings.Colors.Text
        dropdownButton.TextSize = 14
        dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
        dropdownButton.Parent = dropdownContainer
        
        local dropdownArrow = Instance.new("TextLabel")
        dropdownArrow.BackgroundTransparency = 1
        dropdownArrow.Position = UDim2.new(1, -20, 0, 0)
        dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
        dropdownArrow.Font = Enum.Font.SourceSansBold
        dropdownArrow.Text = "▼"
        dropdownArrow.TextColor3 = self.Settings.Colors.Text
        dropdownArrow.TextSize = 14
        dropdownArrow.Parent = dropdownButton
        
        local dropdownMenu = Instance.new("Frame")
        dropdownMenu.Name = "DropdownMenu"
        dropdownMenu.Position = UDim2.new(0.4, 5, 1, 0)
        dropdownMenu.Size = UDim2.new(0.6, -5, 0, #options * 25)
        dropdownMenu.BackgroundColor3 = self.Settings.Colors.Main
        dropdownMenu.BorderSizePixel = 1
        dropdownMenu.Visible = false
        dropdownMenu.ZIndex = 5
        dropdownMenu.Parent = dropdownContainer
        
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option"..i
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.BackgroundColor3 = self.Settings.Colors.Button
            optionButton.BorderSizePixel = 0
            optionButton.Font = Enum.Font.SourceSans
            optionButton.Text = option
            optionButton.TextColor3 = self.Settings.Colors.Text
            optionButton.TextSize = 14
            optionButton.ZIndex = 6
            optionButton.Parent = dropdownMenu
            
            optionButton.MouseButton1Click:Connect(function()
                dropdownButton.Text = option
                dropdownMenu.Visible = false
                callback(option)
            end)
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = self.Settings.Colors.ButtonHover
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = self.Settings.Colors.Button
            end)
        end
        
        dropdownButton.MouseButton1Click:Connect(function()
            dropdownMenu.Visible = not dropdownMenu.Visible
            dropdownArrow.Text = dropdownMenu.Visible and "▲" or "▼"
        end)
        
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local inDropdown = mousePos.X >= dropdownButton.AbsolutePosition.X and 
                                mousePos.X <= dropdownButton.AbsolutePosition.X + dropdownButton.AbsoluteSize.X and
                                mousePos.Y >= dropdownButton.AbsolutePosition.Y and
                                mousePos.Y <= dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y
                
                if not inDropdown and dropdownMenu.Visible then
                    dropdownMenu.Visible = false
                    dropdownArrow.Text = "▼"
                end
            end
        end)
        
        feature = dropdownContainer
    elseif typeof(featureContent) == "table" and featureContent.type == "color" then
        local colorContainer = Instance.new("Frame")
        colorContainer.BackgroundTransparency = 1
        colorContainer.Size = UDim2.new(1, -40, 0, 30)
        
        local colorLabel = Instance.new("TextLabel")
        colorLabel.BackgroundTransparency = 1
        colorLabel.Position = UDim2.new(0, 0, 0, 0)
        colorLabel.Size = UDim2.new(0.7, 0, 1, 0)
        colorLabel.Font = Enum.Font.SourceSans
        colorLabel.Text = featureName
        colorLabel.TextColor3 = self.Settings.Colors.Text
        colorLabel.TextSize = 16
        colorLabel.TextXAlignment = Enum.TextXAlignment.Left
        colorLabel.Parent = colorContainer
        
        local defaultColor = featureContent.default or Color3.fromRGB(255, 255, 255)
        local callback = featureContent.callback or function() end
        
        local colorDisplay = Instance.new("TextButton")
        colorDisplay.Position = UDim2.new(0.75, 0, 0, 5)
        colorDisplay.Size = UDim2.new(0, 40, 0, 20)
        colorDisplay.BackgroundColor3 = defaultColor
        colorDisplay.BorderSizePixel = 1
        colorDisplay.Text = ""
        colorDisplay.Parent = colorContainer
        
        local isColorPickerOpen = false
        local colorPicker
        
        colorDisplay.MouseButton1Click:Connect(function()
            if isColorPickerOpen then
                if colorPicker then colorPicker:Destroy() end
                isColorPickerOpen = false
                return
            end
            
            isColorPickerOpen = true
            colorPicker = Instance.new("Frame")
            colorPicker.Name = "ColorPicker"
            colorPicker.Position = UDim2.new(0.75, 0, 1, 5)
            colorPicker.Size = UDim2.new(0, 160, 0, 120)
            colorPicker.BackgroundColor3 = self.Settings.Colors.Main
            colorPicker.BorderSizePixel = 1
            colorPicker.ZIndex = 10
            colorPicker.Parent = colorContainer
            
            local presetColors = {
                Color3.fromRGB(255, 0, 0),    
                Color3.fromRGB(0, 255, 0),    
                Color3.fromRGB(0, 0, 255),  
                Color3.fromRGB(255, 255, 0), 
                Color3.fromRGB(0, 255, 255),
                Color3.fromRGB(255, 0, 255), 
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(0, 0, 0),     
                Color3.fromRGB(128, 128, 128),
                Color3.fromRGB(255, 128, 0),  
                Color3.fromRGB(128, 0, 255),  
                Color3.fromRGB(0, 128, 0)     
            }
            
            for i, color in ipairs(presetColors) do
                local row = math.floor((i-1) / 4)
                local col = (i-1) % 4
                
                local colorButton = Instance.new("TextButton")
                colorButton.Position = UDim2.new(col * 0.25, 5, row * 0.33, 5)
                colorButton.Size = UDim2.new(0.25, -10, 0.33, -10)
                colorButton.BackgroundColor3 = color
                colorButton.BorderSizePixel = 1
                colorButton.Text = ""
                colorButton.ZIndex = 11
                colorButton.Parent = colorPicker
                
                colorButton.MouseButton1Click:Connect(function()
                    colorDisplay.BackgroundColor3 = color
                    callback(color)
                    colorPicker:Destroy()
                    isColorPickerOpen = false
                end)
            end
        end)
        
        feature = colorContainer
    elseif typeof(featureContent) == "table" and featureContent.type == "input" then
        local inputContainer = Instance.new("Frame")
        inputContainer.BackgroundTransparency = 1
        inputContainer.Size = UDim2.new(1, -40, 0, 30)
        
        local inputLabel = Instance.new("TextLabel")
        inputLabel.BackgroundTransparency = 1
        inputLabel.Position = UDim2.new(0, 0, 0, 0)
        inputLabel.Size = UDim2.new(0.4, 0, 1, 0)
        inputLabel.Font = Enum.Font.SourceSans
        inputLabel.Text = featureName
        inputLabel.TextColor3 = self.Settings.Colors.Text
        inputLabel.TextSize = 16
        inputLabel.TextXAlignment = Enum.TextXAlignment.Left
        inputLabel.Parent = inputContainer
        
        local default = featureContent.default or ""
        local placeholder = featureContent.placeholder or "Enter text..."
        local callback = featureContent.callback or function() end
        
        local inputBox = Instance.new("TextBox")
        inputBox.Position = UDim2.new(0.4, 5, 0, 0)
        inputBox.Size = UDim2.new(0.6, -5, 1, 0)
        inputBox.BackgroundColor3 = self.Settings.Colors.InputBackground
        inputBox.BorderSizePixel = 1
        inputBox.Font = Enum.Font.SourceSans
        inputBox.Text = default
        inputBox.PlaceholderText = placeholder
        inputBox.TextColor3 = self.Settings.Colors.Text
        inputBox.TextSize = 14
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.Parent = inputContainer
        
        inputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(inputBox.Text)
            end
        end)
        
        feature = inputContainer
    elseif typeof(featureContent) == "Instance" then
        feature = featureContent
    else
        feature = Instance.new("TextLabel")
        feature.BackgroundTransparency = 1
        feature.Size = UDim2.new(1, -40, 0, 30)
        feature.Font = Enum.Font.Gotham
        feature.Text = tostring(featureContent)
        feature.TextColor3 = self.Settings.Colors.Text
        feature.TextSize = 18
        feature.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    local featureHeight = feature.Size.Y.Offset
    feature.Position = UDim2.new(0, 20, 0, section.CanvasHeight + 20)
    feature.Name = featureName
    feature.Parent = section.ScrollFrame
    
    table.insert(section.Features, feature)
    section.CanvasHeight = section.CanvasHeight + featureHeight + 10
    self:UpdateCanvasSize(section)
    
    return feature
end

function GuiCreator:AddSectionTitle(sectionName, titleText)
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Font = Enum.Font.GothamBlack
    title.Text = titleText
    title.TextColor3 = self.Settings.Colors.Text
    title.TextSize = 26
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Top
    
    return self:AddFeature(sectionName, "SectionTitle", title)
end

function GuiCreator:SetTitle(title)
    self.Settings.Title = title
    self.Elements.MainFrame.TopBar.HubName.Text = title
end

function GuiCreator:AddSlider(sectionName, name, options)
    options = options or {}
    local sliderOptions = {
        type = "slider",
        min = options.min or 0,
        max = options.max or 100,
        default = options.default or options.min or 0,
        callback = options.callback or function() end
    }
    
    return self:AddFeature(sectionName, name, sliderOptions)
end

function GuiCreator:AddDropdown(sectionName, name, options)
    options = options or {}
    local dropdownOptions = {
        type = "dropdown",
        options = options.options or {},
        default = options.default or (options.options and options.options[1] or ""),
        callback = options.callback or function() end
    }
    
    return self:AddFeature(sectionName, name, dropdownOptions)
end

function GuiCreator:AddColorPicker(sectionName, name, options)
    options = options or {}
    local colorOptions = {
        type = "color",
        default = options.default or Color3.fromRGB(255, 255, 255),
        callback = options.callback or function() end
    }
    
    return self:AddFeature(sectionName, name, colorOptions)
end

function GuiCreator:AddTextInput(sectionName, name, options)
    options = options or {}
    local inputOptions = {
        type = "input",
        default = options.default or "",
        placeholder = options.placeholder or "Enter text...",
        callback = options.callback or function() end
    }
    
    return self:AddFeature(sectionName, name, inputOptions)
end

function GuiCreator:SetTheme(theme)
    if type(theme) == "table" then
        for key, color in pairs(theme) do
            if self.Settings.Colors[key] then
                self.Settings.Colors[key] = color
            end
        end
    end
end
