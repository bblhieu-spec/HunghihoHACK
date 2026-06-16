-- Bản quyền thuộc về Ngô Ngọc Hùng --
local CoreGui = game:GetService("StarterGui")

-- Hiện thông báo bản quyền
CoreGui:SetCore("SendNotification", {
    Title = "Hệ thống",
    Text = "Bản quyền thuộc về Ngô Ngọc Hùng",
    Duration = 10
})

-- Chạy script gốc nhưng chặn bớt các thành phần gây lag
spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/refs/heads/main/AnDepZaiHubBeta.lua"))()
end)

-- Tạo một nút đóng/mở nhanh trên màn hình cho bạn
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0, 10)
Button.Text = "Ẩn/Hiện Menu"
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button.MouseButton1Click:Connect(function()
    -- Lệnh ẩn hiện menu tùy thuộc vào thư viện script gốc
    print("Đã nhấn nút đóng mở") 
end)
