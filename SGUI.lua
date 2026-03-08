local BoostUI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ACCENT_COLOR = Color3.fromRGB(0, 170, 255) -- Default accent (customizable)

-- ==================== CREATE WINDOW (Short API) ====================
function BoostUI:Create(config)
    config = config or {}
    local windowTitle = config.Title or "BoostUI"
    local hubName = config.HubName or "v2.0"
    local devBy = config.DevBy or "You"
    local accent = config.Accent or ACCENT_COLOR

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BoostUI_v2"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(0, 650, 0, 460)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -230)
    mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = mainFrame

    -- Shadow (simple ImageLabel - free asset)
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- Soft shadow asset
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame

    -- Draggable
    local dragging = false
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local dragStart = input.Position
            local startPos = mainFrame.Position
            local conn
            conn = UserInputService.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = inp.Position - dragStart
                    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            UserInputService.InputEnded:Connect(function()
                dragging = false
                conn:Disconnect()
            end)
        end
    end)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 14)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -260, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowTitle .. "  •  " .. hubName
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    local titlePad = Instance.new("UIPadding")
    titlePad.PaddingLeft = UDim.new(0, 20)
    titlePad.Parent = titleLabel

    local devLabel = Instance.new("TextLabel")
    devLabel.Size = UDim2.new(0, 200, 1, 0)
    devLabel.Position = UDim2.new(1, -260, 0, 0)
    devLabel.BackgroundTransparency = 1
    devLabel.Text = "Dev by " .. devBy
    devLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    devLabel.TextScaled = true
    devLabel.Font = Enum.Font.Gotham
    devLabel.TextXAlignment = Enum.TextXAlignment.Right
    devLabel.Parent = titleBar

    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 40, 1, 0)
    minBtn.Position = UDim2.new(1, -80, 0, 0)
    minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    minBtn.Text = "–"
    minBtn.TextColor3 = Color3.new(1, 1, 1)
    minBtn.TextScaled = true
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleBar
    local minimized = false
    local originalSize = mainFrame.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 650, 0, 50)}):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = originalSize}):Play()
        end
    end)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 46)
    tabBar.Position = UDim2.new(0, 0, 0, 50)
    tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 6)
    tabList.Parent = tabBar

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 12)
    tabPadding.Parent = tabBar

    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -96)
    contentFrame.Position = UDim2.new(0, 0, 0, 96)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local tabs = {}

    -- ==================== CREATE TAB (Short: Window:Tab) ====================
    local function createTab(tabName)
        -- Tab Button (Auto width)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 0, 1, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.AutomaticSize = Enum.AutomaticSize.X
        tabBtn.Parent = tabBar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = tabBtn

        -- Hover effect
        tabBtn.MouseEnter:Connect(function()
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        end)
        tabBtn.MouseLeave:Connect(function()
            if not tabBtn:GetAttribute("Active") then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            end
        end)

        -- Page
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 5
        page.ScrollBarImageColor3 = accent
        page.Parent = contentFrame
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = page

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingLeft = UDim.new(0, 15)
        pagePadding.PaddingRight = UDim.new(0, 15)
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.Parent = page

        local function updateCanvas()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 30)
        end
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

        -- Tab switch with fade
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabs) do
                t.Page.Visible = false
                t.Button:SetAttribute("Active", false)
                TweenService:Create(t.Button, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            end
            page.Visible = true
            tabBtn:SetAttribute("Active", true)
            TweenService:Create(tabBtn, TweenInfo.new(0.25), {BackgroundColor3 = accent}):Play()
        end)

        local tabData = {Button = tabBtn, Page = page, UpdateCanvas = updateCanvas}
        table.insert(tabs, tabData)

        if #tabs == 1 then
            page.Visible = true
            tabBtn:SetAttribute("Active", true)
            tabBtn.BackgroundColor3 = accent
        end

        -- Tab object (Short API)
        local Tab = {}

        function Tab:Section(title)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, 0, 0, 32)
            section.BackgroundTransparency = 1
            section.Parent = page

            local secLabel = Instance.new("TextLabel")
            secLabel.Size = UDim2.new(1, 0, 1, 0)
            secLabel.BackgroundTransparency = 1
            secLabel.Text = title
            secLabel.TextColor3 = accent
            secLabel.TextScaled = true
            secLabel.Font = Enum.Font.GothamBold
            secLabel.TextXAlignment = Enum.TextXAlignment.Left
            secLabel.Parent = section

            local underline = Instance.new("Frame")
            underline.Size = UDim2.new(1, 0, 0, 2)
            underline.Position = UDim2.new(0, 0, 1, -2)
            underline.BackgroundColor3 = accent
            underline.Parent = section

            tabData.UpdateCanvas()
            return section
        end

        function Tab:Label(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 30)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = page

            tabData.UpdateCanvas()
        end

        function Tab:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 44)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = text
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamSemibold
            btn.Parent = page

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 10)
            bCorner.Parent = btn

            -- Hover
            btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play() end)
            btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() end)

            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)

            tabData.UpdateCanvas()
        end

        function Tab:Toggle(text, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 44)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = page

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.Parent = toggleFrame

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 92, 1, 0)
            toggleBtn.Position = UDim2.new(1, -92, 0, 0)
            toggleBtn.BackgroundColor3 = default and accent or Color3.fromRGB(55, 55, 55)
            toggleBtn.Text = default and "ON" or "OFF"
            toggleBtn.TextColor3 = Color3.new(1, 1, 1)
            toggleBtn.TextScaled = true
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Parent = toggleFrame

            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(0, 22)
            tCorner.Parent = toggleBtn

            local state = default or false

            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = state and accent or Color3.fromRGB(55, 55, 55)
                }):Play()
                toggleBtn.Text = state and "ON" or "OFF"
                if callback then callback(state) end
            end)

            tabData.UpdateCanvas()
            return {Set = function(v)
                state = v
                TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = v and accent or Color3.fromRGB(55, 55, 55)}):Play()
                toggleBtn.Text = v and "ON" or "OFF"
                if callback then callback(v) end
            end}
        end

        function Tab:Slider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 58)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = page

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 22)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. (default or min)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.Parent = sliderFrame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, 0, 0, 14)
            bar.Position = UDim2.new(0, 0, 0, 28)
            bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            bar.Parent = sliderFrame

            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 7)
            barCorner.Parent = bar

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = accent
            fill.Parent = bar

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 7)
            fillCorner.Parent = fill

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = UDim2.new(0, 0, 0.5, -12)
            knob.BackgroundColor3 = Color3.new(1, 1, 1)
            knob.Parent = bar

            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob

            local value = math.clamp(default or min, min, max)
            local function update()
                local percent = (value - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, -12, 0.5, -12)
                label.Text = text .. ": " .. math.floor(value)
                if callback then callback(value) end
            end

            local sliding = false
            bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * percent
                    update()
                end
            end)

            update()
            tabData.UpdateCanvas()
        end

        function Tab:Dropdown(text, options, default, callback)
            local dropFrame = Instance.new("Frame")
            dropFrame.Size = UDim2.new(1, 0, 0, 44)
            dropFrame.BackgroundTransparency = 1
            dropFrame.Parent = page

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = true
            label.Parent = dropFrame

            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.new(0.58, 0, 1, 0)
            dropBtn.Position = UDim2.new(0.42, 0, 0, 0)
            dropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            dropBtn.Text = default or options[1] or "Select..."
            dropBtn.TextColor3 = Color3.new(1, 1, 1)
            dropBtn.TextScaled = true
            dropBtn.Font = Enum.Font.Gotham
            dropBtn.Parent = dropFrame

            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 10)
            dCorner.Parent = dropBtn

            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(0.58, 0, 0, 0)
            listFrame.Position = UDim2.new(0.42, 0, 1, 6)
            listFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            listFrame.Visible = false
            listFrame.ZIndex = 100
            listFrame.Parent = dropFrame

            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 10)
            listCorner.Parent = listFrame

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = listFrame

            local open = false
            for _, opt in ipairs(options or {}) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 34)
                optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.new(1, 1, 1)
                optBtn.TextScaled = true
                optBtn.Parent = listFrame

                local oCorner = Instance.new("UICorner")
                oCorner.CornerRadius = UDim.new(0, 8)
                oCorner.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    dropBtn.Text = opt
                    listFrame.Visible = false
                    open = false
                    if callback then callback(opt) end
                end)
            end

            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                listFrame.Visible = open
                listFrame.Size = UDim2.new(0.58, 0, 0, (#options * 36) + 8)
            end)

            tabData.UpdateCanvas()
        end

        function Tab:Input(text, default, callback)
            local boxFrame = Instance.new("Frame")
            boxFrame.Size = UDim2.new(1, 0, 0, 44)
            boxFrame.BackgroundTransparency = 1
            boxFrame.Parent = page

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = true
            label.Parent = boxFrame

            local input = Instance.new("TextBox")
            input.Size = UDim2.new(0.58, 0, 1, 0)
            input.Position = UDim2.new(0.42, 0, 0, 0)
            input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            input.Text = default or ""
            input.PlaceholderText = "Type here..."
            input.TextColor3 = Color3.new(1, 1, 1)
            input.TextScaled = true
            input.ClearTextOnFocus = false
            input.Parent = boxFrame

            local ibCorner = Instance.new("UICorner")
            ibCorner.CornerRadius = UDim.new(0, 10)
            ibCorner.Parent = input

            input.FocusLost:Connect(function(enterPressed)
                if callback then callback(input.Text) end
            end)

            tabData.UpdateCanvas()
        end

        return Tab
    end

    -- ==================== RETURN SHORT API ====================
    local Window = {}
    function Window:Tab(name)
        return createTab(name)
    end
    return Window
end
