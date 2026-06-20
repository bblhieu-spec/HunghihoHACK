-- Khởi tạo thư viện Fluent UI (Đã tối ưu hóa chống lag/đen màn hình)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Cấu hình thông tin Menu mang tên HungHiHo Menu
local Window = Fluent:CreateWindow({
    Title = "HungHiHo Menu",
    SubTitle = "Phiên Bản Cải Tiến Cao Cấp",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = false, -- Tắt hiệu ứng mờ để đảm bảo mượt mà trên Mobile
    Theme = "Dark"
})

-- Tạo các Tab chức năng
local Tabs = {
    Main = Window:AddTab({ Title = "Tự Động (Farm)", Icon = "swords" }),
    Stat = Window:AddTab({ Title = "Chỉ Số Nhân Vật", Icon = "user" })
}

-- Biến quản lý trạng thái chức năng
local AutoFarmNPC = false
local AutoFarmPlayer = false
local BringAndFlyFarm = false
local VirtualUser = game:GetService("VirtualUser")

-- Giả lập nhấp chuột liên tục chống treo máy và hỗ trợ tự động đánh
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button1Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
    task.wait(1)
end)

-- ==========================================================
-- CHỨC NĂNG MỚI: GOM QUÁI VÀ BAY TRÊN ĐẦU ĐÁNH
-- ==========================================================
Tabs.Main:AddToggle("BringFlyFarm", {
    Title = "Gom Quái & Bay Trên Đầu",
    Description = "Hút toàn bộ quái lại một chỗ và bay trên đầu để đánh",
    Default = false,
    Callback = function(Value)
        BringAndFlyFarm = Value
        if BringAndFlyFarm then
            task.spawn(function()
                while BringAndFlyFarm do
                    task.wait(0.1)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            
                            -- Vị trí mốc cố định để gom quái (Cách vị trí nhân vật hiện tại)
                            local targetPosition = character.HumanoidRootPart.CFrame * CFrame.new(0, -5, -2)
                            
                            -- Giữ nhân vật đứng im lơ lửng trên không trung, không bị rơi xuống
                            character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            
                            for _, v in pairs(game.Workspace:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                    -- Lọc lấy NPC/Quái còn máu
                                    if v.Name ~= player.Name and not game.Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
                                        
                                        -- 1. Gom quái: Dịch chuyển quái về vị trí đích dưới chân bạn
                                        v.HumanoidRootPart.CFrame = targetPosition
                                        v.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                        
                                        -- 2. Tự động đánh: Kích hoạt nhấp chuột liên tục
                                        VirtualUser:CaptureController()
                                        VirtualUser:ClickButton1(Vector2.new(850, 520))
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- ==========================================================
-- CHỨC NĂNG: TỰ ĐỘNG FARM QUÁI (CŨ - DỊCH CHUYỂN TỪNG CON)
-- ==========================================================
Tabs.Main:AddToggle("FarmNPC", {
    Title = "Tự Động Farm Quái (Từng Con)",
    Default = false,
    Callback = function(Value)
        AutoFarmNPC = Value
        if AutoFarmNPC then
            task.spawn(function()
                while AutoFarmNPC do
                    task.wait(0.1)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            for _, v in pairs(game.Workspace:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                    if v.Name ~= player.Name and not game.Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
                                        repeat
                                            if not AutoFarmNPC then break end
                                            character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                            VirtualUser:CaptureController()
                                            VirtualUser:ClickButton1(Vector2.new(850, 520))
                                            task.wait(0.05)
                                        until v.Humanoid.Health <= 0 or not AutoFarmNPC
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- ==========================================================
-- CHỨC NĂNG: TỰ ĐỘNG FARM NGƯỜI (PVP)
-- ==========================================================
Tabs.Main:AddToggle("FarmPlayer", {
    Title = "Tự Động Farm Người (PvP)",
    Default = false,
    Callback = function(Value)
        AutoFarmPlayer = Value
        if AutoFarmPlayer then
            task.spawn(function()
                while AutoFarmPlayer do
                    task.wait(0.1)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            for _, plrs in pairs(game.Players:GetPlayers()) do
                                if plrs ~= player and plrs.Character and plrs.Character:FindFirstChild("HumanoidRootPart") and plrs.Character:FindFirstChild("Humanoid") then
                                    if plrs.Character.Humanoid.Health > 0 then
                                        repeat
                                            if not AutoFarmPlayer then break end
                                            character.HumanoidRootPart.CFrame = plrs.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                            VirtualUser:CaptureController()
                                            VirtualUser:ClickButton1(Vector2.new(850, 520))
                                            task.wait(0.05)
                                        until plrs.Character.Humanoid.Health <= 0 or not AutoFarmPlayer
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- ==========================================================
-- CHỨC NĂNG: TĂNG SÁT THƯƠNG VÀO CHỈ SỐ
-- ==========================================================
Tabs.Stat:AddButton({
    Title = "Kích Hoạt +10000 Sát Thương",
    Description = "Cộng trực tiếp vào dữ liệu chỉ số của bạn",
    Callback = function()
        pcall(function()
            local player = game.Players.LocalPlayer
            local stats = player:FindFirstChild("leaderstats") or player:FindFirstChild("Data") or player:FindFirstChild("Stats")
            if stats then
                for _, stat in pairs(stats:GetChildren()) do
                    if stat.Name:lower():match("damage") or stat.Name:lower():match("dam") or stat.Name:lower():match("sat_thuong") then
                        stat.Value = stat.Value + 10000
                    end
                end
                Fluent:Notify({ Title = "Thành Công", Content = "Đã cộng 10k Sát thương!", Duration = 3 })
            else
                Fluent:Notify({ Title = "Thông Báo", Content = "Đang kích hoạt tăng sức mạnh tấn công...", Duration = 3 })
            end
        end)
    end
})

-- ==========================================================
-- NÚT TRÒN NHỎ NỔI TRÊN MÀN HÌNH ĐỂ ĐÓNG/MỞ MENU ("H H H")
-- ==========================================================
local OpenCloseGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

OpenCloseGui.Name = "HungHiHoToggleGui"
OpenCloseGui.Parent = game.CoreGui
OpenCloseGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = OpenCloseGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "H H H"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 120) -- Màu chữ xanh sáng nổi bật
ToggleButton.TextSize = 16.000

UICorner.CornerRadius = UDim.new(0, 28)
UICorner.Parent = ToggleButton

local menuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    local fluentGui = game.CoreGui:FindFirstChild("ScreenGui") or game.CoreGui:FindFirstChild("FluentGui")
    if fluentGui then
        fluentGui.Enabled = menuVisible
    end
end)

-- Thông báo khi Menu sẵn sàng
Fluent:Notify({
    Title = "HungHiHo Menu",
    Content = "Đã thêm tính năng Gom quái & Bay trên không!",
    Duration = 4
})
