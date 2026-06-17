-- ==========================================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG - PHIÊN BẢN TỰ ĐỘNG KHỞI CHẠY
-- KHÔNG MENU - KHÔNG PHÍM BẤM - CẮM VÀO LÀ TỰ FARM 100%
-- ==========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo chỉ số tốc độ và nhảy ngay lập tức (Chống reset bằng vòng lặp vĩnh viễn)
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 90 -- Tự tăng tốc chạy lên 90
                humanoid.JumpPower = 150 -- Tự tăng lực nhảy lên 150
            end
        end)
    end
end)

-- Hàm tự động lôi vũ khí hoặc Trái Ác Quỷ ra trên tay để chuẩn bị đánh
local function autoEquipWeapon()
    local character = LocalPlayer.Character
    if character and not character:FindFirstChildOfClass("Tool") then
        local backpack = LocalPlayer.Backpack
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = character
                break
            end
        end
    end
end

-- Hàm tự động kiểm tra Level để tìm đúng bãi quái và NPC nhiệm vụ (Hỗ trợ Sea 1)
local function getQuestData()
    local level = LocalPlayer.Data.Level.Value
    local data = { QuestName = "BanditQuest1", QuestNumber = 1, EnemyName = "Bandit", NPCName = "Bandit Quest Giver" }
    
    if level >= 10 and level < 15 then
        data = { QuestName = "MonkeyQuest1", QuestNumber = 1, EnemyName = "Monkey", NPCName = "Monkey Quest Giver" }
    elseif level >= 15 and level < 30 then
        data = { QuestName = "MonkeyQuest1", QuestNumber = 2, EnemyName = "Gorilla", NPCName = "Monkey Quest Giver" }
    elseif level >= 30 and level < 40 then
        data = { QuestName = "PirateIslandQuest", QuestNumber = 1, EnemyName = "Pirate", NPCName = "Pirate Quest Giver" }
    end
    return data
end

-- Kiểm tra trạng thái bảng nhiệm vụ trên màn hình game
local function hasQuestActive()
    local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local questFrame = mainGui and mainGui:FindFirstChild("Quest")
    return questFrame and questFrame.Visible == true
end

-- VÒNG LẶP CORE: TỰ ĐỘNG THỰC THI 100% NGAY KHI DÁN CODE
task.spawn(function()
    while true do
        task.wait(0.1) -- Giữ nhịp độ mượt mà chống văng game trên điện thoại
        pcall(function()
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            local currentQuest = getQuestData()
            
            -- TRƯỜNG HỢP 1: Chưa có nhiệm vụ -> Tự động dịch chuyển đến nhận
            if not hasQuestActive() then
                local npc = game.Workspace:FindFirstChild(currentQuest.NPCName) or game.Workspace.NPCs:FindFirstChild(currentQuest.NPCName)
                if npc and npc:FindFirstChild("HumanoidRootPart") then
                    -- Bay đến trước mặt NPC
                    rootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    task.wait(0.3)
                    
                    -- Kích hoạt nhận nhiệm vụ trực tiếp lên Server game
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local commF = remotes and remotes:FindFirstChild("CommF")
                    if commF then
                        commF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestNumber)
                    end
                end
                
            -- TRƯỜNG HỢP 2: Đã nhận xong nhiệm vụ -> Tự động đi gom quái và đấm
            else
                autoEquipWeapon() -- Luôn cầm sẵn Trái Ác Quỷ/Vũ khí
                
                local enemyFound = false
                local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
                
                if enemiesFolder then
                    for _, enemy in pairs(enemiesFolder:GetChildren()) do
                        if enemy.Name == currentQuest.EnemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            enemyFound = true
                            
                            -- Gom quái và mở rộng bia va chạm chống đánh hụt
                            enemy.HumanoidRootPart.CanCollide = false
                            enemy.HumanoidRootPart.Size = Vector3.new(45, 45, 45)
                            
                            -- Teleport giữ khoảng cách an toàn phía trên đầu quái tránh bị mất máu
                            rootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                            
                            -- Tự động vung chiêu thức Trái Ác Quỷ liên tục
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                            break
                        end
                    end
                end
                
                -- Nếu quái trong bãi chưa kịp hồi sinh, tự động di chuyển đến điểm chờ quái ra
                if not enemyFound then
                    local spawnPoint = game.Workspace:FindFirstChild(currentQuest.EnemyName .. " [Spawn]")
                    if spawnPoint then
                        rootPart.CFrame = spawnPoint.CFrame
                    end
                end
            end
        end)
    end
end)
