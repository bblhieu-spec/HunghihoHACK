-- ==========================================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG - MENU CHÁT SỐ RÚT GỌN
-- TỰ ĐỘNG NHẬN NHIỆM VỤ, FARM THEO CẤP ĐỘ & KHÓA CHỈ SỐ
-- ==========================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Biến cấu hình hệ thống ngầm
local isVerified = false
local autoFarmActive = false
local speedActive = false
local jumpActive = false

-- Hàm lấy mã khóa từ server Jsonbin.io của bạn
local function getServerKey()
    local success, result = pcall(function()
        return game:HttpGet("https://api.jsonbin.io/v3/b/6a104353ee5a733b12ffcdf5/latest?meta=false")
    end)
    if success then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        if decodeSuccess and data and data.ServerKey then
            return string.gsub(data.ServerKey, "%s+", "")
        end
    end
    return nil
end

-- Hàm hiển thị menu bằng tin nhắn hệ thống (Chỉ mình bạn nhìn thấy trong khung chat)
local function sendChatMenu()
    print("\n--- HÙNG HUB CHAT MENU ---")
    if not isVerified then
        print("[HỆ THỐNG]: Trạng thái: CHƯA KÍCH HOẠT")
        print("-> Để kích hoạt, hãy chát: key [Mã_Key_Của_Bạn]")
        print("   (Ví dụ: key HUNG_123)")
    else
        print("[HỆ THỐNG]: Trạng thái: ĐÃ KÍCH HOẠT")
        print("Hãy chát các SỐ sau để BẬT/TẮT nhanh:")
        print("[ 1 ] : Auto Farm Nhiệm Vụ Theo Cấp Độ (Hiện tại: " .. (autoFarmActive and "BẬT" or "TẮT") .. ")")
        print("[ 2 ] : Tốc Độ Chạy Siêu Nhanh Speed 90 (Hiện tại: " .. (speedActive and "BẬT" or "TẮT") .. ")")
        print("[ 3 ] : Nhảy Siêu Cao Jump 150 (Hiện tại: " .. (jumpActive and "BẬT" or "TẮT") .. ")")
        print("[ 0 ] : Xem lại bảng Menu này")
    end
    print("---------------------------\n")
end

-- Khởi động hiển thị menu ngay khi nạp script
task.wait(1)
sendChatMenu()

-- Lắng nghe tin nhắn bạn gõ trong ô Chat
LocalPlayer.Chatted:Connect(function(message)
    -- Xóa khoảng trắng thừa
    local cleanMessage = string.gsub(message, "^%s*(.-)%s*$", "%1")
    local args = string.split(cleanMessage, " ")
    
    ------------------------------------------------------------------------
    -- BƯỚC 1: NHẬP KEY (Gõ chữ "key" dấu cách rồi đến mã key)
    ------------------------------------------------------------------------
    if string.lower(args[1]) == "key" then
        if isVerified then
            print("[HỆ THỐNG]: Bạn đã kích hoạt thành công từ trước rồi!")
            return
        end
        
        local inputKey = args[2]
        if not inputKey then
            print("[HỆ THỐNG]: Vui lòng nhập đúng cú pháp: key [Mã_Key]")
            return
        end
        
        print("[HỆ THỐNG]: Đang kiểm tra mã khóa...")
        local targetKey = getServerKey()
        
        if targetKey and inputKey == targetKey then
            isVerified = true
            print("[HỆ THỐNG]: ✅ KÍCH HOẠT THÀNH CÔNG!")
            sendChatMenu()
        else
            print("[HỆ THỐNG]: ❌ Sai mã khóa hoặc Server lỗi. Thử lại!")
        end
        return
    end
    
    ------------------------------------------------------------------------
    -- BƯỚC 2: ĐIỀU KHIỂN BẰNG SỐ (Chỉ chạy khi đã mở khóa Key)
    ------------------------------------------------------------------------
    if isVerified then
        -- Ấn số 1 để Farm
        if cleanMessage == "1" then
            autoFarmActive = not autoFarmActive
            print("[HỆ THỐNG]: Đã " .. (autoFarmActive and "BẬT 🌾" or "TẮT 🛑") .. " Auto Farm Level.")
            
        -- Ấn số 2 để Chạy nhanh
        elseif cleanMessage == "2" then
            speedActive = not speedActive
            print("[HỆ THỐNG]: Đã " .. (speedActive and "BẬT ⚡" or "TẮT 🚶") .. " Tốc độ cao.")
            if not speedActive then
                pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
            end
            
        -- Ấn số 3 để Nhảy cao
        elseif cleanMessage == "3" then
            jumpActive = not jumpActive
            print("[HỆ THỐNG]: Đã " .. (jumpActive and "BẬT 🦘" or "TẮT 🛑") .. " Nhảy cao.")
            if not jumpActive then
                pcall(function() LocalPlayer.Character.Humanoid.JumpPower = 50 end)
            end
            
        -- Ấn số 0 để hiển thị lại Menu hướng dẫn
        elseif cleanMessage == "0" then
            sendChatMenu()
        end
    else
        -- Nếu chưa nhập key mà đã bấm số
        if cleanMessage == "1" or cleanMessage == "2" or cleanMessage == "3" then
            print("[HỆ THỐNG]: ⛔ Bạn cần phải kích hoạt Key trước. Hãy gõ: key [Mã_Key]")
        end
    end
end)

------------------------------------------------------------------------
-- CÁC VÒNG LẶP HACK CHẠY NGẦM LOGIC (GIỮ NGUYÊN BẢN MƯỢT NHẤT)
------------------------------------------------------------------------

-- Khóa chỉ số di chuyển chống game reset
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if speedActive then humanoid.WalkSpeed = 90 end
                if jumpActive then humanoid.JumpPower = 150 end
            end
        end)
    end
end)

-- Tự động lấy vũ khí/trái ác quỷ lên tay
local function autoEquip()
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

-- Nhận diện bãi quái và NPC theo Level
local function getQuestData()
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

-- Auto Farm lõi
task.spawn(function()
    while task.wait() do
        if isVerified and autoFarmActive then
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                local q = getQuestData()
                local hasQuest = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible
                
                if not hasQuest then
                    local npc = game.Workspace:FindFirstChild(q.NPCName) or game.Workspace.NPCs:FindFirstChild(q.NPCName)
                    if npc and npc:FindFirstChild("HumanoidRootPart") then
                        root.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        task.wait(0.5)
                        local comm = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF")
                        if comm then comm:InvokeServer("StartQuest", q.QuestName, q.QuestNumber) end
                    end
                else
                    autoEquip()
                    local enemyFound = false
                    local folder = game.Workspace:FindFirstChild("Enemies")
                    if folder then
                        for _, e in pairs(folder:GetChildren()) do
                            if e.Name == q.EnemyName and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and e:FindFirstChild("HumanoidRootPart") then
                                enemyFound = true
                                e.HumanoidRootPart.CanCollide = false
                                e.HumanoidRootPart.Size = Vector3.new(40, 40, 40)
                                root.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                                break
                            end
                        end
                    end
                    if not enemyFound then
                        local sp = game.Workspace:FindFirstChild(q.EnemyName .. " [Spawn]")
                        if sp then root.CFrame = sp.CFrame end
                    end
                end
            end)
        end
    end
end)
