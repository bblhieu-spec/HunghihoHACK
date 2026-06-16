-- ==========================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedButton = Instance.new("TextButton")
local JumpButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

-- Cấu hình Giao diện chính (Menu)
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "HungHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể giữ chuột để kéo menu di chuyển

-- Dòng chữ Bản Quyền (Tiêu đề Menu)
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(0, 250, 0, 40)
Title.Text = "Ngô Ngọc Hùng Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextSize = 18
Title.TextFont = Enum.Font.SourceSansBold

-- CHỨC NĂNG 1: TĂNG TỐC ĐỘ CHẠY (SPEED)
SpeedButton.Parent = MainFrame
SpeedButton.Position = UDim2.new(0, 25, 0, 60)
SpeedButton.Size = UDim2.new(0, 200, 0, 35)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SpeedButton.Text = "Bật Tốc Độ Nhanh (Speed)"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 16

local speedToggle = false
SpeedButton.MouseButton1Click:Connect(function()
    speedToggle = not speedToggle
    if speedToggle then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100 -- Chỉnh tốc độ chạy
        SpeedButton.Text = "Tốc Độ: Đang Bật"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Trở về bình thường
        SpeedButton.Text = "Bật Tốc Độ Nhanh (Speed)"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

-- CHỨC NĂNG 2: NHẢY CAO (JUMP)
JumpButton.Parent = MainFrame
JumpButton.Position = UDim2.new(0, 25, 0, 110)
JumpButton.Size = UDim2.new(0, 200, 0, 35)
JumpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
JumpButton.Text = "Bật Nhảy Cao (Jump)"
JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpButton.TextSize = 16

local jumpToggle = false
JumpButton.MouseButton1Click:Connect(function()
    jumpToggle = not jumpToggle
    if jumpToggle then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150 -- Chỉnh sức nhảy
        JumpButton.Text = "Nhảy Cao: Đang Bật"
        JumpButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50 -- Trở về bình thường
        JumpButton.Text = "Bật Nhảy Cao (Jump)"
        JumpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

-- NÚT ĐÓNG MENU (Tắt hẳn menu đi)
CloseButton.Parent = MainFrame
CloseButton.Position = UDim2.new(0, 25, 0, 160)
CloseButton.Size = UDim2.new(0, 200, 0, 30)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CloseButton.Text = "Đóng Menu"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy() -- Xóa hoàn toàn menu khỏi màn hình
end)

-- Thông báo nhỏ góc màn hình khi bật script
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Ngô Ngọc Hùng",
    Text = "Menu đã sẵn sàng!",
    Duration = 5
})
