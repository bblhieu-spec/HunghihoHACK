-- ==========================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")
local FarmToggle = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")
local JumpButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

-- Giao diện chính (Căn chỉnh chuẩn cho điện thoại)
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "HungHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100) -- Căn chính giữa màn hình
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

-- Tiêu đề Menu Bản Quyền
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Ngô Ngọc Hùng Hub"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 18
Title.TextFont = Enum.Font.SourceSansBold

-- Tự động sắp xếp các nút bấm thẳng hàng, không sợ bị lệch vị trí
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- CHỨC NĂNG 1: AUTO FARM BLOX FRUITS (Tự gom quái và đánh)
FarmToggle.Parent = MainFrame
FarmToggle.Size = UDim2.new(1, 0, 0, 35)
FarmToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
FarmToggle.Text = "Auto Farm: ĐANG TẮT"
FarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmToggle.TextSize = 15

local _G = getgenv and getgenv() or _G
_G.AutoFarm = false

FarmToggle.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        FarmToggle.Text = "Auto Farm: ĐANG BẬT"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        FarmToggle.Text = "Auto Farm: ĐANG TẮT"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)

-- Vòng lặp Auto Farm (Tìm quái gần nhất, gom lại và tự đánh)
spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                local player = game.Players.LocalPlayer
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        -- Gom quái lại một chỗ
                        v.HumanoidRootPart.CanCollide = false
                        v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                        
                        -- Di chuyển nhân vật đến chỗ quái
                        repeat
                            wait()
                            player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            
                            -- Tự động kích hoạt công cụ (Kiếm/Trái ác quỷ) đang cầm để đánh
                            local tool = player.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        until not _G.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

-- CHỨC NĂNG 2: TĂNG TỐC ĐỘ CHẠY (SPEED)
SpeedButton.Parent = MainFrame
SpeedButton.Size = UDim2.new(1, 0, 0, 35)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SpeedButton.Text = "Tốc Độ: Bình Thường"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local speedToggle = false
SpeedButton.MouseButton1Click:Connect(function()
    speedToggle = not speedToggle
    if speedToggle then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 90
        SpeedButton.Text = "Tốc Độ: Siêu Nhanh"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        SpeedButton.Text = "Tốc Độ: Bình Thường"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

-- CHỨC NĂNG 3: NHẢY CAO (JUMP)
JumpButton.Parent = MainFrame
JumpButton.Size = UDim2.new(1, 0, 0, 35)
JumpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
JumpButton.Text = "Nhảy Cao: Bình Thường"
JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local jumpToggle = false
JumpButton.MouseButton1Click:Connect(function()
    jumpToggle = not jumpToggle
    if jumpToggle then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
        JumpButton.Text = "Nhảy Cao: Siêu Cao"
        JumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        JumpButton.Text = "Nhảy Cao: Bình Thường"
        JumpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

-- NÚT ĐÓNG MENU
CloseButton.Parent = MainFrame
CloseButton.Size = UDim2.new(1, 0, 0, 35)
CloseButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
CloseButton.Text = "Đóng Menu (Tắt)"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

CloseButton.MouseButton1Click:Connect(function()
    _G.AutoFarm = false
    ScreenGui:Destroy()
end)
