local Nexus = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(15, 15, 23),
    Sidebar = Color3.fromRGB(20, 20, 31),
    Panel = Color3.fromRGB(25, 25, 38),
    Element = Color3.fromRGB(32, 32, 48),
    Accent = Color3.fromRGB(145, 85, 255),
    AccentDark = Color3.fromRGB(105, 55, 205),
    Text = Color3.fromRGB(240, 240, 250),
    Muted = Color3.fromRGB(145, 145, 165),
    Border = Color3.fromRGB(48, 45, 65),
    Success = Color3.fromRGB(90, 210, 140),
    Danger = Color3.fromRGB(230, 85, 100)
}

local function Clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function Stroke(parent, color, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Transparency = transparency or 0,
        Thickness = 1
    }, parent)
end

local function Padding(parent, left, right, top, bottom)
    return Create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0)
    }, parent)
end

local function MakeText(parent, text, size, color, font)
    return Create("TextLabel", {
        BackgroundTransparency = 1,
        Text = tostring(text or ""),
        TextColor3 = color or Theme.Text,
        TextSize = size or 14,
        Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, 0, 1, 0)
    }, parent)
end

local function MakeButton(parent, text, size)
    local button = Create("TextButton", {
        Size = size or UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Element,
        Text = tostring(text or "Button"),
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, parent)

    Corner(button, 7)
    return button
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )

    tween:Play()
    return tween
end

local function SafeCallback(callback, ...)
    if typeof(callback) ~= "function" then
        return
    end

    local success, err = pcall(callback, ...)

    if not success then
        warn("[NEXUS] Callback error: " .. tostring(err))
    end
end

local function NormalizeColor(value)
    if typeof(value) == "Color3" then
        return value
    end

    return Theme.Accent
end

function Nexus:SetTheme(theme)
    if typeof(theme) ~= "table" then
        return
    end

    for key, value in pairs(theme) do
        if Theme[key] ~= nil and typeof(value) == "Color3" then
            Theme[key] = value
        end
    end
end

function Nexus:CreateWindow(options)
    options = options or {}

    local Window = {}
    Window.Connections = {}
    Window.Tabs = {}
    Window.Notifications = {}
    Window.Destroyed = false
    Window.Title = tostring(options.Title or "NEXUS")
    Window.Size = options.Size or UDim2.fromOffset(680, 460)

    local function Connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(Window.Connections, connection)
        return connection
    end

    local function IsAlive(object)
        return object ~= nil and object.Parent ~= nil and not Window.Destroyed
    end

    local parent = nil

    if type(gethui) == "function" then
        local success, result = pcall(gethui)
        if success and result then
            parent = result
        end
    end

    if not parent then
        local success, result = pcall(function()
            return CoreGui
        end)

        if success and result then
            parent = result
        end
    end

    if not parent then
        parent = Player:WaitForChild("PlayerGui")
    end

    local oldGui = nil
    pcall(function()
        oldGui = parent:FindFirstChild("NEXUS_UI")
        if oldGui then
            oldGui:Destroy()
        end
    end)

    local ScreenGui = Create("ScreenGui", {
        Name = "NEXUS_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, parent)

    Window.Gui = ScreenGui

    local Main = Create("Frame", {
        Name = "Main",
        Size = Window.Size,
        Position = UDim2.new(0.5, -Window.Size.X.Offset / 2, 0.5, -Window.Size.Y.Offset / 2),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, ScreenGui)

    Window.Main = Main
    Corner(Main, 12)
    Stroke(Main, Theme.Border)

    local Topbar = Create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0
    }, Main)

    local Title = MakeText(Topbar, Window.Title, 16, Theme.Text, Enum.Font.GothamBold)
    Title.Position = UDim2.fromOffset(18, 0)
    Title.Size = UDim2.new(1, -100, 1, 0)

    local CloseButton = Create("TextButton", {
        Size = UDim2.fromOffset(32, 32),
        Position = UDim2.new(1, -42, 0, 8),
        BackgroundColor3 = Theme.Element,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, Topbar)

    Corner(CloseButton, 8)

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(0, 155, 1, -48),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0
    }, Main)

    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Position = UDim2.fromOffset(0, 12),
        Size = UDim2.new(1, 0, 1, -24),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, Sidebar)

    Padding(TabList, 10, 10, 4, 4)

    Create("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, TabList)

    local Content = Create("Frame", {
        Name = "Content",
        Position = UDim2.new(0, 155, 0, 48),
        Size = UDim2.new(1, -155, 1, -48),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0
    }, Main)

    local PageTitle = MakeText(Content, "Home", 18, Theme.Text, Enum.Font.GothamBold)
    PageTitle.Position = UDim2.fromOffset(20, 12)
    PageTitle.Size = UDim2.new(1, -40, 0, 28)

    local Pages = Create("Frame", {
        Name = "Pages",
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 1, -48),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    }, Content)

    Window.Pages = Pages

    local function SwitchTab(tab)
        if Window.Destroyed or not tab then
            return
        end

        for _, existing in ipairs(Window.Tabs) do
            local selected = existing == tab
            existing.Page.Visible = selected
            existing.Button.BackgroundColor3 = selected and Theme.AccentDark or Theme.Element
            existing.Button.TextColor3 = selected and Theme.Text or Theme.Muted
        end

        PageTitle.Text = tab.Name
    end

    function Window:SetTitle(value)
        Window.Title = tostring(value or "NEXUS")
        Title.Text = Window.Title
    end

    function Window:SetVisible(value)
        if Window.Destroyed then
            return
        end

        Main.Visible = value == true
    end

    function Window:Notify(title, message, duration)
        if Window.Destroyed then
            return
        end

        local Notification = Create("Frame", {
            Size = UDim2.fromOffset(270, 78),
            Position = UDim2.new(1, 285, 1, -95),
            BackgroundColor3 = Theme.Panel,
            BorderSizePixel = 0,
            ZIndex = 20
        }, ScreenGui)

        Corner(Notification, 9)
        Stroke(Notification, Theme.Accent)

        local Header = MakeText(Notification, title or "NEXUS", 14, Theme.Accent, Enum.Font.GothamBold)
        Header.Position = UDim2.fromOffset(12, 7)
        Header.Size = UDim2.new(1, -24, 0, 22)
        Header.ZIndex = 21

        local Body = MakeText(Notification, message or "", 12, Theme.Text)
        Body.Position = UDim2.fromOffset(12, 32)
        Body.Size = UDim2.new(1, -24, 0, 36)
        Body.TextWrapped = true
        Body.TextYAlignment = Enum.TextYAlignment.Top
        Body.ZIndex = 21

        table.insert(Window.Notifications, Notification)

        local offset = (#Window.Notifications - 1) * 88
        Tween(Notification, {
            Position = UDim2.new(1, -285, 1, -95 - offset)
        }, 0.25)

        task.delay(tonumber(duration) or 3, function()
            if Notification and Notification.Parent then
                Tween(Notification, {
                    Position = UDim2.new(1, 285, 1, -95 - offset)
                }, 0.2)

                task.wait(0.22)

                if Notification then
                    Notification:Destroy()
                end

                for index, item in ipairs(Window.Notifications) do
                    if item == Notification then
                        table.remove(Window.Notifications, index)
                        break
                    end
                end
            end
        end)
    end

    function Window:CreateTab(name)
        if Window.Destroyed then
            return nil
        end

        local Tab = {}
        Tab.Name = tostring(name or "Tab")

        local Button = Create("TextButton", {
            Name = Tab.Name .. "Button",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.Element,
            Text = Tab.Name,
            TextColor3 = Theme.Muted,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            BorderSizePixel = 0
        }, TabList)

        Corner(Button, 7)

        local Page = Create("ScrollingFrame", {
            Name = Tab.Name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        }, Pages)

        Padding(Page, 18, 18, 15, 15)

        Create("UIListLayout", {
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        Tab.Button = Button
        Tab.Page = Page

        table.insert(Window.Tabs, Tab)

        Connect(Button.MouseButton1Click, function()
            SwitchTab(Tab)
        end)

        function Tab:CreateSection(sectionName)
            if Window.Destroyed or not IsAlive(Page) then
                return nil
            end

            local Section = {}

            local Container = Create("Frame", {
                Name = "Section",
                Size = UDim2.new(1, 0, 0, 45),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Panel,
                BorderSizePixel = 0
            }, Page)

            Corner(Container, 9)
            Stroke(Container, Theme.Border)
            Padding(Container, 12, 12, 10, 12)

            local SectionTitle = MakeText(
                Container,
                sectionName or "Section",
                14,
                Theme.Accent,
                Enum.Font.GothamBold
            )

            SectionTitle.Size = UDim2.new(1, 0, 0, 24)

            local Elements = Create("Frame", {
                Position = UDim2.fromOffset(0, 30),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            }, Container)

            Create("UIListLayout", {
                Padding = UDim.new(0, 9),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, Elements)

            local function AddHolder(height)
                return Create("Frame", {
                    Size = UDim2.new(1, 0, 0, height),
                    BackgroundTransparency = 1
                }, Elements)
            end

            function Section:CreateButton(config)
                config = config or {}

                local button = MakeButton(Elements, config.Name or "Button")

                Connect(button.MouseButton1Click, function()
                    if not IsAlive(button) then
                        return
                    end

                    Tween(button, {BackgroundColor3 = Theme.AccentDark}, 0.1)
                    SafeCallback(config.Callback)

                    task.delay(0.14, function()
                        if IsAlive(button) then
                            Tween(button, {BackgroundColor3 = Theme.Element}, 0.14)
                        end
                    end)
                end)

                return button
            end

            function Section:CreateToggle(config)
                config = config or {}

                local Toggle = {Value = config.CurrentValue == true}
                local holder = AddHolder(36)
                local label = MakeText(holder, config.Name or "Toggle", 13, Theme.Text)
                label.Size = UDim2.new(1, -65, 1, 0)

                local switch = Create("TextButton", {
                    Size = UDim2.fromOffset(42, 22),
                    Position = UDim2.new(1, -42, 0.5, -11),
                    BackgroundColor3 = Toggle.Value and Theme.Accent or Theme.Element,
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0
                }, holder)

                Corner(switch, 20)

                local circle = Create("Frame", {
                    Size = UDim2.fromOffset(16, 16),
                    Position = Toggle.Value and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                }, switch)

                Corner(circle, 20)

                function Toggle:Set(value, silent)
                    Toggle.Value = value == true

                    Tween(switch, {
                        BackgroundColor3 = Toggle.Value and Theme.Accent or Theme.Element
                    }, 0.15)

                    Tween(circle, {
                        Position = Toggle.Value and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3)
                    }, 0.15)

                    if not silent then
                        SafeCallback(config.Callback, Toggle.Value)
                    end
                end

                Connect(switch.MouseButton1Click, function()
                    Toggle:Set(not Toggle.Value)
                end)

                if config.CurrentValue == true then
                    SafeCallback(config.Callback, true)
                end

                return Toggle
            end

            function Section:CreateSlider(config)
                config = config or {}

                local Slider = {}
                local minimum = tonumber(config.Min) or 0
                local maximum = tonumber(config.Max) or 100
                local step = tonumber(config.Increment) or 1

                if maximum < minimum then
                    maximum = minimum
                end

                if step <= 0 then
                    step = 1
                end

                local holder = AddHolder(52)
                local label = MakeText(holder, config.Name or "Slider", 13, Theme.Text)
                label.Size = UDim2.new(1, -70, 0, 22)

                local valueLabel = MakeText(holder, tostring(minimum), 12, Theme.Accent)
                valueLabel.Size = UDim2.fromOffset(65, 22)
                valueLabel.Position = UDim2.new(1, -65, 0, 0)
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local bar = Create("TextButton", {
                    Position = UDim2.fromOffset(0, 31),
                    Size = UDim2.new(1, 0, 0, 7),
                    BackgroundColor3 = Theme.Element,
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0
                }, holder)

                Corner(bar, 10)

                local fill = Create("Frame", {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0
                }, bar)

                Corner(fill, 10)

                local function RoundValue(value)
                    if maximum == minimum then
                        return minimum
                    end

                    local rounded = minimum + math.floor((value - minimum) / step + 0.5) * step
                    return Clamp(rounded, minimum, maximum)
                end

                function Slider:Set(value, silent)
                    value = tonumber(value) or minimum
                    value = RoundValue(Clamp(value, minimum, maximum))
                    Slider.Value = value

                    local percent = 0
                    if maximum > minimum then
                        percent = (value - minimum) / (maximum - minimum)
                    end

                    Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.08)
                    valueLabel.Text = tostring(value)

                    if not silent then
                        SafeCallback(config.Callback, value)
                    end
                end

                local initial = tonumber(config.CurrentValue) or minimum
                Slider:Set(initial, true)

                local dragging = false

                local function UpdateSlider(input)
                    if maximum == minimum or bar.AbsoluteSize.X <= 0 then
                        Slider:Set(minimum)
                        return
                    end

                    local percent = Clamp(
                        (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                        0,
                        1
                    )

                    Slider:Set(minimum + (maximum - minimum) * percent)
                end

                Connect(bar.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)

                Connect(UserInputService.InputChanged, function(input)
                    if dragging and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    ) then
                        UpdateSlider(input)
                    end
                end)

                Connect(UserInputService.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                return Slider
            end

            function Section:CreateLabel(text)
                local label = MakeText(Elements, text or "Label", 13, Theme.Text)
                label.Size = UDim2.new(1, 0, 0, 25)

                function label:Set(value)
                    label.Text = tostring(value or "")
                end

                return label
            end

            function Section:CreateParagraph(config)
                config = config or {}

                local holder = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 55),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0
                }, Elements)

                Corner(holder, 7)
                Padding(holder, 10, 10, 8, 8)

                local title = MakeText(
                    holder,
                    config.Title or "Information",
                    13,
                    Theme.Accent,
                    Enum.Font.GothamBold
                )

                title.Size = UDim2.new(1, 0, 0, 20)

                local description = MakeText(holder, config.Content or "", 12, Theme.Muted)
                description.Position = UDim2.fromOffset(0, 23)
                description.Size = UDim2.new(1, 0, 0, 0)
                description.AutomaticSize = Enum.AutomaticSize.Y
                description.TextWrapped = true
                description.TextYAlignment = Enum.TextYAlignment.Top

                return {
                    SetTitle = function(_, value)
                        title.Text = tostring(value or "")
                    end,
                    SetContent = function(_, value)
                        description.Text = tostring(value or "")
                    end
                }
            end

            function Section:CreateTextbox(config)
                config = config or {}

                local holder = AddHolder(38)
                local box = Create("TextBox", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = config.ClearTextOnFocus == true,
                    PlaceholderText = config.PlaceholderText or config.Name or "Enter text...",
                    PlaceholderColor3 = Theme.Muted,
                    Text = tostring(config.CurrentValue or ""),
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, holder)

                Corner(box, 7)
                Padding(box, 10, 10, 0, 0)

                Connect(box.FocusLost, function(enterPressed)
                    SafeCallback(config.Callback, box.Text, enterPressed)
                end)

                local Textbox = {}

                function Textbox:Set(value, silent)
                    box.Text = tostring(value or "")
                    if not silent then
                        SafeCallback(config.Callback, box.Text, false)
                    end
                end

                function Textbox:Get()
                    return box.Text
                end

                return Textbox
            end

            Section.CreateInput = Section.CreateTextbox

            function Section:CreateDropdown(config)
                config = config or {}

                local Dropdown = {Value = config.CurrentOption}
                local optionsList = config.Options or {}
                local opened = false
                local holder = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true
                }, Elements)

                local header = MakeButton(holder, "", UDim2.new(1, 0, 0, 36))
                local title = MakeText(header, config.Name or "Dropdown", 13, Theme.Text)
                title.Position = UDim2.fromOffset(10, 0)
                title.Size = UDim2.new(0.45, -10, 1, 0)

                local selected = MakeText(header, tostring(Dropdown.Value or "Select..."), 12, Theme.Accent)
                selected.Position = UDim2.new(0.45, 0, 0, 0)
                selected.Size = UDim2.new(0.55, -26, 1, 0)
                selected.TextXAlignment = Enum.TextXAlignment.Right

                local arrow = MakeText(header, "⌄", 16, Theme.Muted)
                arrow.Position = UDim2.new(1, -25, 0, 0)
                arrow.Size = UDim2.fromOffset(20, 36)
                arrow.TextXAlignment = Enum.TextXAlignment.Center

                local list = Create("ScrollingFrame", {
                    Position = UDim2.fromOffset(0, 39),
                    Size = UDim2.new(1, 0, 0, 90),
                    BackgroundColor3 = Theme.Panel,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Visible = true
                }, holder)

                Corner(list, 7)
                Padding(list, 5, 5, 5, 5)

                Create("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }, list)

                local function RefreshOptions()
                    for _, child in ipairs(list:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end

                    for _, option in ipairs(optionsList) do
                        local optionValue = tostring(option)
                        local optionButton = MakeButton(list, optionValue, UDim2.new(1, 0, 0, 28))
                        optionButton.TextSize = 12
                        optionButton.TextXAlignment = Enum.TextXAlignment.Left
                        Padding(optionButton, 8, 8, 0, 0)

                        Connect(optionButton.MouseButton1Click, function()
                            Dropdown:Set(option)
                            opened = false
                            holder.ClipsDescendants = true
                            Tween(holder, {Size = UDim2.new(1, 0, 0, 38)}, 0.15)
                            arrow.Text = "⌄"
                        end)
                    end
                end

                function Dropdown:Set(value, silent)
                    Dropdown.Value = value
                    selected.Text = tostring(value or "Select...")
                    if not silent then
                        SafeCallback(config.Callback, value)
                    end
                end

                function Dropdown:Refresh(newOptions)
                    optionsList = newOptions or {}
                    RefreshOptions()
                end

                Connect(header.MouseButton1Click, function()
                    opened = not opened
                    local height = opened and 136 or 38
                    Tween(holder, {Size = UDim2.new(1, 0, 0, height)}, 0.15)
                    arrow.Text = opened and "⌃" or "⌄"
                end)

                RefreshOptions()

                if Dropdown.Value ~= nil then
                    Dropdown:Set(Dropdown.Value, true)
                end

                return Dropdown
            end

            function Section:CreateMultiDropdown(config)
                config = config or {}

                local MultiDropdown = {Values = config.CurrentOptions or {}}
                local optionsList = config.Options or {}
                local opened = false
                local holder = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true
                }, Elements)

                local header = MakeButton(holder, "", UDim2.new(1, 0, 0, 36))
                local title = MakeText(header, config.Name or "Multi Dropdown", 13, Theme.Text)
                title.Position = UDim2.fromOffset(10, 0)
                title.Size = UDim2.new(0.45, -10, 1, 0)

                local selected = MakeText(header, "None", 11, Theme.Accent)
                selected.Position = UDim2.new(0.45, 0, 0, 0)
                selected.Size = UDim2.new(0.55, -26, 1, 0)
                selected.TextXAlignment = Enum.TextXAlignment.Right
                selected.TextTruncate = Enum.TextTruncate.AtEnd

                local arrow = MakeText(header, "⌄", 16, Theme.Muted)
                arrow.Position = UDim2.new(1, -25, 0, 0)
                arrow.Size = UDim2.fromOffset(20, 36)
                arrow.TextXAlignment = Enum.TextXAlignment.Center

                local list = Create("ScrollingFrame", {
                    Position = UDim2.fromOffset(0, 39),
                    Size = UDim2.new(1, 0, 0, 100),
                    BackgroundColor3 = Theme.Panel,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y
                }, holder)

                Corner(list, 7)
                Padding(list, 5, 5, 5, 5)

                Create("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }, list)

                local function Contains(value)
                    for _, current in ipairs(MultiDropdown.Values) do
                        if current == value then
                            return true
                        end
                    end
                    return false
                end

                local function UpdateDisplay()
                    if #MultiDropdown.Values == 0 then
                        selected.Text = "None"
                    else
                        local display = {}
                        for _, value in ipairs(MultiDropdown.Values) do
                            table.insert(display, tostring(value))
                        end
                        selected.Text = table.concat(display, ", ")
                    end
                end

                function MultiDropdown:Set(values, silent)
                    MultiDropdown.Values = values or {}
                    UpdateDisplay()
                    if not silent then
                        SafeCallback(config.Callback, MultiDropdown.Values)
                    end
                end

                function MultiDropdown:Refresh(newOptions)
                    optionsList = newOptions or {}
                    for _, child in ipairs(list:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end

                    for _, option in ipairs(optionsList) do
                        local optionValue = option
                        local optionButton = MakeButton(list, tostring(optionValue), UDim2.new(1, 0, 0, 28))
                        optionButton.TextSize = 12
                        optionButton.TextXAlignment = Enum.TextXAlignment.Left
                        Padding(optionButton, 8, 8, 0, 0)

                        Connect(optionButton.MouseButton1Click, function()
                            if Contains(optionValue) then
                                for index, current in ipairs(MultiDropdown.Values) do
                                    if current == optionValue then
                                        table.remove(MultiDropdown.Values, index)
                                        break
                                    end
                                end
                            else
                                table.insert(MultiDropdown.Values, optionValue)
                            end

                            UpdateDisplay()
                            SafeCallback(config.Callback, MultiDropdown.Values)
                        end)
                    end
                end

                Connect(header.MouseButton1Click, function()
                    opened = not opened
                    Tween(holder, {
                        Size = UDim2.new(1, 0, 0, opened and 146 or 38)
                    }, 0.15)
                    arrow.Text = opened and "⌃" or "⌄"
                end)

                MultiDropdown:Refresh(optionsList)
                UpdateDisplay()

                return MultiDropdown
            end

            function Section:CreateKeybind(config)
                config = config or {}

                local Keybind = {Value = config.CurrentKey or Enum.KeyCode.Unknown}
                local holder = AddHolder(36)
                local label = MakeText(holder, config.Name or "Keybind", 13, Theme.Text)
                label.Size = UDim2.new(1, -115, 1, 0)

                local keyButton = MakeButton(holder, tostring(Keybind.Value.Name), UDim2.fromOffset(105, 30))
                keyButton.Position = UDim2.new(1, -105, 0, 3)
                keyButton.TextSize = 12

                local listening = false

                function Keybind:Set(key, silent)
                    if typeof(key) == "string" then
                        local success, result = pcall(function()
                            return Enum.KeyCode[key]
                        end)
                        if success and result then
                            key = result
                        end
                    end

                    if typeof(key) ~= "EnumItem" then
                        return
                    end

                    Keybind.Value = key
                    keyButton.Text = key.Name

                    if not silent then
                        SafeCallback(config.Callback, key)
                    end
                end

                Connect(keyButton.MouseButton1Click, function()
                    listening = true
                    keyButton.Text = "..."
                end)

                Connect(UserInputService.InputBegan, function(input, processed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            Keybind:Set(input.KeyCode)
                        end
                        return
                    end

                    if processed then
                        return
                    end

                    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Keybind.Value then
                        SafeCallback(config.Callback, Keybind.Value)
                    end
                end)

                return Keybind
            end

            function Section:CreateColorPicker(config)
                config = config or {}

                local ColorPicker = {Value = NormalizeColor(config.Color or config.CurrentValue)}
                local opened = false
                local holder = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true
                }, Elements)

                local label = MakeText(holder, config.Name or "Color Picker", 13, Theme.Text)
                label.Size = UDim2.new(1, -55, 0, 36)

                local preview = Create("TextButton", {
                    Size = UDim2.fromOffset(38, 24),
                    Position = UDim2.new(1, -38, 0, 6),
                    BackgroundColor3 = ColorPicker.Value,
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0
                }, holder)

                Corner(preview, 6)
                Stroke(preview, Theme.Border)

                local panel = Create("Frame", {
                    Position = UDim2.fromOffset(0, 42),
                    Size = UDim2.new(1, 0, 0, 82),
                    BackgroundColor3 = Theme.Panel,
                    BorderSizePixel = 0
                }, holder)

                Corner(panel, 7)
                Padding(panel, 8, 8, 7, 7)

                local fields = {}
                local components = {"R", "G", "B"}
                local current = {
                    math.floor(ColorPicker.Value.R * 255 + 0.5),
                    math.floor(ColorPicker.Value.G * 255 + 0.5),
                    math.floor(ColorPicker.Value.B * 255 + 0.5)
                }

                for index, component in ipairs(components) do
                    local fieldLabel = MakeText(panel, component, 12, Theme.Muted)
                    fieldLabel.Position = UDim2.fromOffset((index - 1) * 82, 0)
                    fieldLabel.Size = UDim2.fromOffset(16, 28)

                    local field = Create("TextBox", {
                        Position = UDim2.fromOffset(18 + (index - 1) * 82, 0),
                        Size = UDim2.fromOffset(56, 28),
                        BackgroundColor3 = Theme.Element,
                        BorderSizePixel = 0,
                        Text = tostring(current[index]),
                        TextColor3 = Theme.Text,
                        PlaceholderColor3 = Theme.Muted,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        ClearTextOnFocus = false
                    }, panel)

                    Corner(field, 5)
                    fields[index] = field
                end

                local applyButton = MakeButton(panel, "Apply", UDim2.new(1, 0, 0, 28))
                applyButton.Position = UDim2.fromOffset(0, 36)
                applyButton.BackgroundColor3 = Theme.AccentDark

                function ColorPicker:Set(color, silent)
                    if typeof(color) ~= "Color3" then
                        return
                    end

                    ColorPicker.Value = color
                    preview.BackgroundColor3 = color

                    current = {
                        math.floor(color.R * 255 + 0.5),
                        math.floor(color.G * 255 + 0.5),
                        math.floor(color.B * 255 + 0.5)
                    }

                    for index, field in ipairs(fields) do
                        field.Text = tostring(current[index])
                    end

                    if not silent then
                        SafeCallback(config.Callback, color)
                    end
                end

                Connect(preview.MouseButton1Click, function()
                    opened = not opened
                    Tween(holder, {
                        Size = UDim2.new(1, 0, 0, opened and 130 or 38)
                    }, 0.15)
                end)

                Connect(applyButton.MouseButton1Click, function()
                    local values = {}

                    for index, field in ipairs(fields) do
                        local number = tonumber(field.Text)
                        if not number then
                            number = current[index]
                        end
                        values[index] = Clamp(math.floor(number + 0.5), 0, 255)
                    end

                    ColorPicker:Set(Color3.fromRGB(values[1], values[2], values[3]))
                end)

                return ColorPicker
            end

            return Section
        end

        if #Window.Tabs == 1 then
            SwitchTab(Tab)
        end

        return Tab
    end

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    Connect(Topbar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = Main.Position
            dragInput = input

            Connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragInput = nil
                end
            end)
        end
    end)

    Connect(UserInputService.InputChanged, function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or (dragInput and input == dragInput) then
            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragInput = nil
        end
    end)

    function Window:Destroy()
        if Window.Destroyed then
            return
        end

        Window.Destroyed = true

        for _, connection in ipairs(Window.Connections) do
            pcall(function()
                connection:Disconnect()
            end)
        end

        Window.Connections = {}
        Window.Notifications = {}

        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    Connect(CloseButton.MouseButton1Click, function()
        Window:Destroy()
    end)

    return Window
end

return Nexus
