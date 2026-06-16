-- ==========================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG
-- ĐIỀU KHIỂN 100% BẰNG KHUNG CHÁT - CHỐNG LỖI MÀN HÌNH
-- ==========================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Biến cấu hình hệ thống
local isVerified = false
local autoFarmActive = false

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

-- Hàm giả lập thông báo hệ thống bằng cách chát riêng (chỉ mình bạn thấy)
local function sendSystemMessage(text)
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local chatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents and chatEvents:FindFirstChild("OnMessageDoneFiltering") then
        -- Cách hiển thị thông báo an toàn trong khung chat
        print("[HỆ THỐNG]: " .. text)
    end
    -- Hiển thị thông báo góc màn hình nếu Executor hỗ trợ
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "NGÔ NGỌC HÙNG HUB",
            Text = text,
            Duration = 5
        })
    end)
end

sendSystemMessage("Hệ thống đã nạp! Hãy chát: /e key [MãKey] để kích hoạt.")

-- Lắng nghe người chơi chát lệnh
LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    
    ------------------------------------------------------------------------
    -- 1. LỆNH NHẬP KEY: /e key [Mã_Key_Của_Bạn]
    ------------------------------------------------------------------------
    if args[1] == "/e" and args[2] == "key" then
        if isVerified then
            sendSystemMessage("Bạn đã xác thực thành công trước đó rồi!")
            return
        end
        
        local inputKey = args[3]
        if not inputKey then
            sendSystemMessage("Vui lòng nhập kèm mã key. Ví dụ: /e key HUNG_123")
            return
        end
        
        sendSystemMessage("Đang kiểm tra Key với server đám mây...")
        local currentServerKey = getServerKey()
        
        if currentServerKey and inputKey == currentServerKey then
            isVerified = true
            sendSystemMessage("✅ XÁC THỰC THÀNH CÔNG! Dùng các lệnh sau để hack:")
            sendSystemMessage("- Chát: /e farm (Để Bật/Tắt Auto Farm)")
            sendSystemMessage("- Chát: /e speed (Để Bật/Tắt Tốc Độ Cao)")
            sendSystemMessage("- Chát: /e jump (Để Bật/Tắt Nhảy Cao)")
        else
            sendSystemMessage("❌ Sai Key hoặc Key đã hết hạn! Hãy kiểm tra lại trên Web.")
        end
    end
    
    ------------------------------------------------------------------------
    -- 2. CÁC LỆNH CHỨC NĂNG HACK (Chỉ chạy khi đã nhập đúng Key)
    ------------------------------------------------------------------------
    if isVerified then
        -- LỆNH BẬT/TẮT AUTO FARM
        if message == "/e farm" then
            autoFarmActive = not autoFarmActive
            if autoFarmActive then
                sendSystemMessage("🌾 BẬT Auto Farm Gom Quái!")
            else
                sendSystemMessage("🛑 TẮT Auto Farm!")
            end
        end
        
        -- LỆNH BẬT/TẮT TỐC ĐỘ
        if message == "/e speed" then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.WalkSpeed == 16 then
                    humanoid.WalkSpeed = 90
                    sendSystemMessage("⚡ BẬT Tốc độ siêu nhanh (Speed 90)")
                else
                    humanoid.WalkSpeed = 16
                    sendSystemMessage("🚶 TẮT Tốc độ (Trở về bình thường)")
                end
            end
        end
        
        -- LỆNH BẬT/TẮT NHẢY CAO
        if message == "/e jump" then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.JumpPower == 50 then
                    humanoid.JumpPower = 150
                    sendSystemMessage("🦘 BẬT Nhảy cao (Jump 150)")
                else
                    humanoid.JumpPower = 50
                    sendSystemMessage("🛑 TẮT Nhảy cao (Trở về bình thường)")
                end
            end
        end
    else
        -- Nếu chưa nhập key mà đòi sài lệnh
        if message == "/e farm" or message == "/e speed" or message == "/e jump" then
            sendSystemMessage("⛔ Cảnh báo: Bạn phải nhập đúng Key trước đã!")
        end
    end
end)

-- Vòng lặp Auto Farm chạy ngầm (Chỉ hoạt động khi autoFarmActive = true)
task.spawn(function()
    while task.wait() do
        if isVerified and autoFarmActive then
            pcall(function()
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.CanCollide = false
                        v.HumanoidRootPart.Size = Vector3.new(45, 45, 45)
                        
                        repeat
                            task.wait()
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        until not autoFarmActive or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)
