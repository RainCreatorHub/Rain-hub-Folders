local Lib = {}

function Lib:MakeWindow(Info)
    Info = Info or {}

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- Remove antiga GUI da lib
    local oldGui = PlayerGui:FindFirstChild("ModernUILibrary")
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = PlayerGui

    -- Main window
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 470, 0, 350)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- TitleBar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -90, 0, 22)
    TitleLabel.Position = UDim2.new(0, 10, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Info.Title or "Window Title!"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- SubTitle
    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Size = UDim2.new(1, -90, 0, 18)
    SubTitleLabel.Position = UDim2.new(0, 10, 0, 23)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = Info.SubTitle or "Hello!"
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.TextSize = 13
    SubTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleBar

    -- Content
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 1, -45)
    Content.Position = UDim2.new(0, 0, 0, 45)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Minimize button
    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.new(0, 30, 0, 30)
    MinButton.Position = UDim2.new(1, -70, 0.5, -15)
    MinButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MinButton.Text = "–"
    MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinButton.TextSize = 20
    MinButton.Font = Enum.Font.GothamBold
    MinButton.Parent = TitleBar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = MinButton

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    local minimized = false
    local function ToggleMinimize()
        minimized = not minimized
        MinButton.Text = minimized and "+" or "–"
        local newSize = minimized and UDim2.new(0, 470, 0, 45) or UDim2.new(0, 470, 0, 350)
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = newSize
        }):Play()
        Content.Visible = not minimized
    end

    MinButton.MouseButton1Click:Connect(ToggleMinimize)

    CloseButton.MouseButton1Click:Connect(function()
        -- Minimiza antes de animar TitleBar
        if not minimized then ToggleMinimize() end
        task.delay(0.3, function()
            -- Anima TitleBar encolhendo da direita para a esquerda
            local goal = {Size = UDim2.new(0, 0, 0, 45)}
            TweenService:Create(TitleBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
            task.delay(0.4, function()
                ScreenGui:Destroy()
            end)
        end)
    end)

    -- Dragging TitleBar
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            0.5, startPos.X.Offset + delta.X,
            MainFrame.Position.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    TitleBar.InputBegan:Connect(function(input)
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

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Notify
    local Notify = Instance.new("TextLabel")
    Notify.Size = UDim2.new(0, 200, 0, 50)
    Notify.Position = UDim2.new(0.5, -100, 0.2, 0)
    Notify.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Notify.BorderSizePixel = 0
    Notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notify.Font = Enum.Font.GothamBold
    Notify.TextSize = 16
    Notify.Text = "UI Library Carregada!"
    Notify.AnchorPoint = Vector2.new(0.5, 0.5)
    Notify.Parent = ScreenGui

    local NotifyCorner = Instance.new("UICorner")
    NotifyCorner.CornerRadius = UDim.new(0, 10)
    NotifyCorner.Parent = Notify

    TweenService:Create(Notify, TweenInfo.new(0.25), {BackgroundTransparency = 0.1}):Play()
    task.delay(1.5, function()
        TweenService:Create(Notify, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        task.delay(0.25, function() Notify:Destroy() end)
    end)

    return {
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        Content = Content,
        MinButton = MinButton,
        CloseButton = CloseButton
    }
end

return Lib
