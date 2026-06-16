-- ==========================================
-- BẢN QUYỀN THUỘC VỀ NGÔ NGỌC HÙNG
-- ==========================================

local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Hàm hiển thị thông báo hệ thống nhanh
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
if CoreGui:FindFirstChild("HungHub_System") then CoreGui.HungHub_System:Destroy() end

-- Khởi tạo Giao diện hệ thống
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HungHub_System"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

------------------------------------------------------------------------
-- KHUNG 1: KHỦNG NHẬP KEY BAN ĐẦU
------------------------------------------------------------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -150, 0.4, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyTitle.Text = "XÁC THỰC SERVER KEY"
KeyTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
KeyTitle.TextSize = 14
KeyTitle.TextFont = Enum.Font.SourceSansBold
KeyTitle.Parent = KeyFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 240, 0, 35)
TextBox.Position = UDim2.new(0.5, -120, 0.45, -17)
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
SubmitButton.Text = "Xác Thực Key"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 14
SubmitButton.TextFont = Enum.Font.SourceSansBold
SubmitButton.Parent = KeyFrame

local currentServerKey = getServerKey()
if currentServerKey then
    TextBox.PlaceholderText = "Nhập mã tạo từ Web..."
else
    TextBox.PlaceholderText = "Lỗi kết nối API Server Key!"
end

------------------------------------------------------------------------
-- XỬ LÝ KHI NHẬP KEY ĐÚNG -> TỰ ĐỘNG VẼ MENU HACK GỐC
------------------------------------------------------------------------
SubmitButton.MouseButton1Click:Connect(function()
    currentServerKey = getServerKey()
    local userEnteredKey = string.gsub(TextBox.Text, "%s+", "")
    
    if userEnteredKey == currentServerKey and currentServerKey ~= nil then
        KeyFrame:Destroy() -- Xóa khung nhập key đi
        showNotification("Thành Công", "Mã khóa chính xác! Đang mở menu...", 3)
        
        -- Tạo Khung Menu Hack Chính (Vẽ bằng Code Gốc, Không Sợ Trắng/Đen)
        local MainMenu = Instance.new("Frame")
        MainMenu.Size = UDim2.new(0, 240, 0, 230)
        MainMenu.Position = UDim2.new(0.5, -120, 0.35, -115)
        MainMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        MainMenu.BorderSizePixel = 2
        MainMenu.BorderColor3 = Color3.fromRGB(255, 215, 0)
        MainMenu.Active = true
        MainMenu.Draggable = true
        MainMenu.Parent = ScreenGui

        local MenuTitle = Instance.new("TextLabel")
        MenuTitle.Size = UDim2.new(1, 0, 0, 40)
        MenuTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        MenuTitle.Text = "Ngô Ngọc Hùng Hub"
        MenuTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
        MenuTitle.TextSize = 16
        MenuTitle.TextFont = Enum.Font.SourceSansBold
        MenuTitle.Parent = MainMenu

        -- NÚT CHỨC NĂNG 1: AUTO FARM
        local FarmButton = Instance.new("TextButton")
        FarmButton.Size = UDim2.new(0.9, 0, 0, 35)
        FarmButton.Position = UDim2.new(0.05, 0, 0, 55)
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
        FarmButton.Text = "Auto Farm: ĐANG TẮT"
        FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FarmButton.TextSize = 14
        FarmButton.TextFont = Enum.Font.SourceSansBold
        FarmButton.Parent = MainMenu

        local _G = getgenv and getgenv() or _G
        _G.AutoFarm = false

        FarmButton.MouseButton1Click:Connect(function()
            _G.AutoFarm = not _G.AutoFarm
            if _G.AutoFarm then
                FarmButton.Text = "Auto Farm: ĐANG BẬT"
                FarmButton.BackgroundColor3 = Color3.fromRGB(204, 0, 0)
            else
                FarmButton.Text = "Auto Farm: ĐANG TẮT"
                FarmButton.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
            end
        end)

        -- Vòng lặp Gom quái và Tự đánh
        task.spawn(function()
            while task.wait() do
                if _G.AutoFarm then
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(45, 45, 45)
                                repeat
                                    task.wait()
                                    player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                                    local tool = player.Character:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() end
                                until not _G.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    end)
                end
            end
        end)

        -- NÚT CHỨC NĂNG 2: TỐC ĐỘ CHẠY (SPEED)
        local SpeedButton = Instance.new("TextButton")
        SpeedButton.Size = UDim2.new(0.9, 0, 0, 35)
        SpeedButton.Position = UDim2.new(0.05, 0, 0, 100)
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
        SpeedButton.Text = "Tốc Độ: Bình Thường"
        SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SpeedButton.TextSize = 14
        SpeedButton.Parent = MainMenu

        local speedToggle = false
        SpeedButton.MouseButton1Click:Connect(function()
            speedToggle = not speedToggle
            if speedToggle then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 90
                SpeedButton.Text = "Tốc Độ: Siêu Nhanh"
                SpeedButton.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
            else
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
                SpeedButton.Text = "Tốc Độ: Bình Thường"
                SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
            end
        end)

        -- NÚT CHỨC NĂNG 3: NHẢY CAO (JUMP)
        local JumpButton = Instance.new("TextButton")
        JumpButton.Size = UDim2.new(0.9, 0, 0, 35)
        JumpButton.Position = UDim2.new(0.05, 0, 0, 145)
        JumpButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
        JumpButton.Text = "Nhảy Cao: Bình Thường"
        JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        JumpButton.TextSize = 14
        JumpButton.Parent = MainMenu

        local jumpToggle = false
        JumpButton.MouseButton1Click:Connect(function()
            jumpToggle = not jumpToggle
            if jumpToggle then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
                JumpButton.Text = "Nhảy Cao: Siêu Cao"
                JumpButton.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
            else
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
                JumpButton.Text = "Nhảy Cao: Bình Thường"
                JumpButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
            end
        end)

        -- NÚT ĐÓNG/ẨN MENU TẠM THỜI
        local CloseButton = Instance.new("TextButton")
        CloseButton.Size = UDim2.new(0.9, 0, 0, 30)
        CloseButton.Position = UDim2.new(0.05, 0, 0, 190)
        CloseButton.BackgroundColor3 = Color3.fromRGB(64, 64, 64)
        CloseButton.Text = "Ẩn/Hiện Bảng Chức Năng"
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextSize = 13
        CloseButton.Parent = MainMenu

        CloseButton.MouseButton1Click:Connect(function()
            MainMenu.Visible = not MainMenu.Visible
            showNotification("Hệ thống", "Đã thay đổi trạng thái hiển thị của Menu!", 2)
        end)
        
    else
        showNotification("Từ Chối Truy Cập", "Mã khóa không hợp lệ hoặc đã bị thay đổi trên Web.", 5)
        TextBox.Text = ""
    end
end)

showNotification("Thông Tin", "Bản quyền thuộc về Ngô Ngọc Hùng", 5)
