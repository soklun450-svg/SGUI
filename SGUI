local BoostUI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== CREATE WINDOW ====================
function BoostUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "BoostUI"
    local hubName = config.HubName or "My Script Hub"
    local devBy = config.DevBy or "YourName"

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BoostUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 620, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -220, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowTitle .. "  •  " .. hubName
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    local titlePadding = Instance.new("UIPadding")
    titlePadding.PaddingLeft = UDim.new(0, 20)
    titlePadding.Parent = titleLabel

    local devLabel = Instance.new("TextLabel")
    devLabel.Size = UDim2.new(0, 200, 1, 0)
    devLabel.Position = UDim2.new(1, -220, 0, 0)
    devLabel.BackgroundTransparency = 1
    devLabel.Text = "Dev by " .. devBy
    devLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    devLabel.TextScaled = true
    devLabel.Font = Enum.Font.Gotham
    devLabel.TextXAlignment = Enum.TextXAlignment.Right
    devLabel.Parent = titleBar

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
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 50)
    tabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 8)
    tabList.Parent = tabBar

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 15)
    tabPadding.Parent = tabBar

    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -90)
    contentFrame.Position = UDim2.new(0, 0, 0, 90)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Store tabs
    local tabs = {}

    -- ==================== CREATE TAB ====================
    local function createTab(tabName)
        -- Tab Button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 120, 1, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Parent = tabBar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = tabBtn

        -- Tab Page (Scrolling)
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 6
        page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        page.Parent = contentFrame
        page.Visible = false

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = page

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingLeft = UDim.new(0, 15)
        pagePadding.PaddingRight = UDim.new(0, 15)
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.Parent = page

        -- Auto canvas size
        local function updateCanvas()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

        -- Tab switch logic
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            page.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        end)

        -- Store
        local tabData = {Button = tabBtn, Page = page, UpdateCanvas = updateCanvas}
        table.insert(tabs, tabData)

        -- Auto open first tab
        if #tabs == 1 then
            page.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        end

        -- ==================== TAB ELEMENTS ====================

        local Tab = {}

        function Tab:CreateButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 42)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            btn.Text = text
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamSemibold
            btn.Parent = page

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 8)
            bCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)

            tabData.UpdateCanvas()
            return btn
        end

        function Tab:CreateToggle(text, defaultState, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 42)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = page

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.75, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.Parent = toggleFrame

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 80, 1, 0)
            toggleBtn.Position = UDim2.new(0.78, 0, 0, 0)
            toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
            toggleBtn.Text = defaultState and "ON" or "OFF"
            toggleBtn.TextColor3 = Color3.new(1, 1, 1)
            toggleBtn.TextScaled = true
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Parent = toggleFrame

            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(0, 20)
            tCorner.Parent = toggleBtn

            local state = defaultState or false

            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    toggleBtn.Text = "ON"
                else
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    toggleBtn.Text = "OFF"
                end
                if callback then callback(state) end
            end)

            tabData.UpdateCanvas()
            return {Set = function(v) state = v; toggleBtn.BackgroundColor3 = v and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,60); toggleBtn.Text = v and "ON" or "OFF"; if callback then callback(v) end end}
        end

        function Tab:CreateDropdown(text, options, default, callback)
            local dropFrame = Instance.new("Frame")
            dropFrame.Size = UDim2.new(1, 0, 0, 42)
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
            dropBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            dropBtn.Text = default or (options and options[1]) or "Select..."
            dropBtn.TextColor3 = Color3.new(1, 1, 1)
            dropBtn.TextScaled = true
            dropBtn.Font = Enum.Font.Gotham
            dropBtn.Parent = dropFrame

            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 8)
            dCorner.Parent = dropBtn

            -- Dropdown list
            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(0.58, 0, 0, 0)
            listFrame.Position = UDim2.new(0.42, 0, 1, 5)
            listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            listFrame.Visible = false
            listFrame.ZIndex = 10
            listFrame.Parent = dropFrame

            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 8)
            listCorner.Parent = listFrame

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = listFrame

            local isOpen = false
            for _, option in ipairs(options or {}) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 32)
                optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                optBtn.Text = option
                optBtn.TextColor3 = Color3.new(1, 1, 1)
                optBtn.TextScaled = true
                optBtn.Parent = listFrame

                local oCorner = Instance.new("UICorner")
                oCorner.CornerRadius = UDim.new(0, 6)
                oCorner.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    dropBtn.Text = option
                    listFrame.Visible = false
                    isOpen = false
                    if callback then callback(option) end
                end)
            end

            dropBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                listFrame.Visible = isOpen
                listFrame.Size = UDim2.new(0.58, 0, 0, (#options * 34) + 10)
            end)

            tabData.UpdateCanvas()
        end

        function Tab:CreateTextbox(text, default, callback)
            local boxFrame = Instance.new("Frame")
            boxFrame.Size = UDim2.new(1, 0, 0, 42)
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

            local textbox = Instance.new("TextBox")
            textbox.Size = UDim2.new(0.58, 0, 1, 0)
            textbox.Position = UDim2.new(0.42, 0, 0, 0)
            textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            textbox.Text = default or ""
            textbox.PlaceholderText = "Type here..."
            textbox.TextColor3 = Color3.new(1, 1, 1)
            textbox.TextScaled = true
            textbox.ClearTextOnFocus = false
            textbox.Parent = boxFrame

            local tbCorner = Instance.new("UICorner")
            tbCorner.CornerRadius = UDim.new(0, 8)
            tbCorner.Parent = textbox

            textbox.FocusLost:Connect(function(enter)
                if callback then callback(textbox.Text) end
            end)

            tabData.UpdateCanvas()
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 55)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = page

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. (default or min)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = true
            label.Parent = sliderFrame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, 0, 0, 12)
            bar.Position = UDim2.new(0, 0, 0, 25)
            bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            bar.Parent = sliderFrame

            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 6)
            barCorner.Parent = bar

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            fill.Parent = bar

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 6)
            fillCorner.Parent = fill

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 22, 0, 22)
            knob.Position = UDim2.new(0, 0, 0.5, -11)
            knob.BackgroundColor3 = Color3.new(1, 1, 1)
            knob.Parent = bar

            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob

            local value = math.clamp(default or min, min, max)
            local function updateVisual()
                local percent = (value - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, -11, 0.5, -11)
                label.Text = text .. ": " .. math.floor(value)
                if callback then callback(value) end
            end

            local sliding = false
            bar.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local barAbsPos = bar.AbsolutePosition.X
                    local barAbsSize = bar.AbsoluteSize.X
                    local mouseX = inp.Position.X
                    local percent = math.clamp((mouseX - barAbsPos) / barAbsSize, 0, 1)
                    value = min + (max - min) * percent
                    updateVisual()
                end
            end)

            updateVisual()
            tabData.UpdateCanvas()
        end

        return Tab
    end

    -- Return library functions
    return {
        CreateTab = createTab
    }
end
