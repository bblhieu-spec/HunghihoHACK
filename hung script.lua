-- ==========================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG
-- ==========================================

-- Xóa menu cũ nếu có để tránh trùng lặp
if game.CoreGui:FindFirstChild("HungHubScreen") then
    game.CoreGui.HungHubScreen:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HungHubScreen"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Khung Menu Chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -90)
MainFrame.Size = UDim2.new(0, 220, 0, 190) -- Thu nhỏ lại cho vừa màn hình dọc/ngang
MainFrame.Active = true
MainFrame.Draggable = true

-- Tiêu đề chữ tên bạn (Nằm cố định ở đỉnh menu)
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Ngô Ngọc Hùng Hub"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 16
Title.TextFont = Enum.Font.SourceSansBold

-- NÚT 1: AUTO FARM (Đặt vị trí chính xác bằng tỷ lệ %, không sợ lệch)
local FarmButton = Instance.new("TextButton")
FarmButton.Parent = MainFrame
FarmButton.Position = UDim2.new(0.05, 0, 0.25, 0)
FarmButton.Size = UDim2.new(0.9, 0, 0.18, 0)
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
FarmButton.Text = "Auto Farm: ĐANG TẮT"
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 14
FarmButton.TextFont = Enum.Font.SourceSans

local _G = getgenv and getgenv() or _G
_G.AutoFarm = false

FarmButton.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        FarmButton.Text = "Auto Farm: ĐANG BẬT"
        FarmButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        FarmButton.Text = "Auto Farm: ĐANG TẮT"
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)

-- Vòng lặp Gom quái và Tự đánh (Blox Fruits)
spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                local player = game.Players.LocalPlayer
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.CanCollide = false
                        v.HumanoidRootPart.Size = Vector3.new(40, 40, 40)
                        repeat
                            wait()
                            player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            local tool = player.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        until not _G.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

-- NÚT 2: TỐC ĐỘ (SPEED)
local SpeedButton = Instance.new("TextButton")
SpeedButton.Parent = MainFrame
SpeedButton.Position = UDim2.new(0.05, 0, 0.48, 0)
SpeedButton.Size = UDim2.new(0.9, 0, 0.18, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SpeedButton.Text = "Bật Tốc Độ Nhanh"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 14

local spdToggle = false
SpeedButton.MouseButton1Click:Connect(function()
    spdToggle = not spdToggle
    if spdToggle then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 90
        SpeedButton.Text = "Tốc Độ: Siêu Nhanh"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        SpeedButton.Text = "Bật Tốc Độ Nhanh"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

-- NÚT 3: ĐÓNG MENU (Xóa hẳn giao diện)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = MainFrame
CloseButton.Position = UDim2.new(0.05, 0, 0.72, 0)
CloseButton.Size = UDim2.new(0.9, 0, 0.18, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CloseButton.Text = "Tắt/Đóng Menu"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

CloseButton.MouseButton1Click:Connect(function()
    _G.AutoFarm = false
    ScreenGui:Destroy()
end)
