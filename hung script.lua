-- ==========================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG
-- ==========================================

local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Hàm hiển thị thông báo hệ thống
local function showNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
end

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

-- Xóa giao diện cũ nếu tồn tại trước đó để tránh trùng lặp
if CoreGui:FindFirstChild("HungScript_System") then CoreGui.HungScript_System:Destroy() end
if CoreGui:FindFirstChild("Orion") then CoreGui.Orion:Destroy() end

-- Khởi tạo Giao diện xác thực Key ban đầu
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HungScript_System"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 320, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -160, 0.4, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "HỆ THỐNG XÁC THỰC SERVER KEY"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 14
Title.TextFont = Enum.Font.SourceSansBold
Title.Parent = KeyFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 260, 0, 35)
TextBox.Position = UDim2.new(0.5, -130, 0.45, -17)
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TextBox.Text = ""
TextBox.PlaceholderText = "Đang kiểm tra kết nối máy chủ..."
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14
TextBox.Parent = KeyFrame

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0, 140, 0, 35)
SubmitButton.Position = UDim2.new(0.5, -70, 0.8, -17)
SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SubmitButton.Text = "Xác Thực Mã Khóa"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 14
SubmitButton.TextFont = Enum.Font.SourceSansBold
SubmitButton.Parent = KeyFrame

local currentServerKey = getServerKey()
if currentServerKey then
    TextBox.PlaceholderText = "Nhập Server Key từ Web..."
else
    TextBox.PlaceholderText = "Lỗi kết nối API Server Key!"
end

-- Khi người dùng bấm nút Xác Thực thành công, hệ thống sẽ tự vẽ Menu Hack xịn luôn
SubmitButton.MouseButton1Click:Connect(function()
    currentServerKey = getServerKey()
    local userEnteredKey = string.gsub(TextBox.Text, "%s+", "")
    
    if not currentServerKey then
        showNotification("Lỗi Hệ Thống", "Không thể truy xuất dữ liệu xác thực từ máy chủ.", 5)
    elseif userEnteredKey == currentServerKey then
        KeyFrame:Destroy() -- Xóa bảng nhập Key
        showNotification("Thành Công", "Mã khóa chính xác! Đang khởi chạy Menu...", 5)
        
        ------------------------------------------------------------------------
        -- KHỞI CHẠY MENU HACK CHÍNH (TỰ CHỦ KHÔNG PHỤ THUỘC LINK NGOÀI)
        ------------------------------------------------------------------------
        local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
        local Window = OrionLib:MakeWindow({
            Name = "Ngô Ngọc Hùng Hub (Blox Fruits)", 
            HidePremium = false, 
            SaveConfig = true, 
            ConfigFolder = "HungHubConfig"
        })

        -- TAB 1: TỰ ĐỘNG ĐÁNH (AUTO FARM)
        local Tab1 = Window:MakeTab({ Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false })
        Tab1:AddLabel("Bản quyền độc quyền: Ngô Ngọc Hùng")

        local _G = getgenv and getgenv() or _G
        _G.AutoFarm = false

        Tab1:AddToggle({
            Name = "Bật Auto Farm (Gom Quái + Tự Đánh)",
            Default = false,
            Callback = function(Value)
                _G.AutoFarm = Value
            end    
        })

        -- Vòng lặp tối ưu chạy Auto Farm siêu mượt, tự động nhận diện vũ khí trên tay
        task.spawn(function()
            while task.wait() do
                if _G.AutoFarm then
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                -- Tự động gom quái tụ lại một điểm nhỏ chống lag
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(45, 45, 45)
                                
                                repeat
                                    task.wait()
                                    -- Teleport giữ khoảng cách an toàn phía trên đầu quái
                                    player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                                    
                                    -- Tự động vung kiếm hoặc đấm quái liên tục
                                    local tool = player.Character:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() end
                                until not _G.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    end)
                end
            end
        end)

        -- TAB 2: TIỆN ÍCH NGƯỜI CHƠI
        local Tab2 = Window:MakeTab({ Name = "Người Chơi", Icon = "rbxassetid://4483345998", PremiumOnly = false })

        Tab2:AddToggle({
            Name = "Bật Tốc Độ Nhanh (Speed 90)",
            Default = false,
            Callback = function(Value)
                if Value then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 90 else game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 end
            end    
        })

        Tab2:AddToggle({
            Name = "Bật Nhảy Cao (Jump 150)",
            Default = false,
            Callback = function(Value)
                if Value then game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150 else game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50 end
            end    
        })

        OrionLib:Init()
    else
        showNotification("Từ Chối Truy Cập", "Mã khóa không hợp lệ hoặc đã bị thay đổi trên Web.", 5)
        TextBox.Text = ""
    end
end)

showNotification("Thông Tin", "Bản quyền thuộc về Ngô Ngọc Hùng", 10)
