-- Đổi tên menu thành HungHiHo Menu và tối ưu hóa giảm lag bằng Kavo UI Mobile
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo:CreateLib("HungHiHo Menu", "DarkTheme")

-- Khởi tạo các Tab chức năng chính
local Tab1 = Window:NewTab("Tự Động Farm")
local Tab2 = Window:NewTab("Chỉ Số (Dam)")

local Section1 = Tab1:NewSection("Chức Năng Farm")
local Section2 = Tab2:NewSection("Tăng Sát Thương")

-- Biến lưu trạng thái hoạt động của chức năng
local AutoFarmNPC = false
local AutoFarmPlayer = false
local VirtualUser = game:GetService("VirtualUser")

-- Giả lập tự động bấm chuột để nhân vật tự vung kiếm/đánh khi farm
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button1Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
    task.wait(1)
end)

-- ==========================================================
-- CHỨC NĂNG 1: TỰ ĐỘNG FARM QUÁI (NPC) HOẠT ĐỘNG THẬT
-- ==========================================================
Section1:NewToggle("Tự Động Farm Quái", "Tự tìm quái trên bản đồ và tiêu diệt", function(state)
    AutoFarmNPC = state
    if AutoFarmNPC then
        task.spawn(function()
            while AutoFarmNPC do
                task.wait(0.1)
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- Quét toàn bộ bản đồ để tìm NPC/Quái có máu (Humanoid)
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                -- Kiểm tra xem đó có phải là Quái không (không phải bản thân và không phải người chơi khác)
                                if v.Name ~= player.Name and not game.Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
                                    -- Lặp lại việc dịch chuyển đến sát vị trí của quái cho đến khi nó chết
                                    repeat
                                        if not AutoFarmNPC then break end
                                        character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                        -- Kích hoạt giả lập click chuột tấn công liên tục
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
end)

-- ==========================================================
-- CHỨC NĂNG 2: TỰ ĐỘNG FARM NGƯỜI (PLAYER PVP)
-- ==========================================================
Section1:NewToggle("Tự Động Farm Người", "Tự dịch chuyển và săn người chơi khác", function(state)
    AutoFarmPlayer = state
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
end)

-- ==========================================================
-- CHỨC NĂNG 3: TĂNG 10,000 SÁT THƯƠNG
-- ==========================================================
Section2:NewButton("Bật Tăng +10000 Sát Thương", "Cộng dồn chỉ số tấn công vật lý", function()
    pcall(function()
        local player = game.Players.LocalPlayer
        -- Tìm kiếm các thư mục lưu dữ liệu chỉ số phổ biến của game để cộng điểm
        local stats = player:FindFirstChild("leaderstats") or player:FindFirstChild("Data") or player:FindFirstChild("Stats")
        if stats then
            for _, stat in pairs(stats:GetChildren()) do
                if stat.Name:lower():match("damage") or stat.Name:lower():match("dam") or stat.Name:lower():match("sat_thuong") then
                    stat.Value = stat.Value + 10000
                end
            end
        end
    end)
end)

-- ==========================================================
-- TẠO NÚT BẤM NHỎ NỔI TRÊN MÀN HÌNH ĐỂ ĐÓNG/MỞ MENU KHÔNG LO LAG
-- ==========================================================
local OpenCloseGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

OpenCloseGui.Name = "HungHiHoToggleGui"
OpenCloseGui.Parent = game.CoreGui
OpenCloseGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = OpenCloseGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0) -- Vị trí nút nhỏ ở góc trên bên trái màn hình
ToggleButton.Size = UDim2.new(0, 60, 0, 60)        -- Kích thước nút tròn nhỏ vừa vặn ngón tay
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "H H H"                         -- Viết tắt của HungHiHo Menu
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16.000

UICorner.CornerRadius = UDim.new(0, 30)             -- Bo tròn nút thành hình tròn 100%
UICorner.Parent = ToggleButton

-- Logic bấm nút để ẩn/hiện bảng menu cực mượt
local menuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    -- Kavo UI tự động ẩn/hiện toàn bộ khung chính khi gọi lệnh này
    game.CoreGui:FindFirstChild("Library").Enabled = menuVisible
end)
