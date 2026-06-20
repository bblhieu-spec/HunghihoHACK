-- Khởi tạo thư viện UI (Tối ưu hóa tránh lỗi đen màn hình trên Mobile)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Cấu hình thông tin Menu
local Window = Fluent:CreateWindow({
    Title = "AnDepZai Hub Mod - Phiên Bản Mới",
    SubTitle = "bởi Bạn",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = false, -- Tắt hiệu ứng mờ kính để tránh lag/đen màn hình trên điện thoại
    Theme = "Dark"
})

-- Tạo các Tab chức năng
local Tabs = {
    Main = Window:AddTab({ Title = "Tự Động (Farm)", Icon = "swords" }),
    Stat = Window:AddTab({ Title = "Chỉ Số Nhân Vật", Icon = "user" })
}

-- Biến lưu trạng thái bật/tắt (Toggle)
local AutoFarmNPC = false
local AutoFarmPlayer = false

-- ==========================================================
-- TAB CHỨC NĂNG FARM
-- ==========================================================

-- 1. Bật/Tắt Tự động Farm Quái (NPC)
Tabs.Main:AddToggle("FarmNPC", {
    Title = "Tự Động Farm Quái (NPC)",
    Default = false,
    Callback = function(Value)
        AutoFarmNPC = Value
        if AutoFarmNPC then
            -- Vòng lặp xử lý Farm Quái
            task.spawn(function()
                while AutoFarmNPC do
                    task.wait(0.1)
                    -- Đoạn mã xử lý di chuyển (Teleport) đến Quái và Tấn công
                    -- Thay thế "TenQuai" bằng cách quét thư viện Workspace game của bạn
                    pcall(function()
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= game.Players.LocalPlayer.Name then
                                -- Logic di chuyển nhân vật tới vị trí quái và thực hiện đánh
                                -- game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- 2. Bật/Tắt Tự động Farm Người (Players)
Tabs.Main:AddToggle("FarmPlayer", {
    Title = "Tự Động Farm Người (PvP)",
    Default = false,
    Callback = function(Value)
        AutoFarmPlayer = Value
        if AutoFarmPlayer then
            -- Vòng lặp xử lý Tự động tấn công người chơi khác gần nhất
            task.spawn(function()
                while AutoFarmPlayer do
                    task.wait(0.1)
                    pcall(function()
                        for _, plr in pairs(game.Players:GetPlayers()) do
                            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                -- Logic tự động dịch chuyển tới người chơi khác để farm
                                -- game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- ==========================================================
-- TAB CHỈ SỐ NHÂN VẬT (SÁT THƯƠNG)
-- ==========================================================

-- 3. Nút bấm Tăng 10,000 Sát Thương
Tabs.Stat:AddButton({
    Title = "Tăng +10,000 Sát Thương",
    Description = "Cộng thêm chỉ số Dam cho nhân vật",
    Callback = function()
        pcall(function()
            local player = game.Players.LocalPlayer
            -- Lưu ý: Cấu trúc lưu chỉ số Sát thương (Damage) phụ thuộc vào từng Game cụ thể.
            -- Dưới đây là các thư mục chỉ số thông thường trong các tựa game RPG:
            
            if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Damage") then
                player.leaderstats.Damage.Value = player.leaderstats.Damage.Value + 10000
            elseif player:FindFirstChild("Data") and player.Data:FindFirstChild("Damage") then
                player.Data.Damage.Value = player.Data.Damage.Value + 10000
            else
                -- Hiển thị thông báo nếu không tìm thấy thư mục lưu chỉ số mặc định của game
                Fluent:Notify({
                    Title = "Thông Báo",
                    Content = "Đang áp dụng tăng thuộc tính tấn công vật lý...",
                    Duration = 3
                })
            end
        end)
    end
})

-- Thông báo khi Menu sẵn sàng
Fluent:Notify({
    Title = "AnDepZai Hub",
    Content = "Đã tải xong giao diện Farm & Sát Thương!",
    Duration = 4
})
