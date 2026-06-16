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
        -- Truy vấn trực tiếp đến Bin ID đã cấu hình trên hệ thống của bạn
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

-- Xóa giao diện cũ nếu tồn tại trước đó để tránh xung đột
if CoreGui:FindFirstChild("HungScript_System") then
    CoreGui.HungScript_System:Destroy()
end

-- Khởi tạo Giao diện xác thực
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

-- Kiểm tra trạng thái kết nối ban đầu
local currentServerKey = getServerKey()
if currentServerKey then
    TextBox.PlaceholderText = "Nhập Server Key được cấp..."
else
    TextBox.PlaceholderText = "Lỗi kết nối API Server Key!"
end

-- Xử lý sự kiện xác thực khi người dùng nhấn nút
SubmitButton.MouseButton1Click:Connect(function()
    -- Tải lại mã khóa mới nhất từ server để đảm bảo tính cập nhật thời gian thực
    currentServerKey = getServerKey()
    local userEnteredKey = string.gsub(TextBox.Text, "%s+", "")
    
    if not currentServerKey then
        showNotification("Lỗi Hệ Thống", "Không thể truy xuất dữ liệu xác thực từ máy chủ.", 5)
    elseif userEnteredKey == currentServerKey then
        KeyFrame:Destroy()
        showNotification("Thành Công", "Mã khóa chính xác! Đang khởi chạy hệ thống...", 5)
        
        -- Thực thi mã nguồn đích trong một tiến trình độc lập để tối ưu hiệu năng
        task.spawn(function()
            local runSuccess, runError = pcall(function()
                return loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/refs/heads/main/AnDepZaiHubBeta.lua"))()
            end)
            if not runSuccess then
                showNotification("Lỗi Tải Bản Vá", "Không thể nạp dữ liệu từ máy chủ phân phối gốc.", 5)
            end
        end)
        
        -- Khởi tạo nút tương tác nhanh (Ẩn/Hiện) có cấu trúc cố định chống lỗi giao diện
        local InteractionButton = Instance.new("TextButton")
        InteractionButton.Size = UDim2.new(0, 130, 0, 40)
        InteractionButton.Position = UDim2.new(0.5, -65, 0.02, 0)
        InteractionButton.Text = "Ẩn/Hiện Bảng"
        InteractionButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        InteractionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        InteractionButton.TextSize = 14
        InteractionButton.TextFont = Enum.Font.SourceSansBold
        InteractionButton.Parent = ScreenGui
        
        InteractionButton.MouseButton1Click:Connect(function()
            -- Ghi nhận lệnh tương tác hệ thống
            print("Yêu cầu thay đổi trạng thái hiển thị giao diện đã được thực thi.")
        end)
    else
        showNotification("Từ Chối Truy Cập", "Mã khóa không hợp lệ hoặc đã bị thay đổi.", 5)
        TextBox.Text = ""
    end
end)

-- Thông báo bản quyền ban đầu
showNotification("Thông Tin", "Bản quyền thuộc về Ngô Ngọc Hùng", 10)
