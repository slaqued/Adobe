--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗     ██╗██████╗ 
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║     ██║██╔══██╗
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║     ██║██████╔╝
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║     ██║██╔══██╗
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ███████╗██║██████╔╝
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚══════╝╚═╝╚═════╝ 

    NexusLib v1.0.0 — Premium Roblox UI Library
    Design: Dark Luxury Glassmorphism
    By: [Your Name]
    
    Features:
    ✦ Windows, Tabs, Sections
    ✦ Toggle, Slider, Dropdown, Textbox, Colorpicker, Keybind, Button, Label, Paragraph
    ✦ Notification System
    ✦ Key System (built-in)
    ✦ Config Save / Load
    ✦ Theme System (custom colors)
    ✦ Search bar in dropdowns
    ✦ Dependency system (show/hide elements)
    ✦ Mobile support
    ✦ Smooth animations (TweenService)
    ✦ Watermark
    ✦ Destroy / Unload
--]]

local NexusLib = {}
NexusLib.__index = NexusLib

-- ══════════════════════════════════════════════
-- SERVICES
-- ══════════════════════════════════════════════
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local CoreGui         = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ══════════════════════════════════════════════
-- UTILITIES
-- ══════════════════════════════════════════════
local function Tween(obj, props, duration, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(duration or 0.25, style, dir), props):Play()
end

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Lerp(a, b, t) return a + (b - a) * t end

local function Round(n, d)
    local m = 10^(d or 0)
    return math.floor(n * m + 0.5) / m
end

local function HSVToColor(h, s, v)
    return Color3.fromHSV(h, s, v)
end

-- ══════════════════════════════════════════════
-- DEFAULT THEME
-- ══════════════════════════════════════════════
NexusLib.Theme = {
    -- Backgrounds
    Background       = Color3.fromRGB(10, 10, 14),
    BackgroundAlt    = Color3.fromRGB(16, 16, 22),
    Surface          = Color3.fromRGB(20, 20, 28),
    SurfaceHover     = Color3.fromRGB(26, 26, 36),
    SurfaceActive    = Color3.fromRGB(30, 30, 42),
    
    -- Borders
    Border           = Color3.fromRGB(40, 40, 58),
    BorderLight      = Color3.fromRGB(55, 55, 78),
    
    -- Accent
    Accent           = Color3.fromRGB(110, 86, 255),
    AccentDim        = Color3.fromRGB(80, 60, 200),
    AccentGlow       = Color3.fromRGB(140, 110, 255),
    AccentSecondary  = Color3.fromRGB(255, 86, 160),
    
    -- Text
    TextPrimary      = Color3.fromRGB(240, 240, 248),
    TextSecondary    = Color3.fromRGB(160, 160, 190),
    TextMuted        = Color3.fromRGB(90, 90, 120),
    TextAccent       = Color3.fromRGB(130, 100, 255),
    
    -- States
    Success          = Color3.fromRGB(60, 220, 130),
    Warning          = Color3.fromRGB(255, 190, 60),
    Error            = Color3.fromRGB(255, 70, 90),
    Info             = Color3.fromRGB(60, 160, 255),
    
    -- Misc
    Topbar           = Color3.fromRGB(14, 14, 20),
    Shadow           = Color3.fromRGB(0, 0, 0),
    Scrollbar        = Color3.fromRGB(50, 50, 70),
    
    -- Fonts
    Font             = Enum.Font.GothamMedium,
    FontBold         = Enum.Font.GothamBold,
    FontLight        = Enum.Font.Gotham,
}

-- ══════════════════════════════════════════════
-- ICONS (rbxassetid or unicode)
-- ══════════════════════════════════════════════
NexusLib.Icons = {
    Close    = "rbxassetid://7072725342",
    Minimize = "rbxassetid://7072719338",
    Search   = "rbxassetid://6031094678",
    Home     = "rbxassetid://6022668888",
    Settings = "rbxassetid://6022668898",
    Key      = "rbxassetid://6031280882",
    Bell     = "rbxassetid://6022668914",
    Check    = "rbxassetid://6022668906",
    Arrow    = "rbxassetid://6022668888",
    Plus     = "rbxassetid://6022668912",
    Color    = "rbxassetid://6022668908",
}

-- ══════════════════════════════════════════════
-- INTERNAL STATE
-- ══════════════════════════════════════════════
NexusLib.Flags        = {}
NexusLib.Signals      = {}
NexusLib.UnloadCBs    = {}
NexusLib.ConfigFile   = "NexusLib_Config"
NexusLib.ConfigFolder = "NexusLib"
NexusLib.Loaded       = false
NexusLib.Windows      = {}

-- ══════════════════════════════════════════════
-- ROOT GUI
-- ══════════════════════════════════════════════
local ScreenGui
do
    local ok = pcall(function()
        ScreenGui = Create("ScreenGui", {
            Name             = "NexusLib",
            ZIndexBehavior   = Enum.ZIndexBehavior.Global,
            ResetOnSpawn     = false,
            DisplayOrder     = 999,
        })
        if gethui then
            ScreenGui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = CoreGui
        else
            ScreenGui.Parent = CoreGui
        end
    end)
    if not ok then
        ScreenGui = Create("ScreenGui", {
            Name           = "NexusLib",
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ResetOnSpawn   = false,
            DisplayOrder   = 999,
            Parent         = LocalPlayer:WaitForChild("PlayerGui"),
        })
    end
end

NexusLib.ScreenGui = ScreenGui

-- ══════════════════════════════════════════════
-- DRAGGING UTILITY
-- ══════════════════════════════════════════════
local function MakeDraggable(frame, dragZone)
    dragZone = dragZone or frame
    local dragging, dragInput, startPos, startFramePos

    dragZone.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragZone.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(
                startFramePos.X.Scale,
                startFramePos.X.Offset + delta.X,
                startFramePos.Y.Scale,
                startFramePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ══════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════════════════
local NotifContainer = Create("Frame", {
    Name              = "NotifContainer",
    Size              = UDim2.new(0, 320, 1, 0),
    Position          = UDim2.new(1, -330, 0, 0),
    BackgroundTransparency = 1,
    Parent            = ScreenGui,
})
Create("UIListLayout", {
    SortOrder         = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding           = UDim.new(0, 8),
    Parent            = NotifContainer,
})
Create("UIPadding", {
    PaddingBottom = UDim.new(0, 16),
    Parent = NotifContainer,
})

function NexusLib:Notify(opts)
    opts = opts or {}
    local title    = opts.Title   or "Notification"
    local content  = opts.Content or ""
    local duration = opts.Duration or 5
    local ntype    = opts.Type    or "Info" -- Info, Success, Warning, Error
    local icon     = opts.Icon

    local T = NexusLib.Theme
    local accentColor = T[ntype] or T.Info

    local notif = Create("Frame", {
        Name              = "Notif",
        Size              = UDim2.new(1, 0, 0, 0),
        BackgroundColor3  = T.Surface,
        BackgroundTransparency = 0.05,
        BorderSizePixel   = 0,
        ClipsDescendants  = true,
        Parent            = NotifContainer,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = notif })
    Create("UIStroke", { Color = accentColor, Thickness = 1, Transparency = 0.5, Parent = notif })

    -- Accent bar left
    local bar = Create("Frame", {
        Size             = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        Parent           = notif,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = bar })

    -- Content
    local inner = Create("Frame", {
        Position         = UDim2.new(0, 14, 0, 0),
        Size             = UDim2.new(1, -14, 1, 0),
        BackgroundTransparency = 1,
        Parent           = notif,
    })
    Create("UIPadding", {
        PaddingTop    = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingRight  = UDim.new(0, 12),
        Parent        = inner,
    })

    local titleLabel = Create("TextLabel", {
        Size            = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text            = title,
        TextColor3      = T.TextPrimary,
        TextSize        = 14,
        Font            = T.FontBold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        Parent          = inner,
    })
    local contentLabel = Create("TextLabel", {
        Position        = UDim2.new(0, 0, 0, 22),
        Size            = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text            = content,
        TextColor3      = T.TextSecondary,
        TextSize        = 12,
        Font            = T.Font,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Top,
        TextWrapped     = true,
        Parent          = inner,
    })

    -- Progress bar
    local progressBg = Create("Frame", {
        Position         = UDim2.new(0, 0, 1, -3),
        Size             = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        Parent           = notif,
    })
    local progress = Create("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        Parent           = progressBg,
    })

    -- Animate in
    notif.Size = UDim2.new(1, 0, 0, 0)
    Tween(notif, { Size = UDim2.new(1, 0, 0, 78) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Tween(progress, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        Tween(notif, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.3)
        task.delay(0.35, function() notif:Destroy() end)
    end)

    return notif
end

-- ══════════════════════════════════════════════
-- CONFIG SAVE / LOAD
-- ══════════════════════════════════════════════
function NexusLib:SaveConfig(name)
    if not (writefile and makefolder and isfolder) then return end
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
    local data = {}
    for flag, obj in pairs(self.Flags) do
        if obj.Value ~= nil then
            local val = obj.Value
            if typeof(val) == "Color3" then
                val = { r = val.R, g = val.G, b = val.B }
            elseif typeof(val) == "EnumItem" then
                val = tostring(val)
            end
            data[flag] = val
        end
    end
    local ok, err = pcall(writefile, self.ConfigFolder.."/"..( name or self.ConfigFile )..".ncfg", HttpService:JSONEncode(data))
    if not ok then warn("NexusLib: Failed to save config —", err) end
end

function NexusLib:LoadConfig(name)
    if not (readfile and isfile) then return end
    local path = self.ConfigFolder.."/"..( name or self.ConfigFile )..".ncfg"
    if not isfile(path) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data) ~= "table" then return end
    for flag, val in pairs(data) do
        if self.Flags[flag] then
            if type(val) == "table" and val.r then
                val = Color3.new(val.r, val.g, val.b)
            end
            pcall(function() self.Flags[flag]:Set(val) end)
        end
    end
end

-- ══════════════════════════════════════════════
-- KEY SYSTEM
-- ══════════════════════════════════════════════
function NexusLib:KeySystem(opts)
    opts = opts or {}
    local keys      = opts.Keys or {}
    local title     = opts.Title or "Key Required"
    local subtitle  = opts.Subtitle or "Enter your access key to continue"
    local link      = opts.Link or ""
    local onSuccess = opts.Callback or function() end

    local T = NexusLib.Theme

    local bg = Create("Frame", {
        Name              = "KeySystem",
        Size              = UDim2.new(1, 0, 1, 0),
        BackgroundColor3  = Color3.fromRGB(5, 5, 8),
        BackgroundTransparency = 0,
        ZIndex            = 999,
        Parent            = ScreenGui,
    })

    -- Blur effect simulation (gradient overlay)
    local glow = Create("Frame", {
        Size             = UDim2.new(0, 400, 0, 400),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0.85,
        BorderSizePixel  = 0,
        ZIndex           = 999,
        Parent           = bg,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = glow })

    local card = Create("Frame", {
        Name              = "Card",
        Size              = UDim2.new(0, 400, 0, 240),
        AnchorPoint       = Vector2.new(0.5, 0.5),
        Position          = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3  = T.Surface,
        BackgroundTransparency = 0.05,
        BorderSizePixel   = 0,
        ZIndex            = 1000,
        Parent            = bg,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = card })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = card })

    Create("TextLabel", {
        Size            = UDim2.new(1, 0, 0, 32),
        Position        = UDim2.new(0, 0, 0, 28),
        BackgroundTransparency = 1,
        Text            = title,
        TextColor3      = T.TextPrimary,
        TextSize        = 20,
        Font            = T.FontBold,
        ZIndex          = 1001,
        Parent          = card,
    })
    Create("TextLabel", {
        Size            = UDim2.new(1, -40, 0, 24),
        Position        = UDim2.new(0, 20, 0, 60),
        BackgroundTransparency = 1,
        Text            = subtitle,
        TextColor3      = T.TextSecondary,
        TextSize        = 13,
        Font            = T.Font,
        TextWrapped     = true,
        ZIndex          = 1001,
        Parent          = card,
    })

    -- Input
    local inputBg = Create("Frame", {
        Size             = UDim2.new(1, -40, 0, 44),
        Position         = UDim2.new(0, 20, 0, 108),
        BackgroundColor3 = T.BackgroundAlt,
        BorderSizePixel  = 0,
        ZIndex           = 1001,
        Parent           = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = inputBg })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = inputBg })

    local inputBox = Create("TextBox", {
        Size                = UDim2.new(1, -20, 1, 0),
        Position            = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                = "",
        PlaceholderText     = "Enter key...",
        TextColor3          = T.TextPrimary,
        PlaceholderColor3   = T.TextMuted,
        TextSize            = 14,
        Font                = T.Font,
        ClearTextOnFocus    = false,
        ZIndex              = 1002,
        Parent              = inputBg,
    })

    -- Status label
    local statusLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -40, 0, 18),
        Position        = UDim2.new(0, 20, 0, 158),
        BackgroundTransparency = 1,
        Text            = link ~= "" and ("Get key: "..link) or "",
        TextColor3      = T.TextMuted,
        TextSize        = 11,
        Font            = T.Font,
        ZIndex          = 1001,
        Parent          = card,
    })

    -- Confirm button
    local confirmBtn = Create("TextButton", {
        Size             = UDim2.new(1, -40, 0, 40),
        Position         = UDim2.new(0, 20, 0, 186),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        Text             = "Continue",
        TextColor3       = T.TextPrimary,
        TextSize         = 14,
        Font             = T.FontBold,
        ZIndex           = 1001,
        Parent           = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = confirmBtn })

    -- Animate card in
    card.Position = UDim2.new(0.5, 0, 0.6, 0)
    card.BackgroundTransparency = 1
    Tween(card, {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 0.05,
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    confirmBtn.MouseButton1Click:Connect(function()
        local entered = inputBox.Text
        local valid = false
        for _, k in ipairs(keys) do
            if entered == k then valid = true break end
        end
        if valid then
            statusLabel.Text = "✓ Access granted"
            statusLabel.TextColor3 = T.Success
            Tween(confirmBtn, { BackgroundColor3 = T.Success }, 0.3)
            task.delay(0.8, function()
                Tween(bg, { BackgroundTransparency = 1 }, 0.4)
                task.delay(0.45, function()
                    bg:Destroy()
                    onSuccess()
                end)
            end)
        else
            statusLabel.Text = "✗ Invalid key"
            statusLabel.TextColor3 = T.Error
            Tween(inputBg, { BackgroundColor3 = Color3.fromRGB(60, 20, 20) }, 0.15)
            task.delay(0.3, function()
                Tween(inputBg, { BackgroundColor3 = T.BackgroundAlt }, 0.3)
            end)
        end
    end)

    return bg
end

-- ══════════════════════════════════════════════
-- CREATE WINDOW
-- ══════════════════════════════════════════════
function NexusLib:CreateWindow(opts)
    opts = opts or {}
    local title       = opts.Title       or "NexusLib"
    local subtitle    = opts.Subtitle    or ""
    local size        = opts.Size        or Vector2.new(600, 440)
    local menuKey     = opts.MenuKeybind or Enum.KeyCode.RightControl
    local configSave  = opts.ConfigurationSaving or false
    local configFile  = opts.FileName    or "config"
    local icon        = opts.Icon        or ""

    if configSave then
        self.ConfigFile = configFile
        task.delay(1, function() self:LoadConfig(configFile) end)
    end

    local T = NexusLib.Theme
    local Window = {}
    local tabList = {}
    local selectedTab = nil

    -- ── Main Frame ─────────────────────────────
    local mainFrame = Create("Frame", {
        Name              = "NexusWindow",
        Size              = UDim2.new(0, size.X, 0, size.Y),
        Position          = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2),
        BackgroundColor3  = T.Background,
        BorderSizePixel   = 0,
        ClipsDescendants  = true,
        Parent            = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = mainFrame })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = mainFrame })

    -- Drop shadow
    local shadow = Create("ImageLabel", {
        Name              = "Shadow",
        Size              = UDim2.new(1, 40, 1, 40),
        Position          = UDim2.new(0, -20, 0, -14),
        BackgroundTransparency = 1,
        Image             = "rbxassetid://6014261993",
        ImageColor3       = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType         = Enum.ScaleType.Slice,
        SliceCenter       = Rect.new(49, 49, 450, 450),
        ZIndex            = -1,
        Parent            = mainFrame,
    })

    -- Animated open
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.new(0, size.X * 0.92, 0, size.Y * 0.92)
    Tween(mainFrame, {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, size.X, 0, size.Y),
    }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- ── Sidebar ────────────────────────────────
    local sidebar = Create("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = T.BackgroundAlt,
        BorderSizePixel  = 0,
        Parent           = mainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = sidebar })
    -- Fix right corners
    Create("Frame", {
        Size             = UDim2.new(0, 14, 1, 0),
        Position         = UDim2.new(1, -14, 0, 0),
        BackgroundColor3 = T.BackgroundAlt,
        BorderSizePixel  = 0,
        Parent           = sidebar,
    })

    -- Sidebar accent line
    Create("Frame", {
        Size             = UDim2.new(0, 1, 1, -40),
        Position         = UDim2.new(1, -1, 0, 20),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        Parent           = sidebar,
    })

    -- Logo area
    local logoArea = Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 72),
        BackgroundTransparency = 1,
        Parent           = sidebar,
    })
    Create("UIPadding", { PaddingLeft = UDim.new(0, 16), PaddingTop = UDim.new(0, 16), Parent = logoArea })

    -- Accent dot
    local dot = Create("Frame", {
        Size             = UDim2.new(0, 8, 0, 8),
        Position         = UDim2.new(0, 0, 0, 6),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        Parent           = logoArea,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })

    Create("TextLabel", {
        Size            = UDim2.new(1, -18, 0, 20),
        Position        = UDim2.new(0, 18, 0, 0),
        BackgroundTransparency = 1,
        Text            = title,
        TextColor3      = T.TextPrimary,
        TextSize        = 16,
        Font            = T.FontBold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        Parent          = logoArea,
    })
    if subtitle ~= "" then
        Create("TextLabel", {
            Size            = UDim2.new(1, -18, 0, 14),
            Position        = UDim2.new(0, 18, 0, 22),
            BackgroundTransparency = 1,
            Text            = subtitle,
            TextColor3      = T.TextMuted,
            TextSize        = 11,
            Font            = T.Font,
            TextXAlignment  = Enum.TextXAlignment.Left,
            Parent          = logoArea,
        })
    end

    -- Tab list (sidebar)
    local tabListFrame = Create("ScrollingFrame", {
        Position          = UDim2.new(0, 0, 0, 76),
        Size              = UDim2.new(1, 0, 1, -100),
        BackgroundTransparency = 1,
        BorderSizePixel   = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Scrollbar,
        CanvasSize        = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent            = sidebar,
    })
    Create("UIListLayout", {
        SortOrder         = Enum.SortOrder.LayoutOrder,
        Padding           = UDim.new(0, 4),
        Parent            = tabListFrame,
    })
    Create("UIPadding", {
        PaddingLeft   = UDim.new(0, 10),
        PaddingRight  = UDim.new(0, 10),
        PaddingTop    = UDim.new(0, 4),
        Parent        = tabListFrame,
    })

    -- Bottom: version / close
    local bottomBar = Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 28),
        Position         = UDim2.new(0, 0, 1, -28),
        BackgroundTransparency = 1,
        Parent           = sidebar,
    })
    Create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingBottom = UDim.new(0, 6), Parent = bottomBar })
    Create("TextLabel", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "NexusLib v1.0",
        TextColor3      = T.TextMuted,
        TextSize        = 10,
        Font            = T.Font,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Bottom,
        Parent          = bottomBar,
    })

    -- ── Topbar ─────────────────────────────────
    local topbar = Create("Frame", {
        Name             = "Topbar",
        Size             = UDim2.new(1, -180, 0, 44),
        Position         = UDim2.new(0, 180, 0, 0),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel  = 0,
        Parent           = mainFrame,
    })
    -- Bottom border on topbar
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        Parent           = topbar,
    })

    -- Tab name in topbar
    local topTabName = Create("TextLabel", {
        Size            = UDim2.new(1, -120, 1, 0),
        Position        = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text            = "",
        TextColor3      = T.TextPrimary,
        TextSize        = 14,
        Font            = T.FontBold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        Parent          = topbar,
    })

    -- Close button
    local closeBtn = Create("TextButton", {
        Size             = UDim2.new(0, 32, 0, 32),
        Position         = UDim2.new(1, -40, 0, 6),
        BackgroundColor3 = Color3.fromRGB(255, 60, 80),
        BackgroundTransparency = 0.4,
        BorderSizePixel  = 0,
        Text             = "✕",
        TextColor3       = T.TextPrimary,
        TextSize         = 13,
        Font             = T.FontBold,
        Parent           = topbar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = closeBtn })

    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainFrame, { Size = UDim2.new(0, size.X * 0.9, 0, size.Y * 0.9), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function() mainFrame:Destroy() end)
        if configSave then self:SaveConfig(configFile) end
    end)

    -- Minimize button
    local minimizeBtn = Create("TextButton", {
        Size             = UDim2.new(0, 32, 0, 32),
        Position         = UDim2.new(1, -80, 0, 6),
        BackgroundColor3 = T.SurfaceHover,
        BorderSizePixel  = 0,
        Text             = "—",
        TextColor3       = T.TextSecondary,
        TextSize         = 14,
        Font             = T.FontBold,
        Parent           = topbar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = minimizeBtn })

    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(mainFrame, { Size = UDim2.new(0, size.X, 0, 44) }, 0.3)
        else
            Tween(mainFrame, { Size = UDim2.new(0, size.X, 0, size.Y) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end)

    -- ── Content Area ────────────────────────────
    local contentArea = Create("Frame", {
        Name             = "ContentArea",
        Size             = UDim2.new(1, -180, 1, -44),
        Position         = UDim2.new(0, 180, 0, 44),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent           = mainFrame,
    })

    -- Make draggable
    MakeDraggable(mainFrame, topbar)

    -- Toggle visibility with keybind
    local visible = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == menuKey then
            visible = not visible
            mainFrame.Visible = visible
        end
    end)

    -- ══════════════════════════════════════════
    -- TAB CREATION
    -- ══════════════════════════════════════════
    function Window:CreateTab(tabOpts)
        tabOpts = tabOpts or {}
        local tabName  = tabOpts.Name  or "Tab"
        local tabIcon  = tabOpts.Icon  or ""

        local Tab = {}
        local sectionList = {}

        -- Sidebar button
        local tabBtn = Create("TextButton", {
            Name             = "TabBtn_"..tabName,
            Size             = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = T.Surface,
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            Text             = "",
            Parent           = tabListFrame,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = tabBtn })

        -- Active indicator bar
        local indicator = Create("Frame", {
            Size             = UDim2.new(0, 3, 0, 18),
            Position         = UDim2.new(0, -1, 0.5, -9),
            BackgroundColor3 = T.Accent,
            BorderSizePixel  = 0,
            Visible          = false,
            Parent           = tabBtn,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = indicator })

        local tabLabel = Create("TextLabel", {
            Size            = UDim2.new(1, -16, 1, 0),
            Position        = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1,
            Text            = tabName,
            TextColor3      = T.TextMuted,
            TextSize        = 13,
            Font            = T.Font,
            TextXAlignment  = Enum.TextXAlignment.Left,
            Parent          = tabBtn,
        })

        -- Content frame for this tab
        local tabContent = Create("ScrollingFrame", {
            Name              = "Tab_"..tabName,
            Size              = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel   = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = T.Scrollbar,
            CanvasSize        = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible           = false,
            Parent            = contentArea,
        })
        Create("UIListLayout", {
            SortOrder    = Enum.SortOrder.LayoutOrder,
            Padding      = UDim.new(0, 10),
            Parent       = tabContent,
        })
        Create("UIPadding", {
            PaddingLeft   = UDim.new(0, 14),
            PaddingRight  = UDim.new(0, 14),
            PaddingTop    = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 14),
            Parent        = tabContent,
        })

        local function SelectTab()
            if selectedTab then
                -- Deselect old
                Tween(selectedTab.btn, { BackgroundTransparency = 1 }, 0.2)
                Tween(selectedTab.label, { TextColor3 = T.TextMuted, Font = T.Font }, 0.2)
                selectedTab.indicator.Visible = false
                selectedTab.content.Visible = false
            end
            selectedTab = { btn = tabBtn, label = tabLabel, indicator = indicator, content = tabContent }
            tabContent.Visible = true
            indicator.Visible  = true
            Tween(tabBtn, { BackgroundTransparency = 0.85 }, 0.2)
            tabLabel.Font = T.FontBold
            Tween(tabLabel, { TextColor3 = T.TextPrimary }, 0.2)
            topTabName.Text = tabName

            -- Slide in animation
            tabContent.Position = UDim2.new(0.05, 0, 0, 0)
            tabContent.BackgroundTransparency = 1
            Tween(tabContent, { Position = UDim2.new(0, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quart)
        end

        tabBtn.MouseButton1Click:Connect(SelectTab)
        tabBtn.MouseEnter:Connect(function()
            if selectedTab and selectedTab.btn ~= tabBtn then
                Tween(tabBtn, { BackgroundTransparency = 0.92 }, 0.15)
                Tween(tabLabel, { TextColor3 = T.TextSecondary }, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if selectedTab and selectedTab.btn ~= tabBtn then
                Tween(tabBtn, { BackgroundTransparency = 1 }, 0.15)
                Tween(tabLabel, { TextColor3 = T.TextMuted }, 0.15)
            end
        end)

        table.insert(tabList, { btn = tabBtn, content = tabContent })
        if #tabList == 1 then SelectTab() end

        -- ════════════════════════════════════
        -- SECTION CREATION
        -- ════════════════════════════════════
        function Tab:CreateSection(sectionOpts)
            sectionOpts = sectionOpts or {}
            local sectionName = sectionOpts.Name or ""

            local Section = {}

            local sectionFrame = Create("Frame", {
                Name             = "Section_"..sectionName,
                Size             = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = T.Surface,
                BackgroundTransparency = 0.3,
                BorderSizePixel  = 0,
                AutomaticSize    = Enum.AutomaticSize.Y,
                Parent           = tabContent,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sectionFrame })
            Create("UIStroke", { Color = T.Border, Thickness = 1, Transparency = 0.5, Parent = sectionFrame })

            local elemList = Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize    = Enum.AutomaticSize.Y,
                Parent           = sectionFrame,
            })
            Create("UIListLayout", {
                SortOrder    = Enum.SortOrder.LayoutOrder,
                Padding      = UDim.new(0, 0),
                Parent       = elemList,
            })
            Create("UIPadding", {
                PaddingLeft   = UDim.new(0, 0),
                PaddingRight  = UDim.new(0, 0),
                PaddingTop    = UDim.new(0, sectionName ~= "" and 36 or 8),
                PaddingBottom = UDim.new(0, 8),
                Parent        = elemList,
            })

            if sectionName ~= "" then
                local header = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 36),
                    Position         = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent           = sectionFrame,
                })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingTop = UDim.new(0, 10), Parent = header })

                -- Accent line
                local accentLine = Create("Frame", {
                    Size             = UDim2.new(0, 3, 0, 14),
                    Position         = UDim2.new(0, 0, 0, 10),
                    BackgroundColor3 = T.Accent,
                    BorderSizePixel  = 0,
                    Parent           = header,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = accentLine })

                Create("TextLabel", {
                    Size            = UDim2.new(1, -20, 0, 16),
                    Position        = UDim2.new(0, 14, 0, 10),
                    BackgroundTransparency = 1,
                    Text            = sectionName,
                    TextColor3      = T.TextSecondary,
                    TextSize        = 11,
                    Font            = T.FontBold,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = header,
                })

                -- Separator
                Create("Frame", {
                    Size             = UDim2.new(1, -28, 0, 1),
                    Position         = UDim2.new(0, 14, 1, -1),
                    BackgroundColor3 = T.Border,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel  = 0,
                    Parent           = header,
                })
            end

            -- ════════════════════════════
            -- ELEMENT BUILDER (internal)
            -- ════════════════════════════
            local function MakeElement(h)
                local elem = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, h or 44),
                    BackgroundTransparency = 1,
                    Parent           = elemList,
                })
                -- Hover highlight
                local highlight = Create("Frame", {
                    Size             = UDim2.new(1, -2, 1, 0),
                    Position         = UDim2.new(0, 1, 0, 0),
                    BackgroundColor3 = T.SurfaceHover,
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    ZIndex           = 0,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = highlight })
                Create("UIPadding", {
                    PaddingLeft  = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14),
                    Parent       = elem,
                })
                elem.MouseEnter:Connect(function() Tween(highlight, { BackgroundTransparency = 0.96 }, 0.15) end)
                elem.MouseLeave:Connect(function() Tween(highlight, { BackgroundTransparency = 1 }, 0.15) end)
                return elem, highlight
            end

            -- ════════════════════════════
            -- BUTTON
            -- ════════════════════════════
            function Section:CreateButton(o)
                o = o or {}
                local elem, hl = MakeElement(44)
                
                Create("TextLabel", {
                    Size            = UDim2.new(0.6, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text            = o.Name or "Button",
                    TextColor3      = T.TextPrimary,
                    TextSize        = 13,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })
                if o.Description then
                    Create("TextLabel", {
                        Size            = UDim2.new(0.6, 0, 0, 16),
                        Position        = UDim2.new(0, 14, 0, 26),
                        BackgroundTransparency = 1,
                        Text            = o.Description,
                        TextColor3      = T.TextMuted,
                        TextSize        = 11,
                        Font            = T.Font,
                        TextXAlignment  = Enum.TextXAlignment.Left,
                        Parent          = elem,
                    })
                    elem.Size = UDim2.new(1, 0, 0, 58)
                end

                local btn = Create("TextButton", {
                    Size             = UDim2.new(0, 88, 0, 30),
                    Position         = UDim2.new(1, -102, 0.5, -15),
                    BackgroundColor3 = T.Accent,
                    BackgroundTransparency = 0.1,
                    BorderSizePixel  = 0,
                    Text             = o.Label or "Execute",
                    TextColor3       = T.TextPrimary,
                    TextSize         = 12,
                    Font             = T.FontBold,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = btn })

                btn.MouseButton1Click:Connect(function()
                    Tween(btn, { BackgroundColor3 = T.AccentGlow }, 0.1)
                    task.delay(0.15, function() Tween(btn, { BackgroundColor3 = T.Accent }, 0.2) end)
                    if o.Callback then pcall(o.Callback) end
                end)
                btn.MouseEnter:Connect(function() Tween(btn, { BackgroundTransparency = 0 }, 0.15) end)
                btn.MouseLeave:Connect(function() Tween(btn, { BackgroundTransparency = 0.1 }, 0.15) end)

                local B = {}
                function B:SetTitle(t) end
                return B
            end

            -- ════════════════════════════
            -- TOGGLE
            -- ════════════════════════════
            function Section:CreateToggle(o)
                o = o or {}
                local elem, hl = MakeElement(44)
                local flagId   = o.Flag or o.Name
                local state    = o.Default or false
                local callback = o.Callback or function() end

                Create("TextLabel", {
                    Size            = UDim2.new(0.7, 0, 0, 18),
                    Position        = UDim2.new(0, 14, 0, 8),
                    BackgroundTransparency = 1,
                    Text            = o.Name or "Toggle",
                    TextColor3      = T.TextPrimary,
                    TextSize        = 13,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })
                if o.Description then
                    Create("TextLabel", {
                        Size            = UDim2.new(0.7, 0, 0, 14),
                        Position        = UDim2.new(0, 14, 0, 26),
                        BackgroundTransparency = 1,
                        Text            = o.Description,
                        TextColor3      = T.TextMuted,
                        TextSize        = 11,
                        Font            = T.Font,
                        TextXAlignment  = Enum.TextXAlignment.Left,
                        Parent          = elem,
                    })
                    elem.Size = UDim2.new(1, 0, 0, 54)
                end

                -- Toggle track
                local track = Create("Frame", {
                    Size             = UDim2.new(0, 40, 0, 22),
                    Position         = UDim2.new(1, -54, 0.5, -11),
                    BackgroundColor3 = state and T.Accent or T.Border,
                    BorderSizePixel  = 0,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

                -- Thumb
                local thumb = Create("Frame", {
                    Size             = UDim2.new(0, 16, 0, 16),
                    Position         = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = T.TextPrimary,
                    BorderSizePixel  = 0,
                    Parent           = track,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })

                local T_obj = {}
                T_obj.Value = state

                local function SetToggle(val)
                    state = val
                    T_obj.Value = val
                    Tween(track, { BackgroundColor3 = val and T.Accent or T.Border }, 0.2)
                    Tween(thumb, { Position = val and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, 0.2)
                    pcall(callback, val)
                end

                function T_obj:Set(v) SetToggle(v) end

                if flagId then NexusLib.Flags[flagId] = T_obj end

                local clickArea = Create("TextButton", {
                    Size                = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                = "",
                    ZIndex              = 5,
                    Parent              = elem,
                })
                clickArea.MouseButton1Click:Connect(function() SetToggle(not state) end)

                return T_obj
            end

            -- ════════════════════════════
            -- SLIDER
            -- ════════════════════════════
            function Section:CreateSlider(o)
                o = o or {}
                local flagId   = o.Flag or o.Name
                local min      = o.Range and o.Range[1] or 0
                local max      = o.Range and o.Range[2] or 100
                local default  = o.Default or min
                local suffix   = o.Suffix or ""
                local decimals = o.Decimals or 0
                local callback = o.Callback or function() end

                local elem, hl = MakeElement(56)

                Create("TextLabel", {
                    Size            = UDim2.new(0.7, 0, 0, 18),
                    Position        = UDim2.new(0, 14, 0, 6),
                    BackgroundTransparency = 1,
                    Text            = o.Name or "Slider",
                    TextColor3      = T.TextPrimary,
                    TextSize        = 13,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local valueLabel = Create("TextLabel", {
                    Size            = UDim2.new(0.3, -14, 0, 18),
                    Position        = UDim2.new(0.7, 0, 0, 6),
                    BackgroundTransparency = 1,
                    Text            = tostring(default)..suffix,
                    TextColor3      = T.TextAccent,
                    TextSize        = 13,
                    Font            = T.FontBold,
                    TextXAlignment  = Enum.TextXAlignment.Right,
                    Parent          = elem,
                })

                -- Track
                local trackBg = Create("Frame", {
                    Size             = UDim2.new(1, -28, 0, 5),
                    Position         = UDim2.new(0, 14, 0, 34),
                    BackgroundColor3 = T.Border,
                    BorderSizePixel  = 0,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackBg })

                local fillPct = (default - min) / (max - min)
                local fill = Create("Frame", {
                    Size             = UDim2.new(fillPct, 0, 1, 0),
                    BackgroundColor3 = T.Accent,
                    BorderSizePixel  = 0,
                    Parent           = trackBg,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

                -- Thumb
                local thumbBtn = Create("Frame", {
                    Size             = UDim2.new(0, 14, 0, 14),
                    Position         = UDim2.new(fillPct, -7, 0.5, -7),
                    BackgroundColor3 = T.TextPrimary,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = trackBg,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumbBtn })
                Create("UIStroke", { Color = T.Accent, Thickness = 2, Parent = thumbBtn })

                local S_obj = {}
                S_obj.Value = default

                local function SetSlider(val)
                    val = math.clamp(Round(val, decimals), min, max)
                    S_obj.Value = val
                    local pct = (val - min) / (max - min)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    thumbBtn.Position = UDim2.new(pct, -7, 0.5, -7)
                    valueLabel.Text = tostring(val)..suffix
                    pcall(callback, val)
                end

                function S_obj:Set(v) SetSlider(v) end
                if flagId then NexusLib.Flags[flagId] = S_obj end

                local dragging = false
                trackBg.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                        local absPos  = trackBg.AbsolutePosition.X
                        local absSize = trackBg.AbsoluteSize.X
                        local pct = math.clamp((inp.Position.X - absPos) / absSize, 0, 1)
                        SetSlider(min + (max - min) * pct)
                    end
                end)

                return S_obj
            end

            -- ════════════════════════════
            -- DROPDOWN
            -- ════════════════════════════
            function Section:CreateDropdown(o)
                o = o or {}
                local flagId   = o.Flag or o.Name
                local options  = o.Options or {}
                local default  = o.Default
                local multi    = o.MultiSelect or false
                local callback = o.Callback or function() end

                local currentVal = multi and {} or (default or (options[1] or "None"))
                local open = false

                local elem, hl = MakeElement(44)

                Create("TextLabel", {
                    Size            = UDim2.new(0.5, 0, 0, 18),
                    Position        = UDim2.new(0, 14, 0.5, -9),
                    BackgroundTransparency = 1,
                    Text            = o.Name or "Dropdown",
                    TextColor3      = T.TextPrimary,
                    TextSize        = 13,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local displayBtn = Create("TextButton", {
                    Size             = UDim2.new(0, 140, 0, 28),
                    Position         = UDim2.new(1, -154, 0.5, -14),
                    BackgroundColor3 = T.BackgroundAlt,
                    BorderSizePixel  = 0,
                    Text             = multi and "None" or tostring(currentVal),
                    TextColor3       = T.TextSecondary,
                    TextSize         = 12,
                    Font             = T.Font,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = displayBtn })
                Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = displayBtn })

                -- Arrow
                local arrow = Create("TextLabel", {
                    Size            = UDim2.new(0, 16, 1, 0),
                    Position        = UDim2.new(1, -20, 0, 0),
                    BackgroundTransparency = 1,
                    Text            = "▾",
                    TextColor3      = T.TextMuted,
                    TextSize        = 12,
                    Font            = T.Font,
                    Parent          = displayBtn,
                })

                -- Dropdown menu (shown below)
                local menuFrame = Create("Frame", {
                    Size             = UDim2.new(0, 140, 0, 0),
                    Position         = UDim2.new(1, -154, 1, 4),
                    BackgroundColor3 = T.BackgroundAlt,
                    BorderSizePixel  = 0,
                    ClipsDescendants = true,
                    ZIndex           = 20,
                    Visible          = false,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = menuFrame })
                Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = menuFrame })

                local menuScroll = Create("ScrollingFrame", {
                    Size              = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel   = 0,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = T.Scrollbar,
                    CanvasSize        = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex            = 21,
                    Parent            = menuFrame,
                })
                Create("UIListLayout", {
                    SortOrder  = Enum.SortOrder.LayoutOrder,
                    Padding    = UDim.new(0, 2),
                    Parent     = menuScroll,
                })
                Create("UIPadding", {
                    PaddingLeft   = UDim.new(0, 4),
                    PaddingRight  = UDim.new(0, 4),
                    PaddingTop    = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    Parent        = menuScroll,
                })

                local D_obj = {}
                D_obj.Value = currentVal

                local function UpdateDisplay()
                    if multi then
                        local count = 0
                        for _ in pairs(currentVal) do count = count + 1 end
                        displayBtn.Text = count == 0 and "None" or (count.." selected")
                    else
                        displayBtn.Text = tostring(currentVal)
                    end
                end

                local function BuildMenu()
                    for _, child in ipairs(menuScroll:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local isSelected = multi and currentVal[opt] or (currentVal == opt)
                        local optBtn = Create("TextButton", {
                            Size             = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = isSelected and T.SurfaceActive or T.Surface,
                            BackgroundTransparency = isSelected and 0.3 or 0.8,
                            BorderSizePixel  = 0,
                            Text             = opt,
                            TextColor3       = isSelected and T.TextAccent or T.TextSecondary,
                            TextSize         = 12,
                            Font             = isSelected and T.FontBold or T.Font,
                            ZIndex           = 22,
                            Parent           = menuScroll,
                        })
                        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = optBtn })

                        optBtn.MouseButton1Click:Connect(function()
                            if multi then
                                if currentVal[opt] then
                                    currentVal[opt] = nil
                                else
                                    currentVal[opt] = true
                                end
                                D_obj.Value = currentVal
                                pcall(callback, currentVal)
                            else
                                currentVal = opt
                                D_obj.Value = opt
                                pcall(callback, opt)
                                -- Close
                                open = false
                                Tween(menuFrame, { Size = UDim2.new(0, 140, 0, 0) }, 0.2)
                                task.delay(0.22, function() menuFrame.Visible = false end)
                                Tween(arrow, { Rotation = 0 }, 0.2)
                            end
                            UpdateDisplay()
                            BuildMenu()
                        end)
                    end
                end

                BuildMenu()

                displayBtn.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        menuFrame.Visible = true
                        local h = math.min(#options * 30 + 8, 160)
                        Tween(menuFrame, { Size = UDim2.new(0, 140, 0, h) }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Tween(arrow, { Rotation = 180 }, 0.2)
                    else
                        Tween(menuFrame, { Size = UDim2.new(0, 140, 0, 0) }, 0.2)
                        task.delay(0.22, function() menuFrame.Visible = false end)
                        Tween(arrow, { Rotation = 0 }, 0.2)
                    end
                end)

                function D_obj:Set(v)
                    currentVal = v
                    UpdateDisplay()
                    BuildMenu()
                end
                function D_obj:Refresh(newOptions)
                    options = newOptions
                    BuildMenu()
                end

                if flagId then NexusLib.Flags[flagId] = D_obj end
                UpdateDisplay()
                return D_obj
            end

            -- ════════════════════════════
            -- TEXTBOX
            -- ════════════════════════════
            function Section:CreateInput(o)
                o = o or {}
                local flagId     = o.Flag or o.Name
                local default    = o.Default or ""
                local placeholder= o.Placeholder or "Type here..."
                local numeric    = o.Numeric or false
                local finished   = o.Finished or false
                local callback   = o.Callback or function() end

                local elem, hl = MakeElement(44)

                Create("TextLabel", {
                    Size            = UDim2.new(0.4, 0, 0, 18),
                    Position        = UDim2.new(0, 14, 0.5, -9),
                    BackgroundTransparency = 1,
                    Text            = o.Name or "Input",
                    TextColor3      = T.TextPrimary,
                    TextSize        = 13,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local inputBg = Create("Frame", {
                    Size             = UDim2.new(0, 160, 0, 30),
                    Position         = UDim2.new(1, -174, 0.5, -15),
                    BackgroundColor3 = T.BackgroundAlt,
                    BorderSizePixel  = 0,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = inputBg })
                Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = inputBg })

                local inputBox = Create("TextBox", {
                    Size                = UDim2.new(1, -16, 1, 0),
                    Position            = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency = 1,
                    Text                = default,
                    PlaceholderText     = placeholder,
                    TextColor3          = T.TextPrimary,
                    PlaceholderColor3   = T.TextMuted,
                    TextSize            = 12,
                    Font                = T.Font,
                    ClearTextOnFocus    = false,
                    TextXAlignment      = Enum.TextXAlignment.Left,
                    ZIndex              = 3,
                    Parent              = inputBg,
                })

                local I_obj = {}
                I_obj.Value = default

                inputBox.Focused:Connect(function() Tween(inputBg, { BackgroundColor3 = T.SurfaceActive }, 0.15) end)
                inputBox.FocusLost:Connect(function(enter)
                    Tween(inputBg, { BackgroundColor3 = T.BackgroundAlt }, 0.15)
                    if not finished or enter then
                        local val = numeric and (tonumber(inputBox.Text) or 0) or inputBox.Text
                        I_obj.Value = val
                        pcall(callback, val)
                    end
                end)
                if not finished then
                    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local val = numeric and (tonumber(inputBox.Text) or 0) or inputBox.Text
                        I_obj.Value = val
                        pcall(callback, val)
                    end)
                end

                function I_obj:Set(v) inputBox.Text = tostring(v) I_obj.Value = v end
                if flagId then NexusLib.Flags[flagId] = I_obj end
                return I_obj
            end

            -- ════════════════════════════
            -- LABEL
            -- ════════════════════════════
            function Section:CreateLabel(o)
                o = o or {}
                local elem = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    Parent           = elemList,
                })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), Parent = elem })

                local lbl = Create("TextLabel", {
                    Size            = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text            = o.Name or o.Text or "Label",
                    TextColor3      = o.Color or T.TextSecondary,
                    TextSize        = o.TextSize or 12,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    TextWrapped     = true,
                    Parent          = elem,
                })

                local L_obj = {}
                function L_obj:Set(text) lbl.Text = text end
                function L_obj:SetColor(c) lbl.TextColor3 = c end
                return L_obj
            end

            -- ════════════════════════════
            -- PARAGRAPH
            -- ════════════════════════════
            function Section:CreateParagraph(o)
                o = o or {}
                local elem = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Parent           = elemList,
                })
                Create("UIPadding", {
                    PaddingLeft   = UDim.new(0, 14),
                    PaddingRight  = UDim.new(0, 14),
                    PaddingTop    = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    Parent        = elem,
                })
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = elem })

                if o.Title then
                    Create("TextLabel", {
                        Size            = UDim2.new(1, 0, 0, 16),
                        BackgroundTransparency = 1,
                        Text            = o.Title,
                        TextColor3      = T.TextPrimary,
                        TextSize        = 13,
                        Font            = T.FontBold,
                        TextXAlignment  = Enum.TextXAlignment.Left,
                        Parent          = elem,
                    })
                end

                local contentLbl = Create("TextLabel", {
                    Size            = UDim2.new(1, 0, 0, 0),
                    AutomaticSize   = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text            = o.Content or "",
                    TextColor3      = T.TextSecondary,
                    TextSize        = 12,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    TextWrapped     = true,
                    Parent          = elem,
                })

                local P_obj = {}
                function P_obj:Set(content) contentLbl.Text = content end
                return P_obj
            end

            -- ════════════════════════════
            -- KEYBIND
            -- ════════════════════════════
            function Section:CreateKeybind(o)
                o = o or {}
                local flagId   = o.Flag or o.Name
                local default  = o.Default or Enum.KeyCode.Unknown
                local callback = o.Callback or function() end
                local current  = default
                local binding  = false

                local elem, hl = MakeElement(44)

                Create("TextLabel", {
                    Size            = UDim2.new(0.6, 0, 0, 18),
                    Position        = UDim2.new(0, 14, 0.5, -9),
                    BackgroundTransparency = 1,
                    Text            = o.Name or "Keybind",
                    TextColor3      = T.TextPrimary,
                    TextSize        = 13,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local keyBtn = Create("TextButton", {
                    Size             = UDim2.new(0, 90, 0, 28),
                    Position         = UDim2.new(1, -104, 0.5, -14),
                    BackgroundColor3 = T.BackgroundAlt,
                    BorderSizePixel  = 0,
                    Text             = tostring(current).."",
                    TextColor3       = T.TextAccent,
                    TextSize         = 12,
                    Font             = T.FontBold,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = keyBtn })
                Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = keyBtn })

                local K_obj = {}
                K_obj.Value = current

                keyBtn.MouseButton1Click:Connect(function()
                    binding = true
                    keyBtn.Text = "..."
                    keyBtn.TextColor3 = T.Warning
                    Tween(keyBtn, { BackgroundColor3 = T.SurfaceActive }, 0.15)
                end)

                UserInputService.InputBegan:Connect(function(inp, proc)
                    if binding and inp.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        current = inp.KeyCode
                        K_obj.Value = current
                        local name = tostring(inp.KeyCode):gsub("Enum.KeyCode.", "")
                        keyBtn.Text = name
                        keyBtn.TextColor3 = T.TextAccent
                        Tween(keyBtn, { BackgroundColor3 = T.BackgroundAlt }, 0.15)
                        pcall(callback, current)
                    elseif not proc and inp.KeyCode == current and not binding then
                        pcall(callback, current)
                    end
                end)

                function K_obj:Set(v)
                    current = v
                    K_obj.Value = v
                    local name = tostring(v):gsub("Enum.KeyCode.", "")
                    keyBtn.Text = name
                end
                if flagId then NexusLib.Flags[flagId] = K_obj end
                return K_obj
            end

            -- ════════════════════════════
            -- COLORPICKER
            -- ════════════════════════════
            function Section:CreateColorpicker(o)
                o = o or {}
                local flagId   = o.Flag or o.Name
                local default  = o.Default or Color3.fromRGB(255, 255, 255)
                local callback = o.Callback or function() end
                local currentColor = default
                local pickerOpen = false

                local elem, hl = MakeElement(44)

                Create("TextLabel", {
                    Size            = UDim2.new(0.7, 0, 0, 18),
                    Position        = UDim2.new(0, 14, 0.5, -9),
                    BackgroundTransparency = 1,
                    Text            = o.Name or "Color",
                    TextColor3      = T.TextPrimary,
                    TextSize        = 13,
                    Font            = T.Font,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local colorPreview = Create("TextButton", {
                    Size             = UDim2.new(0, 30, 0, 30),
                    Position         = UDim2.new(1, -44, 0.5, -15),
                    BackgroundColor3 = currentColor,
                    BorderSizePixel  = 0,
                    Text             = "",
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = colorPreview })
                Create("UIStroke", { Color = T.Border, Thickness = 2, Parent = colorPreview })

                -- Simple picker popup
                local pickerFrame = Create("Frame", {
                    Size             = UDim2.new(0, 200, 0, 0),
                    Position         = UDim2.new(1, -214, 1, 6),
                    BackgroundColor3 = T.Surface,
                    BorderSizePixel  = 0,
                    ClipsDescendants = true,
                    ZIndex           = 25,
                    Visible          = false,
                    Parent           = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = pickerFrame })
                Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = pickerFrame })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = pickerFrame })
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = pickerFrame })

                -- Hue label
                Create("TextLabel", { Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = "Hue · Saturation · Value", TextColor3 = T.TextMuted, TextSize = 10, Font = T.Font, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 26, Parent = pickerFrame })

                -- Sliders for H S V
                local h, s, v = Color3.toHSV(currentColor)
                local sliderData = { { "H", h }, { "S", s }, { "V", v } }
                local hsvValues = { h, s, v }

                local function UpdateColor()
                    currentColor = Color3.fromHSV(hsvValues[1], hsvValues[2], hsvValues[3])
                    colorPreview.BackgroundColor3 = currentColor
                    pcall(callback, currentColor)
                end

                for i, sd in ipairs(sliderData) do
                    local sRow = Create("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, ZIndex = 26, Parent = pickerFrame })
                    Create("TextLabel", { Size = UDim2.new(0, 12, 1, 0), BackgroundTransparency = 1, Text = sd[1], TextColor3 = T.TextMuted, TextSize = 11, Font = T.FontBold, ZIndex = 26, Parent = sRow })
                    local sBg = Create("Frame", { Size = UDim2.new(1, -20, 0, 5), Position = UDim2.new(0, 18, 0.5, -3), BackgroundColor3 = T.Border, BorderSizePixel = 0, ZIndex = 26, Parent = sRow })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sBg })
                    local sFill = Create("Frame", { Size = UDim2.new(hsvValues[i], 0, 1, 0), BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 27, Parent = sBg })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sFill })
                    local sThumb = Create("Frame", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(hsvValues[i], -5, 0.5, -5), BackgroundColor3 = T.TextPrimary, BorderSizePixel = 0, ZIndex = 28, Parent = sBg })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sThumb })

                    local sDragging = false
                    sBg.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sDragging = true end end)
                    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sDragging = false end end)
                    UserInputService.InputChanged:Connect(function(inp)
                        if sDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                            local pct = math.clamp((inp.Position.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X, 0, 1)
                            hsvValues[i] = pct
                            sFill.Size = UDim2.new(pct, 0, 1, 0)
                            sThumb.Position = UDim2.new(pct, -5, 0.5, -5)
                            UpdateColor()
                        end
                    end)
                end

                colorPreview.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    if pickerOpen then
                        pickerFrame.Visible = true
                        Tween(pickerFrame, { Size = UDim2.new(0, 200, 0, 140) }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    else
                        Tween(pickerFrame, { Size = UDim2.new(0, 200, 0, 0) }, 0.2)
                        task.delay(0.22, function() pickerFrame.Visible = false end)
                    end
                end)

                local C_obj = {}
                C_obj.Value = currentColor
                function C_obj:Set(col)
                    currentColor = col
                    colorPreview.BackgroundColor3 = col
                    C_obj.Value = col
                end
                if flagId then NexusLib.Flags[flagId] = C_obj end
                return C_obj
            end

            -- ════════════════════════════
            -- SEPARATOR
            -- ════════════════════════════
            function Section:AddSeparator()
                Create("Frame", {
                    Size             = UDim2.new(1, -28, 0, 1),
                    BackgroundColor3 = T.Border,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel  = 0,
                    Parent           = elemList,
                })
            end

            return Section
        end -- CreateSection

        return Tab
    end -- CreateTab

    -- WATERMARK
    function Window:CreateWatermark(o)
        o = o or {}
        local wm = Create("Frame", {
            Name             = "Watermark",
            Size             = UDim2.new(0, 0, 0, 28),
            AutomaticSize    = Enum.AutomaticSize.X,
            Position         = UDim2.new(0, 12, 0, 12),
            BackgroundColor3 = T.Surface,
            BackgroundTransparency = 0.1,
            BorderSizePixel  = 0,
            Parent           = ScreenGui,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = wm })
        Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = wm })
        Create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = wm })

        local wmLabel = Create("TextLabel", {
            Size            = UDim2.new(0, 0, 1, 0),
            AutomaticSize   = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text            = o.Text or (title.." | "..subtitle),
            TextColor3      = T.TextSecondary,
            TextSize         = 12,
            Font            = T.Font,
            Parent           = wm,
        })

        local W_obj = {}
        function W_obj:Set(text) wmLabel.Text = text end
        function W_obj:Destroy() wm:Destroy() end
        return W_obj
    end

    -- DESTROY
    function Window:Destroy()
        if configSave then NexusLib:SaveConfig(configFile) end
        for _, cb in ipairs(NexusLib.UnloadCBs) do pcall(cb) end
        Tween(mainFrame, { BackgroundTransparency = 1, Size = UDim2.new(0, size.X * 0.9, 0, size.Y * 0.9) }, 0.3)
        task.delay(0.35, function() mainFrame:Destroy() end)
    end

    table.insert(NexusLib.Windows, Window)
    return Window
end

-- ══════════════════════════════════════════════
-- THEME SETTER
-- ══════════════════════════════════════════════
function NexusLib:SetTheme(custom)
    for k, v in pairs(custom) do
        if self.Theme[k] ~= nil then
            self.Theme[k] = v
        end
    end
end

-- ══════════════════════════════════════════════
-- ON UNLOAD
-- ══════════════════════════════════════════════
function NexusLib:OnUnload(cb)
    table.insert(self.UnloadCBs, cb)
end

function NexusLib:Unload()
    for _, cb in ipairs(self.UnloadCBs) do pcall(cb) end
    ScreenGui:Destroy()
end

-- ══════════════════════════════════════════════
return NexusLib
