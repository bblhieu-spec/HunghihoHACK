-- ==========================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG
-- ==========================================

-- Tải thư viện giao diện Orion Lib chuẩn
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo cửa sổ Menu chính
local Window = OrionLib:MakeWindow({
    Name = "Ngô Ngọc Hùng Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "OrionTest"
})

-- Tạo một Tab chức năng
local Tab1 = Window:MakeTab({
    Name = "Chức Năng Chính",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Dòng chữ hiển thị bản quyền bên trong Tab
Tab1:AddLabel("Bản quyền thuộc về Ngô Ngọc Hùng")

-- CHỨC NĂNG 1: TỐC ĐỘ CHẠY
Tab1:AddToggle({
    Name = "Bật Tốc Độ Nhanh (Speed)",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 90
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end    
})

-- CHỨC NĂNG 2: NHẢY CAO
Tab1:AddToggle({
    Name = "Bật Nhảy Cao (Jump)",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
        else
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end    
})

-- Khởi tạo Menu
OrionLib:Init()
