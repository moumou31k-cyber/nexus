--[[
    NexusUI
    Modern Luau UI Library

    API:
        local Nexus = require(...)

        local Window = Nexus:CreateWindow({
            Title = "NEXUS",
            Subtitle = "Modern UI",
            Size = UDim2.fromOffset(680, 450)
        })

        local Tab = Window:CreateTab({
            Name = "Main",
            Icon = "◆"
        })

        local Section = Tab:CreateSection({
            Name = "General"
        })

        Section:CreateButton({...})
        Section:CreateToggle({...})
        Section:CreateSlider({...})
        Section:CreateDropdown({...})
        Section:CreateTextbox({...})
        Section:CreateKeybind({...})
        Section:CreateLabel({...})

        Window:Notify({...})
        Window:SetTitle(...)
        Window:SetSubtitle(...)
        Window:SetSize(...)
        Window:SetVisible(...)
        Window:Destroy()

        Nexus:SetTheme({...})
]]

local Nexus = {}

--========================================================
-- Services
--========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--========================================================
-- Theme
--========================================================

local Theme = {
    Background = Color3.fromRGB(12, 13, 17),
    Surface = Color3.fromRGB(17, 18, 23),
    Surface2 = Color3.fromRGB(21, 22, 28),
    Hover = Color3.fromRGB(28, 29, 37),

    Accent = Color3.fromRGB(108, 124, 255),
    AccentHover = Color3.fromRGB(128, 142, 255),

    Text = Color3.fromRGB(242, 243, 247),
    SubText = Color3.fromRGB(150, 153, 165),
    Muted = Color3.fromRGB(102, 105, 117),

    Border = Color3.fromRGB(37, 39, 48),

    Success = Color3.fromRGB(85, 210, 130),
    Warning = Color3.fromRGB(235, 185, 75),
    Error = Color3.fromRGB(235, 85, 95),

    White = Color3.fromRGB(255, 255, 255),
}

function Nexus:GetTheme()
    return table.clone(Theme)
end

function Nexus:SetTheme(NewTheme)
    for Key, Value in pairs(NewTheme or {}) do
        if Theme[Key] ~= nil then
            Theme[Key] = Value
        end
    end
end

--========================================================
-- Utilities
--========================================================

local function Tween(Object, Properties, Duration)
    if not Object or not Object.Parent then
        return
    end

    local Animation = TweenService:Create(
        Object,
        TweenInfo.new(
            Duration or 0.2,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        Properties
    )

    Animation:Play()

    return Animation
end

local function Create(ClassName, Properties, Parent)
    local Object = Instance.new(ClassName)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    Object.Parent = Parent

    return Object
end

local function Corner(Object, Radius)
    local UI = Instance.new("UICorner")
    UI.CornerRadius = UDim.new(0, Radius or 8)
    UI.Parent = Object
    return UI
end

local function Stroke(Object, Color, Thickness, Transparency)
    local UI = Instance.new("UIStroke")

    UI.Color = Color or Theme.Border
    UI.Thickness = Thickness or 1
    UI.Transparency = Transparency or 0

    UI.Parent = Object

    return UI
end

local function Padding(Object, Left, Right, Top, Bottom)
    local UI = Instance.new("UIPadding")

    UI.PaddingLeft = UDim.new(0, Left or 0)
    UI.PaddingRight = UDim.new(0, Right or 0)
    UI.PaddingTop = UDim.new(0, Top or 0)
    UI.PaddingBottom = UDim.new(0, Bottom or 0)

    UI.Parent = Object

    return UI
end

local function Clamp(Value, Minimum, Maximum)
    return math.clamp(Value, Minimum, Maximum)
end

local function GetPlayerGui()
    if not LocalPlayer then
        return nil
    end

    return LocalPlayer:FindFirstChildOfClass("PlayerGui")
        or LocalPlayer:WaitForChild("PlayerGui")
end

--========================================================
-- Window
--========================================================

function Nexus:CreateWindow(Config)
    Config = Config or {}

    local TitleText = tostring(Config.Title or Config.Name or "NEXUS")
    local SubtitleText = tostring(Config.Subtitle or "Modern Interface")
    local WindowSize = Config.Size or UDim2.fromOffset(680, 450)

    local PlayerGui = GetPlayerGui()

    if not PlayerGui then
        error("NexusUI: PlayerGui unavailable")
    end

    --====================================================
    -- ScreenGui
    --====================================================

    local ScreenGui = Create("ScreenGui", {
        Name = "NexusUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    }, PlayerGui)

    --====================================================
    -- Main
    --====================================================

    local Main = Create("Frame", {
        Name = "Window",

        Size = WindowSize,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,

        ClipsDescendants = true,

        ZIndex = 10,
    }, ScreenGui)

    Corner(Main, 12)
    Stroke(Main, Theme.Border, 1)

    --====================================================
    -- Header
    --====================================================

    local Header = Create("Frame", {
        Name = "Header",

        Size = UDim2.new(1, 0, 0, 62),

        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,

        ZIndex = 11,
    }, Main)

    local AccentLine = Create("Frame", {
        Size = UDim2.fromOffset(3, 30),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),

        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,

        ZIndex = 12,
    }, Header)

    Corner(AccentLine, 3)

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -150, 0, 22),
        Position = UDim2.fromOffset(20, 9),

        BackgroundTransparency = 1,

        Text = TitleText,
        TextColor3 = Theme.Text,

        Font = Enum.Font.GothamBold,
        TextSize = 16,

        TextXAlignment = Enum.TextXAlignment.Left,

        ZIndex = 12,
    }, Header)

    local Subtitle = Create("TextLabel", {
        Size = UDim2.new(1, -150, 0, 17),
        Position = UDim2.fromOffset(20, 32),

        BackgroundTransparency = 1,

        Text = SubtitleText,
        TextColor3 = Theme.SubText,

        Font = Enum.Font.Gotham,
        TextSize = 10,

        TextXAlignment = Enum.TextXAlignment.Left,

        ZIndex = 12,
    }, Header)

    --====================================================
    -- Header buttons
    --====================================================

    local MinimizeButton = Create("TextButton", {
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -76, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),

        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        Text = "−",
        TextColor3 = Theme.SubText,

        Font = Enum.Font.GothamBold,
        TextSize = 17,

        AutoButtonColor = false,

        ZIndex = 13,
    }, Header)

    Corner(MinimizeButton, 7)

    local CloseButton = Create("TextButton", {
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -40, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),

        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        Text = "×",
        TextColor3 = Theme.SubText,

        Font = Enum.Font.GothamBold,
        TextSize = 17,

        AutoButtonColor = false,

        ZIndex = 13,
    }, Header)

    Corner(CloseButton, 7)

    --====================================================
    -- Body
    --====================================================

    local Body = Create("Frame", {
        Name = "Body",

        Size = UDim2.new(1, 0, 1, -62),
        Position = UDim2.fromOffset(0, 62),

        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        ZIndex = 11,
    }, Main)

    --====================================================
    -- Sidebar
    --====================================================

    local Sidebar = Create("Frame", {
        Name = "Sidebar",

        Size = UDim2.new(0, 155, 1, 0),

        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,

        ZIndex = 11,
    }, Body)

    local SidebarLine = Create("Frame", {
        Size = UDim2.fromOffset(1, 1),
        Position = UDim2.new(1, -1, 0, 0),

        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,

        ZIndex = 14,
    }, Sidebar)

    SidebarLine.Size = UDim2.new(0, 1, 1, 0)

    local TabHolder = Create("ScrollingFrame", {
        Name = "Tabs",

        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.fromOffset(10, 10),

        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        ScrollBarThickness = 0,

        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,

        ZIndex = 12,
    }, Sidebar)

    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, TabHolder)

    --====================================================
    -- Content
    --====================================================

    local Content = Create("Frame", {
        Name = "Content",

        Size = UDim2.new(1, -155, 1, 0),
        Position = UDim2.fromOffset(155, 0),

        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,

        ZIndex = 11,
    }, Body)

    --====================================================
    -- Notifications
    --====================================================

    local Notifications = Create("Frame", {
        Name = "Notifications",

        Size = UDim2.fromOffset(310, 500),
        Position = UDim2.new(1, -18, 1, -18),
        AnchorPoint = Vector2.new(1, 1),

        BackgroundTransparency = 1,

        ZIndex = 1000,
    }, ScreenGui)

    local NotificationLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 8),

        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,

        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Notifications)

    --====================================================
    -- Window object
    --====================================================

    local Window = {}

    Window.Instance = Main
    Window.ScreenGui = ScreenGui

    Window.Tabs = {}
    Window.ActiveTab = nil

    Window.Minimized = false
    Window.Destroyed = false

    local Connections = {}

    local function Connect(Signal, Callback)
        local Connection = Signal:Connect(Callback)
        table.insert(Connections, Connection)
        return Connection
    end

    local function DisconnectAll()
        for _, Connection in ipairs(Connections) do
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        table.clear(Connections)
    end

    --====================================================
    -- Dragging
    --====================================================

    local Dragging = false
    local DragStart
    local StartPosition

    Connect(Header.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Main.Position

            local Changed

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false

                    if Changed then
                        Changed:Disconnect()
                    end
                end
            end)
        end
    end)

    Connect(UserInputService.InputChanged, function(Input)
        if not Dragging then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end)

    --====================================================
    -- Window methods
    --====================================================

    function Window:SetTitle(Text)
        Title.Text = tostring(Text)
    end

    function Window:SetSubtitle(Text)
        Subtitle.Text = tostring(Text)
    end

    function Window:SetSize(Size)
        WindowSize = Size
        Main.Size = Size
    end

    function Window:SetVisible(State)
        Main.Visible = State == true
    end

    function Window:Destroy()
        if Window.Destroyed then
            return
        end

        Window.Destroyed = true

        DisconnectAll()

        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    --====================================================
    -- Notifications
    --====================================================

    function Window:Notify(Config)
        Config = Config or {}

        local NTitle = tostring(Config.Title or "Notification")
        local NContent = tostring(Config.Content or Config.Text or "")
        local Duration = tonumber(Config.Duration) or 4
        local Type = Config.Type or "Info"

        local Accent = Theme.Accent

        if Type == "Success" then
            Accent = Theme.Success
        elseif Type == "Warning" then
            Accent = Theme.Warning
        elseif Type == "Error" then
            Accent = Theme.Error
        end

        local Notification = Create("Frame", {
            Size = UDim2.fromOffset(290, 70),

            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,

            ZIndex = 1001,
        }, Notifications)

        Corner(Notification, 9)
        Stroke(Notification, Theme.Border, 1)

        local AccentBar = Create("Frame", {
            Size = UDim2.fromOffset(3, 42),
            Position = UDim2.fromOffset(9, 14),

            BackgroundColor3 = Accent,
            BorderSizePixel = 0,

            ZIndex = 1002,
        }, Notification)

        Corner(AccentBar, 3)

        local NotificationTitle = Create("TextLabel", {
            Size = UDim2.new(1, -45, 0, 20),
            Position = UDim2.fromOffset(23, 8),

            BackgroundTransparency = 1,

            Text = NTitle,
            TextColor3 = Theme.Text,

            Font = Enum.Font.GothamBold,
            TextSize = 12,

            TextXAlignment = Enum.TextXAlignment.Left,

            ZIndex = 1002,
        }, Notification)

        local NotificationContent = Create("TextLabel", {
            Size = UDim2.new(1, -45, 0, 32),
            Position = UDim2.fromOffset(23, 30),

            BackgroundTransparency = 1,

            Text = NContent,
            TextColor3 = Theme.SubText,

            Font = Enum.Font.Gotham,
            TextSize = 10,

            TextWrapped = true,

            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,

            ZIndex = 1002,
        }, Notification)

        Notification.Position = UDim2.new(1, 320, 0, 0)

        Tween(Notification, {
            Position = UDim2.new(1, 0, 0, 0)
        }, 0.3)

        task.delay(Duration, function()
            if not Notification.Parent then
                return
            end

            local Animation = Tween(Notification, {
                Position = UDim2.new(1, 320, 0, 0),
                BackgroundTransparency = 1,
            }, 0.25)

            if Animation then
                Animation.Completed:Wait()
            end

            if Notification then
                Notification:Destroy()
            end
        end)

        return Notification
    end

    --====================================================
    -- Header interactions
    --====================================================

    Connect(MinimizeButton.MouseEnter, function()
        Tween(MinimizeButton, {
            BackgroundTransparency = 0,
            BackgroundColor3 = Theme.Hover,
            TextColor3 = Theme.Text,
        })
    end)

    Connect(MinimizeButton.MouseLeave, function()
        Tween(MinimizeButton, {
            BackgroundTransparency = 1,
            TextColor3 = Theme.SubText,
        })
    end)

    Connect(CloseButton.MouseEnter, function()
        Tween(CloseButton, {
            BackgroundTransparency = 0,
            BackgroundColor3 = Theme.Error,
            TextColor3 = Theme.White,
        })
    end)

    Connect(CloseButton.MouseLeave, function()
        Tween(CloseButton, {
            BackgroundTransparency = 1,
            TextColor3 = Theme.SubText,
        })
    end)

    Connect(CloseButton.MouseButton1Click, function()
        Window:Destroy()
    end)

    Connect(MinimizeButton.MouseButton1Click, function()
        Window.Minimized = not Window.Minimized

        if Window.Minimized then
            Body.Visible = false

            Tween(Main, {
                Size = UDim2.fromOffset(
                    Main.AbsoluteSize.X,
                    62
                )
            }, 0.25)
        else
            Body.Visible = true

            Tween(Main, {
                Size = WindowSize
            }, 0.25)
        end
    end)

    --====================================================
    -- Create Tab
    --====================================================

    function Window:CreateTab(Config)
        Config = Config or {}

        local TabName = tostring(Config.Name or "Tab")
        local TabIcon = tostring(Config.Icon or "◆")

        local TabButton = Create("TextButton", {
            Name = TabName,

            Size = UDim2.new(1, 0, 0, 38),

            BackgroundColor3 = Theme.Hover,
            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Text = "",
            AutoButtonColor = false,

            ZIndex = 13,
        }, TabHolder)

        Corner(TabButton, 7)

        local Icon = Create("TextLabel", {
            Size = UDim2.fromOffset(28, 38),
            Position = UDim2.fromOffset(6, 0),

            BackgroundTransparency = 1,

            Text = TabIcon,
            TextColor3 = Theme.Muted,

            Font = Enum.Font.GothamBold,
            TextSize = 12,

            ZIndex = 14,
        }, TabButton)

        local Text = Create("TextLabel", {
            Size = UDim2.new(1, -42, 1, 0),
            Position = UDim2.fromOffset(38, 0),

            BackgroundTransparency = 1,

            Text = TabName,
            TextColor3 = Theme.SubText,

            Font = Enum.Font.GothamMedium,
            TextSize = 11,

            TextXAlignment = Enum.TextXAlignment.Left,

            ZIndex = 14,
        }, TabButton)

        local TabContent = Create("ScrollingFrame", {
            Name = TabName,

            Size = UDim2.new(1, -28, 1, -28),
            Position = UDim2.fromOffset(14, 14),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.2,

            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,

            Visible = false,

            ZIndex = 12,
        }, Content)

        Padding(TabContent, 0, 4, 0, 12)

        local Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, TabContent)

        local Tab = {}

        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Sections = {}

        function Tab:Select()
            if Window.Destroyed then
                return
            end

            if Window.ActiveTab then
                local Old = Window.ActiveTab

                Old.Content.Visible = false

                Tween(Old.Button, {
                    BackgroundTransparency = 1
                })

                Tween(Old.Text, {
                    TextColor3 = Theme.SubText
                })

                Tween(Old.Icon, {
                    TextColor3 = Theme.Muted
                })
            end

            Window.ActiveTab = Tab

            TabContent.Visible = true

            Tween(TabButton, {
                BackgroundTransparency = 0,
                BackgroundColor3 = Theme.Hover
            })

            Tween(Text, {
                TextColor3 = Theme.Text
            })

            Tween(Icon, {
                TextColor3 = Theme.Accent
            })
        end

        Connect(TabButton.MouseEnter, function()
            if Window.ActiveTab == Tab then
                return
            end

            Tween(TabButton, {
                BackgroundTransparency = 0.5,
                BackgroundColor3 = Theme.Hover
            })

            Tween(Text, {
                TextColor3 = Theme.Text
            })
        end)

        Connect(TabButton.MouseLeave, function()
            if Window.ActiveTab == Tab then
                return
            end

            Tween(TabButton, {
                BackgroundTransparency = 1
            })

            Tween(Text, {
                TextColor3 = Theme.SubText
            })
        end)

        Connect(TabButton.MouseButton1Click, function()
            Tab:Select()
        end)

        --================================================
        -- Section
        --================================================

        function Tab:CreateSection(Config)
            Config = Config or {}

            local SectionName = tostring(Config.Name or "Section")

            local SectionFrame = Create("Frame", {
                Name = SectionName,

                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,

                BackgroundTransparency = 1,

                ZIndex = 13,
            }, TabContent)

            local SectionTitle = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),

                BackgroundTransparency = 1,

                Text = string.upper(SectionName),
                TextColor3 = Theme.Muted,

                Font = Enum.Font.GothamBold,
                TextSize = 9,

                TextXAlignment = Enum.TextXAlignment.Left,

                ZIndex = 14,
            }, SectionFrame)

            local Container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 25),

                AutomaticSize = Enum.AutomaticSize.Y,

                BackgroundTransparency = 1,

                ZIndex = 13,
            }, SectionFrame)

            local ComponentLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 7),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, Container)

            local Section = {}

            Section.Instance = SectionFrame
            Section.Container = Container

            table.insert(Tab.Sections, Section)

            --================================================
            -- Button
            --================================================

            function Section:CreateButton(Config)
                Config = Config or {}

                local Name = tostring(Config.Name or "Button")
                local Description = tostring(Config.Description or "")
                local Callback = Config.Callback

                local Height = Description ~= "" and 58 or 42

                local Button = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, Height),

                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,

                    Text = "",
                    AutoButtonColor = false,

                    ZIndex = 15,
                }, Container)

                Corner(Button, 8)
                Stroke(Button, Theme.Border)

                local ButtonTitle = Create("TextLabel", {
                    Size = UDim2.new(1, -45, 0, 20),
                    Position = UDim2.fromOffset(13, Description ~= "" and 8 or 11),

                    BackgroundTransparency = 1,

                    Text = Name,
                    TextColor3 = Theme.Text,

                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Button)

                local ButtonDescription = Create("TextLabel", {
                    Size = UDim2.new(1, -45, 0, 18),
                    Position = UDim2.fromOffset(13, 30),

                    BackgroundTransparency = 1,

                    Text = Description,
                    TextColor3 = Theme.SubText,

                    Font = Enum.Font.Gotham,
                    TextSize = 9,

                    Visible = Description ~= "",

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Button)

                local Arrow = Create("TextLabel", {
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -29, 0.5, -10),

                    BackgroundTransparency = 1,

                    Text = "›",
                    TextColor3 = Theme.Muted,

                    Font = Enum.Font.GothamBold,
                    TextSize = 17,

                    ZIndex = 16,
                }, Button)

                Connect(Button.MouseEnter, function()
                    Tween(Button, {
                        BackgroundColor3 = Theme.Hover
                    })

                    Tween(Arrow, {
                        TextColor3 = Theme.Accent,
                        Position = UDim2.new(1, -25, 0.5, -10)
                    })
                end)

                Connect(Button.MouseLeave, function()
                    Tween(Button, {
                        BackgroundColor3 = Theme.Surface
                    })

                    Tween(Arrow, {
                        TextColor3 = Theme.Muted,
                        Position = UDim2.new(1, -29, 0.5, -10)
                    })
                end)

                Connect(Button.MouseButton1Click, function()
                    if Callback then
                        task.spawn(Callback)
                    end
                end)

                local Object = {
                    Instance = Button
                }

                function Object:SetText(Value)
                    ButtonTitle.Text = tostring(Value)
                end

                function Object:SetVisible(Value)
                    Button.Visible = Value == true
                end

                function Object:Destroy()
                    Button:Destroy()
                end

                return Object
            end

            --================================================
            -- Toggle
            --================================================

            function Section:CreateToggle(Config)
                Config = Config or {}

                local Name = tostring(Config.Name or "Toggle")
                local Description = tostring(Config.Description or "")
                local State = Config.Default == true
                local Callback = Config.Callback

                local Toggle = Create("TextButton", {
                    Size = UDim2.new(
                        1,
                        0,
                        0,
                        Description ~= "" and 58 or 42
                    ),

                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,

                    Text = "",
                    AutoButtonColor = false,

                    ZIndex = 15,
                }, Container)

                Corner(Toggle, 8)
                Stroke(Toggle, Theme.Border)

                local ToggleTitle = Create("TextLabel", {
                    Size = UDim2.new(1, -75, 0, 20),
                    Position = UDim2.fromOffset(
                        13,
                        Description ~= "" and 8 or 11
                    ),

                    BackgroundTransparency = 1,

                    Text = Name,
                    TextColor3 = Theme.Text,

                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Toggle)

                local ToggleDescription = Create("TextLabel", {
                    Size = UDim2.new(1, -75, 0, 18),
                    Position = UDim2.fromOffset(13, 30),

                    BackgroundTransparency = 1,

                    Text = Description,
                    TextColor3 = Theme.SubText,

                    Font = Enum.Font.Gotham,
                    TextSize = 9,

                    Visible = Description ~= "",

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Toggle)

                local Switch = Create("Frame", {
                    Size = UDim2.fromOffset(38, 20),
                    Position = UDim2.new(1, -50, 0.5, -10),

                    BackgroundColor3 = State
                        and Theme.Accent
                        or Theme.Border,

                    BorderSizePixel = 0,

                    ZIndex = 16,
                }, Toggle)

                Corner(Switch, 10)

                local Knob = Create("Frame", {
                    Size = UDim2.fromOffset(16, 16),

                    Position = State
                        and UDim2.new(1, -18, 0.5, -8)
                        or UDim2.new(0, 2, 0.5, -8),

                    BackgroundColor3 = Theme.White,
                    BorderSizePixel = 0,

                    ZIndex = 17,
                }, Switch)

                Corner(Knob, 8)

                local function SetState(Value, Fire)
                    State = Value == true

                    Tween(Switch, {
                        BackgroundColor3 = State
                            and Theme.Accent
                            or Theme.Border
                    })

                    Tween(Knob, {
                        Position = State
                            and UDim2.new(1, -18, 0.5, -8)
                            or UDim2.new(0, 2, 0.5, -8)
                    })

                    if Fire and Callback then
                        task.spawn(Callback, State)
                    end
                end

                Connect(Toggle.MouseEnter, function()
                    Tween(Toggle, {
                        BackgroundColor3 = Theme.Hover
                    })
                end)

                Connect(Toggle.MouseLeave, function()
                    Tween(Toggle, {
                        BackgroundColor3 = Theme.Surface
                    })
                end)

                Connect(Toggle.MouseButton1Click, function()
                    SetState(not State, true)
                end)

                local Object = {
                    Instance = Toggle
                }

                function Object:SetValue(Value)
                    SetState(Value, true)
                end

                function Object:GetValue()
                    return State
                end

                function Object:SetText(Value)
                    ToggleTitle.Text = tostring(Value)
                end

                function Object:SetVisible(Value)
                    Toggle.Visible = Value == true
                end

                function Object:Destroy()
                    Toggle:Destroy()
                end

                return Object
            end

            --================================================
            -- Slider
            --================================================

            function Section:CreateSlider(Config)
                Config = Config or {}

                local Name = tostring(Config.Name or "Slider")
                local Min = tonumber(Config.Min) or 0
                local Max = tonumber(Config.Max) or 100
                local Current = tonumber(Config.Default) or Min

                local Callback = Config.Callback

                if Max <= Min then
                    Max = Min + 1
                end

                Current = Clamp(Current, Min, Max)

                local Slider = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 58),

                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,

                    ZIndex = 15,
                }, Container)

                Corner(Slider, 8)
                Stroke(Slider, Theme.Border)

                local SliderTitle = Create("TextLabel", {
                    Size = UDim2.new(1, -80, 0, 20),
                    Position = UDim2.fromOffset(13, 8),

                    BackgroundTransparency = 1,

                    Text = Name,
                    TextColor3 = Theme.Text,

                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Slider)

                local ValueLabel = Create("TextLabel", {
                    Size = UDim2.fromOffset(55, 20),
                    Position = UDim2.new(1, -68, 0, 8),

                    BackgroundTransparency = 1,

                    TextColor3 = Theme.Accent,
                    Text = tostring(Current),

                    Font = Enum.Font.GothamBold,
                    TextSize = 10,

                    TextXAlignment = Enum.TextXAlignment.Right,

                    ZIndex = 16,
                }, Slider)

                local Track = Create("Frame", {
                    Size = UDim2.new(1, -26, 0, 5),
                    Position = UDim2.new(0, 13, 1, -17),

                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0,

                    ZIndex = 16,
                }, Slider)

                Corner(Track, 3)

                local Fill = Create("Frame", {
                    Size = UDim2.new(
                        (Current - Min) / (Max - Min),
                        0,
                        1,
                        0
                    ),

                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,

                    ZIndex = 17,
                }, Track)

                Corner(Fill, 3)

                local Knob = Create("Frame", {
                    Size = UDim2.fromOffset(12, 12),

                    Position = UDim2.new(1, -6, 0.5, -6),

                    BackgroundColor3 = Theme.White,
                    BorderSizePixel = 0,

                    ZIndex = 18,
                }, Fill)

                Corner(Knob, 6)

                local DraggingSlider = false

                local function SetValue(Value, Fire)
                    Current = Clamp(Value, Min, Max)

                    local Percent = (Current - Min) / (Max - Min)

                    Tween(Fill, {
                        Size = UDim2.new(
                            Percent,
                            0,
                            1,
                            0
                        )
                    }, 0.1)

                    ValueLabel.Text =
                        tostring(math.floor(Current * 100) / 100)

                    if Fire and Callback then
                        task.spawn(Callback, Current)
                    end
                end

                local function UpdateFromInput(Input)
                    local Start = Track.AbsolutePosition.X
                    local Width = Track.AbsoluteSize.X

                    if Width <= 0 then
                        return
                    end

                    local Percent = Clamp(
                        (Input.Position.X - Start) / Width,
                        0,
                        1
                    )

                    SetValue(
                        Min + ((Max - Min) * Percent),
                        true
                    )
                end

                Connect(Track.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Input.UserInputType == Enum.UserInputType.Touch then

                        DraggingSlider = true
                        UpdateFromInput(Input)
                    end
                end)

                Connect(UserInputService.InputChanged, function(Input)
                    if not DraggingSlider then
                        return
                    end

                    if Input.UserInputType == Enum.UserInputType.MouseMovement
                        or Input.UserInputType == Enum.UserInputType.Touch then

                        UpdateFromInput(Input)
                    end
                end)

                Connect(UserInputService.InputEnded, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Input.UserInputType == Enum.UserInputType.Touch then

                        DraggingSlider = false
                    end
                end)

                local Object = {
                    Instance = Slider
                }

                function Object:SetValue(Value)
                    SetValue(tonumber(Value) or Min, true)
                end

                function Object:GetValue()
                    return Current
                end

                function Object:SetVisible(Value)
                    Slider.Visible = Value == true
                end

                function Object:Destroy()
                    Slider:Destroy()
                end

                return Object
            end

            --================================================
            -- Dropdown
            --================================================

            function Section:CreateDropdown(Config)
                Config = Config or {}

                local Name = tostring(Config.Name or "Dropdown")
                local Options = Config.Options or {}
                local Current = Config.Default or Options[1]
                local Callback = Config.Callback

                local Open = false

                local Dropdown = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),

                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,

                    ZIndex = 20,
                }, Container)

                Corner(Dropdown, 8)
                Stroke(Dropdown, Theme.Border)

                local DropdownTitle = Create("TextLabel", {
                    Size = UDim2.new(1, -155, 1, 0),
                    Position = UDim2.fromOffset(13, 0),

                    BackgroundTransparency = 1,

                    Text = Name,
                    TextColor3 = Theme.Text,

                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 21,
                }, Dropdown)

                local Selected = Create("TextButton", {
                    Size = UDim2.fromOffset(135, 30),
                    Position = UDim2.new(1, -145, 0.5, -15),

                    BackgroundColor3 = Theme.Surface2,
                    BorderSizePixel = 0,

                    Text = tostring(Current or "Select"),
                    TextColor3 = Theme.SubText,

                    Font = Enum.Font.GothamMedium,
                    TextSize = 10,

                    AutoButtonColor = false,

                    ZIndex = 22,
                }, Dropdown)

                Corner(Selected, 7)
                Stroke(Selected, Theme.Border)

                local Arrow = Create("TextLabel", {
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -24, 0.5, -10),

                    BackgroundTransparency = 1,

                    Text = "⌄",
                    TextColor3 = Theme.Muted,

                    Font = Enum.Font.GothamBold,
                    TextSize = 12,

                    ZIndex = 23,
                }, Selected)

                local OptionsFrame = Create("Frame", {
                    Size = UDim2.new(1, -26, 0, 0),
                    Position = UDim2.new(0, 13, 1, 5),

                    BackgroundColor3 = Theme.Surface2,
                    BorderSizePixel = 0,

                    ClipsDescendants = true,

                    Visible = false,

                    ZIndex = 100,
                }, Dropdown)

                Corner(OptionsFrame, 7)
                Stroke(OptionsFrame, Theme.Border)

                local OptionsLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }, OptionsFrame)

                Padding(OptionsFrame, 4, 4, 4, 4)

                local function RefreshOptions()
                    for _, Child in ipairs(OptionsFrame:GetChildren()) do
                        if Child:IsA("TextButton") then
                            Child:Destroy()
                        end
                    end

                    for _, Option in ipairs(Options) do
                        local Button = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),

                            BackgroundColor3 = Theme.Surface2,
                            BorderSizePixel = 0,

                            Text = tostring(Option),
                            TextColor3 = Theme.SubText,

                            Font = Enum.Font.GothamMedium,
                            TextSize = 10,

                            AutoButtonColor = false,

                            ZIndex = 101,
                        }, OptionsFrame)

                        Corner(Button, 5)

                        Connect(Button.MouseEnter, function()
                            Tween(Button, {
                                BackgroundColor3 = Theme.Hover,
                                TextColor3 = Theme.Text,
                            })
                        end)

                        Connect(Button.MouseLeave, function()
                            Tween(Button, {
                                BackgroundColor3 = Theme.Surface2,
                                TextColor3 = Theme.SubText,
                            })
                        end)

                        Connect(Button.MouseButton1Click, function()
                            Current = Option
                            Selected.Text = tostring(Option)

                            Open = false
                            OptionsFrame.Visible = false
                            OptionsFrame.Size =
                                UDim2.new(1, -26, 0, 0)

                            Arrow.Text = "⌄"

                            if Callback then
                                task.spawn(Callback, Option)
                            end
                        end)
                    end

                    return math.min(
                        (#Options * 30) + 8,
                        180
                    )
                end

                Connect(Selected.MouseButton1Click, function()
                    Open = not Open

                    if Open then
                        local Height = RefreshOptions()

                        OptionsFrame.Visible = true

                        Tween(OptionsFrame, {
                            Size = UDim2.new(
                                1,
                                -26,
                                0,
                                Height
                            )
                        }, 0.18)

                        Arrow.Text = "⌃"
                    else
                        Tween(OptionsFrame, {
                            Size = UDim2.new(
                                1,
                                -26,
                                0,
                                0
                            )
                        }, 0.18)

                        Arrow.Text = "⌄"

                        task.delay(0.18, function()
                            if not Open and OptionsFrame then
                                OptionsFrame.Visible = false
                            end
                        end)
                    end
                end)

                local Object = {
                    Instance = Dropdown
                }

                function Object:SetValue(Value)
                    Current = Value
                    Selected.Text = tostring(Value)

                    if Callback then
                        task.spawn(Callback, Value)
                    end
                end

                function Object:GetValue()
                    return Current
                end

                function Object:SetOptions(NewOptions)
                    Options = NewOptions or {}

                    if Open then
                        RefreshOptions()
                    end
                end

                function Object:SetVisible(Value)
                    Dropdown.Visible = Value == true
                end

                function Object:Destroy()
                    Dropdown:Destroy()
                end

                return Object
            end

            --================================================
            -- Textbox
            --================================================

            function Section:CreateTextbox(Config)
                Config = Config or {}

                local Name = tostring(Config.Name or "Textbox")
                local Placeholder = tostring(
                    Config.Placeholder or "Enter text..."
                )

                local Default = tostring(Config.Default or "")
                local Callback = Config.Callback

                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),

                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,

                    ZIndex = 15,
                }, Container)

                Corner(Frame, 8)
                Stroke(Frame, Theme.Border)

                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, -165, 1, 0),
                    Position = UDim2.fromOffset(13, 0),

                    BackgroundTransparency = 1,

                    Text = Name,
                    TextColor3 = Theme.Text,

                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Frame)

                local Input = Create("TextBox", {
                    Size = UDim2.fromOffset(140, 30),
                    Position = UDim2.new(1, -150, 0.5, -15),

                    BackgroundColor3 = Theme.Surface2,
                    BorderSizePixel = 0,

                    Text = Default,
                    PlaceholderText = Placeholder,

                    TextColor3 = Theme.Text,
                    PlaceholderColor3 = Theme.Muted,

                    Font = Enum.Font.Gotham,
                    TextSize = 10,

                    ClearTextOnFocus = false,

                    ZIndex = 16,
                }, Frame)

                Corner(Input, 7)
                Stroke(Input, Theme.Border)
                Padding(Input, 8, 8, 0, 0)

                Connect(Input.FocusLost, function()
                    if Callback then
                        task.spawn(Callback, Input.Text)
                    end
                end)

                local Object = {
                    Instance = Frame
                }

                function Object:SetValue(Value)
                    Input.Text = tostring(Value)
                end

                function Object:GetValue()
                    return Input.Text
                end

                function Object:SetVisible(Value)
                    Frame.Visible = Value == true
                end

                function Object:Destroy()
                    Frame:Destroy()
                end

                return Object
            end

            --================================================
            -- Keybind
            --================================================

            function Section:CreateKeybind(Config)
                Config = Config or {}

                local Name = tostring(Config.Name or "Keybind")
                local CurrentKey =
                    Config.Default or Enum.KeyCode.RightShift

                local Callback = Config.Callback

                local Listening = false

                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 46),

                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,

                    ZIndex = 15,
                }, Container)

                Corner(Frame, 8)
                Stroke(Frame, Theme.Border)

                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.fromOffset(13, 0),

                    BackgroundTransparency = 1,

                    Text = Name,
                    TextColor3 = Theme.Text,

                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,

                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Frame)

                local KeyButton = Create("TextButton", {
                    Size = UDim2.fromOffset(70, 30),
                    Position = UDim2.new(1, -80, 0.5, -15),

                    BackgroundColor3 = Theme.Surface2,
                    BorderSizePixel = 0,

                    Text = CurrentKey.Name,
                    TextColor3 = Theme.SubText,

                    Font = Enum.Font.GothamBold,
                    TextSize = 9,

                    AutoButtonColor = false,

                    ZIndex = 16,
                }, Frame)

                Corner(KeyButton, 6)
                Stroke(KeyButton, Theme.Border)

                Connect(KeyButton.MouseButton1Click, function()
                    Listening = true

                    KeyButton.Text = "PRESS..."

                    Tween(KeyButton, {
                        BackgroundColor3 = Theme.Accent,
                        TextColor3 = Theme.White,
                    })
                end)

                Connect(UserInputService.InputBegan, function(Input, Processed)
                    if Listening then
                        if Input.UserInputType
                            == Enum.UserInputType.Keyboard then

                            CurrentKey = Input.KeyCode
                            Listening = false

                            KeyButton.Text = CurrentKey.Name

                            Tween(KeyButton, {
                                BackgroundColor3 = Theme.Surface2,
                                TextColor3 = Theme.SubText,
                            })

                            return
                        end
                    end

                    if Processed then
                        return
                    end

                    if Input.KeyCode == CurrentKey then
                        if Callback then
                            task.spawn(Callback, CurrentKey)
                        end
                    end
                end)

                local Object = {
                    Instance = Frame
                }

                function Object:SetValue(Key)
                    if typeof(Key) == "EnumItem"
                        and Key.EnumType == Enum.KeyCode then

                        CurrentKey = Key
                        KeyButton.Text = Key.Name
                    end
                end

                function Object:GetValue()
                    return CurrentKey
                end

                function Object:SetVisible(Value)
                    Frame.Visible = Value == true
                end

                function Object:Destroy()
                    Frame:Destroy()
                end

                return Object
            end

            --================================================
            -- Label
            --================================================

            function Section:CreateLabel(Config)
                Config = Config or {}

                local Text = tostring(
                    Config.Text or Config.Name or "Label"
                )

                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),

                    BackgroundTransparency = 1,

                    ZIndex = 15,
                }, Container)

                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.fromOffset(10, 0),

                    BackgroundTransparency = 1,

                    Text = Text,
                    TextColor3 = Theme.SubText,

                    Font = Enum.Font.Gotham,
                    TextSize = 10,

                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,

                    ZIndex = 16,
                }, Frame)

                local Object = {
                    Instance = Frame
                }

                function Object:SetText(Value)
                    Label.Text = tostring(Value)
                end

                function Object:SetVisible(Value)
                    Frame.Visible = Value == true
                end

                function Object:Destroy()
                    Frame:Destroy()
                end

                return Object
            end

            return Section
        end

        table.insert(Window.Tabs, Tab)

        if not Window.ActiveTab then
            Tab:Select()
        end

        return Tab
    end

    --====================================================
    -- Opening animation
    --====================================================

    local OriginalSize = WindowSize

    Main.Size = UDim2.fromOffset(
        OriginalSize.X.Offset * 0.92,
        OriginalSize.Y.Offset * 0.92
    )

    Main.BackgroundTransparency = 1

    Tween(Main, {
        Size = OriginalSize,
        BackgroundTransparency = 0
    }, 0.35)

    return Window
end

return Nexus
