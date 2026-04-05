local Amnezia = {}
Amnezia.__index = Amnezia

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer

local T = {
    BG0        = Color3.fromRGB(10, 10, 14),
    BG1        = Color3.fromRGB(15, 15, 21),
    BG2        = Color3.fromRGB(20, 20, 30),
    BG3        = Color3.fromRGB(26, 26, 38),
    BG4        = Color3.fromRGB(32, 32, 48),
    Panel      = Color3.fromRGB(13, 13, 19),
    Accent     = Color3.fromRGB(94, 129, 244),
    AccentDark = Color3.fromRGB(60, 90, 200),
    AccentGlow = Color3.fromRGB(120, 150, 255),
    Purple     = Color3.fromRGB(155, 89, 255),
    Cyan       = Color3.fromRGB(80, 220, 200),
    Border     = Color3.fromRGB(38, 38, 58),
    BorderHi   = Color3.fromRGB(70, 70, 100),
    BorderAcc  = Color3.fromRGB(94, 129, 244),
    Text       = Color3.fromRGB(230, 232, 245),
    TextSub    = Color3.fromRGB(140, 145, 175),
    TextDim    = Color3.fromRGB(75, 80, 110),
    Success    = Color3.fromRGB(80, 220, 140),
    Warning    = Color3.fromRGB(255, 200, 60),
    Error      = Color3.fromRGB(255, 90, 90),
    White      = Color3.fromRGB(255, 255, 255),
    Black      = Color3.fromRGB(0, 0, 0),
}

local function tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 8)
    c.Parent = p
    return c
end

local function stroke(p, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 8)
    u.PaddingBottom = UDim.new(0, b or 8)
    u.PaddingLeft   = UDim.new(0, l or 8)
    u.PaddingRight  = UDim.new(0, r or 8)
    u.Parent = p
    return u
end

local function list(p, dir, spacing)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, spacing or 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = Enum.HorizontalAlignment.Left
    l.VerticalAlignment = Enum.VerticalAlignment.Top
    l.Parent = p
    return l
end

local function frame(parent, props)
    local f = Instance.new("Frame")
    for k, v in pairs(props or {}) do f[k] = v end
    f.Parent = parent
    return f
end

local function label(parent, props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = T.Text
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    for k, v in pairs(props or {}) do l[k] = v end
    l.Parent = parent
    return l
end

local function gradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rot or 90
    g.Parent = parent
    return g
end

local function shadow(parent, size, trans)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.BackgroundTransparency = 1
    s.Size = UDim2.new(1, size or 24, 1, size or 24)
    s.Position = UDim2.new(0, -(size or 24)/2, 0, (size or 12)/2)
    s.ZIndex = (parent.ZIndex or 1) - 1
    s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = T.Black
    s.ImageTransparency = trans or 0.55
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.Parent = parent
    return s
end

local function makeDraggable(win, handle)
    local drag, start, origin = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; start = i.Position; origin = win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            win.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
end

local function saveConfig(data, name)
    pcall(function()
        if writefile then writefile("amnezia_" .. (name or "cfg") .. ".json", HttpService:JSONEncode(data)) end
    end)
end

local function loadConfig(name)
    local ok, v = pcall(function()
        if readfile and isfile then
            local p = "amnezia_" .. (name or "cfg") .. ".json"
            if isfile(p) then return HttpService:JSONDecode(readfile(p)) end
        end
        return {}
    end)
    return ok and v or {}
end

local NotifHolder

local function initNotifs(gui)
    NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifs"
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Size = UDim2.new(0, 340, 1, 0)
    NotifHolder.Position = UDim2.new(1, -350, 0, 0)
    NotifHolder.Parent = gui
    local l = Instance.new("UIListLayout")
    l.FillDirection = Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, 8)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = Enum.HorizontalAlignment.Right
    l.VerticalAlignment = Enum.VerticalAlignment.Bottom
    l.Parent = NotifHolder
end

function Amnezia:Notify(opts)
    opts = opts or {}
    local title    = opts.Title    or "Amnezia"
    local msg      = opts.Message  or ""
    local ntype    = opts.Type     or "info"
    local duration = opts.Duration or 4

    local ac = ({success=T.Success, warning=T.Warning, error=T.Error, info=T.Accent})[ntype] or T.Accent

    local n = Instance.new("Frame")
    n.BackgroundColor3 = T.BG2
    n.Size = UDim2.new(1, 0, 0, 72)
    n.BackgroundTransparency = 0
    n.ClipsDescendants = true
    n.Parent = NotifHolder
    corner(n, UDim.new(0, 10))
    stroke(n, T.Border, 1)
    shadow(n, 16, 0.6)

    local bar = frame(n, {
        BackgroundColor3 = ac,
        Size = UDim2.new(0, 3, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 2,
    })
    corner(bar, UDim.new(0, 3))

    local glow = frame(n, {
        BackgroundColor3 = ac,
        BackgroundTransparency = 0.88,
        Size = UDim2.new(0.5, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 1,
    })
    gradient(glow, ac, Color3.fromRGB(0,0,0), 90)

    local iconBg = frame(n, {
        BackgroundColor3 = ac,
        BackgroundTransparency = 0.75,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(0, 14, 0.5, -15),
        ZIndex = 3,
    })
    corner(iconBg, UDim.new(0, 7))

    local iconStr = ({success="OK", warning="!", error="X", info="i"})[ntype] or "i"
    label(iconBg, {
        Text = iconStr, TextColor3 = ac, Font = Enum.Font.GothamBold,
        TextSize = 13, Size = UDim2.fromScale(1,1), TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 4,
    })

    label(n, {
        Text = title, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
        TextSize = 13, Position = UDim2.new(0, 54, 0, 10),
        Size = UDim2.new(1, -66, 0, 18), ZIndex = 4,
    })
    label(n, {
        Text = msg, TextColor3 = T.TextSub, Font = Enum.Font.Gotham,
        TextSize = 11, Position = UDim2.new(0, 54, 0, 30),
        Size = UDim2.new(1, -66, 0, 30), ZIndex = 4, TextWrapped = true,
    })

    local prog = frame(n, {
        BackgroundColor3 = ac, Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0, ZIndex = 4,
    })
    corner(prog, UDim.new(1, 0))

    n.Position = UDim2.new(1, 20, 1, 0)
    tween(n, {Position = UDim2.new(0, 0, 1, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    tween(prog, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        tween(n, {Position = UDim2.new(1, 20, 1, 0)}, 0.3)
        task.wait(0.35)
        n:Destroy()
    end)
end

local function showIntro(gui)
    local f = frame(gui, {
        BackgroundColor3 = T.BG0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 200,
    })
    gradient(f, T.BG0, Color3.fromRGB(12, 8, 28), 135)

    for i = 1, 10 do
        local gl = frame(f, {
            BackgroundColor3 = T.Accent,
            BackgroundTransparency = 0.96,
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, i/11, 0),
            BorderSizePixel = 0,
            ZIndex = 201,
        })
    end
    for i = 1, 14 do
        local gl = frame(f, {
            BackgroundColor3 = T.Accent,
            BackgroundTransparency = 0.96,
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(i/15, 0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 201,
        })
    end

    local orb = frame(f, {
        BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0.72,
        Size = UDim2.fromOffset(180, 180),
        Position = UDim2.new(0.5, -90, 0.5, -150),
        BorderSizePixel = 0,
        ZIndex = 201,
    })
    corner(orb, UDim.new(1, 0))

    local orb2 = frame(f, {
        BackgroundColor3 = T.Purple,
        BackgroundTransparency = 0.82,
        Size = UDim2.fromOffset(120, 120),
        Position = UDim2.new(0.5, -20, 0.5, -100),
        BorderSizePixel = 0,
        ZIndex = 201,
    })
    corner(orb2, UDim.new(1, 0))

    local titleF = frame(f, {
        BackgroundColor3 = T.BG1,
        BackgroundTransparency = 0.4,
        Size = UDim2.fromOffset(340, 64),
        Position = UDim2.new(0.5, -170, 0.5, -32),
        ZIndex = 203,
    })
    corner(titleF, UDim.new(0, 14))
    stroke(titleF, T.BorderAcc, 1, 0.5)

    local accentTop = frame(titleF, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
        ZIndex = 204,
    })
    corner(accentTop, UDim.new(0, 2))
    gradient(accentTop, T.Purple, T.AccentGlow, 90)

    label(titleF, {
        Text = "AMNEZIA",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 30,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 205,
        TextTransparency = 1,
    })
    label(titleF, {
        Text = "SCRIPT HUB  |  v1.0.0",
        TextColor3 = T.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 44),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 205,
        TextTransparency = 1,
    })

    local loadBg = frame(f, {
        BackgroundColor3 = T.BG2,
        BackgroundTransparency = 0.3,
        Size = UDim2.fromOffset(280, 4),
        Position = UDim2.new(0.5, -140, 0.5, 50),
        BorderSizePixel = 0,
        ZIndex = 203,
        BackgroundTransparency = 1,
    })
    corner(loadBg, UDim.new(1, 0))
    stroke(loadBg, T.Border, 1)

    local loadFill = frame(loadBg, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 204,
    })
    corner(loadFill, UDim.new(1, 0))
    gradient(loadFill, T.Purple, T.AccentGlow, 90)

    local loadLbl = label(f, {
        Text = "Initializing...",
        TextColor3 = T.TextDim,
        Font = Enum.Font.Code,
        TextSize = 10,
        Size = UDim2.fromOffset(280, 16),
        Position = UDim2.new(0.5, -140, 0.5, 60),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 203,
        TextTransparency = 1,
    })

    local titleMain = titleF:FindFirstChildWhichIsA("TextLabel")
    local allLabels = titleF:GetChildren()

    task.spawn(function()
        task.wait(0.15)
        tween(orb, {BackgroundTransparency = 0.82, Size = UDim2.fromOffset(240, 240), Position = UDim2.new(0.5, -120, 0.5, -160)}, 0.7, Enum.EasingStyle.Quart)
        tween(orb2, {BackgroundTransparency = 0.88, Size = UDim2.fromOffset(160, 160)}, 0.6, Enum.EasingStyle.Quart)
        task.wait(0.3)

        for _, c in ipairs(titleF:GetChildren()) do
            if c:IsA("TextLabel") then
                tween(c, {TextTransparency = 0}, 0.45)
                task.wait(0.08)
            end
        end
        tween(loadBg, {BackgroundTransparency = 0.3}, 0.3)
        tween(loadLbl, {TextTransparency = 0.4}, 0.3)

        local steps = {"Loading modules...", "Connecting...", "Applying patches...", "Ready!"}
        for i, s in ipairs(steps) do
            loadLbl.Text = s
            tween(loadFill, {Size = UDim2.new(i/#steps, 0, 1, 0)}, 0.3, Enum.EasingStyle.Quart)
            task.wait(0.32)
        end

        task.wait(0.25)
        tween(f, {BackgroundTransparency = 1}, 0.5)
        for _, c in ipairs(f:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, {TextTransparency = 1}, 0.4)
            elseif c:IsA("Frame") or c:IsA("ImageLabel") then tween(c, {BackgroundTransparency = 1}, 0.4) end
        end
        task.wait(0.55)
        f:Destroy()
    end)

    return 0.15 + 0.3 + 4*0.32 + 0.25 + 0.1
end

local function showKeySystem(gui, reqKey, cb)
    local overlay = frame(gui, {
        BackgroundColor3 = T.Black,
        BackgroundTransparency = 0.5,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 150,
    })

    local panel = frame(overlay, {
        BackgroundColor3 = T.BG1,
        Size = UDim2.fromOffset(400, 260),
        Position = UDim2.new(0.5, -200, 0.5, -130),
        ZIndex = 151,
    })
    corner(panel, UDim.new(0, 14))
    stroke(panel, T.BorderAcc, 1, 0.4)
    shadow(panel, 28, 0.45)

    local topBar = frame(panel, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
        ZIndex = 152,
    })
    corner(topBar, UDim.new(0, 2))
    gradient(topBar, T.Purple, T.AccentGlow, 90)

    local glow = frame(panel, {
        BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0.9,
        Size = UDim2.new(0.6, 0, 0.5, 0),
        Position = UDim2.new(0.2, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 151,
    })
    gradient(glow, T.Accent, Color3.fromRGB(0,0,0), 90)

    label(panel, {
        Text = "ACCESS REQUIRED",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0, 24),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 153,
    })
    label(panel, {
        Text = "Enter your Amnezia key to continue",
        TextColor3 = T.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Size = UDim2.new(1, -40, 0, 18),
        Position = UDim2.new(0, 20, 0, 56),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 153,
    })

    local ibg = frame(panel, {
        BackgroundColor3 = T.BG3,
        Size = UDim2.new(1, -40, 0, 38),
        Position = UDim2.new(0, 20, 0, 90),
        ZIndex = 153,
    })
    corner(ibg, UDim.new(0, 8))
    local ist = stroke(ibg, T.Border, 1)

    local tb = Instance.new("TextBox")
    tb.BackgroundTransparency = 1
    tb.Size = UDim2.new(1, -16, 1, 0)
    tb.Position = UDim2.new(0, 8, 0, 0)
    tb.Font = Enum.Font.Code
    tb.TextSize = 13
    tb.TextColor3 = T.Text
    tb.PlaceholderText = "Access key..."
    tb.PlaceholderColor3 = T.TextDim
    tb.Text = ""
    tb.ClearTextOnFocus = false
    tb.ZIndex = 154
    tb.Parent = ibg

    tb.Focused:Connect(function() tween(ist, {Color = T.Accent}, 0.2) end)
    tb.FocusLost:Connect(function() tween(ist, {Color = T.Border}, 0.2) end)

    local errL = label(panel, {
        Text = "",
        TextColor3 = T.Error,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        Size = UDim2.new(1, -40, 0, 14),
        Position = UDim2.new(0, 20, 0, 136),
        ZIndex = 153,
    })

    local btn = Instance.new("TextButton")
    btn.Text = "CONFIRM"
    btn.TextColor3 = T.White
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BackgroundColor3 = T.Accent
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 158)
    btn.ZIndex = 153
    btn.BorderSizePixel = 0
    btn.Parent = panel
    corner(btn, UDim.new(0, 9))
    gradient(btn, T.AccentDark, T.AccentGlow, 135)
    stroke(btn, T.BorderAcc, 1, 0.5)

    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = T.AccentGlow}, 0.15) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = T.Accent}, 0.15) end)

    btn.MouseButton1Click:Connect(function()
        if tb.Text == reqKey then
            tween(overlay, {BackgroundTransparency = 1}, 0.35)
            tween(panel, {Size = UDim2.fromOffset(400, 0), Position = UDim2.new(0.5, -200, 0.5, 0), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Back)
            task.wait(0.4)
            overlay:Destroy()
            cb(true)
        else
            errL.Text = "Invalid key. Please try again."
            tween(ibg, {BackgroundColor3 = Color3.fromRGB(45, 15, 15)}, 0.15)
            tween(ist, {Color = T.Error}, 0.15)
            task.wait(1.5)
            tween(ibg, {BackgroundColor3 = T.BG3}, 0.3)
            tween(ist, {Color = T.Border}, 0.3)
            task.wait(0.3)
            errL.Text = ""
        end
    end)

    panel.Size = UDim2.fromOffset(400, 0)
    panel.BackgroundTransparency = 1
    tween(panel, {Size = UDim2.fromOffset(400, 260), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Amnezia:CreateWindow(opts)
    opts = opts or {}
    local title     = opts.Title      or "Amnezia"
    local subtitle  = opts.SubTitle   or "Script Hub"
    local key       = opts.Key
    local doIntro   = opts.ShowIntro ~= false
    local W         = opts.Width      or 760
    local H         = opts.Height     or 500
    local cfgName   = opts.ConfigName or "default"

    local gui = Instance.new("ScreenGui")
    gui.Name = "AmneziaUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 1000
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

    initNotifs(gui)

    local win = frame(gui, {
        BackgroundColor3 = T.BG0,
        Size = UDim2.fromOffset(W, H),
        Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
        ZIndex = 10,
        Visible = false,
        ClipsDescendants = false,
    })
    corner(win, UDim.new(0, 14))
    stroke(win, T.Border, 1)
    shadow(win, 36, 0.38)

    local winGrad = frame(win, {
        BackgroundColor3 = T.BG0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 10,
        ClipsDescendants = true,
    })
    corner(winGrad, UDim.new(0, 14))
    gradient(winGrad, T.BG0, Color3.fromRGB(11, 9, 22), 135)

    local topAccent = frame(win, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
        ZIndex = 20,
    })
    corner(topAccent, UDim.new(0, 2))
    gradient(topAccent, T.Purple, T.AccentGlow, 90)

    local sidebar = frame(win, {
        BackgroundColor3 = T.Panel,
        Size = UDim2.new(0, 210, 1, 0),
        ZIndex = 11,
        ClipsDescendants = true,
    })
    corner(sidebar, UDim.new(0, 14))

    local sideRight = frame(sidebar, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 12,
    })

    local sideGlow = frame(sidebar, {
        BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0.93,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        ZIndex = 11,
    })
    gradient(sideGlow, T.Accent, Color3.fromRGB(0,0,0), 180)

    local logoArea = frame(sidebar, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 68),
        ZIndex = 13,
    })

    local logoAccent = frame(logoArea, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.fromOffset(36, 3),
        Position = UDim2.new(0, 16, 1, -10),
        BorderSizePixel = 0,
        ZIndex = 14,
    })
    corner(logoAccent, UDim.new(1, 0))
    gradient(logoAccent, T.Purple, T.AccentGlow, 90)

    label(logoArea, {
        Text = "AMNEZIA",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 19,
        Size = UDim2.new(1, -16, 0, 26),
        Position = UDim2.new(0, 16, 0, 14),
        ZIndex = 14,
    })
    label(logoArea, {
        Text = subtitle,
        TextColor3 = T.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        Size = UDim2.new(1, -16, 0, 14),
        Position = UDim2.new(0, 16, 0, 40),
        ZIndex = 14,
    })

    local divLogoBg = frame(logoArea, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 1, -1),
        BorderSizePixel = 0,
        ZIndex = 13,
    })

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.BackgroundTransparency = 1
    tabScroll.Size = UDim2.new(1, 0, 1, -110)
    tabScroll.Position = UDim2.new(0, 0, 0, 70)
    tabScroll.ScrollBarThickness = 2
    tabScroll.ScrollBarImageColor3 = T.Accent
    tabScroll.CanvasSize = UDim2.new(0,0,0,0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.ZIndex = 13
    tabScroll.Parent = sidebar
    pad(tabScroll, 8, 8, 10, 10)
    list(tabScroll, Enum.FillDirection.Vertical, 3)

    local sideBottom = frame(sidebar, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        Position = UDim2.new(0, 0, 1, -40),
        ZIndex = 13,
    })
    local divBottom = frame(sideBottom, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 13,
    })
    label(sideBottom, {
        Text = "v1.0.0  -  Amnezia",
        TextColor3 = T.TextDim,
        Font = Enum.Font.Code,
        TextSize = 9,
        Size = UDim2.new(1, -16, 0, 26),
        Position = UDim2.new(0, 16, 0, 6),
        ZIndex = 14,
    })

    local header = frame(win, {
        BackgroundColor3 = T.BG1,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(1, -210, 0, 44),
        Position = UDim2.new(0, 210, 0, 0),
        ZIndex = 12,
    })
    local headerDiv = frame(header, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BorderSizePixel = 0,
        ZIndex = 13,
    })

    local activeTabLabel = label(header, {
        Text = title,
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        ZIndex = 13,
    })

    local function makeHeaderBtn(txt, xOffset, hoverCol)
        local b = Instance.new("TextButton")
        b.Text = txt
        b.TextColor3 = T.TextSub
        b.Font = Enum.Font.GothamBold
        b.TextSize = 15
        b.BackgroundTransparency = 1
        b.Size = UDim2.fromOffset(30, 30)
        b.Position = UDim2.new(1, xOffset, 0.5, -15)
        b.ZIndex = 14
        b.BorderSizePixel = 0
        b.Parent = header
        corner(b, UDim.new(0, 6))
        b.MouseEnter:Connect(function()
            tween(b, {BackgroundTransparency = 0.6, TextColor3 = hoverCol}, 0.15)
        end)
        b.MouseLeave:Connect(function()
            tween(b, {BackgroundTransparency = 1, TextColor3 = T.TextSub}, 0.15)
        end)
        return b
    end

    local closeBtn = makeHeaderBtn("x", -10, T.Error)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 18, 18)
    closeBtn.MouseButton1Click:Connect(function()
        tween(win, {Size = UDim2.fromOffset(W, 0), Position = UDim2.new(0.5, -W/2, 0.5, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quart)
        task.wait(0.35)
        gui:Destroy()
    end)

    local minimized = false
    local minBtn = makeHeaderBtn("-", -46, T.TextSub)
    minBtn.TextSize = 20
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(win, {Size = UDim2.fromOffset(210, 44)}, 0.3, Enum.EasingStyle.Quart)
        else
            tween(win, {Size = UDim2.fromOffset(W, H)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end)

    makeDraggable(win, header)

    local content = frame(win, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -210, 1, -44),
        Position = UDim2.new(0, 210, 0, 44),
        ZIndex = 11,
        ClipsDescendants = true,
    })

    local tabs = {}
    local activeTab = nil

    local function activateTab(t)
        if activeTab == t then return end
        if activeTab then
            tween(activeTab.btn, {BackgroundTransparency = 1, BackgroundColor3 = T.BG3}, 0.18)
            tween(activeTab.btnLbl, {TextColor3 = T.TextSub}, 0.18)
            tween(activeTab.indicator, {BackgroundTransparency = 1}, 0.18)
            activeTab.page.Visible = false
        end
        activeTab = t
        tween(t.btn, {BackgroundTransparency = 0, BackgroundColor3 = T.BG3}, 0.2)
        tween(t.btnLbl, {TextColor3 = T.AccentGlow}, 0.2)
        tween(t.indicator, {BackgroundTransparency = 0}, 0.2)
        activeTabLabel.Text = t.name
        t.page.Visible = true
        t.page.Position = UDim2.new(0.03, 0, 0, 0)
        tween(t.page, {Position = UDim2.fromScale(0,0)}, 0.22, Enum.EasingStyle.Quart)
    end

    local Window = {}
    Window._cfg = loadConfig(cfgName)
    Window._cfgName = cfgName

    function Window:AddTab(topts)
        topts = topts or {}
        local name = topts.Name or "Tab"

        local btn = Instance.new("TextButton")
        btn.Text = ""
        btn.BackgroundColor3 = T.BG3
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BorderSizePixel = 0
        btn.ZIndex = 14
        btn.Parent = tabScroll
        corner(btn, UDim.new(0, 7))

        local indicator = frame(btn, {
            BackgroundColor3 = T.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(3, 18),
            Position = UDim2.new(0, 1, 0.5, -9),
            BorderSizePixel = 0,
            ZIndex = 15,
        })
        corner(indicator, UDim.new(1, 0))

        local btnLbl = label(btn, {
            Text = name,
            TextColor3 = T.TextSub,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            Size = UDim2.new(1, -18, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            ZIndex = 15,
        })

        local page = Instance.new("ScrollingFrame")
        page.BackgroundTransparency = 1
        page.Size = UDim2.fromScale(1, 1)
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = T.Accent
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.ZIndex = 12
        page.Parent = content
        pad(page, 14, 14, 14, 14)
        list(page, Enum.FillDirection.Vertical, 10)

        local tabObj = {btn=btn, btnLbl=btnLbl, indicator=indicator, page=page, name=name}
        table.insert(tabs, tabObj)

        btn.MouseEnter:Connect(function()
            if activeTab ~= tabObj then
                tween(btn, {BackgroundTransparency = 0.7}, 0.15)
                tween(btnLbl, {TextColor3 = T.Text}, 0.15)
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab ~= tabObj then
                tween(btn, {BackgroundTransparency = 1}, 0.15)
                tween(btnLbl, {TextColor3 = T.TextSub}, 0.15)
            end
        end)
        btn.MouseButton1Click:Connect(function()
            activateTab(tabObj)
        end)

        if #tabs == 1 then
            activateTab(tabObj)
        end

        local Tab = {}

        function Tab:AddSection(sopts)
            sopts = sopts or {}
            local sname = sopts.Name or "Section"

            local sec = frame(page, {
                BackgroundColor3 = T.BG2,
                BackgroundTransparency = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                ZIndex = 13,
            })
            corner(sec, UDim.new(0, 10))
            stroke(sec, T.Border, 1)

            local secHeader = frame(sec, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 34),
                LayoutOrder = 0,
                ZIndex = 14,
            })

            local sAccent = frame(secHeader, {
                BackgroundColor3 = T.Accent,
                Size = UDim2.fromOffset(3, 14),
                Position = UDim2.new(0, 14, 0.5, -7),
                BorderSizePixel = 0,
                ZIndex = 15,
            })
            corner(sAccent, UDim.new(1, 0))
            gradient(sAccent, T.Purple, T.AccentGlow, 90)

            label(secHeader, {
                Text = string.upper(sname),
                TextColor3 = T.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                Size = UDim2.new(1, -34, 1, 0),
                Position = UDim2.new(0, 24, 0, 0),
                ZIndex = 15,
            })

            local secDiv = frame(secHeader, {
                BackgroundColor3 = T.Border,
                Size = UDim2.new(1, -20, 0, 1),
                Position = UDim2.new(0, 10, 1, -1),
                BorderSizePixel = 0,
                ZIndex = 14,
            })

            local items = frame(sec, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 1,
                ZIndex = 14,
            })
            pad(items, 2, 10, 12, 12)
            list(items, Enum.FillDirection.Vertical, 5)

            local secLayout = Instance.new("UIListLayout")
            secLayout.FillDirection = Enum.FillDirection.Vertical
            secLayout.SortOrder = Enum.SortOrder.LayoutOrder
            secLayout.Parent = sec

            local Section = {}
            local order = 0
            local function nxt() order = order + 1; return order end

            local function makeRow(h)
                local r = frame(items, {
                    BackgroundColor3 = T.BG3,
                    BackgroundTransparency = 0.35,
                    Size = UDim2.new(1, 0, 0, h or 36),
                    BorderSizePixel = 0,
                    ZIndex = 15,
                    LayoutOrder = nxt(),
                })
                corner(r, UDim.new(0, 7))
                stroke(r, T.Border, 1)
                return r
            end

            function Section:AddButton(opts)
                opts = opts or {}
                local n   = opts.Name or "Button"
                local desc = opts.Description
                local cb  = opts.Callback or function() end

                local r = makeRow(desc and 52 or 36)

                local gradBg = frame(r, {
                    BackgroundColor3 = T.Accent,
                    BackgroundTransparency = 0.97,
                    Size = UDim2.fromScale(1, 1),
                    BorderSizePixel = 0,
                    ZIndex = 15,
                })
                corner(gradBg, UDim.new(0, 7))
                gradient(gradBg, T.Accent, Color3.fromRGB(0,0,0), 90)

                label(r, {
                    Text = n,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    Size = UDim2.new(1, -40, 0, 18),
                    Position = UDim2.new(0, 12, 0, desc and 8 or 9),
                    ZIndex = 16,
                })
                if desc then
                    label(r, {
                        Text = desc,
                        TextColor3 = T.TextDim,
                        Font = Enum.Font.Gotham,
                        TextSize = 10,
                        Size = UDim2.new(1, -40, 0, 16),
                        Position = UDim2.new(0, 12, 0, 28),
                        ZIndex = 16,
                    })
                end

                local arr = label(r, {
                    Text = ">",
                    TextColor3 = T.Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -28, 0.5, -10),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 16,
                })

                local click = Instance.new("TextButton")
                click.BackgroundTransparency = 1
                click.Size = UDim2.fromScale(1,1)
                click.Text = ""
                click.ZIndex = 17
                click.Parent = r

                click.MouseEnter:Connect(function()
                    tween(r, {BackgroundTransparency = 0.1, BackgroundColor3 = T.BG4}, 0.15)
                    tween(arr, {TextColor3 = T.AccentGlow}, 0.15)
                    tween(gradBg, {BackgroundTransparency = 0.93}, 0.15)
                end)
                click.MouseLeave:Connect(function()
                    tween(r, {BackgroundTransparency = 0.35, BackgroundColor3 = T.BG3}, 0.15)
                    tween(arr, {TextColor3 = T.Accent}, 0.15)
                    tween(gradBg, {BackgroundTransparency = 0.97}, 0.15)
                end)
                click.MouseButton1Down:Connect(function()
                    tween(r, {BackgroundColor3 = T.BG4, BackgroundTransparency = 0}, 0.1)
                end)
                click.MouseButton1Up:Connect(function()
                    tween(r, {BackgroundColor3 = T.BG3, BackgroundTransparency = 0.35}, 0.15)
                end)
                click.MouseButton1Click:Connect(function()
                    task.spawn(cb)
                end)

                return r
            end

            function Section:AddToggle(opts)
                opts = opts or {}
                local n    = opts.Name or "Toggle"
                local desc = opts.Description
                local def  = opts.Default ~= nil and opts.Default or false
                local cb   = opts.Callback or function() end
                local flag = opts.Flag

                local state = def
                if flag and Window._cfg[flag] ~= nil then state = Window._cfg[flag] end

                local r = makeRow(desc and 52 or 36)

                label(r, {
                    Text = n,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    Size = UDim2.new(1, -66, 0, 18),
                    Position = UDim2.new(0, 12, 0, desc and 8 or 9),
                    ZIndex = 16,
                })
                if desc then
                    label(r, {
                        Text = desc, TextColor3 = T.TextDim, Font = Enum.Font.Gotham,
                        TextSize = 10, Size = UDim2.new(1, -66, 0, 16),
                        Position = UDim2.new(0, 12, 0, 28), ZIndex = 16,
                    })
                end

                local pillBg = frame(r, {
                    BackgroundColor3 = T.BG4,
                    Size = UDim2.fromOffset(42, 22),
                    Position = UDim2.new(1, -52, 0.5, -11),
                    ZIndex = 16,
                })
                corner(pillBg, UDim.new(1, 0))
                local pillStroke = stroke(pillBg, T.Border, 1)

                local pill = frame(pillBg, {
                    BackgroundColor3 = T.TextDim,
                    Size = UDim2.fromOffset(16, 16),
                    ZIndex = 17,
                })
                corner(pill, UDim.new(1, 0))

                local function set(v)
                    state = v
                    if state then
                        tween(pillBg, {BackgroundColor3 = T.Accent}, 0.2)
                        tween(pill, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = T.White}, 0.2, Enum.EasingStyle.Back)
                        tween(pillStroke, {Color = T.Accent}, 0.2)
                    else
                        tween(pillBg, {BackgroundColor3 = T.BG4}, 0.2)
                        tween(pill, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = T.TextDim}, 0.2, Enum.EasingStyle.Back)
                        tween(pillStroke, {Color = T.Border}, 0.2)
                    end
                    if flag then Window._cfg[flag] = v; saveConfig(Window._cfg, Window._cfgName) end
                    task.spawn(cb, v)
                end

                set(state)

                local click = Instance.new("TextButton")
                click.BackgroundTransparency = 1
                click.Size = UDim2.fromScale(1,1)
                click.Text = ""
                click.ZIndex = 18
                click.Parent = r
                click.MouseButton1Click:Connect(function() set(not state) end)

                r.MouseEnter:Connect(function() tween(r, {BackgroundTransparency = 0.1, BackgroundColor3 = T.BG4}, 0.15) end)
                r.MouseLeave:Connect(function() tween(r, {BackgroundTransparency = 0.35, BackgroundColor3 = T.BG3}, 0.15) end)

                return {Set = set, Get = function() return state end}
            end

            function Section:AddSlider(opts)
                opts = opts or {}
                local n    = opts.Name or "Slider"
                local mn   = opts.Min or 0
                local mx   = opts.Max or 100
                local def  = opts.Default ~= nil and opts.Default or mn
                local suf  = opts.Suffix or ""
                local cb   = opts.Callback or function() end
                local flag = opts.Flag

                local val = math.clamp(def, mn, mx)
                if flag and Window._cfg[flag] ~= nil then val = Window._cfg[flag] end

                local r = makeRow(56)

                label(r, {
                    Text = n,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    Size = UDim2.new(0.65, 0, 0, 18),
                    Position = UDim2.new(0, 12, 0, 8),
                    ZIndex = 16,
                })

                local valLbl = label(r, {
                    Text = tostring(math.floor(val)) .. suf,
                    TextColor3 = T.AccentGlow,
                    Font = Enum.Font.Code,
                    TextSize = 12,
                    Size = UDim2.new(0.35, -12, 0, 18),
                    Position = UDim2.new(0.65, 0, 0, 8),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 16,
                })

                local trackBg = frame(r, {
                    BackgroundColor3 = T.BG4,
                    Size = UDim2.new(1, -24, 0, 5),
                    Position = UDim2.new(0, 12, 0, 36),
                    ZIndex = 16,
                })
                corner(trackBg, UDim.new(1, 0))
                stroke(trackBg, T.Border, 1)

                local fill = frame(trackBg, {
                    BackgroundColor3 = T.Accent,
                    Size = UDim2.new((val-mn)/(mx-mn), 0, 1, 0),
                    BorderSizePixel = 0,
                    ZIndex = 17,
                })
                corner(fill, UDim.new(1, 0))
                gradient(fill, T.AccentDark, T.AccentGlow, 90)

                local thumb = frame(trackBg, {
                    BackgroundColor3 = T.White,
                    Size = UDim2.fromOffset(13, 13),
                    ZIndex = 18,
                })
                corner(thumb, UDim.new(1, 0))
                stroke(thumb, T.Accent, 2)

                local function setValue(v)
                    v = math.clamp(math.floor(v + 0.5), mn, mx)
                    val = v
                    local pct = (v-mn)/(mx-mn)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    thumb.Position = UDim2.new(pct, -6, 0.5, -6)
                    valLbl.Text = tostring(v) .. suf
                    if flag then Window._cfg[flag] = v; saveConfig(Window._cfg, Window._cfgName) end
                    task.spawn(cb, v)
                end

                setValue(val)

                local drag = false
                local clickArea = Instance.new("TextButton")
                clickArea.BackgroundTransparency = 1
                clickArea.Size = UDim2.fromScale(1,1)
                clickArea.Text = ""
                clickArea.ZIndex = 19
                clickArea.Parent = trackBg

                clickArea.MouseButton1Down:Connect(function()
                    drag = true
                    tween(thumb, {Size = UDim2.fromOffset(15, 15)}, 0.1)
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = (i.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
                        setValue(mn + (mx - mn) * math.clamp(rel, 0, 1))
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 and drag then
                        drag = false
                        tween(thumb, {Size = UDim2.fromOffset(13, 13)}, 0.1)
                    end
                end)

                r.MouseEnter:Connect(function() tween(r, {BackgroundTransparency = 0.1, BackgroundColor3 = T.BG4}, 0.15) end)
                r.MouseLeave:Connect(function() tween(r, {BackgroundTransparency = 0.35, BackgroundColor3 = T.BG3}, 0.15) end)

                return {Set = setValue, Get = function() return val end}
            end

            function Section:AddDropdown(opts)
                opts = opts or {}
                local n    = opts.Name or "Dropdown"
                local options = opts.Options or {}
                local def  = opts.Default or (options[1] or "")
                local cb   = opts.Callback or function() end
                local flag = opts.Flag

                local sel = def
                if flag and Window._cfg[flag] ~= nil then sel = Window._cfg[flag] end
                local open = false

                local r = frame(items, {
                    BackgroundColor3 = T.BG3,
                    BackgroundTransparency = 0.35,
                    Size = UDim2.new(1, 0, 0, 36),
                    BorderSizePixel = 0,
                    ZIndex = 15,
                    LayoutOrder = nxt(),
                    ClipsDescendants = false,
                })
                corner(r, UDim.new(0, 7))
                stroke(r, T.Border, 1)

                label(r, {
                    Text = n,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    Size = UDim2.new(0.48, 0, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    ZIndex = 16,
                })

                local selLbl = label(r, {
                    Text = sel,
                    TextColor3 = T.AccentGlow,
                    Font = Enum.Font.Code,
                    TextSize = 11,
                    Size = UDim2.new(0.44, -28, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 16,
                })

                local chevLbl = label(r, {
                    Text = "v",
                    TextColor3 = T.TextSub,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -24, 0.5, -10),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 16,
                })

                local panel2 = frame(r, {
                    BackgroundColor3 = T.BG2,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 4),
                    ZIndex = 60,
                    ClipsDescendants = true,
                    Visible = false,
                })
                corner(panel2, UDim.new(0, 8))
                stroke(panel2, T.BorderHi, 1)
                shadow(panel2, 14, 0.5)

                local dScroll = Instance.new("ScrollingFrame")
                dScroll.BackgroundTransparency = 1
                dScroll.Size = UDim2.fromScale(1,1)
                dScroll.ScrollBarThickness = 2
                dScroll.ScrollBarImageColor3 = T.Accent
                dScroll.CanvasSize = UDim2.new(0,0,0,0)
                dScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
                dScroll.ZIndex = 61
                dScroll.Parent = panel2
                pad(dScroll, 4, 4, 6, 6)
                list(dScroll, Enum.FillDirection.Vertical, 2)

                local maxH = math.min(#options * 30 + 8, 160)

                for _, opt in ipairs(options) do
                    local isActive = opt == sel
                    local ob = Instance.new("TextButton")
                    ob.Text = opt
                    ob.TextColor3 = isActive and T.AccentGlow or T.TextSub
                    ob.Font = isActive and Enum.Font.GothamBold or Enum.Font.Gotham
                    ob.TextSize = 12
                    ob.BackgroundColor3 = isActive and T.BG4 or T.BG3
                    ob.BackgroundTransparency = isActive and 0.3 or 1
                    ob.Size = UDim2.new(1, 0, 0, 28)
                    ob.TextXAlignment = Enum.TextXAlignment.Left
                    ob.ZIndex = 62
                    ob.BorderSizePixel = 0
                    ob.Parent = dScroll
                    corner(ob, UDim.new(0, 5))
                    pad(ob, 0, 0, 8, 0)

                    ob.MouseEnter:Connect(function()
                        if opt ~= sel then tween(ob, {BackgroundTransparency = 0.7, TextColor3 = T.Text}, 0.1) end
                    end)
                    ob.MouseLeave:Connect(function()
                        if opt ~= sel then tween(ob, {BackgroundTransparency = 1, TextColor3 = T.TextSub}, 0.1) end
                    end)
                    ob.MouseButton1Click:Connect(function()
                        sel = opt
                        selLbl.Text = opt
                        for _, c in ipairs(dScroll:GetChildren()) do
                            if c:IsA("TextButton") then
                                local a = c.Text == opt
                                tween(c, {BackgroundTransparency = a and 0.3 or 1, TextColor3 = a and T.AccentGlow or T.TextSub}, 0.15)
                            end
                        end
                        open = false
                        tween(panel2, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart)
                        tween(chevLbl, {Rotation = 0}, 0.2)
                        task.wait(0.22)
                        panel2.Visible = false
                        if flag then Window._cfg[flag] = opt; saveConfig(Window._cfg, Window._cfgName) end
                        task.spawn(cb, opt)
                    end)
                end

                local click = Instance.new("TextButton")
                click.BackgroundTransparency = 1
                click.Size = UDim2.fromScale(1,1)
                click.Text = ""
                click.ZIndex = 17
                click.Parent = r
                click.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        panel2.Visible = true
                        panel2.Size = UDim2.new(1, 0, 0, 0)
                        tween(panel2, {Size = UDim2.new(1, 0, 0, maxH)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        tween(chevLbl, {Rotation = 180}, 0.2)
                    else
                        tween(panel2, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart)
                        tween(chevLbl, {Rotation = 0}, 0.2)
                        task.wait(0.22)
                        panel2.Visible = false
                    end
                end)

                r.MouseEnter:Connect(function() tween(r, {BackgroundTransparency = 0.1, BackgroundColor3 = T.BG4}, 0.15) end)
                r.MouseLeave:Connect(function() tween(r, {BackgroundTransparency = 0.35, BackgroundColor3 = T.BG3}, 0.15) end)

                return {Set = function(v) sel = v; selLbl.Text = v end, Get = function() return sel end}
            end

            function Section:AddInput(opts)
                opts = opts or {}
                local n    = opts.Name or "Input"
                local def  = opts.Default or ""
                local ph   = opts.Placeholder or "Type here..."
                local cb   = opts.Callback or function() end
                local flag = opts.Flag

                local r = makeRow(54)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(1, -12, 0, 18),
                    Position = UDim2.new(0, 12, 0, 6), ZIndex = 16,
                })

                local ibg = frame(r, {
                    BackgroundColor3 = T.BG4,
                    Size = UDim2.new(1, -24, 0, 22),
                    Position = UDim2.new(0, 12, 0, 27),
                    ZIndex = 16,
                })
                corner(ibg, UDim.new(0, 5))
                local ist = stroke(ibg, T.Border, 1)

                local tb = Instance.new("TextBox")
                tb.Text = def
                tb.PlaceholderText = ph
                tb.PlaceholderColor3 = T.TextDim
                tb.TextColor3 = T.Text
                tb.Font = Enum.Font.Code
                tb.TextSize = 11
                tb.BackgroundTransparency = 1
                tb.Size = UDim2.new(1, -10, 1, 0)
                tb.Position = UDim2.new(0, 5, 0, 0)
                tb.TextXAlignment = Enum.TextXAlignment.Left
                tb.ClearTextOnFocus = false
                tb.ZIndex = 17
                tb.Parent = ibg

                tb.Focused:Connect(function() tween(ist, {Color = T.Accent}, 0.2) end)
                tb.FocusLost:Connect(function()
                    tween(ist, {Color = T.Border}, 0.2)
                    if flag then Window._cfg[flag] = tb.Text; saveConfig(Window._cfg, Window._cfgName) end
                    task.spawn(cb, tb.Text)
                end)

                r.MouseEnter:Connect(function() tween(r, {BackgroundTransparency = 0.1, BackgroundColor3 = T.BG4}, 0.15) end)
                r.MouseLeave:Connect(function() tween(r, {BackgroundTransparency = 0.35, BackgroundColor3 = T.BG3}, 0.15) end)

                return {Set = function(v) tb.Text = tostring(v) end, Get = function() return tb.Text end}
            end

            function Section:AddLabel(opts)
                opts = opts or {}
                local l2 = label(items, {
                    Text = opts.Text or "",
                    TextColor3 = opts.Color or T.TextSub,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    Size = UDim2.new(1, 0, 0, 18),
                    ZIndex = 15,
                    LayoutOrder = nxt(),
                    TextWrapped = true,
                })
                return {Set = function(v) l2.Text = v end}
            end

            return Section
        end

        return Tab
    end

    local function showMain(d)
        task.delay(d or 0, function()
            win.Visible = true
            win.BackgroundTransparency = 1
            win.Size = UDim2.fromOffset(W * 0.94, H * 0.94)
            win.Position = UDim2.new(0.5, -(W*0.94)/2, 0.5, -(H*0.94)/2)
            tween(win, {
                BackgroundTransparency = 0,
                Size = UDim2.fromOffset(W, H),
                Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
            }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end)
    end

    if doIntro then
        local d = showIntro(gui)
        if key then
            task.delay(d, function()
                showKeySystem(gui, key, function(ok) if ok then showMain(0.1) end end)
            end)
        else
            showMain(d)
        end
    elseif key then
        showKeySystem(gui, key, function(ok) if ok then showMain(0.2) end end)
    else
        showMain(0)
    end

    return Window
end

return Amnezia
