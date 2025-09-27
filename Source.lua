-- ✦ MODERN UI LIBRARY v2 — ARQUITETURA DE ESTADO IMUTÁVEL + COMPONENTES ISOLADOS ✦
local Lib = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ▼ UTILS ▼
local function Create(instanceType, props)
	local obj = Instance.new(instanceType)
	for k, v in pairs(props) do obj[k] = v end
	return obj
end

-- ▼ CORE WINDOW ▼
function Lib:MakeWindow(Info)
	Info = Info or {}
	
	-- Garanta limpeza total
	PlayerGui:FindFirstChild("ModernUILibrary")?.Destroy()
	
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
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		BorderSizePixel = 0,
		Parent = ScreenGui
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = MainFrame })
	
	-- ▼ TITLE BAR ▼
	local TitleBar = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderSizePixel = 0,
		Parent = MainFrame
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = TitleBar })
	
	Create("TextLabel", {
		Size = UDim2.new(1, -90, 0, 22),
		Position = UDim2.new(0, 10, 0, 4),
		BackgroundTransparency = 1,
		Text = Info.Title or "Window Title!",
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = MainFrame
	})
	
	Create("TextLabel", {
		Size = UDim2.new(1, -90, 0, 18),
		Position = UDim2.new(0, 10, 0, 23),
		BackgroundTransparency = 1,
		Text = Info.SubTitle or "Hello!",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		Parent = MainFrame
	})
	
	-- ▼ CONTENT ZONE ▼
	local ContentZone = Create("Frame", {
		Size = UDim2.new(1, 0, 1, -80), -- Ajustado: 45 (title) + 35 (tabs)
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
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Text = "–",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		Parent = MainFrame
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinButton })
	
	local CloseButton = Create("TextButton", {
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -35, 0, 7),
		BackgroundColor3 = Color3.fromRGB(200, 50, 50),
		Text = "X",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		Parent = MainFrame
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseButton })
	
	-- ▼ LÓGICA DE MINIMIZAR ▼
	local function SetMinimized(min)
		State.Minimized = min
		MinButton.Text = min and "+" or "–"
		TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
			Font = Enum.Font.Gotham,
			TextSize = 14,
			Parent = notify
		})
		task.delay(2, notify.Destroy, notify)
	end
	Notify("Window Loaded")
	
	-- ▼ SISTEMA DE TABS (COM ESTADO) ▼
	function MainFrame:Tab(Info)
		Info = Info or {}
		local tabName = Info.Name or "Tab"
		
		local TabButton = Create("TextButton", {
			Size = UDim2.new(0, 120, 0, 30),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			Text = tabName,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			Parent = TabsScroll
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabButton })
		
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
				t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			end
			TabContent.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
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
	
	-- ▼ DIALOG SYSTEM (REUSÁVEL) ▼
	function MainFrame:Dialog(Info)
		Info = Info or {}
		
		local DialogFrame = Create("Frame", {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, -20),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			BorderSizePixel = 0,
			Visible = false,
			Parent = ScreenGui
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = DialogFrame })
		
		Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 30),
			Position = UDim2.new(0, 10, 0, 10),
			BackgroundTransparency = 1,
			Text = Info.Title or "Dialog",
			Font = Enum.Font.GothamBold,
			TextSize = 18,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Parent = DialogFrame
		})
		
		Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 40),
			Position = UDim2.new(0, 10, 0, 40),
			BackgroundTransparency = 1,
			Text = Info.SubTitle or "",
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextWrapped = true,
			Parent = DialogFrame
		})
		
		local buttonY = 90
		for _, opt in ipairs(Info.Options or {}) do
			local btn = Create("TextButton", {
				Size = UDim2.new(0.8, 0, 0, 30),
				Position = UDim2.new(0.1, 0, 0, buttonY),
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				Text = opt.Title or "Option",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.GothamBold,
				TextSize = 14,
				Parent = DialogFrame
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
			btn.MouseButton1Click:Connect(function()
				opt.Callback?.()
				DialogFrame.Visible = false
			end)
			buttonY += 40
		end
		
		return {
			Show = function()
				DialogFrame.Visible = true
				TweenService:Create(DialogFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 350, 0, 180),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				}):Play()
			end,
			Close = function()
				TweenService:Create(DialogFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0),
					Position = UDim2.new(0.5, 0, 0.5, -20)
				}):Play()
				task.delay(0.25, function() DialogFrame.Visible = false end)
			end
		}
	end
	
	-- ▼ CLOSE COM CONFIRMAÇÃO ▼
	CloseButton.MouseButton1Click:Connect(function()
		MainFrame:Dialog({
			Title = "Close Window",
			SubTitle = "Are you sure you want to close this window?",
			Options = {
				{ Title = "Confirm", Callback = function() MainFrame:Destroy() end },
				{ Title = "Cancel" }
			}
		}):Show()
	end)
	
	return MainFrame
end

return Lib
