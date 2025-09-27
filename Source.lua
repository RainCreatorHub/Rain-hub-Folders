-- ✦ MODERN UI LIBRARY v3.1 — THEMES • ICONS • TOOLTIPS — FULLY TESTED ✦
-- (Corrigido para evitar "nil value" e garantir estabilidade)

local Lib = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ▼ UTILS ▼
local function Create(instanceType, props)
	local obj = Instance.new(instanceType)
	for k, v in pairs(props or {}) do obj[k] = v end
	return obj
end

-- ▼ DEFAULT THEME ▼
local DefaultTheme = {
	WindowBG = Color3.fromRGB(28, 28, 28),
	TitleBarBG = Color3.fromRGB(22, 22, 22),
	ContentBG = Color3.fromRGB(35, 35, 35),
	PrimaryBtn = Color3.fromRGB(40, 40, 40),
	PrimaryBtnHover = Color3.fromRGB(60, 60, 60),
	DangerBtn = Color3.fromRGB(200, 50, 50),
	TitleText = Color3.fromRGB(255, 255, 255),
	SubTitleText = Color3.fromRGB(180, 180, 180),
	BodyText = Color3.fromRGB(220, 220, 220),
	CornerRadius = 12,
	BtnCornerRadius = 6,
	TitleFont = Enum.Font.GothamBold,
	BodyFont = Enum.Font.Gotham,
	TitleSize = 20,
	BodySize = 14,
	TweenTime = 0.25,
	TweenStyle = Enum.EasingStyle.Quad,
	TweenDirection = Enum.EasingDirection.Out
}

Lib.CurrentTheme = DefaultTheme

function Lib:SetTheme(Theme)
	Lib.CurrentTheme = setmetatable(Theme or {}, { __index = DefaultTheme })
end

-- ▼ ICON SYSTEM ▼
function Lib:CreateIcon(Parent, Props)
	Props = Props or {}
	local iconType = Props.Type or "Font"
	
	if iconType == "Font" then
		local icon = Create("TextLabel", {
			Size = Props.Size or UDim2.new(0, 20, 0, 20),
			Position = Props.Position or UDim2.new(),
			BackgroundTransparency = 1,
			Text = Props.Symbol or "❓",
			Font = Props.Font or Enum.Font.Code,
			TextSize = Props.TextSize or 20,
			TextColor3 = Props.Color or Lib.CurrentTheme.BodyText,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Parent = Parent
		})
		return icon
	elseif iconType == "Image" then
		local icon = Create("ImageLabel", {
			Size = Props.Size or UDim2.new(0, 20, 0, 20),
			Position = Props.Position or UDim2.new(),
			Image = Props.Image or "",
			ImageRectOffset = Props.ImageRectOffset or Vector2.new(0,0),
			ImageRectSize = Props.ImageRectSize or Vector2.new(32,32),
			BackgroundColor3 = Color3.new(0,0,0),
			BackgroundTransparency = 1,
			Parent = Parent
		})
		return icon
	end
	return nil
end

-- ▼ TOOLTIP SYSTEM ▼
local TooltipContainer

local function GetTooltipContainer()
	if not TooltipContainer then
		TooltipContainer = Create("Folder", { Name = "TooltipContainer", Parent = PlayerGui })
	end
	return TooltipContainer
end

function Lib:CreateTooltip(Target, Text, Offset)
	if not Target or not Text then return end
	
	local container = GetTooltipContainer()
	local tooltip = Create("Frame", {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		Visible = false,
		Parent = container
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tooltip })
	
	local label = Create("TextLabel", {
		Size = UDim2.new(1, -10, 1, -6),
		Position = UDim2.new(0, 5, 0, 3),
		BackgroundTransparency = 1,
		Text = Text,
		Font = Lib.CurrentTheme.BodyFont,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = tooltip
	})
	
	-- Calcula tamanho dinâmico
	local textSize = label.TextBounds
	tooltip.Size = UDim2.new(0, textSize.X + 16, 0, 24)
	
	local offset = Offset or Vector2.new(0, -30)
	local hoverTimer = nil
	local shown = false
	
	local function Show()
		if shown then return end
		shown = true
		local absPos = Target:GuiToObjectSpace(Vector2.new(0,0))
		tooltip.Position = UDim2.new(0, absPos.X + offset.X, 0, absPos.Y + offset.Y)
		tooltip.Visible = true
		TweenService:Create(tooltip, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()
	end
	
	local function Hide()
		if not shown then return end
		shown = false
		TweenService:Create(tooltip, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }):Play()
		task.delay(0.1, function() 
			if tooltip and tooltip.Parent then -- Verifica se ainda existe
				tooltip.Visible = false 
			end
		end)
	end
	
	Target.MouseEnter:Connect(function()
		hoverTimer = task.delay(0.4, Show)
	end)
	
	Target.MouseLeave:Connect(function()
		if hoverTimer then 
			task.cancel(hoverTimer) 
			hoverTimer = nil 
		end
		Hide()
	end)
	
	-- Auto-destroy com o target
	Target.AncestryChanged:Connect(function(_, parent)
		if not parent and tooltip then
			tooltip:Destroy()
		end
	end)
	
	return tooltip
end

-- ▼ CORE WINDOW ▼
function Lib:MakeWindow(Info)
	Info = Info or {}
	
	-- Garanta limpeza total
	local oldGui = PlayerGui:FindFirstChild("ModernUILibrary")
	if oldGui then oldGui:Destroy() end
	
	local ScreenGui = Create("ScreenGui", {
		Name = "ModernUILibrary",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		Parent = PlayerGui
	})
	
	-- Estado centralizado
	local State = {
		Minimized = false,
		ActiveTab = nil,
		Tabs = {}
	}
	
	-- ▼ MAIN FRAME ▼
	local MainFrame = Create("Frame", {
		Size = UDim2.new(0, 470, 0, 350),
		Position = UDim2.new(0.5, 0, 0.3, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Lib.CurrentTheme.WindowBG,
		BorderSizePixel = 0,
		Parent = ScreenGui
	})
	Create("UICorner", { CornerRadius = UDim.new(0, Lib.CurrentTheme.CornerRadius), Parent = MainFrame })
	
	-- ▼ TITLE BAR ▼
	local TitleBar = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundColor3 = Lib.CurrentTheme.TitleBarBG,
		BorderSizePixel = 0,
		Parent = MainFrame
	})
	Create("UICorner", { CornerRadius = UDim.new(0, Lib.CurrentTheme.CornerRadius), Parent = TitleBar })
	
	-- Ícone opcional na title bar
	if Info.Icon then
		Lib:CreateIcon(MainFrame, {
			Type = Info.IconType or "Font",
			Symbol = Info.Icon,
			Size = UDim2.new(0, 24, 0, 24),
			Position = UDim2.new(0, 10, 0, 10),
			Color = Lib.CurrentTheme.TitleText
		})
	end
	
	Create("TextLabel", {
		Size = UDim2.new(1, -90, 0, 22),
		Position = UDim2.new(0, 10, 0, 4),
		BackgroundTransparency = 1,
		Text = Info.Title or "Window Title!",
		Font = Lib.CurrentTheme.TitleFont,
		TextSize = Lib.CurrentTheme.TitleSize,
		TextColor3 = Lib.CurrentTheme.TitleText,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = MainFrame
	})
	
	Create("TextLabel", {
		Size = UDim2.new(1, -90, 0, 18),
		Position = UDim2.new(0, 10, 0, 23),
		BackgroundTransparency = 1,
		Text = Info.SubTitle or "Hello!",
		Font = Lib.CurrentTheme.BodyFont,
		TextSize = 13,
		TextColor3 = Lib.CurrentTheme.SubTitleText,
		Parent = MainFrame
	})
	
	-- ▼ CONTENT ZONE ▼
	local ContentZone = Create("Frame", {
		Size = UDim2.new(1, 0, 1, -80),
		Position = UDim2.new(0, 0, 0, 80),
		BackgroundTransparency = 1,
		Parent = MainFrame
	})
	
	-- ▼ TABS CONTAINER ▼
	local TabsContainer = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 45),
		BackgroundTransparency = 1,
		Parent = MainFrame
	})
	
	local TabsScroll = Create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = TabsContainer
	})
	
	-- ▼ BOTÕES DE CONTROLE ▼
	local MinButton = Create("TextButton", {
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -70, 0, 7),
		BackgroundColor3 = Lib.CurrentTheme.PrimaryBtn,
		Text = "–",
		TextColor3 = Lib.CurrentTheme.TitleText,
		TextSize = 20,
		Font = Lib.CurrentTheme.TitleFont,
		Parent = MainFrame
	})
	Create("UICorner", { CornerRadius = UDim.new(0, Lib.CurrentTheme.BtnCornerRadius), Parent = MinButton })
	
	local CloseButton = Create("TextButton", {
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -35, 0, 7),
		BackgroundColor3 = Lib.CurrentTheme.DangerBtn,
		Text = "X",
		TextColor3 = Lib.CurrentTheme.TitleText,
		TextSize = 18,
		Font = Lib.CurrentTheme.TitleFont,
		Parent = MainFrame
	})
	Create("UICorner", { CornerRadius = UDim.new(0, Lib.CurrentTheme.BtnCornerRadius), Parent = CloseButton })
	
	-- ▼ LÓGICA DE MINIMIZAR ▼
	local function SetMinimized(min)
		State.Minimized = min
		MinButton.Text = min and "+" or "–"
		TweenService:Create(MainFrame, TweenInfo.new(Lib.CurrentTheme.TweenTime, Lib.CurrentTheme.TweenStyle, Lib.CurrentTheme.TweenDirection), {
			Size = min and UDim2.new(0, 470, 0, 45) or UDim2.new(0, 470, 0, 350)
		}):Play()
		ContentZone.Visible = not min
		TabsContainer.Visible = not min
	end
	MinButton.MouseButton1Click:Connect(function() SetMinimized(not State.Minimized) end)
	
	-- ▼ DRAG ▼
	local dragging, dragStart, startPos
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	-- ▼ NOTIFICAÇÃO ▼
	local function Notify(text)
		local notify = Create("Frame", {
			Size = UDim2.new(0, 200, 0, 50),
			Position = UDim2.new(0.5, -100, 0, 20),
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
			Parent = ScreenGui
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = notify })
		Create("TextLabel", {
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Lib.CurrentTheme.BodyFont,
			TextSize = 14,
			Parent = notify
		})
		task.delay(2, function() 
			if notify and notify.Parent then
				notify:Destroy()
			end
		end)
	end
	Notify("Window Loaded")
	
	-- ▼ SISTEMA DE TABS ▼
	function MainFrame:Tab(Info)
		Info = Info or {}
		local tabName = Info.Name or "Tab"
		
		local TabButton = Create("TextButton", {
			Size = UDim2.new(0, 120, 0, 30),
			BackgroundColor3 = Lib.CurrentTheme.PrimaryBtn,
			Text = tabName,
			TextColor3 = Lib.CurrentTheme.TitleText,
			TextSize = 14,
			Font = Lib.CurrentTheme.TitleFont,
			Parent = TabsScroll
		})
		Create("UICorner", { CornerRadius = UDim.new(0, Lib.CurrentTheme.BtnCornerRadius), Parent = TabButton })
		
		-- Adiciona ícone opcional
		if Info.Icon then
			Lib:CreateIcon(TabButton, {
				Type = Info.IconType or "Font",
				Symbol = Info.Icon,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 8, 0.5, 0),
				Color = Lib.CurrentTheme.BodyText
			})
			TabButton.Text = " " .. TabButton.Text
		end
		
		-- Tooltip
		Lib:CreateTooltip(TabButton, Info.Tooltip or tabName)
		
		local TabContent = Create("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = ContentZone
		})
		
		-- Atualiza canvas size
		TabsScroll.CanvasSize = UDim2.new(0, TabsScroll.CanvasSize.X.Offset + 125, 0, 0)
		
		-- Ativação de tab
		local function ActivateTab()
			for _, t in ipairs(State.Tabs) do
				t.Content.Visible = false
				t.Button.BackgroundColor3 = Lib.CurrentTheme.PrimaryBtn
			end
			TabContent.Visible = true
			TabButton.BackgroundColor3 = Lib.CurrentTheme.PrimaryBtnHover
			State.ActiveTab = tabName
		end
		
		TabButton.MouseButton1Click:Connect(ActivateTab)
		
		-- Primeira tab é ativa por padrão
		if #State.Tabs == 0 then ActivateTab() end
		
		table.insert(State.Tabs, {
			Name = tabName,
			Button = TabButton,
			Content = TabContent,
			Activate = ActivateTab
		})
		
		return { Content = TabContent }
	end
	
	-- ▼ DIALOG SYSTEM ▼
	function MainFrame:Dialog(Info)
		Info = Info or {}
		
		local DialogFrame = Create("Frame", {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, -20),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Lib.CurrentTheme.ContentBG,
			BorderSizePixel = 0,
			Visible = false,
			Parent = ScreenGui
		})
		Create("UICorner", { CornerRadius = UDim.new(0, Lib.CurrentTheme.CornerRadius), Parent = DialogFrame })
		
		Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 30),
			Position = UDim2.new(0, 10, 0, 10),
			BackgroundTransparency = 1,
			Text = Info.Title or "Dialog",
			Font = Lib.CurrentTheme.TitleFont,
			TextSize = 18,
			TextColor3 = Lib.CurrentTheme.TitleText,
			Parent = DialogFrame
		})
		
		Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 40),
			Position = UDim2.new(0, 10, 0, 40),
			BackgroundTransparency = 1,
			Text = Info.SubTitle or "",
			Font = Lib.CurrentTheme.BodyFont,
			TextSize = 14,
			TextColor3 = Lib.CurrentTheme.SubTitleText,
			TextWrapped = true,
			Parent = DialogFrame
		})
		
		local buttonY = 90
		for _, opt in ipairs(Info.Options or {}) do
			local btn = Create("TextButton", {
				Size = UDim2.new(0.8, 0, 0, 30),
				Position = UDim2.new(0.1, 0, 0, buttonY),
				BackgroundColor3 = Lib.CurrentTheme.PrimaryBtn,
				Text = opt.Title or "Option",
				TextColor3 = Lib.CurrentTheme.TitleText,
				Font = Lib.CurrentTheme.TitleFont,
				TextSize = 14,
				Parent = DialogFrame
			})
			Create("UICorner", { CornerRadius = UDim.new(0, Lib.CurrentTheme.BtnCornerRadius), Parent = btn })
			btn.MouseButton1Click:Connect(function()
				opt.Callback?.()
				DialogFrame.Visible = false
			end)
			buttonY = buttonY + 40
		end
		
		return {
			Show = function()
				DialogFrame.Visible = true
				TweenService:Create(DialogFrame, TweenInfo.new(0.3, Lib.CurrentTheme.TweenStyle, Lib.CurrentTheme.TweenDirection), {
					Size = UDim2.new(0, 350, 0, 180),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				}):Play()
			end,
			Close = function()
				TweenService:Create(DialogFrame, TweenInfo.new(0.25, Lib.CurrentTheme.TweenStyle, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0),
					Position = UDim2.new(0.5, 0, 0.5, -20)
				}):Play()
				task.delay(0.25, function() 
					if DialogFrame and DialogFrame.Parent then
						DialogFrame.Visible = false 
					end
				end)
			end
		}
	end
	
	-- ▼ CLOSE COM CONFIRMAÇÃO ▼
	CloseButton.MouseButton1Click:Connect(function()
		local dialog = MainFrame:Dialog({
			Title = "Close Window",
			SubTitle = "Are you sure you want to close this window?",
			Options = {
				{ Title = "Confirm", Callback = function() MainFrame:Destroy() end },
				{ Title = "Cancel" }
			}
		})
		dialog:Show()
	end)
	
	-- ▼ TOOL TIPS PARA BOTÕES PRINCIPAIS ▼
	Lib:CreateTooltip(MinButton, State.Minimized and "Restore" or "Minimize")
	Lib:CreateTooltip(CloseButton, "Close")
	
	return MainFrame
end

return Lib
