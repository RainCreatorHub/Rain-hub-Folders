local Lib = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

function Lib:MakeWindow(Info)
    Info = Info or {}

    -- Remove antiga GUI
    local oldGui = PlayerGui:FindFirstChild("ModernUILibrary")
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = PlayerGui

    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 470, 0, 350)
    MainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0)
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

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -90, 0, 22)
    TitleLabel.Position = UDim2.new(0, 10, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Info.Title or "Window Title!"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = MainFrame

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

    -- Content Frame
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

    -- Minimize logic
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

    -- Drag logic
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

    -- Notification ao carregar
    local function Notify(Text)
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Size = UDim2.new(0, 200, 0, 50)
        NotifyFrame.Position = UDim2.new(0.5, -100, 0, 20)
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = NotifyFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 1, -10)
        Label.Position = UDim2.new(0, 5, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = Text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Parent = NotifyFrame

        task.delay(2, function()
            NotifyFrame:Destroy()
        end)
    end
    Notify("Window Loaded")

    -- Tabs
    MainFrame.TabsContainer = Instance.new("Frame")
    MainFrame.TabsContainer.Size = UDim2.new(1, 0, 0, 35)
    MainFrame.TabsContainer.Position = UDim2.new(0, 0, 0, 45)
    MainFrame.TabsContainer.BackgroundTransparency = 1
    MainFrame.TabsContainer.Parent = MainFrame

    MainFrame.TabsScroll = Instance.new("ScrollingFrame")
    MainFrame.TabsScroll.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.TabsScroll.BackgroundTransparency = 1
    MainFrame.TabsScroll.BorderSizePixel = 0
    MainFrame.TabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    MainFrame.TabsScroll.ScrollBarThickness = 0
    MainFrame.TabsScroll.Parent = MainFrame.TabsContainer

    -- Função para criar Tab
    function MainFrame:Tab(Info)
        Info = Info or {}
        local TabName = Info.Name or "Tab"

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 120, 0, 30)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.Text = TabName
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Parent = self.TabsScroll

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = TabButton

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, -35)
        TabContent.Position = UDim2.new(0, 0, 0, 35)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = self

        TabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(self:GetChildren()) do
                if frame:IsA("Frame") and frame ~= TitleBar and frame ~= self.TabsContainer then
                    frame.Visible = false
                end
            end
            TabContent.Visible = true
        end)

        return {
            Button = TabButton,
            Content = TabContent,
            Name = TabName
        }
    end

    -- Função Dialog
    function MainFrame:Dialog(Info)
        Info = Info or {}
        local Options = Info.Options or {}

        local DialogFrame = Instance.new("Frame")
        DialogFrame.Size = UDim2.new(0, 350, 0, 180)
        DialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        DialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        DialogFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        DialogFrame.BorderSizePixel = 0
        DialogFrame.Parent = ScreenGui
        DialogFrame.Visible = false

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = DialogFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -20, 0, 30)
        TitleLabel.Position = UDim2.new(0, 10, 0, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 18
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Text = Info.Title or "Dialog"
        TitleLabel.Parent = DialogFrame

        local SubTitleLabel = Instance.new("TextLabel")
        SubTitleLabel.Size = UDim2.new(1, -20, 0, 40)
        SubTitleLabel.Position = UDim2.new(0, 10, 0, 40)
        SubTitleLabel.BackgroundTransparency = 1
        SubTitleLabel.Font = Enum.Font.Gotham
        SubTitleLabel.TextSize = 14
        SubTitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        SubTitleLabel.TextWrapped = true
        SubTitleLabel.Text = Info.SubTitle or ""
        SubTitleLabel.Parent = DialogFrame

        local ButtonY = 90
        for _, opt in pairs(Options) do
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0.8, 0, 0, 30)
            Btn.Position = UDim2.new(0.1, 0, 0, ButtonY)
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.Text = opt.Title or "Option"
            Btn.Parent = DialogFrame

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                if opt.Callback then opt.Callback() end
                DialogFrame.Visible = false
            end)

            ButtonY = ButtonY + 40
        end

        local DialogObj = {}
        function DialogObj:Show()
            DialogFrame.Visible = true
            DialogFrame.Position = UDim2.new(0.5, 0, 0.5, -20)
            DialogFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(DialogFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 350, 0, 180),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
        end
        function DialogObj:Close()
            TweenService:Create(DialogFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, -20)
            }):Play()
            task.delay(0.25, function() DialogFrame.Visible = false end)
        end

        return DialogObj
    end

    -- Close logic com Dialog
    CloseButton.MouseButton1Click:Connect(function()
        local Dialog = MainFrame:Dialog({
            Title = TitleLabel.Text,
            SubTitle = "Are you sure you want to close the window?",
            Options = {
                Op1 = {Title = "Confirm", Callback = function() MainFrame:Destroy() end},
                Op2 = {Title = "Cancel", Callback = function() end}
            }
        })
        Dialog:Show()
    end)

    return MainFrame
end

return Lib
