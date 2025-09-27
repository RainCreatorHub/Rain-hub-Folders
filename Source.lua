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
    TitleLabel.Parent = MainFrame  -- Fixo

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
    SubTitleLabel.Parent = MainFrame

    -- Content
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 1, -45)
    Content.Position = UDim2.new(0, 0, 0, 45)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Minimize button
    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.new(0, 30, 0, 30)
    MinButton.Position = UDim2.new(1, -70, 0, 7)
    MinButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MinButton.Text = "–"
    MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinButton.TextSize = 20
    MinButton.Font = Enum.Font.GothamBold
    MinButton.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = MinButton

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 7)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = MainFrame

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    -- Minimizar função
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

    -- Drag
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

    -- Função de criar diálogo
    local function CreateDialog()
        local Dialog = Instance.new("Frame")
        Dialog.Size = UDim2.new(0, 300, 0, 150)
        Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
        Dialog.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Dialog.BorderSizePixel = 0
        Dialog.AnchorPoint = Vector2.new(0.5, 0.5)
        Dialog.Parent = ScreenGui

        local DialogCorner = Instance.new("UICorner")
        DialogCorner.CornerRadius = UDim.new(0, 12)
        DialogCorner.Parent = Dialog

        local DialogTitle = Instance.new("TextLabel")
        DialogTitle.Size = UDim2.new(1, -20, 0, 30)
        DialogTitle.Position = UDim2.new(0, 10, 0, 10)
        DialogTitle.BackgroundTransparency = 1
        DialogTitle.Text = (Info.Title or "Window") .. " Info"
        DialogTitle.Font = Enum.Font.GothamBold
        DialogTitle.TextSize = 18
        DialogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        DialogTitle.Parent = Dialog

        local DialogSub = Instance.new("TextLabel")
        DialogSub.Size = UDim2.new(1, -20, 0, 40)
        DialogSub.Position = UDim2.new(0, 10, 0, 50)
        DialogSub.BackgroundTransparency = 1
        DialogSub.Text = "Are you sure you want to close the window?"
        DialogSub.Font = Enum.Font.Gotham
        DialogSub.TextSize = 14
        DialogSub.TextColor3 = Color3.fromRGB(200, 200, 200)
        DialogSub.TextWrapped = true
        DialogSub.Parent = Dialog

        local Confirm = Instance.new("TextButton")
        Confirm.Size = UDim2.new(0.4, 0, 0, 30)
        Confirm.Position = UDim2.new(0.05, 0, 1, -40)
        Confirm.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        Confirm.Text = "Confirm"
        Confirm.TextColor3 = Color3.fromRGB(255, 255, 255)
        Confirm.Font = Enum.Font.GothamBold
        Confirm.TextSize = 14
        Confirm.Parent = Dialog

        local Cancel = Instance.new("TextButton")
        Cancel.Size = UDim2.new(0.4, 0, 0, 30)
        Cancel.Position = UDim2.new(0.55, 0, 1, -40)
        Cancel.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        Cancel.Text = "Cancel"
        Cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
        Cancel.Font = Enum.Font.GothamBold
        Cancel.TextSize = 14
        Cancel.Parent = Dialog

        Confirm.MouseButton1Click:Connect(function()
            if not minimized then ToggleMinimize() end
            task.delay(0.3, function()
                local goal = {Size = UDim2.new(0, 0, 0, TitleBar.Size.Y.Offset)}
                TweenService:Create(TitleBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
                task.delay(0.4, function()
                    ScreenGui:Destroy()
                end)
            end)
        end)

        Cancel.MouseButton1Click:Connect(function()
            Dialog:Destroy()
        end)
    end

    CloseButton.MouseButton1Click:Connect(CreateDialog)

    -- Notify
    local Notify = Instance.new("TextLabel")
    Notify.Size = UDim2.new(0, 200, 0, 50)
    Notify.Position = UDim2.new(0.5, -100, 0.2, 0)
    Notify.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Notify.BorderSizePixel = 0
    Notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notify.Font = Enum.Font.GothamBold
    Notify.TextSize = 16
    Notify.Text = "UI Library Carregada"
    Notify.AnchorPoint = Vector2.new(0.5, 0.5)
    Notify.Parent = ScreenGui

    local NotifyCorner = Instance.new("UICorner")
    NotifyCorner.CornerRadius = UDim.new(0, 10)
    NotifyCorner.Parent = Notify

    task.delay(1.5, function() Notify:Destroy() end)

    return {
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        Content = Content,
        MinButton = MinButton,
        CloseButton = CloseButton
    }
end

return Lib
