local Lib = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Função utilitária para criar UICorner
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

-- Função utilitária para criar TextLabel
local function CreateLabel(parent, props)
    local label = Instance.new("TextLabel")
    for k,v in pairs(props) do label[k] = v end
    label.Parent = parent
    return label
end

function Lib:MakeWindow(Info)
    Info = Info or {}
    local oldGui = PlayerGui:FindFirstChild("ModernUILibrary")
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = PlayerGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 470, 0, 350)
    MainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    CreateCorner(MainFrame, 12)

    -- TitleBar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1,0,0,45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    CreateCorner(TitleBar, 12)

    local TitleLabel = CreateLabel(MainFrame,{
        Size = UDim2.new(1, -90, 0, 22),
        Position = UDim2.new(0,10,0,4),
        BackgroundTransparency = 1,
        Text = Info.Title or "Window Title!",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SubTitleLabel = CreateLabel(MainFrame,{
        Size = UDim2.new(1,-90,0,18),
        Position = UDim2.new(0,10,0,23),
        BackgroundTransparency = 1,
        Text = Info.SubTitle or "Hello!",
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(180,180,180),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Content Frame
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1,0,1,-45)
    Content.Position = UDim2.new(0,0,0,45)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Minimize Button
    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.new(0,30,0,30)
    MinButton.Position = UDim2.new(1,-70,0,7)
    MinButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
    MinButton.Text = "–"
    MinButton.TextColor3 = Color3.fromRGB(255,255,255)
    MinButton.TextSize = 20
    MinButton.Font = Enum.Font.GothamBold
    MinButton.Parent = MainFrame
    CreateCorner(MinButton,6)

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0,30,0,30)
    CloseButton.Position = UDim2.new(1,-35,0,7)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = MainFrame
    CreateCorner(CloseButton,6)

    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(0.5, startPos.X.Offset + delta.X, MainFrame.Position.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

    -- Minimize Logic
    local minimized = false
    local function ToggleMinimize()
        minimized = not minimized
        MinButton.Text = minimized and "+" or "–"
        local newSize = minimized and UDim2.new(0,470,0,45) or UDim2.new(0,470,0,350)
        TweenService:Create(MainFrame, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=newSize}):Play()
        Content.Visible = not minimized
    end
    MinButton.MouseButton1Click:Connect(ToggleMinimize)

    -- Notification
    local function Notify(Text)
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Size = UDim2.new(0,200,0,50)
        NotifyFrame.Position = UDim2.new(0.5,-100,0,20)
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Parent = ScreenGui
        CreateCorner(NotifyFrame,8)
        local Label = CreateLabel(NotifyFrame,{
            Size = UDim2.new(1,-10,1,-10),
            Position = UDim2.new(0,5,0,5),
            BackgroundTransparency = 1,
            Text = Text,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.Gotham,
            TextSize = 14
        })
        task.delay(2,function() NotifyFrame:Destroy() end)
    end
    Notify("Window Loaded")

    -- Tabs
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Size = UDim2.new(1,0,0,35)
    TabsContainer.Position = UDim2.new(0,0,0,45)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame

    local TabsScroll = Instance.new("ScrollingFrame")
    TabsScroll.Size = UDim2.new(1,0,1,0)
    TabsScroll.BackgroundTransparency = 1
    TabsScroll.BorderSizePixel = 0
    TabsScroll.CanvasSize = UDim2.new(0,0,0,0)
    TabsScroll.ScrollBarThickness = 0
    TabsScroll.Parent = TabsContainer

    -- Função Tab
    function MainFrame:Tab(Info)
        Info = Info or {}
        local TabName = Info.Name or "Tab"
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0,120,0,30)
        TabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
        TabButton.Text = TabName
        TabButton.TextColor3 = Color3.fromRGB(255,255,255)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Parent = TabsScroll
        CreateCorner(TabButton,6)

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1,0,1,-35)
        TabContent.Position = UDim2.new(0,0,0,35)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = MainFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(MainFrame:GetChildren()) do
                if frame:IsA("Frame") and frame ~= TitleBar and frame ~= TabsContainer then
                    frame.Visible = false
                end
            end
            TabContent.Visible = true
        end)

        return {Button=TabButton, Content=TabContent, Name=TabName}
    end

    -- Função Dialog refinada
    function MainFrame:Dialog(Info)
        Info = Info or {}
        local DialogFrame = Instance.new("Frame")
        DialogFrame.Size = UDim2.new(0,350,0,180)
        DialogFrame.Position = UDim2.new(0.5,0,0.5,0)
        DialogFrame.AnchorPoint = Vector2.new(0.5,0.5)
        DialogFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
        DialogFrame.BorderSizePixel = 0
        DialogFrame.Parent = ScreenGui
        DialogFrame.Visible = false
        CreateCorner(DialogFrame,12)

        local TitleLabel = CreateLabel(DialogFrame,{
            Size = UDim2.new(1,-20,0,30),
            Position = UDim2.new(0,10,0,10),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = Info.Title or "Dialog"
        })

        local SubLabel = CreateLabel(DialogFrame,{
            Size = UDim2.new(1,-20,0,40),
            Position = UDim2.new(0,10,0,40),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(200,200,200),
            TextWrapped = true,
            Text = Info.SubTitle or ""
        })

        local ButtonY = 90
        for _, opt in pairs(Info.Options or {}) do
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0.8,0,0,30)
            Btn.Position = UDim2.new(0.1,0,0,ButtonY)
            Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.Text = opt.Title or "Option"
            Btn.Parent = DialogFrame
            CreateCorner(Btn,6)
            Btn.MouseButton1Click:Connect(function()
                if opt.Callback then opt.Callback() end
                DialogFrame.Visible = false
            end)
            ButtonY += 40
        end

        local DialogObj = {}
        function DialogObj:Show()
            DialogFrame.Visible = true
            DialogFrame.Position = UDim2.new(0.5,0,0.5,-20)
            DialogFrame.Size = UDim2.new(0,0,0,0)
            TweenService:Create(DialogFrame, TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
                Size=UDim2.new(0,350,0,180),
                Position=UDim2.new(0.5,0,0.5,0)
            }):Play()
        end
        function DialogObj:Close()
            TweenService:Create(DialogFrame, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
                Size=UDim2.new(0,0,0,0),
                Position=UDim2.new(0.5,0,0.5,-20)
            }):Play()
            task.delay(0.25,function() DialogFrame.Visible=false end)
        end
        return DialogObj
    end

    -- Close Button Dialog
    CloseButton.MouseButton1Click:Connect(function()
        local Dialog = MainFrame:Dialog({
            Title = TitleLabel.Text,
            SubTitle = "Are you sure you want to close the window?",
            Options = {
                {Title="Confirm", Callback=function() MainFrame:Destroy() end},
                {Title="Cancel", Callback=function() end}
            }
        })
        Dialog:Show()
    end)

    return MainFrame
end

return Lib
