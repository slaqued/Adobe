--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            AMNEZIA  UI  LIBRARY  —  v2.0.0               ║
    ║         Modern • Animated • Feature-Rich                  ║
    ╚═══════════════════════════════════════════════════════════╝

    NOUVEAUTÉS v2.0.0 :
    ─────────────────────────────────────────────────────────────
    • Animation de fermeture refaite (shatter / dissolve effect)
    • Theming complet : plusieurs thèmes intégrés + custom
    • AddColorPicker — sélecteur de couleur HSV + hex
    • AddKeybind     — capture de touche clavier
    • AddMultiDropdown — sélection multiple dans un dropdown
    • AddProgressBar — barre de progression animée dynamique
    • AddSeparator   — séparateur visuel stylisé
    • AddImage       — affichage d'image / icône rbxassetid
    • Search / Filter — barre de recherche dans les onglets
    • Résumé d'état (Window:GetAllValues)
    • Tooltip au survol (opts.Tooltip)
    • Indicateur de chargement (Window:SetLoading)
    • Minimap des onglets (icônes optionnelles par tab)
    • Animations d'entrée par section (slide-in)
    • Ripple effect sur les boutons
    • Dégradés animés sur l'accent top bar
    • Fermeture/minimisation avec raccourci clavier (RightCtrl)
    • Callbacks onTabChanged, onClose sur la fenêtre
    • Config multi-profil + reset
    • Border glow pulsé sur les éléments actifs
    ─────────────────────────────────────────────────────────────
]]

local Amnezia = {}
Amnezia.__index = Amnezia

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")

local LP = Players.LocalPlayer

-- ─────────────────────────────────────────────
--  THEMES
-- ─────────────────────────────────────────────
local Themes = {
    Dark = {
        BG0        = Color3.fromRGB(8, 8, 12),
        BG1        = Color3.fromRGB(13, 13, 19),
        BG2        = Color3.fromRGB(18, 18, 28),
        BG3        = Color3.fromRGB(24, 24, 36),
        BG4        = Color3.fromRGB(30, 30, 46),
        Panel      = Color3.fromRGB(10, 10, 16),
        Accent     = Color3.fromRGB(94, 129, 244),
        AccentDark = Color3.fromRGB(55, 85, 195),
        AccentGlow = Color3.fromRGB(130, 160, 255),
        Accent2    = Color3.fromRGB(155, 89, 255),
        Accent3    = Color3.fromRGB(80, 220, 200),
        Border     = Color3.fromRGB(35, 35, 55),
        BorderHi   = Color3.fromRGB(65, 65, 95),
        BorderAcc  = Color3.fromRGB(94, 129, 244),
        Text       = Color3.fromRGB(230, 232, 245),
        TextSub    = Color3.fromRGB(140, 145, 175),
        TextDim    = Color3.fromRGB(70, 75, 105),
        Success    = Color3.fromRGB(70, 210, 130),
        Warning    = Color3.fromRGB(255, 195, 55),
        Error      = Color3.fromRGB(255, 80, 80),
        White      = Color3.fromRGB(255, 255, 255),
        Black      = Color3.fromRGB(0, 0, 0),
    },
    Midnight = {
        BG0        = Color3.fromRGB(5, 5, 10),
        BG1        = Color3.fromRGB(10, 10, 18),
        BG2        = Color3.fromRGB(14, 14, 24),
        BG3        = Color3.fromRGB(18, 18, 32),
        BG4        = Color3.fromRGB(24, 24, 42),
        Panel      = Color3.fromRGB(7, 7, 13),
        Accent     = Color3.fromRGB(180, 100, 255),
        AccentDark = Color3.fromRGB(120, 60, 200),
        AccentGlow = Color3.fromRGB(210, 140, 255),
        Accent2    = Color3.fromRGB(100, 200, 255),
        Accent3    = Color3.fromRGB(255, 100, 180),
        Border     = Color3.fromRGB(30, 25, 50),
        BorderHi   = Color3.fromRGB(60, 50, 90),
        BorderAcc  = Color3.fromRGB(180, 100, 255),
        Text       = Color3.fromRGB(235, 230, 255),
        TextSub    = Color3.fromRGB(145, 135, 175),
        TextDim    = Color3.fromRGB(70, 65, 100),
        Success    = Color3.fromRGB(70, 210, 130),
        Warning    = Color3.fromRGB(255, 195, 55),
        Error      = Color3.fromRGB(255, 80, 80),
        White      = Color3.fromRGB(255, 255, 255),
        Black      = Color3.fromRGB(0, 0, 0),
    },
    Ocean = {
        BG0        = Color3.fromRGB(5, 10, 18),
        BG1        = Color3.fromRGB(8, 15, 26),
        BG2        = Color3.fromRGB(10, 20, 34),
        BG3        = Color3.fromRGB(14, 26, 44),
        BG4        = Color3.fromRGB(18, 32, 54),
        Panel      = Color3.fromRGB(6, 11, 20),
        Accent     = Color3.fromRGB(0, 200, 220),
        AccentDark = Color3.fromRGB(0, 140, 165),
        AccentGlow = Color3.fromRGB(60, 230, 240),
        Accent2    = Color3.fromRGB(0, 120, 255),
        Accent3    = Color3.fromRGB(0, 255, 180),
        Border     = Color3.fromRGB(15, 35, 55),
        BorderHi   = Color3.fromRGB(30, 65, 95),
        BorderAcc  = Color3.fromRGB(0, 200, 220),
        Text       = Color3.fromRGB(220, 235, 245),
        TextSub    = Color3.fromRGB(130, 160, 180),
        TextDim    = Color3.fromRGB(60, 85, 110),
        Success    = Color3.fromRGB(70, 210, 130),
        Warning    = Color3.fromRGB(255, 195, 55),
        Error      = Color3.fromRGB(255, 80, 80),
        White      = Color3.fromRGB(255, 255, 255),
        Black      = Color3.fromRGB(0, 0, 0),
    },
    Rose = {
        BG0        = Color3.fromRGB(12, 8, 10),
        BG1        = Color3.fromRGB(18, 12, 15),
        BG2        = Color3.fromRGB(24, 16, 20),
        BG3        = Color3.fromRGB(30, 20, 26),
        BG4        = Color3.fromRGB(38, 25, 32),
        Panel      = Color3.fromRGB(10, 6, 8),
        Accent     = Color3.fromRGB(255, 100, 150),
        AccentDark = Color3.fromRGB(200, 60, 110),
        AccentGlow = Color3.fromRGB(255, 150, 190),
        Accent2    = Color3.fromRGB(255, 180, 80),
        Accent3    = Color3.fromRGB(180, 100, 255),
        Border     = Color3.fromRGB(45, 28, 36),
        BorderHi   = Color3.fromRGB(75, 48, 60),
        BorderAcc  = Color3.fromRGB(255, 100, 150),
        Text       = Color3.fromRGB(245, 230, 235),
        TextSub    = Color3.fromRGB(175, 140, 155),
        TextDim    = Color3.fromRGB(95, 65, 80),
        Success    = Color3.fromRGB(70, 210, 130),
        Warning    = Color3.fromRGB(255, 195, 55),
        Error      = Color3.fromRGB(255, 80, 80),
        White      = Color3.fromRGB(255, 255, 255),
        Black      = Color3.fromRGB(0, 0, 0),
    },
}

-- Thème actif (modifiable via Window:SetTheme)
local T = {}
for k, v in pairs(Themes.Dark) do T[k] = v end

-- ─────────────────────────────────────────────
--  UTILITIES
-- ─────────────────────────────────────────────

local function tween(obj, props, t, style, dir)
    local ok, tw = pcall(function()
        return TweenService:Create(obj, TweenInfo.new(
            t or 0.22,
            style or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out
        ), props)
    end)
    if ok and tw then tw:Play() end
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

local function gradient3(parent, c0, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c0),
        ColorSequenceKeypoint.new(0.5, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
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

-- Tooltip universel
local _tooltipFrame, _tooltipLabel
local function initTooltip(gui)
    _tooltipFrame = frame(gui, {
        BackgroundColor3 = T.BG4,
        Size = UDim2.fromOffset(160, 26),
        Visible = false,
        ZIndex = 9999,
        BorderSizePixel = 0,
    })
    corner(_tooltipFrame, UDim.new(0, 6))
    stroke(_tooltipFrame, T.BorderAcc, 1, 0.3)
    _tooltipLabel = label(_tooltipFrame, {
        Text = "",
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10000,
    })
end

local function attachTooltip(obj, text, gui)
    if not text or text == "" then return end
    local showing = false
    obj.MouseEnter:Connect(function()
        if not _tooltipFrame then return end
        _tooltipLabel.Text = text
        -- auto-resize
        local tw = math.max(80, #text * 7 + 16)
        _tooltipFrame.Size = UDim2.fromOffset(tw, 26)
        showing = true
        _tooltipFrame.Visible = true
        _tooltipFrame.BackgroundTransparency = 1
        tween(_tooltipFrame, {BackgroundTransparency = 0}, 0.15)
    end)
    obj.MouseLeave:Connect(function()
        showing = false
        if _tooltipFrame then _tooltipFrame.Visible = false end
    end)
    if RunService then
        RunService.RenderStepped:Connect(function()
            if showing and _tooltipFrame then
                local mp = UserInputService:GetMouseLocation()
                _tooltipFrame.Position = UDim2.fromOffset(mp.X + 12, mp.Y + 8)
            end
        end)
    end
end

-- Ripple effect
local function ripple(parent, x, y)
    local rip = frame(parent, {
        BackgroundColor3 = T.White,
        BackgroundTransparency = 0.75,
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(x - parent.AbsolutePosition.X, y - parent.AbsolutePosition.Y),
        ZIndex = parent.ZIndex + 10,
        BorderSizePixel = 0,
        ClipsDescendants = false,
    })
    corner(rip, UDim.new(1, 0))
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.2
    tween(rip, {Size = UDim2.fromOffset(size, size), Position = UDim2.fromOffset(
        x - parent.AbsolutePosition.X - size/2,
        y - parent.AbsolutePosition.Y - size/2
    ), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quad)
    task.delay(0.55, function() rip:Destroy() end)
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

-- ─────────────────────────────────────────────
--  NOTIFICATIONS
-- ─────────────────────────────────────────────
local NotifHolder

local function initNotifs(gui)
    NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifs"
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Size = UDim2.new(0, 360, 1, 0)
    NotifHolder.Position = UDim2.new(1, -370, 0, 0)
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
    local icon     = opts.Icon

    local ac = ({success=T.Success, warning=T.Warning, error=T.Error, info=T.Accent})[ntype] or T.Accent
    local iconMap = {success="✓", warning="!", error="✕", info="i"}

    local n = Instance.new("Frame")
    n.BackgroundColor3 = T.BG2
    n.Size = UDim2.new(1, 0, 0, 76)
    n.ClipsDescendants = true
    n.Parent = NotifHolder
    corner(n, UDim.new(0, 12))
    stroke(n, T.Border, 1)
    shadow(n, 18, 0.5)

    -- Gradient bg
    local nbg = frame(n, {BackgroundColor3 = T.BG2, Size = UDim2.fromScale(1,1), ZIndex = 1, BorderSizePixel = 0})
    corner(nbg, UDim.new(0, 12))
    gradient(nbg, T.BG2, T.BG1, 135)

    -- Accent bar
    local bar = frame(n, {
        BackgroundColor3 = ac,
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 0, 0, 8),
        BorderSizePixel = 0, ZIndex = 3,
    })
    corner(bar, UDim.new(0, 3))

    -- Glow
    local glow = frame(n, {
        BackgroundColor3 = ac, BackgroundTransparency = 0.88,
        Size = UDim2.new(0.5, 0, 1, 0), BorderSizePixel = 0, ZIndex = 2,
    })
    gradient(glow, ac, Color3.fromRGB(0,0,0), 90)

    -- Icon circle
    local iconBg = frame(n, {
        BackgroundColor3 = ac, BackgroundTransparency = 0.7,
        Size = UDim2.fromOffset(32, 32),
        Position = UDim2.new(0, 14, 0.5, -16),
        ZIndex = 4,
    })
    corner(iconBg, UDim.new(1, 0))
    label(iconBg, {
        Text = icon or iconMap[ntype] or "i",
        TextColor3 = ac, Font = Enum.Font.GothamBold,
        TextSize = 14, Size = UDim2.fromScale(1,1),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 5,
    })

    label(n, {
        Text = title, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
        TextSize = 13, Position = UDim2.new(0, 56, 0, 12),
        Size = UDim2.new(1, -68, 0, 18), ZIndex = 5,
    })
    label(n, {
        Text = msg, TextColor3 = T.TextSub, Font = Enum.Font.Gotham,
        TextSize = 11, Position = UDim2.new(0, 56, 0, 32),
        Size = UDim2.new(1, -68, 0, 32), ZIndex = 5, TextWrapped = true,
    })

    -- Progress bar
    local prog = frame(n, {
        BackgroundColor3 = ac, Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0, ZIndex = 5,
    })
    corner(prog, UDim.new(1, 0))
    gradient(prog, T.AccentDark, ac, 90)

    -- Close btn
    local xBtn = Instance.new("TextButton")
    xBtn.Text = "×" xBtn.TextColor3 = T.TextDim xBtn.Font = Enum.Font.GothamBold
    xBtn.TextSize = 16 xBtn.BackgroundTransparency = 1
    xBtn.Size = UDim2.fromOffset(22, 22)
    xBtn.Position = UDim2.new(1, -26, 0, 4)
    xBtn.ZIndex = 6 xBtn.Parent = n

    local function dismiss()
        tween(n, {Position = UDim2.new(1, 20, n.Position.Y.Scale, n.Position.Y.Offset),
            BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quart)
        task.wait(0.35) n:Destroy()
    end
    xBtn.MouseButton1Click:Connect(dismiss)

    n.Position = UDim2.new(1, 20, 1, 0)
    tween(n, {Position = UDim2.new(0, 0, 1, 0)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    tween(prog, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        if n.Parent then dismiss() end
    end)
end

-- ─────────────────────────────────────────────
--  INTRO SCREEN
-- ─────────────────────────────────────────────
local function showIntro(gui, titleText, subtitleText)
    local f = frame(gui, {
        BackgroundColor3 = T.BG0,
        Size = UDim2.fromScale(1, 1), ZIndex = 200,
    })
    gradient(f, T.BG0, Color3.fromRGB(10, 6, 24), 135)

    -- Grid lines
    for i = 1, 9 do
        frame(f, {
            BackgroundColor3 = T.Accent, BackgroundTransparency = 0.95,
            Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, i/10, 0),
            BorderSizePixel = 0, ZIndex = 201,
        })
    end
    for i = 1, 11 do
        frame(f, {
            BackgroundColor3 = T.Accent, BackgroundTransparency = 0.95,
            Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(i/12, 0, 0, 0),
            BorderSizePixel = 0, ZIndex = 201,
        })
    end

    -- Glowing orbs
    local orbData = {
        {T.Accent,    0.72, 200, 200, 0.5, -100, 0.5, -160},
        {T.Accent2,   0.80, 130, 130, 0.5,  -20, 0.5,  -90},
        {T.Accent3,   0.85,  90,  90, 0.5,   60, 0.5, -120},
    }
    local orbs = {}
    for _, d in ipairs(orbData) do
        local o = frame(f, {
            BackgroundColor3 = d[1], BackgroundTransparency = d[2],
            Size = UDim2.fromOffset(d[3], d[4]),
            Position = UDim2.new(d[5], d[6], d[7], d[8]),
            BorderSizePixel = 0, ZIndex = 201,
        })
        corner(o, UDim.new(1, 0))
        table.insert(orbs, o)
    end

    -- Title card
    local card = frame(f, {
        BackgroundColor3 = T.BG1, BackgroundTransparency = 0.25,
        Size = UDim2.fromOffset(380, 70),
        Position = UDim2.new(0.5, -190, 0.5, -35),
        ZIndex = 203,
    })
    corner(card, UDim.new(0, 16))
    stroke(card, T.BorderAcc, 1, 0.4)

    local topLine = frame(card, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(1, 0, 0, 2), BorderSizePixel = 0, ZIndex = 204,
    })
    corner(topLine, UDim.new(0, 2))
    gradient3(topLine, T.Accent2, T.Accent, T.Accent3, 90)

    local titleLbl = label(card, {
        Text = titleText or "AMNEZIA",
        TextColor3 = T.Text, Font = Enum.Font.GothamBold,
        TextSize = 32, Size = UDim2.new(1, 0, 0, 44),
        Position = UDim2.new(0, 0, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 205, TextTransparency = 1,
    })
    local subLbl = label(card, {
        Text = subtitleText or "SCRIPT HUB  |  v2.0.0",
        TextColor3 = T.TextSub, Font = Enum.Font.Gotham,
        TextSize = 11, Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 50),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 205, TextTransparency = 1,
    })

    -- Loading bar
    local loadBg = frame(f, {
        BackgroundColor3 = T.BG3, BackgroundTransparency = 0.4,
        Size = UDim2.fromOffset(300, 4),
        Position = UDim2.new(0.5, -150, 0.5, 52),
        BorderSizePixel = 0, ZIndex = 203,
    })
    corner(loadBg, UDim.new(1, 0))
    stroke(loadBg, T.Border, 1)

    local loadFill = frame(loadBg, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0, ZIndex = 204,
    })
    corner(loadFill, UDim.new(1, 0))
    gradient3(loadFill, T.Accent2, T.Accent, T.AccentGlow, 90)

    local loadLbl = label(f, {
        Text = "Initializing...",
        TextColor3 = T.TextDim, Font = Enum.Font.Code,
        TextSize = 10, Size = UDim2.fromOffset(300, 16),
        Position = UDim2.new(0.5, -150, 0.5, 62),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 203, TextTransparency = 1,
    })

    task.spawn(function()
        task.wait(0.1)
        tween(orbs[1], {BackgroundTransparency = 0.78, Size = UDim2.fromOffset(260, 260), Position = UDim2.new(0.5, -130, 0.5, -170)}, 0.8, Enum.EasingStyle.Quart)
        tween(orbs[2], {BackgroundTransparency = 0.84, Size = UDim2.fromOffset(170, 170)}, 0.6, Enum.EasingStyle.Quart)
        task.wait(0.25)
        tween(titleLbl, {TextTransparency = 0}, 0.5)
        task.wait(0.1)
        tween(subLbl, {TextTransparency = 0.2}, 0.4)
        task.wait(0.2)
        tween(loadBg, {BackgroundTransparency = 0}, 0.3)
        tween(loadLbl, {TextTransparency = 0.35}, 0.3)

        local steps = {
            "Loading modules...", "Checking integrity...",
            "Connecting to server...", "Applying patches...", "Ready!"
        }
        for i, s in ipairs(steps) do
            loadLbl.Text = s
            tween(loadFill, {Size = UDim2.new(i / #steps, 0, 1, 0)}, 0.28, Enum.EasingStyle.Quart)
            task.wait(0.30)
        end

        task.wait(0.3)
        -- Fade out
        for _, c in ipairs(f:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, {TextTransparency = 1}, 0.4)
            elseif c:IsA("Frame") or c:IsA("ImageLabel") then tween(c, {BackgroundTransparency = 1}, 0.4) end
        end
        tween(f, {BackgroundTransparency = 1}, 0.45)
        task.wait(0.5)
        f:Destroy()
    end)

    return 0.1 + 0.25 + 0.2 + (#{"Loading modules...","Checking integrity...","Connecting to server...","Applying patches...","Ready!"} * 0.30) + 0.3 + 0.15
end

-- ─────────────────────────────────────────────
--  KEY SYSTEM
-- ─────────────────────────────────────────────
local function showKeySystem(gui, reqKey, cb)
    local overlay = frame(gui, {
        BackgroundColor3 = T.Black, BackgroundTransparency = 0.45,
        Size = UDim2.fromScale(1, 1), ZIndex = 150,
    })

    local panel = frame(overlay, {
        BackgroundColor3 = T.BG1,
        Size = UDim2.fromOffset(420, 280),
        Position = UDim2.new(0.5, -210, 0.5, -140),
        ZIndex = 151,
    })
    corner(panel, UDim.new(0, 16))
    stroke(panel, T.BorderAcc, 1, 0.35)
    shadow(panel, 32, 0.4)

    local panelBg = frame(panel, {BackgroundColor3=T.BG1, Size=UDim2.fromScale(1,1), ZIndex=151, BorderSizePixel=0})
    corner(panelBg, UDim.new(0,16))
    gradient(panelBg, T.BG1, Color3.fromRGB(10, 8, 20), 135)

    local topBar = frame(panel, {BackgroundColor3=T.Accent, Size=UDim2.new(1,0,0,2), BorderSizePixel=0, ZIndex=152})
    corner(topBar, UDim.new(0,2))
    gradient3(topBar, T.Accent2, T.Accent, T.AccentGlow, 90)

    -- Icon
    local lockBg = frame(panel, {
        BackgroundColor3=T.Accent, BackgroundTransparency=0.75,
        Size=UDim2.fromOffset(48,48), Position=UDim2.new(0.5,-24,0,18),
        ZIndex=153, BorderSizePixel=0,
    })
    corner(lockBg, UDim.new(1,0))
    label(lockBg, {
        Text="🔑", TextSize=22, Size=UDim2.fromScale(1,1),
        TextXAlignment=Enum.TextXAlignment.Center,
        TextYAlignment=Enum.TextYAlignment.Center,
        ZIndex=154,
    })

    label(panel, {
        Text="ACCESS REQUIRED", TextColor3=T.Text, Font=Enum.Font.GothamBold,
        TextSize=17, Size=UDim2.new(1,0,0,24),
        Position=UDim2.new(0,0,0,72),
        TextXAlignment=Enum.TextXAlignment.Center, ZIndex=153,
    })
    label(panel, {
        Text="Enter your Amnezia license key", TextColor3=T.TextSub, Font=Enum.Font.Gotham,
        TextSize=11, Size=UDim2.new(1,-40,0,16),
        Position=UDim2.new(0,20,0,100),
        TextXAlignment=Enum.TextXAlignment.Center, ZIndex=153,
    })

    local ibg = frame(panel, {
        BackgroundColor3=T.BG3, Size=UDim2.new(1,-40,0,38),
        Position=UDim2.new(0,20,0,126), ZIndex=153,
    })
    corner(ibg, UDim.new(0,9))
    local ist = stroke(ibg, T.Border, 1)

    local tb = Instance.new("TextBox")
    tb.Text="" tb.PlaceholderText="XXXX-XXXX-XXXX-XXXX"
    tb.PlaceholderColor3=T.TextDim tb.TextColor3=T.Text
    tb.Font=Enum.Font.Code tb.TextSize=13
    tb.BackgroundTransparency=1
    tb.Size=UDim2.new(1,-16,1,0) tb.Position=UDim2.new(0,8,0,0)
    tb.TextXAlignment=Enum.TextXAlignment.Center
    tb.ClearTextOnFocus=false tb.ZIndex=154 tb.Parent=ibg
    tb.Focused:Connect(function() tween(ist,{Color=T.Accent},0.2) end)
    tb.FocusLost:Connect(function() tween(ist,{Color=T.Border},0.2) end)

    local errL = label(panel, {
        Text="", TextColor3=T.Error, Font=Enum.Font.Gotham,
        TextSize=10, Size=UDim2.new(1,-40,0,14),
        Position=UDim2.new(0,20,0,172),
        TextXAlignment=Enum.TextXAlignment.Center, ZIndex=153,
    })

    local btn = Instance.new("TextButton")
    btn.Text="UNLOCK ACCESS" btn.TextColor3=T.White
    btn.Font=Enum.Font.GothamBold btn.TextSize=12
    btn.BackgroundColor3=T.Accent
    btn.Size=UDim2.new(1,-40,0,42)
    btn.Position=UDim2.new(0,20,0,194)
    btn.ZIndex=153 btn.BorderSizePixel=0 btn.Parent=panel
    corner(btn, UDim.new(0,10))
    gradient3(btn, T.AccentDark, T.Accent, T.AccentGlow, 135)
    stroke(btn, T.BorderAcc, 1, 0.5)

    btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=T.AccentGlow},0.15) end)
    btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=T.Accent},0.15) end)
    btn.MouseButton1Click:Connect(function()
        if tb.Text==reqKey then
            tween(overlay,{BackgroundTransparency=1},0.4)
            tween(panel,{Size=UDim2.fromOffset(420,0),Position=UDim2.new(0.5,-210,0.5,0),BackgroundTransparency=1},0.35,Enum.EasingStyle.Back)
            task.wait(0.42) overlay:Destroy() cb(true)
        else
            errL.Text="✕  Invalid key — please try again."
            tween(ibg,{BackgroundColor3=Color3.fromRGB(40,12,12)},0.15)
            tween(ist,{Color=T.Error},0.15)
            task.wait(1.8)
            tween(ibg,{BackgroundColor3=T.BG3},0.3) tween(ist,{Color=T.Border},0.3)
            task.wait(0.3) errL.Text=""
        end
    end)

    panel.Size=UDim2.fromOffset(420,0) panel.BackgroundTransparency=1
    tween(panel,{Size=UDim2.fromOffset(420,280),BackgroundTransparency=0},0.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end

-- ─────────────────────────────────────────────
--  CLOSE ANIMATION  (shatter dissolve)
-- ─────────────────────────────────────────────
local function animateClose(win, gui, W, H, onDone)
    -- Étape 1 : flash de bord
    local flashStroke = stroke(win, T.AccentGlow, 2, 0)
    tween(flashStroke, {Transparency=0.2}, 0.06)
    task.wait(0.07)

    -- Étape 2 : éclatement en fragments puis fade
    local COLS, ROWS = 6, 4
    local fw = W / COLS
    local fh = H / ROWS
    local fragments = {}

    for row = 0, ROWS-1 do
        for col = 0, COLS-1 do
            local ox = win.AbsolutePosition.X + col * fw
            local oy = win.AbsolutePosition.Y + row * fh
            local frag = frame(gui, {
                BackgroundColor3 = T.BG1,
                Size = UDim2.fromOffset(fw-1, fh-1),
                Position = UDim2.fromOffset(ox, oy),
                ZIndex = 9000,
                BorderSizePixel = 0,
                ClipsDescendants = true,
            })
            -- teinture légère aléatoire
            local hue = (col + row * COLS) / (COLS * ROWS)
            frag.BackgroundColor3 = T.BG2:Lerp(T.Accent, 0.04 + hue * 0.06)

            -- direction d'envol aléatoire
            local dx = (col - COLS/2) * 40 + math.random(-30, 30)
            local dy = (row - ROWS/2) * 35 + math.random(-20, 20)
            local rot = math.random(-25, 25)
            table.insert(fragments, {f=frag, dx=dx, dy=dy, rot=rot, ox=ox, oy=oy})
        end
    end

    -- Cacher la vraie fenêtre
    win.Visible = false
    flashStroke:Destroy()

    -- Animer les fragments
    for i, data in ipairs(fragments) do
        local delay = (i-1) * 0.012
        task.delay(delay, function()
            if not data.f.Parent then return end
            tween(data.f, {
                Position = UDim2.fromOffset(data.ox + data.dx, data.oy + data.dy + 60),
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(fw * 0.6, fh * 0.6),
            }, 0.38 + math.random()*0.12, Enum.EasingStyle.Quart)
        end)
    end

    task.delay(0.55, function()
        for _, data in ipairs(fragments) do
            pcall(function() data.f:Destroy() end)
        end
        if onDone then onDone() end
        pcall(function() gui:Destroy() end)
    end)
end

-- ─────────────────────────────────────────────
--  MAIN WINDOW
-- ─────────────────────────────────────────────
function Amnezia:CreateWindow(opts)
    opts = opts or {}
    local title      = opts.Title       or "Amnezia"
    local subtitle   = opts.SubTitle    or "Script Hub"
    local key        = opts.Key
    local doIntro    = opts.ShowIntro  ~= false
    local W          = opts.Width       or 800
    local H          = opts.Height      or 520
    local cfgName    = opts.ConfigName  or "default"
    local themeName  = opts.Theme       or "Dark"
    local onClose    = opts.OnClose     or function() end
    local onTabChange= opts.OnTabChanged or function() end
    local toggleKey  = opts.ToggleKey   or Enum.KeyCode.RightControl

    -- Appliquer le thème
    local themeData = Themes[themeName] or Themes.Dark
    for k, v in pairs(themeData) do T[k] = v end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AmneziaUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 1000
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

    initNotifs(gui)
    initTooltip(gui)

    local win = frame(gui, {
        BackgroundColor3 = T.BG0,
        Size = UDim2.fromOffset(W, H),
        Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
        ZIndex = 10, Visible = false,
        ClipsDescendants = false,
    })
    corner(win, UDim.new(0, 16))
    stroke(win, T.Border, 1)
    shadow(win, 44, 0.35)

    local winBg = frame(win, {
        BackgroundColor3 = T.BG0,
        Size = UDim2.fromScale(1,1), ZIndex = 10,
        ClipsDescendants = true, BorderSizePixel = 0,
    })
    corner(winBg, UDim.new(0,16))
    gradient(winBg, T.BG0, Color3.fromRGB(10,7,22), 135)

    -- Animated top accent bar
    local topAccent = frame(win, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(1,0,0,2), BorderSizePixel = 0, ZIndex = 20,
    })
    corner(topAccent, UDim.new(0,2))
    local topGrad = gradient3(topAccent, T.Accent2, T.Accent, T.Accent3, 90)

    -- Animate gradient rotation slowly
    local gradRot = 90
    local gradConn
    gradConn = RunService.RenderStepped:Connect(function(dt)
        gradRot = gradRot + dt * 18
        if gradRot > 360 then gradRot = gradRot - 360 end
        pcall(function() topGrad.Rotation = gradRot end)
    end)

    -- ─── SIDEBAR ───────────────────────────
    local sidebar = frame(win, {
        BackgroundColor3 = T.Panel,
        Size = UDim2.new(0, 220, 1, 0),
        ZIndex = 11, ClipsDescendants = true,
    })
    corner(sidebar, UDim.new(0, 16))

    -- Fill right side to cover round corner overlap
    frame(sidebar, {
        BackgroundColor3 = T.Panel,
        Size = UDim2.new(0, 16, 1, 0),
        Position = UDim2.new(1, -16, 0, 0),
        ZIndex = 11, BorderSizePixel = 0,
    })

    frame(sidebar, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(0,1,1,0),
        Position = UDim2.new(1,-1,0,0),
        BorderSizePixel = 0, ZIndex = 12,
    })

    local sideGlow = frame(sidebar, {
        BackgroundColor3 = T.Accent, BackgroundTransparency = 0.94,
        Size = UDim2.fromScale(1,1), BorderSizePixel = 0, ZIndex = 11,
    })
    gradient(sideGlow, T.Accent, Color3.fromRGB(0,0,0), 180)

    -- Logo area
    local logoArea = frame(sidebar, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,74), ZIndex = 13,
    })

    local logoAccentBar = frame(logoArea, {
        BackgroundColor3 = T.Accent,
        Size = UDim2.fromOffset(40,3),
        Position = UDim2.new(0,16,1,-10),
        BorderSizePixel = 0, ZIndex = 14,
    })
    corner(logoAccentBar, UDim.new(1,0))
    gradient3(logoAccentBar, T.Accent2, T.Accent, T.Accent3, 90)

    label(logoArea, {
        Text = title, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
        TextSize = 20, Size = UDim2.new(1,-16,0,28),
        Position = UDim2.new(0,16,0,14), ZIndex = 14,
    })
    label(logoArea, {
        Text = subtitle, TextColor3 = T.TextDim, Font = Enum.Font.Gotham,
        TextSize = 10, Size = UDim2.new(1,-16,0,14),
        Position = UDim2.new(0,16,0,42), ZIndex = 14,
    })

    frame(logoArea, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(1,-20,0,1),
        Position = UDim2.new(0,10,1,-1),
        BorderSizePixel = 0, ZIndex = 13,
    })

    -- Search bar in sidebar
    local searchBg = frame(sidebar, {
        BackgroundColor3 = T.BG3,
        Size = UDim2.new(1,-20,0,28),
        Position = UDim2.new(0,10,0,76),
        ZIndex = 13,
    })
    corner(searchBg, UDim.new(0,7))
    local searchStroke = stroke(searchBg, T.Border, 1)

    label(searchBg, {
        Text = "🔍", TextSize = 11,
        Size = UDim2.fromOffset(20,28),
        Position = UDim2.new(0,4,0,0),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 14,
    })

    local searchBox = Instance.new("TextBox")
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search tabs..."
    searchBox.PlaceholderColor3 = T.TextDim
    searchBox.TextColor3 = T.TextSub
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 11
    searchBox.BackgroundTransparency = 1
    searchBox.Size = UDim2.new(1,-28,1,0)
    searchBox.Position = UDim2.new(0,24,0,0)
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 14
    searchBox.Parent = searchBg
    searchBox.Focused:Connect(function() tween(searchStroke,{Color=T.Accent},0.2) end)
    searchBox.FocusLost:Connect(function() tween(searchStroke,{Color=T.Border},0.2) end)

    -- Tab scroll
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.BackgroundTransparency = 1
    tabScroll.Size = UDim2.new(1,0,1,-148)
    tabScroll.Position = UDim2.new(0,0,0,108)
    tabScroll.ScrollBarThickness = 2
    tabScroll.ScrollBarImageColor3 = T.Accent
    tabScroll.CanvasSize = UDim2.new(0,0,0,0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.ZIndex = 13
    tabScroll.Parent = sidebar
    pad(tabScroll,6,6,8,8)
    list(tabScroll, Enum.FillDirection.Vertical, 3)

    -- Sidebar bottom
    local sideBottom = frame(sidebar, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,38),
        Position = UDim2.new(0,0,1,-40),
        ZIndex = 13,
    })
    frame(sideBottom, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(1,-20,0,1),
        Position = UDim2.new(0,10,0,0),
        BorderSizePixel = 0, ZIndex = 13,
    })
    label(sideBottom, {
        Text = "v2.0.0  —  Amnezia",
        TextColor3 = T.TextDim, Font = Enum.Font.Code,
        TextSize = 9, Size = UDim2.new(1,-16,0,26),
        Position = UDim2.new(0,16,0,6), ZIndex = 14,
    })

    -- ─── HEADER ────────────────────────────
    local header = frame(win, {
        BackgroundColor3 = T.BG1, BackgroundTransparency = 0.15,
        Size = UDim2.new(1,-220,0,46),
        Position = UDim2.new(0,220,0,0),
        ZIndex = 12,
    })
    frame(header, {
        BackgroundColor3 = T.Border,
        Size = UDim2.new(1,0,0,1),
        Position = UDim2.new(0,0,1,-1),
        BorderSizePixel = 0, ZIndex = 13,
    })

    local activeTabLabel = label(header, {
        Text = title, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
        TextSize = 13, Size = UDim2.new(0.5,0,1,0),
        Position = UDim2.new(0,14,0,0), ZIndex = 13,
    })

    -- Loading indicator in header
    local loadingDots = label(header, {
        Text = "", TextColor3 = T.Accent, Font = Enum.Font.GothamBold,
        TextSize = 18, Size = UDim2.fromOffset(60,46),
        Position = UDim2.new(0.5,-30,0,0),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 13, Visible = false,
    })

    local function makeHeaderBtn(txt, xOffset, hoverCol)
        local b = Instance.new("TextButton")
        b.Text = txt b.TextColor3 = T.TextSub
        b.Font = Enum.Font.GothamBold b.TextSize = 15
        b.BackgroundColor3 = T.BG3 b.BackgroundTransparency = 1
        b.Size = UDim2.fromOffset(30,30)
        b.Position = UDim2.new(1,xOffset,0.5,-15)
        b.ZIndex = 14 b.BorderSizePixel = 0 b.Parent = header
        corner(b, UDim.new(0,7))
        b.MouseEnter:Connect(function() tween(b,{BackgroundTransparency=0.55,TextColor3=hoverCol},0.15) end)
        b.MouseLeave:Connect(function() tween(b,{BackgroundTransparency=1,TextColor3=T.TextSub},0.15) end)
        return b
    end

    local closeBtn = makeHeaderBtn("✕", -10, T.Error)
    closeBtn.BackgroundColor3 = Color3.fromRGB(48,16,16)
    closeBtn.MouseButton1Click:Connect(function()
        gradConn:Disconnect()
        pcall(onClose)
        animateClose(win, gui, W, H)
    end)

    local minimized = false
    local minBtn = makeHeaderBtn("—", -46, T.TextSub)
    minBtn.TextSize = 18
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(win, {Size=UDim2.fromOffset(220,46)}, 0.3, Enum.EasingStyle.Quart)
        else
            tween(win, {Size=UDim2.fromOffset(W,H)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end)

    -- Maximise toggle
    local maxed = false
    local maxBtn = makeHeaderBtn("⛶", -82, T.AccentGlow)
    maxBtn.TextSize = 13
    maxBtn.MouseButton1Click:Connect(function()
        maxed = not maxed
        if maxed then
            local vp = workspace.CurrentCamera.ViewportSize
            tween(win,{Size=UDim2.fromOffset(vp.X-20,vp.Y-20),Position=UDim2.fromOffset(10,10)},0.3,Enum.EasingStyle.Quart)
        else
            tween(win,{Size=UDim2.fromOffset(W,H),Position=UDim2.new(0.5,-W/2,0.5,-H/2)},0.3,Enum.EasingStyle.Quart)
        end
    end)

    makeDraggable(win, header)

    -- Toggle with keybind
    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == toggleKey then
            win.Visible = not win.Visible
        end
    end)

    -- ─── CONTENT AREA ──────────────────────
    local content = frame(win, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-220,1,-46),
        Position = UDim2.new(0,220,0,46),
        ZIndex = 11, ClipsDescendants = true,
    })

    -- ─── WINDOW OBJECT ─────────────────────
    local Window = {}
    Window._cfg     = loadConfig(cfgName)
    Window._cfgName = cfgName
    Window._flags   = {}

    -- Change theme at runtime
    function Window:SetTheme(name)
        local td = Themes[name] or Themes.Dark
        for k, v in pairs(td) do T[k] = v end
    end

    -- Add custom theme
    function Window:AddTheme(name, data)
        Themes[name] = data
    end

    -- Loading indicator
    local loadingDotsConn
    function Window:SetLoading(on)
        loadingDots.Visible = on
        if on then
            local dots = 0
            loadingDotsConn = RunService.Heartbeat:Connect(function()
                dots = dots + 1
                if dots > 3 then dots = 0 end
                loadingDots.Text = string.rep("•", dots) .. string.rep("◦", 3 - dots)
            end)
        else
            if loadingDotsConn then loadingDotsConn:Disconnect() end
            loadingDots.Text = ""
        end
    end

    -- Get all flag values
    function Window:GetAllValues()
        local out = {}
        for k, v in pairs(self._flags) do
            out[k] = v.Get()
        end
        return out
    end

    -- Reset config
    function Window:ResetConfig()
        self._cfg = {}
        saveConfig({}, self._cfgName)
    end

    local tabs = {}
    local activeTab = nil

    -- Filter tabs by search
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchBox.Text:lower()
        for _, t in ipairs(tabs) do
            if q == "" then
                t.btn.Visible = true
            else
                t.btn.Visible = t.name:lower():find(q, 1, true) ~= nil
            end
        end
    end)

    local function activateTab(t)
        if activeTab == t then return end
        if activeTab then
            tween(activeTab.btn, {BackgroundTransparency=1, BackgroundColor3=T.BG3}, 0.18)
            tween(activeTab.btnLbl, {TextColor3=T.TextSub}, 0.18)
            tween(activeTab.indicator, {BackgroundTransparency=1}, 0.18)
            activeTab.page.Visible = false
        end
        activeTab = t
        tween(t.btn, {BackgroundTransparency=0, BackgroundColor3=T.BG3}, 0.2)
        tween(t.btnLbl, {TextColor3=T.AccentGlow}, 0.2)
        tween(t.indicator, {BackgroundTransparency=0}, 0.2)
        activeTabLabel.Text = t.name
        t.page.Visible = true
        t.page.Position = UDim2.new(0.04,0,0,0)
        tween(t.page, {Position=UDim2.fromScale(0,0)}, 0.22, Enum.EasingStyle.Quart)
        pcall(onTabChange, t.name)
    end

    function Window:AddTab(topts)
        topts = topts or {}
        local name = topts.Name or "Tab"
        local icon = topts.Icon or ""

        local btn = Instance.new("TextButton")
        btn.Text = "" btn.BackgroundColor3 = T.BG3
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1,0,0,36)
        btn.BorderSizePixel = 0 btn.ZIndex = 14
        btn.Parent = tabScroll
        corner(btn, UDim.new(0,8))

        local indicator = frame(btn, {
            BackgroundColor3 = T.Accent, BackgroundTransparency = 1,
            Size = UDim2.fromOffset(3,18),
            Position = UDim2.new(0,1,0.5,-9),
            BorderSizePixel = 0, ZIndex = 15,
        })
        corner(indicator, UDim.new(1,0))
        gradient(indicator, T.Accent2, T.AccentGlow, 90)

        local startX = 12
        if icon ~= "" then
            label(btn, {
                Text = icon, TextSize = 14,
                Size = UDim2.fromOffset(20,36),
                Position = UDim2.new(0,12,0,0),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                TextColor3 = T.TextSub, ZIndex = 15,
            })
            startX = 34
        end

        local btnLbl = label(btn, {
            Text = name, TextColor3 = T.TextSub,
            Font = Enum.Font.GothamBold, TextSize = 12,
            Size = UDim2.new(1,-startX-8,1,0),
            Position = UDim2.new(0,startX,0,0),
            ZIndex = 15,
        })

        local page = Instance.new("ScrollingFrame")
        page.BackgroundTransparency = 1
        page.Size = UDim2.fromScale(1,1)
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = T.Accent
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false page.ZIndex = 12
        page.Parent = content
        pad(page,14,14,14,14)
        list(page, Enum.FillDirection.Vertical, 10)

        local tabObj = {btn=btn, btnLbl=btnLbl, indicator=indicator, page=page, name=name}
        table.insert(tabs, tabObj)

        btn.MouseEnter:Connect(function()
            if activeTab ~= tabObj then
                tween(btn,{BackgroundTransparency=0.7},0.15)
                tween(btnLbl,{TextColor3=T.Text},0.15)
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab ~= tabObj then
                tween(btn,{BackgroundTransparency=1},0.15)
                tween(btnLbl,{TextColor3=T.TextSub},0.15)
            end
        end)
        btn.MouseButton1Click:Connect(function() activateTab(tabObj) end)

        if #tabs == 1 then activateTab(tabObj) end

        -- ─── TAB OBJECT ──────────────────
        local Tab = {}

        function Tab:AddSection(sopts)
            sopts = sopts or {}
            local sname = sopts.Name or "Section"
            local collapsed = sopts.Collapsed or false

            local sec = frame(page, {
                BackgroundColor3 = T.BG2,
                Size = UDim2.new(1,0,0,0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0, ZIndex = 13,
            })
            corner(sec, UDim.new(0,12))
            stroke(sec, T.Border, 1)

            -- Slide-in animation
            sec.Position = UDim2.new(0.03,0,0,0)
            sec.BackgroundTransparency = 1
            task.delay(0.05 * #page:GetChildren(), function()
                tween(sec,{Position=UDim2.fromScale(0,0), BackgroundTransparency=0}, 0.3, Enum.EasingStyle.Quart)
            end)

            local secHeader = frame(sec, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,0,36),
                LayoutOrder = 0, ZIndex = 14,
            })

            local sAccent = frame(secHeader, {
                BackgroundColor3 = T.Accent,
                Size = UDim2.fromOffset(3,16),
                Position = UDim2.new(0,14,0.5,-8),
                BorderSizePixel = 0, ZIndex = 15,
            })
            corner(sAccent, UDim.new(1,0))
            gradient(sAccent, T.Accent2, T.AccentGlow, 90)

            label(secHeader, {
                Text = string.upper(sname),
                TextColor3 = T.Accent, Font = Enum.Font.GothamBold,
                TextSize = 10, Size = UDim2.new(1,-60,1,0),
                Position = UDim2.new(0,26,0,0), ZIndex = 15,
            })

            -- Collapse button
            local chevron = label(secHeader, {
                Text = collapsed and "›" or "‹",
                TextColor3 = T.TextDim, Font = Enum.Font.GothamBold,
                TextSize = 14, Size = UDim2.fromOffset(24,36),
                Position = UDim2.new(1,-28,0,0),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 15,
            })

            frame(secHeader, {
                BackgroundColor3 = T.Border,
                Size = UDim2.new(1,-20,0,1),
                Position = UDim2.new(0,10,1,-1),
                BorderSizePixel = 0, ZIndex = 14,
            })

            local items = frame(sec, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,0,0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 1, ZIndex = 14,
            })
            pad(items, 2, 10, 12, 12)
            list(items, Enum.FillDirection.Vertical, 5)

            local secLayout = Instance.new("UIListLayout")
            secLayout.FillDirection = Enum.FillDirection.Vertical
            secLayout.SortOrder = Enum.SortOrder.LayoutOrder
            secLayout.Parent = sec

            -- Collapse logic
            local isCollapsed = false
            local function setCollapsed(v)
                isCollapsed = v
                if v then
                    items.Visible = false
                    chevron.Text = "›"
                else
                    items.Visible = true
                    chevron.Text = "‹"
                end
            end

            local colClick = Instance.new("TextButton")
            colClick.BackgroundTransparency = 1
            colClick.Size = UDim2.fromScale(1,1)
            colClick.Text = "" colClick.ZIndex = 16
            colClick.Parent = secHeader
            colClick.MouseButton1Click:Connect(function()
                setCollapsed(not isCollapsed)
            end)
            setCollapsed(collapsed)

            local Section = {}
            local order = 0
            local function nxt() order = order+1; return order end

            local function makeRow(h, noHover)
                local r = frame(items, {
                    BackgroundColor3 = T.BG3,
                    BackgroundTransparency = 0.35,
                    Size = UDim2.new(1,0,0,h or 36),
                    BorderSizePixel = 0, ZIndex = 15,
                    LayoutOrder = nxt(),
                })
                corner(r, UDim.new(0,8))
                stroke(r, T.Border, 1)
                if not noHover then
                    r.MouseEnter:Connect(function() tween(r,{BackgroundTransparency=0.1, BackgroundColor3=T.BG4},0.15) end)
                    r.MouseLeave:Connect(function() tween(r,{BackgroundTransparency=0.35, BackgroundColor3=T.BG3},0.15) end)
                end
                return r
            end

            -- ── BUTTON ──────────────────────
            function Section:AddButton(opts)
                opts = opts or {}
                local n    = opts.Name or "Button"
                local desc = opts.Description
                local cb   = opts.Callback or function() end
                local tip  = opts.Tooltip
                local color = opts.Color

                local rowH = desc and 52 or 36
                local r = makeRow(rowH, true)

                local gBg = frame(r, {
                    BackgroundColor3 = color or T.Accent,
                    BackgroundTransparency = 0.96,
                    Size = UDim2.fromScale(1,1),
                    BorderSizePixel = 0, ZIndex = 15,
                })
                corner(gBg, UDim.new(0,8))
                gradient(gBg, color or T.Accent, Color3.fromRGB(0,0,0), 90)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(1,-42,0,18),
                    Position = UDim2.new(0,12,0,desc and 8 or 9), ZIndex = 16,
                })
                if desc then
                    label(r, {
                        Text = desc, TextColor3 = T.TextDim, Font = Enum.Font.Gotham,
                        TextSize = 10, Size = UDim2.new(1,-42,0,16),
                        Position = UDim2.new(0,12,0,28), ZIndex = 16,
                    })
                end

                local arr = label(r, {
                    Text = "›", TextColor3 = color or T.Accent,
                    Font = Enum.Font.GothamBold, TextSize = 18,
                    Size = UDim2.fromOffset(22,22),
                    Position = UDim2.new(1,-30,0.5,-11),
                    TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 16,
                })

                local click = Instance.new("TextButton")
                click.BackgroundTransparency = 1
                click.Size = UDim2.fromScale(1,1)
                click.Text = "" click.ZIndex = 17 click.Parent = r

                click.MouseEnter:Connect(function()
                    tween(r,{BackgroundTransparency=0.05, BackgroundColor3=T.BG4},0.15)
                    tween(arr,{TextColor3= T.AccentGlow},0.15)
                    tween(gBg,{BackgroundTransparency=0.92},0.15)
                end)
                click.MouseLeave:Connect(function()
                    tween(r,{BackgroundTransparency=0.35, BackgroundColor3=T.BG3},0.15)
                    tween(arr,{TextColor3= color or T.Accent},0.15)
                    tween(gBg,{BackgroundTransparency=0.96},0.15)
                end)
                click.MouseButton1Down:Connect(function()
                    tween(r,{BackgroundTransparency=0, BackgroundColor3=T.BG4},0.08)
                end)
                click.MouseButton1Up:Connect(function()
                    tween(r,{BackgroundTransparency=0.35, BackgroundColor3=T.BG3},0.15)
                end)
                click.MouseButton1Click:Connect(function(x,y)
                    ripple(r, x, y)
                    task.spawn(cb)
                end)

                if tip then attachTooltip(r, tip, gui) end
                return r
            end

            -- ── TOGGLE ──────────────────────
            function Section:AddToggle(opts)
                opts = opts or {}
                local n    = opts.Name or "Toggle"
                local desc = opts.Description
                local def  = opts.Default ~= nil and opts.Default or false
                local cb   = opts.Callback or function() end
                local flag = opts.Flag
                local tip  = opts.Tooltip

                local state = def
                if flag and Window._cfg[flag] ~= nil then state = Window._cfg[flag] end

                local r = makeRow(desc and 52 or 36)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(1,-68,0,18),
                    Position = UDim2.new(0,12,0,desc and 8 or 9), ZIndex = 16,
                })
                if desc then
                    label(r, {
                        Text = desc, TextColor3 = T.TextDim, Font = Enum.Font.Gotham,
                        TextSize = 10, Size = UDim2.new(1,-68,0,16),
                        Position = UDim2.new(0,12,0,28), ZIndex = 16,
                    })
                end

                local pillBg = frame(r, {
                    BackgroundColor3 = T.BG4,
                    Size = UDim2.fromOffset(44,24),
                    Position = UDim2.new(1,-54,0.5,-12),
                    ZIndex = 16,
                })
                corner(pillBg, UDim.new(1,0))
                local pillStroke = stroke(pillBg, T.Border, 1)

                local pill = frame(pillBg, {
                    BackgroundColor3 = T.TextDim,
                    Size = UDim2.fromOffset(18,18),
                    ZIndex = 17,
                })
                corner(pill, UDim.new(1,0))

                local function set(v)
                    state = v
                    if state then
                        tween(pillBg,{BackgroundColor3=T.Accent},0.2)
                        tween(pill,{Position=UDim2.new(1,-20,0.5,-9),BackgroundColor3=T.White},0.22,Enum.EasingStyle.Back)
                        tween(pillStroke,{Color=T.Accent},0.2)
                    else
                        tween(pillBg,{BackgroundColor3=T.BG4},0.2)
                        tween(pill,{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=T.TextDim},0.22,Enum.EasingStyle.Back)
                        tween(pillStroke,{Color=T.Border},0.2)
                    end
                    if flag then Window._cfg[flag]=v; saveConfig(Window._cfg,Window._cfgName) end
                    task.spawn(cb,v)
                end
                set(state)

                local click = Instance.new("TextButton")
                click.BackgroundTransparency=1 click.Size=UDim2.fromScale(1,1)
                click.Text="" click.ZIndex=18 click.Parent=r
                click.MouseButton1Click:Connect(function() set(not state) end)

                if flag then Window._flags[flag]={Get=function() return state end} end
                if tip then attachTooltip(r,tip,gui) end
                return {Set=set, Get=function() return state end}
            end

            -- ── SLIDER ──────────────────────
            function Section:AddSlider(opts)
                opts = opts or {}
                local n    = opts.Name or "Slider"
                local mn   = opts.Min or 0
                local mx   = opts.Max or 100
                local def  = opts.Default ~= nil and opts.Default or mn
                local suf  = opts.Suffix or ""
                local step = opts.Step or 1
                local cb   = opts.Callback or function() end
                local flag = opts.Flag
                local tip  = opts.Tooltip

                local val = math.clamp(def, mn, mx)
                if flag and Window._cfg[flag] ~= nil then val = Window._cfg[flag] end

                local r = makeRow(58)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(0.62,0,0,18),
                    Position = UDim2.new(0,12,0,8), ZIndex = 16,
                })

                local valLbl = label(r, {
                    Text = tostring(val) .. suf,
                    TextColor3 = T.AccentGlow, Font = Enum.Font.Code,
                    TextSize = 12, Size = UDim2.new(0.38,-12,0,18),
                    Position = UDim2.new(0.62,0,0,8),
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 16,
                })

                local trackBg = frame(r, {
                    BackgroundColor3 = T.BG4,
                    Size = UDim2.new(1,-24,0,6),
                    Position = UDim2.new(0,12,0,36),
                    ZIndex = 16,
                })
                corner(trackBg, UDim.new(1,0))
                stroke(trackBg, T.Border, 1)

                local fill = frame(trackBg, {
                    BackgroundColor3 = T.Accent,
                    Size = UDim2.new((val-mn)/(mx-mn),0,1,0),
                    BorderSizePixel = 0, ZIndex = 17,
                })
                corner(fill, UDim.new(1,0))
                gradient3(fill, T.AccentDark, T.Accent, T.AccentGlow, 90)

                local thumb = frame(trackBg, {
                    BackgroundColor3 = T.White,
                    Size = UDim2.fromOffset(14,14),
                    ZIndex = 18,
                })
                corner(thumb, UDim.new(1,0))
                stroke(thumb, T.Accent, 2)

                local function setValue(v)
                    v = math.clamp(math.floor((v / step) + 0.5) * step, mn, mx)
                    val = v
                    local pct = (v-mn)/(mx-mn)
                    fill.Size = UDim2.new(pct,0,1,0)
                    thumb.Position = UDim2.new(pct,-7,0.5,-7)
                    valLbl.Text = tostring(v) .. suf
                    if flag then Window._cfg[flag]=v; saveConfig(Window._cfg,Window._cfgName) end
                    task.spawn(cb,v)
                end
                setValue(val)

                local drag = false
                local ca = Instance.new("TextButton")
                ca.BackgroundTransparency=1 ca.Size=UDim2.fromScale(1,1)
                ca.Text="" ca.ZIndex=19 ca.Parent=trackBg

                ca.MouseButton1Down:Connect(function()
                    drag=true tween(thumb,{Size=UDim2.fromOffset(16,16)},0.1)
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                        local rel=(i.Position.X-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X
                        setValue(mn+(mx-mn)*math.clamp(rel,0,1))
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 and drag then
                        drag=false tween(thumb,{Size=UDim2.fromOffset(14,14)},0.1)
                    end
                end)

                if flag then Window._flags[flag]={Get=function() return val end} end
                if tip then attachTooltip(r,tip,gui) end
                return {Set=setValue, Get=function() return val end}
            end

            -- ── DROPDOWN ────────────────────
            function Section:AddDropdown(opts)
                opts = opts or {}
                local n       = opts.Name or "Dropdown"
                local options = opts.Options or {}
                local def     = opts.Default or (options[1] or "")
                local cb      = opts.Callback or function() end
                local flag    = opts.Flag
                local tip     = opts.Tooltip

                local sel = def
                if flag and Window._cfg[flag] ~= nil then sel = Window._cfg[flag] end
                local open = false

                local r = frame(items, {
                    BackgroundColor3 = T.BG3, BackgroundTransparency = 0.35,
                    Size = UDim2.new(1,0,0,36),
                    BorderSizePixel = 0, ZIndex = 15,
                    LayoutOrder = nxt(), ClipsDescendants = false,
                })
                corner(r, UDim.new(0,8))
                stroke(r, T.Border, 1)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(0.48,0,1,0),
                    Position = UDim2.new(0,12,0,0), ZIndex = 16,
                })
                local selLbl = label(r, {
                    Text = sel, TextColor3 = T.AccentGlow, Font = Enum.Font.Code,
                    TextSize = 11, Size = UDim2.new(0.44,-28,1,0),
                    Position = UDim2.new(0.5,0,0,0),
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 16,
                })
                local chevLbl = label(r, {
                    Text = "›", TextColor3 = T.TextSub, Font = Enum.Font.GothamBold,
                    TextSize = 14, Size = UDim2.fromOffset(20,20),
                    Position = UDim2.new(1,-24,0.5,-10),
                    TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 16,
                })

                local panel2 = frame(r, {
                    BackgroundColor3 = T.BG2,
                    Size = UDim2.new(1,0,0,0),
                    Position = UDim2.new(0,0,1,4),
                    ZIndex = 60, ClipsDescendants = true, Visible = false,
                })
                corner(panel2, UDim.new(0,9))
                stroke(panel2, T.BorderHi, 1)
                shadow(panel2,14,0.5)

                local dScroll = Instance.new("ScrollingFrame")
                dScroll.BackgroundTransparency=1
                dScroll.Size=UDim2.fromScale(1,1)
                dScroll.ScrollBarThickness=2
                dScroll.ScrollBarImageColor3=T.Accent
                dScroll.CanvasSize=UDim2.new(0,0,0,0)
                dScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
                dScroll.ZIndex=61 dScroll.Parent=panel2
                pad(dScroll,4,4,6,6)
                list(dScroll,Enum.FillDirection.Vertical,2)

                local maxH = math.min(#options*30+8,180)

                local function refreshItems()
                    for _, c in ipairs(dScroll:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local isA = opt==sel
                        local ob = Instance.new("TextButton")
                        ob.Text=opt ob.TextColor3=isA and T.AccentGlow or T.TextSub
                        ob.Font=isA and Enum.Font.GothamBold or Enum.Font.Gotham
                        ob.TextSize=12
                        ob.BackgroundColor3=isA and T.BG4 or T.BG3
                        ob.BackgroundTransparency=isA and 0.3 or 1
                        ob.Size=UDim2.new(1,0,0,28)
                        ob.TextXAlignment=Enum.TextXAlignment.Left
                        ob.ZIndex=62 ob.BorderSizePixel=0 ob.Parent=dScroll
                        corner(ob,UDim.new(0,5))
                        pad(ob,0,0,8,0)
                        ob.MouseEnter:Connect(function()
                            if opt~=sel then tween(ob,{BackgroundTransparency=0.7,TextColor3=T.Text},0.1) end
                        end)
                        ob.MouseLeave:Connect(function()
                            if opt~=sel then tween(ob,{BackgroundTransparency=1,TextColor3=T.TextSub},0.1) end
                        end)
                        ob.MouseButton1Click:Connect(function()
                            sel=opt selLbl.Text=opt
                            open=false
                            tween(panel2,{Size=UDim2.new(1,0,0,0)},0.2,Enum.EasingStyle.Quart)
                            tween(chevLbl,{Rotation=0},0.2)
                            task.wait(0.22) panel2.Visible=false
                            refreshItems()
                            if flag then Window._cfg[flag]=opt; saveConfig(Window._cfg,Window._cfgName) end
                            task.spawn(cb,opt)
                        end)
                    end
                end
                refreshItems()

                local click = Instance.new("TextButton")
                click.BackgroundTransparency=1 click.Size=UDim2.fromScale(1,1)
                click.Text="" click.ZIndex=17 click.Parent=r
                click.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        panel2.Visible=true panel2.Size=UDim2.new(1,0,0,0)
                        tween(panel2,{Size=UDim2.new(1,0,0,maxH)},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                        tween(chevLbl,{Rotation=90},0.2)
                    else
                        tween(panel2,{Size=UDim2.new(1,0,0,0)},0.2,Enum.EasingStyle.Quart)
                        tween(chevLbl,{Rotation=0},0.2)
                        task.wait(0.22) panel2.Visible=false
                    end
                end)

                r.MouseEnter:Connect(function() tween(r,{BackgroundTransparency=0.1,BackgroundColor3=T.BG4},0.15) end)
                r.MouseLeave:Connect(function() tween(r,{BackgroundTransparency=0.35,BackgroundColor3=T.BG3},0.15) end)

                if flag then Window._flags[flag]={Get=function() return sel end} end
                if tip then attachTooltip(r,tip,gui) end

                return {
                    Set = function(v) sel=v; selLbl.Text=v; refreshItems() end,
                    Get = function() return sel end,
                    SetOptions = function(newOpts)
                        options = newOpts
                        if not table.find(options, sel) then sel = options[1] or "" end
                        selLbl.Text = sel
                        maxH = math.min(#options*30+8,180)
                        refreshItems()
                    end,
                }
            end

            -- ── MULTI-DROPDOWN ──────────────
            function Section:AddMultiDropdown(opts)
                opts = opts or {}
                local n       = opts.Name or "Multi Select"
                local options = opts.Options or {}
                local def     = opts.Default or {}
                local cb      = opts.Callback or function() end
                local flag    = opts.Flag
                local maxSel  = opts.Max or 999

                local selected = {}
                for _, v in ipairs(def) do selected[v]=true end
                if flag and Window._cfg[flag] ~= nil then
                    selected = {}
                    for _, v in ipairs(Window._cfg[flag]) do selected[v]=true end
                end
                local open = false

                local r = frame(items, {
                    BackgroundColor3 = T.BG3, BackgroundTransparency = 0.35,
                    Size = UDim2.new(1,0,0,36),
                    BorderSizePixel = 0, ZIndex = 15,
                    LayoutOrder = nxt(), ClipsDescendants = false,
                })
                corner(r, UDim.new(0,8))
                stroke(r, T.Border, 1)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(0.45,0,1,0),
                    Position = UDim2.new(0,12,0,0), ZIndex = 16,
                })
                local countLbl = label(r, {
                    Text = "0 selected", TextColor3 = T.AccentGlow, Font = Enum.Font.Code,
                    TextSize = 11, Size = UDim2.new(0.45,-28,1,0),
                    Position = UDim2.new(0.5,0,0,0),
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 16,
                })
                local chevLbl2 = label(r, {
                    Text = "›", TextColor3 = T.TextSub, Font = Enum.Font.GothamBold,
                    TextSize = 14, Size = UDim2.fromOffset(20,20),
                    Position = UDim2.new(1,-24,0.5,-10),
                    TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 16,
                })

                local panel3 = frame(r, {
                    BackgroundColor3 = T.BG2,
                    Size = UDim2.new(1,0,0,0),
                    Position = UDim2.new(0,0,1,4),
                    ZIndex = 60, ClipsDescendants = true, Visible = false,
                })
                corner(panel3, UDim.new(0,9))
                stroke(panel3, T.BorderHi, 1)

                local mScroll = Instance.new("ScrollingFrame")
                mScroll.BackgroundTransparency=1 mScroll.Size=UDim2.fromScale(1,1)
                mScroll.ScrollBarThickness=2 mScroll.ScrollBarImageColor3=T.Accent
                mScroll.CanvasSize=UDim2.new(0,0,0,0) mScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
                mScroll.ZIndex=61 mScroll.Parent=panel3
                pad(mScroll,4,4,6,6) list(mScroll,Enum.FillDirection.Vertical,2)

                local maxH3 = math.min(#options*30+8,180)

                local function updateCount()
                    local c = 0
                    for _ in pairs(selected) do c=c+1 end
                    countLbl.Text = c==0 and "None" or c.." selected"
                end
                updateCount()

                for _, opt in ipairs(options) do
                    local ob = Instance.new("TextButton")
                    ob.Text="" ob.BackgroundColor3=T.BG3
                    ob.BackgroundTransparency=selected[opt] and 0.3 or 1
                    ob.Size=UDim2.new(1,0,0,28)
                    ob.ZIndex=62 ob.BorderSizePixel=0 ob.Parent=mScroll
                    corner(ob,UDim.new(0,5))

                    local checkLbl = label(ob,{
                        Text = selected[opt] and "✓" or "  ",
                        TextColor3=T.Accent, Font=Enum.Font.GothamBold,
                        TextSize=12, Size=UDim2.fromOffset(24,28),
                        Position=UDim2.new(0,4,0,0),
                        TextXAlignment=Enum.TextXAlignment.Center,
                        ZIndex=63,
                    })
                    label(ob,{
                        Text=opt, TextColor3=selected[opt] and T.Text or T.TextSub,
                        Font=selected[opt] and Enum.Font.GothamBold or Enum.Font.Gotham,
                        TextSize=12, Size=UDim2.new(1,-32,1,0),
                        Position=UDim2.new(0,28,0,0),
                        TextXAlignment=Enum.TextXAlignment.Left,
                        ZIndex=63,
                    })

                    ob.MouseButton1Click:Connect(function()
                        local cnt=0; for _ in pairs(selected) do cnt=cnt+1 end
                        if selected[opt] then
                            selected[opt]=nil
                            tween(ob,{BackgroundTransparency=1},0.12)
                            checkLbl.Text="  "
                        elseif cnt < maxSel then
                            selected[opt]=true
                            tween(ob,{BackgroundTransparency=0.3},0.12)
                            checkLbl.Text="✓"
                        end
                        updateCount()
                        local out={}; for k in pairs(selected) do table.insert(out,k) end
                        if flag then Window._cfg[flag]=out; saveConfig(Window._cfg,Window._cfgName) end
                        task.spawn(cb,out)
                    end)
                end

                local click3 = Instance.new("TextButton")
                click3.BackgroundTransparency=1 click3.Size=UDim2.fromScale(1,1)
                click3.Text="" click3.ZIndex=17 click3.Parent=r
                click3.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        panel3.Visible=true panel3.Size=UDim2.new(1,0,0,0)
                        tween(panel3,{Size=UDim2.new(1,0,0,maxH3)},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                        tween(chevLbl2,{Rotation=90},0.2)
                    else
                        tween(panel3,{Size=UDim2.new(1,0,0,0)},0.2,Enum.EasingStyle.Quart)
                        tween(chevLbl2,{Rotation=0},0.2)
                        task.wait(0.22) panel3.Visible=false
                    end
                end)

                r.MouseEnter:Connect(function() tween(r,{BackgroundTransparency=0.1,BackgroundColor3=T.BG4},0.15) end)
                r.MouseLeave:Connect(function() tween(r,{BackgroundTransparency=0.35,BackgroundColor3=T.BG3},0.15) end)

                return {
                    Get = function()
                        local out={}; for k in pairs(selected) do table.insert(out,k) end; return out
                    end,
                    SetSelected = function(list2)
                        selected={}
                        for _,v in ipairs(list2) do selected[v]=true end
                        updateCount()
                    end,
                }
            end

            -- ── INPUT ───────────────────────
            function Section:AddInput(opts)
                opts = opts or {}
                local n    = opts.Name or "Input"
                local def  = opts.Default or ""
                local ph   = opts.Placeholder or "Type here..."
                local cb   = opts.Callback or function() end
                local flag = opts.Flag
                local tip  = opts.Tooltip
                local numOnly = opts.NumberOnly or false

                local r = makeRow(58)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(1,-12,0,18),
                    Position = UDim2.new(0,12,0,6), ZIndex = 16,
                })

                local ibg = frame(r, {
                    BackgroundColor3 = T.BG4,
                    Size = UDim2.new(1,-24,0,26),
                    Position = UDim2.new(0,12,0,28),
                    ZIndex = 16,
                })
                corner(ibg, UDim.new(0,7))
                local ist = stroke(ibg, T.Border, 1)

                local tb = Instance.new("TextBox")
                tb.Text=def tb.PlaceholderText=ph
                tb.PlaceholderColor3=T.TextDim tb.TextColor3=T.Text
                tb.Font=Enum.Font.Code tb.TextSize=12
                tb.BackgroundTransparency=1
                tb.Size=UDim2.new(1,-12,1,0)
                tb.Position=UDim2.new(0,6,0,0)
                tb.TextXAlignment=Enum.TextXAlignment.Left
                tb.ClearTextOnFocus=false tb.ZIndex=17 tb.Parent=ibg

                if numOnly then
                    tb:GetPropertyChangedSignal("Text"):Connect(function()
                        local clean = tb.Text:gsub("[^%d%.%-]","")
                        if clean ~= tb.Text then tb.Text = clean end
                    end)
                end

                tb.Focused:Connect(function() tween(ist,{Color=T.Accent},0.2) end)
                tb.FocusLost:Connect(function()
                    tween(ist,{Color=T.Border},0.2)
                    if flag then Window._cfg[flag]=tb.Text; saveConfig(Window._cfg,Window._cfgName) end
                    task.spawn(cb,tb.Text)
                end)

                if flag then Window._flags[flag]={Get=function() return tb.Text end} end
                if tip then attachTooltip(r,tip,gui) end
                return {Set=function(v) tb.Text=tostring(v) end, Get=function() return tb.Text end}
            end

            -- ── KEYBIND ─────────────────────
            function Section:AddKeybind(opts)
                opts = opts or {}
                local n    = opts.Name or "Keybind"
                local def  = opts.Default or Enum.KeyCode.Unknown
                local cb   = opts.Callback or function() end
                local flag = opts.Flag

                local bound = def
                if flag and Window._cfg[flag] ~= nil then
                    pcall(function() bound = Enum.KeyCode[Window._cfg[flag]] or def end)
                end
                local listening = false

                local r = makeRow(36)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(1,-120,0,18),
                    Position = UDim2.new(0,12,0,9), ZIndex = 16,
                })

                local kbBtn = Instance.new("TextButton")
                kbBtn.Text = bound == Enum.KeyCode.Unknown and "None" or bound.Name
                kbBtn.TextColor3 = T.AccentGlow kbBtn.Font = Enum.Font.Code
                kbBtn.TextSize = 11 kbBtn.BackgroundColor3 = T.BG4
                kbBtn.Size = UDim2.fromOffset(100,22)
                kbBtn.Position = UDim2.new(1,-110,0.5,-11)
                kbBtn.ZIndex = 16 kbBtn.BorderSizePixel = 0 kbBtn.Parent = r
                corner(kbBtn, UDim.new(0,6))
                stroke(kbBtn, T.Border, 1)

                kbBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    kbBtn.Text = "Press key..."
                    kbBtn.TextColor3 = T.Warning
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(i, gp)
                        if gp then return end
                        if i.UserInputType == Enum.UserInputType.Keyboard then
                            bound = i.KeyCode
                            kbBtn.Text = bound.Name
                            kbBtn.TextColor3 = T.AccentGlow
                            listening = false
                            conn:Disconnect()
                            if flag then Window._cfg[flag]=bound.Name; saveConfig(Window._cfg,Window._cfgName) end
                            task.spawn(cb, bound)
                        end
                    end)
                end)

                -- Fire callback when key is pressed
                UserInputService.InputBegan:Connect(function(i, gp)
                    if gp or listening then return end
                    if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == bound then
                        task.spawn(cb, bound)
                    end
                end)

                if flag then Window._flags[flag]={Get=function() return bound end} end
                return {Get=function() return bound end, Set=function(k) bound=k; kbBtn.Text=k.Name end}
            end

            -- ── COLOR PICKER ────────────────
            function Section:AddColorPicker(opts)
                opts = opts or {}
                local n    = opts.Name or "Color"
                local def  = opts.Default or Color3.fromRGB(94,129,244)
                local cb   = opts.Callback or function() end
                local flag = opts.Flag

                local currentColor = def
                if flag and Window._cfg[flag] ~= nil then
                    pcall(function()
                        local d = Window._cfg[flag]
                        currentColor = Color3.fromRGB(d[1],d[2],d[3])
                    end)
                end

                local open = false

                local r = frame(items, {
                    BackgroundColor3 = T.BG3, BackgroundTransparency = 0.35,
                    Size = UDim2.new(1,0,0,36),
                    BorderSizePixel = 0, ZIndex = 15,
                    LayoutOrder = nxt(), ClipsDescendants = false,
                })
                corner(r, UDim.new(0,8))
                stroke(r, T.Border, 1)

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(1,-80,0,36),
                    Position = UDim2.new(0,12,0,0), ZIndex = 16,
                })

                -- Color preview swatch
                local swatch = frame(r, {
                    BackgroundColor3 = currentColor,
                    Size = UDim2.fromOffset(48,22),
                    Position = UDim2.new(1,-58,0.5,-11),
                    ZIndex = 16,
                })
                corner(swatch, UDim.new(0,7))
                stroke(swatch, T.Border, 1)

                -- HSV picker panel
                local pickerPanel = frame(r, {
                    BackgroundColor3 = T.BG2,
                    Size = UDim2.new(1,0,0,0),
                    Position = UDim2.new(0,0,1,4),
                    ZIndex = 60, ClipsDescendants = true, Visible = false,
                })
                corner(pickerPanel, UDim.new(0,9))
                stroke(pickerPanel, T.BorderHi, 1)

                local pickerInner = frame(pickerPanel, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,0,130),
                    ZIndex = 61,
                })
                pad(pickerInner,8,8,10,10)

                -- Saturation/Value grid
                local svGrid = frame(pickerInner, {
                    BackgroundColor3 = Color3.fromHSV(0,1,1),
                    Size = UDim2.new(1,-110,1,0),
                    ZIndex = 62,
                })
                corner(svGrid, UDim.new(0,6))

                -- White gradient overlay (saturation)
                local svWhite = frame(svGrid, {BackgroundColor3=T.White, Size=UDim2.fromScale(1,1), ZIndex=63, BorderSizePixel=0})
                corner(svWhite, UDim.new(0,6))
                gradient(svWhite, T.White, Color3.new(1,1,1), 90)
                local svWhiteG = Instance.new("UIGradient")
                svWhiteG.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
                svWhiteG.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)
                })
                svWhiteG.Rotation = 0
                svWhiteG.Parent = svWhite

                -- Black gradient overlay (value)
                local svBlack = frame(svGrid, {BackgroundColor3=T.Black, Size=UDim2.fromScale(1,1), ZIndex=64, BorderSizePixel=0})
                corner(svBlack, UDim.new(0,6))
                local svBlackG = Instance.new("UIGradient")
                svBlackG.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0))
                svBlackG.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)
                })
                svBlackG.Rotation = 90
                svBlackG.Parent = svBlack

                -- SV cursor
                local svCursor = frame(svGrid, {
                    BackgroundColor3 = T.White,
                    Size = UDim2.fromOffset(10,10),
                    ZIndex = 65, BorderSizePixel = 0,
                })
                corner(svCursor, UDim.new(1,0))
                stroke(svCursor, T.Black, 1)

                -- Hue slider
                local hueBar = frame(pickerInner, {
                    Size = UDim2.new(0,16,1,0),
                    Position = UDim2.new(1,-100,0,0),
                    ZIndex = 62,
                })
                corner(hueBar, UDim.new(0,5))
                local hueGradient = Instance.new("UIGradient")
                hueGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,   Color3.fromHSV(0,1,1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,1,1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1,1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)),
                    ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,1,1)),
                })
                hueGradient.Rotation = 90
                hueGradient.Parent = hueBar

                local hueCursor = frame(hueBar, {
                    BackgroundColor3=T.White, Size=UDim2.new(1,4,0,4),
                    Position=UDim2.new(0,-2,0,0), ZIndex=63, BorderSizePixel=0,
                })
                corner(hueCursor, UDim.new(0,3))
                stroke(hueCursor, T.Black, 1)

                -- Hex input
                local hexBg = frame(pickerInner, {
                    BackgroundColor3=T.BG4,
                    Size=UDim2.new(0,78,0,22),
                    Position=UDim2.new(1,-80,1,-24),
                    ZIndex=62,
                })
                corner(hexBg, UDim.new(0,5))
                stroke(hexBg, T.Border, 1)

                local hexBox = Instance.new("TextBox")
                hexBox.Text="FFFFFF" hexBox.Font=Enum.Font.Code
                hexBox.TextSize=11 hexBox.TextColor3=T.Text
                hexBox.BackgroundTransparency=1
                hexBox.Size=UDim2.new(1,-6,1,0) hexBox.Position=UDim2.new(0,3,0,0)
                hexBox.TextXAlignment=Enum.TextXAlignment.Center
                hexBox.ClearTextOnFocus=false hexBox.ZIndex=63
                hexBox.Parent=hexBg

                -- Color state
                local h, s, v2 = Color3.toHSV(currentColor)

                local function colorFromHSV()
                    return Color3.fromHSV(h, s, v2)
                end

                local function updateAll()
                    local c = colorFromHSV()
                    currentColor = c
                    swatch.BackgroundColor3 = c
                    svGrid.BackgroundColor3 = Color3.fromHSV(h,1,1)
                    -- hex
                    local r2,g,b2 = math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)
                    hexBox.Text = string.format("%02X%02X%02X",r2,g,b2)
                    -- cursors
                    svCursor.Position = UDim2.new(s,-5,1-v2,-5)
                    hueCursor.Position = UDim2.new(0,-2,h,-2)
                    if flag then
                        Window._cfg[flag]={math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)}
                        saveConfig(Window._cfg,Window._cfgName)
                    end
                    task.spawn(cb,c)
                end
                updateAll()

                -- SV drag
                local svDrag = false
                local svClick = Instance.new("TextButton")
                svClick.BackgroundTransparency=1 svClick.Size=UDim2.fromScale(1,1)
                svClick.Text="" svClick.ZIndex=66 svClick.Parent=svGrid
                svClick.MouseButton1Down:Connect(function() svDrag=true end)
                UserInputService.InputChanged:Connect(function(i)
                    if svDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
                        local rx=math.clamp((i.Position.X-svGrid.AbsolutePosition.X)/svGrid.AbsoluteSize.X,0,1)
                        local ry=math.clamp((i.Position.Y-svGrid.AbsolutePosition.Y)/svGrid.AbsoluteSize.Y,0,1)
                        s=rx v2=1-ry updateAll()
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then svDrag=false end
                end)

                -- Hue drag
                local hueDrag = false
                local hueClick = Instance.new("TextButton")
                hueClick.BackgroundTransparency=1 hueClick.Size=UDim2.fromScale(1,1)
                hueClick.Text="" hueClick.ZIndex=64 hueClick.Parent=hueBar
                hueClick.MouseButton1Down:Connect(function() hueDrag=true end)
                UserInputService.InputChanged:Connect(function(i)
                    if hueDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
                        h=math.clamp((i.Position.Y-hueBar.AbsolutePosition.Y)/hueBar.AbsoluteSize.Y,0,1)
                        updateAll()
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then hueDrag=false end
                end)

                -- Hex input
                hexBox.FocusLost:Connect(function()
                    local hex = hexBox.Text:gsub("#","")
                    if #hex==6 then
                        local nr=tonumber(hex:sub(1,2),16)
                        local ng=tonumber(hex:sub(3,4),16)
                        local nb=tonumber(hex:sub(5,6),16)
                        if nr and ng and nb then
                            currentColor=Color3.fromRGB(nr,ng,nb)
                            h,s,v2=Color3.toHSV(currentColor)
                            updateAll()
                        end
                    end
                end)

                -- Toggle picker
                local swatchClick = Instance.new("TextButton")
                swatchClick.BackgroundTransparency=1 swatchClick.Size=UDim2.fromScale(1,1)
                swatchClick.Text="" swatchClick.ZIndex=17 swatchClick.Parent=r

                local rClick = Instance.new("TextButton")
                rClick.BackgroundTransparency=1 rClick.Size=UDim2.fromScale(1,1)
                rClick.Text="" rClick.ZIndex=17 rClick.Parent=r

                rClick.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        pickerPanel.Visible=true pickerPanel.Size=UDim2.new(1,0,0,0)
                        tween(pickerPanel,{Size=UDim2.new(1,0,0,148)},0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                    else
                        tween(pickerPanel,{Size=UDim2.new(1,0,0,0)},0.2,Enum.EasingStyle.Quart)
                        task.wait(0.22) pickerPanel.Visible=false
                    end
                end)

                r.MouseEnter:Connect(function() tween(r,{BackgroundTransparency=0.1,BackgroundColor3=T.BG4},0.15) end)
                r.MouseLeave:Connect(function() tween(r,{BackgroundTransparency=0.35,BackgroundColor3=T.BG3},0.15) end)

                if flag then Window._flags[flag]={Get=function() return currentColor end} end
                return {
                    Get = function() return currentColor end,
                    Set = function(c)
                        currentColor=c h,s,v2=Color3.toHSV(c) updateAll()
                    end,
                }
            end

            -- ── PROGRESS BAR ────────────────
            function Section:AddProgressBar(opts)
                opts = opts or {}
                local n   = opts.Name or "Progress"
                local def = opts.Value or 0
                local max = opts.Max or 100
                local suf = opts.Suffix or "%"
                local col = opts.Color

                local r = makeRow(52, true)
                r.BackgroundTransparency = 1

                label(r, {
                    Text = n, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(0.6,0,0,18),
                    Position = UDim2.new(0,12,0,6), ZIndex = 16,
                })
                local pValLbl = label(r, {
                    Text = tostring(def)..suf, TextColor3 = T.AccentGlow,
                    Font = Enum.Font.Code, TextSize = 12,
                    Size = UDim2.new(0.4,-12,0,18),
                    Position = UDim2.new(0.6,0,0,6),
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 16,
                })

                local trackBg2 = frame(r, {
                    BackgroundColor3 = T.BG4,
                    Size = UDim2.new(1,-24,0,8),
                    Position = UDim2.new(0,12,0,32),
                    ZIndex = 16,
                })
                corner(trackBg2, UDim.new(1,0))
                stroke(trackBg2, T.Border, 1)

                local pFill = frame(trackBg2, {
                    BackgroundColor3 = col or T.Accent,
                    Size = UDim2.new(def/max,0,1,0),
                    BorderSizePixel = 0, ZIndex = 17,
                })
                corner(pFill, UDim.new(1,0))
                gradient3(pFill, col and col:Lerp(T.Black,0.3) or T.AccentDark,
                    col or T.Accent,
                    col and col:Lerp(T.White,0.2) or T.AccentGlow, 90)

                local function setValue(v)
                    v = math.clamp(v, 0, max)
                    pValLbl.Text = tostring(v) .. suf
                    tween(pFill, {Size=UDim2.new(v/max,0,1,0)}, 0.3, Enum.EasingStyle.Quart)
                end
                setValue(def)

                return {Set=setValue, Get=function() return tonumber(pValLbl.Text:gsub(suf,"")) end}
            end

            -- ── SEPARATOR ───────────────────
            function Section:AddSeparator(opts)
                opts = opts or {}
                local text = opts.Text or ""
                local color = opts.Color or T.Border

                local r = frame(items, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,0,20),
                    ZIndex = 15, LayoutOrder = nxt(),
                })

                if text == "" then
                    local line = frame(r, {
                        BackgroundColor3 = color,
                        Size = UDim2.new(1,0,0,1),
                        Position = UDim2.new(0,0,0.5,0),
                        BorderSizePixel = 0, ZIndex = 16,
                    })
                    gradient3(line, Color3.new(0,0,0), color, Color3.new(0,0,0), 90)
                else
                    local tw2 = #text * 7 + 16
                    frame(r, {
                        BackgroundColor3 = color,
                        Size = UDim2.new(0.5,-tw2/2-4,0,1),
                        Position = UDim2.new(0,0,0.5,0),
                        BorderSizePixel = 0, ZIndex = 16,
                    })
                    frame(r, {
                        BackgroundColor3 = color,
                        Size = UDim2.new(0.5,-tw2/2-4,0,1),
                        Position = UDim2.new(0.5,tw2/2+4,0.5,0),
                        BorderSizePixel = 0, ZIndex = 16,
                    })
                    label(r, {
                        Text = text, TextColor3 = T.TextDim,
                        Font = Enum.Font.Gotham, TextSize = 10,
                        Size = UDim2.fromOffset(tw2,20),
                        Position = UDim2.new(0.5,-tw2/2,0,0),
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex = 16,
                    })
                end
                return r
            end

            -- ── IMAGE ───────────────────────
            function Section:AddImage(opts)
                opts = opts or {}
                local assetId = opts.Image or "rbxassetid://0"
                local h2      = opts.Height or 100
                local desc    = opts.Caption

                local r = makeRow(h2 + (desc and 20 or 0), true)
                r.BackgroundTransparency = 0.7

                local img = Instance.new("ImageLabel")
                img.Image = assetId
                img.BackgroundTransparency = 1
                img.Size = UDim2.new(1,-24, 0, h2)
                img.Position = UDim2.new(0,12,0,6)
                img.ZIndex = 16
                img.ScaleType = Enum.ScaleType.Fit
                img.Parent = r

                if desc then
                    label(r, {
                        Text = desc, TextColor3 = T.TextDim, Font = Enum.Font.Gotham,
                        TextSize = 10, Size = UDim2.new(1,-24,0,16),
                        Position = UDim2.new(0,12,0,h2+8),
                        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 16,
                    })
                end

                return {SetImage=function(id) img.Image=id end}
            end

            -- ── LABEL ───────────────────────
            function Section:AddLabel(opts)
                opts = opts or {}
                local l2 = label(items, {
                    Text = opts.Text or "",
                    TextColor3 = opts.Color or T.TextSub,
                    Font = Enum.Font.Gotham, TextSize = 11,
                    Size = UDim2.new(1,0,0,18),
                    ZIndex = 15, LayoutOrder = nxt(),
                    TextWrapped = true,
                })
                return {Set=function(v) l2.Text=v end, SetColor=function(c) l2.TextColor3=c end}
            end

            return Section
        end

        return Tab
    end

    -- ─── OPEN ANIMATION ─────────────────────
    local function showMain(d)
        task.delay(d or 0, function()
            win.Visible = true
            win.BackgroundTransparency = 1
            win.Size = UDim2.fromOffset(W*0.88, H*0.88)
            win.Position = UDim2.new(0.5,-(W*0.88)/2,0.5,-(H*0.88)/2)
            tween(win, {
                BackgroundTransparency = 0,
                Size = UDim2.fromOffset(W,H),
                Position = UDim2.new(0.5,-W/2,0.5,-H/2),
            }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end)
    end

    if doIntro then
        local d = showIntro(gui, title, subtitle)
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

-- ─────────────────────────────────────────────
--  EXPOSE THEMES
-- ─────────────────────────────────────────────
Amnezia.Themes = Themes

return Amnezia



