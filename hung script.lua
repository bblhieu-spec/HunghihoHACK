-- ==========================================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG - PHIÊN BẢN KHÔNG GIAO DIỆN
-- TỰ ĐỘNG CHẠY 100% - CHỐNG LỖI ĐEN MÀN HÌNH TUYỆT ĐỐI
-- ==========================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH TỰ ĐỘNG: Bật thẳng tất cả các tính năng không cần bấm nút
local autoFarmActive = true
local speedActive = true
local jumpActive = true

-- Hàm lấy mã khóa ngầm từ server Jsonbin.io của bạn
local function checkServerKey()
    local success, result = pcall(function()
        return game:HttpGet("https://api.jsonbin.io/v3/b/6a104353ee5a733b12ffcdf5/latest?meta=false")
    end)
    if success then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        if decodeSuccess and data and data.ServerKey then
            return true -- Luôn cho phép chạy nếu server hoạt động
        end
    end
    return true -- Dự phòng: Nếu API lỗi vẫn cho người chơi trải nghiệm
end

------------------------------------------------------------------------
-- TỰ ĐỘNG KHÓA CHỈ SỐ DI CHUYỂN VÀ NHẢY CAO CHỐNG RESET
------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if speedActive then 
                    humanoid.WalkSpeed = 90 -- Tự động chạy nhanh
                end
                if jumpActive then 
                    humanoid.JumpPower = 150 -- Tự động nhảy cao
                end
            end
        end)
    end
end)

------------------------------------------------------------------------
-- LOGIC TỰ ĐỘNG TRANG BỊ VŨ KHÍ / TRÁI ÁC QUỶ ĐANG CÓ
------------------------------------------------------------------------
local function autoEquipWeapon()
    local char = LocalPlayer.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = char
                break
            end
        end
    end
end

------------------------------------------------------------------------
-- TỰ ĐỘNG PHÂN TÍCH VÀ DI CHUYỂN THEO CẤP ĐỘ NHÂN VẬT (FARM NHIỆM VỤ)
------------------------------------------------------------------------
local function getQuestByLevel()
    local level = LocalPlayer.Data.Level.Value
    local quest = { QuestName = "BanditQuest1", QuestNumber = 1, EnemyName = "Bandit", NPCName = "Bandit Quest Giver" }
    
    if level >= 10 and level < 15 then
        quest = { QuestName = "MonkeyQuest1", QuestNumber = 1, EnemyName = "Monkey", NPCName = "Monkey Quest Giver" }
    elseif level >= 15 and level < 30 then
        quest = { QuestName = "MonkeyQuest1", QuestNumber = 2, EnemyName = "Gorilla", NPCName = "Monkey Quest Giver" }
    elseif level >= 30 and level < 40 then
        quest = { QuestName = "PirateIslandQuest", QuestNumber = 1, EnemyName = "Pirate", NPCName = "Pirate Quest Giver" }
    end
    return quest
end

-- Kiểm tra xem nhân vật đã nhận nhiệm vụ hiển thị trên màn hình chưa
local function isQuestVisible()
    local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local questFrame = mainGui and mainGui:FindFirstChild("Quest")
    return questFrame and questFrame.Visible == true
end

------------------------------------------------------------------------
-- VÒNG LẶP CORE: TỰ ĐỘNG ĐÁNH VÀ DI CHUYỂN LIÊN TỤC
------------------------------------------------------------------------
task.spawn(function()
    if not checkServerKey() then return end
    
    while task.wait() do
        if autoFarmActive then
            pcall(function()
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                local currentJob = getQuestByLevel()
                
                -- HÀNH ĐỘNG 1: Chưa có nhiệm vụ -> Tự động bay tới NPC nhận ngay
                if not isQuestVisible() then
                    local npc = game.Workspace:FindFirstChild(currentJob.NPCName) or game.Workspace.NPCs:FindFirstChild(currentJob.NPCName)
                    if npc and npc:FindFirstChild("HumanoidRootPart") then
                        rootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        task.wait(0.4)
                        
                        -- Gửi lệnh nhận nhiệm vụ lên Server game
                        local comms = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF")
                        if comms then
                            comms:InvokeServer("StartQuest", currentJob.QuestName, currentJob.QuestNumber)
                        end
                    end
                
                -- HÀNH ĐỘNG 2: Đã có nhiệm vụ -> Tự lấy Trái Ác Quỷ/Vũ khí ra gom quái và farm
                else
                    autoEquipWeapon()
                    local enemyFound = false
                    local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
                    
                    if enemiesFolder then
                        for _, enemy in pairs(enemiesFolder:GetChildren()) do
                            if enemy.Name == currentJob.EnemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                enemyFound = true
                                
                                -- Gom quái, phóng to bia va chạm để không bị đánh trượt
                                enemy.HumanoidRootPart.CanCollide = false
                                enemy.HumanoidRootPart.Size = Vector3.new(40, 40, 40)
                                
                                -- Bay trên đầu quái 700 mét (tránh quái đánh trả)
                                rootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                
                                -- Tự động kích hoạt đòn đánh của Trái Ác Quỷ/Kiếm
                                local weapon = character:FindFirstChildOfClass("Tool")
                                if weapon then weapon:Activate() end
                                break
                            end
                        end
                    end
                    
                    -- Nếu quái chưa hồi sinh tại bãi, tự động đứng đợi ở điểm Spawn của quái
                    if not enemyFound then
                        local spawnArea = game.Workspace:FindFirstChild(currentJob.EnemyName .. " [Spawn]")
                        if spawnArea then 
                            rootPart.CFrame = spawnArea.CFrame 
                        end
                    end
                end
            end)
        end
    end
end)

------------------------------------------------------------------------
-- CƠ CHẾ CẤP CỨU: NẾU MUỐN TẮT HACK -> ẤN NÚT GIẢM ÂM LƯỢNG (VOLUME DOWN)
------------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, processed)
    -- Khi bấm nút Giảm âm lượng trên điện thoại, hệ thống sẽ dừng Farm lập tức để bạn làm việc khác
    if input.KeyCode == Enum.KeyCode.VolumeDown then
        autoFarmActive = not autoFarmActive
        speedActive = autoFarmActive
        jumpActive = autoFarmActive
        if not autoFarmActive then
            pcall(function()
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
                LocalPlayer.Character.Humanoid.JumpPower = 50
            end)
        end
    end
end)
