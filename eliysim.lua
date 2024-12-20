getgenv().elisium = {
    Camlock = {
        Enabled = true,
        AimPart = "UpperTorso",
        Prediction = 0.123,
        Smoothness = 0.09,
        Mode = "Button",
        Spectate = false
    },
    TargetAim = {
        enabled = true,
        targetPart = "UpperTorso",
        prediction = 0.1161431
    },
    AutoAir = {
        Enabled = true,
        Delay = 0
    },
    AutoPred = {
        Enabled = true,
        Mode = "Advanced" -- // Ping, Advanced, Distance
    },
    Cframe = {
        enabled = false,
        speed = 2
    },
    Fov = {
        Visible = true,
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 1,
        Size = 90,
        Thickness = 2,
        Filled = false
    },
    Strafe = {
        Enabled = false,
        StrafeSpeed = 10,
        StrafeRadius = 10,
        StrafeHeight = 3,
        Mode = "CSync", -- // Strafe, Random, CSync
        Spoof = true
    },
    Desync = {
        Toggled = false,
        Speed = 0.1,
        Mode = "Walkable", -- // Default, Random, Walkable
        X = 5000,
        Y = 5000,
        Z = 5000
    },
    Visualizer = {
        Enabled = false,
        Color = Color3.fromRGB(0, 0, 0),
        Material = "ForceField"
    },
    Selfcham = {
        Enabled = false,
        Color = Color3.fromRGB(0, 0, 0),
        Material = "ForceField"
    },
    LineTrail = {
        Enabled = true,
        Color = Color3.fromRGB(0, 0, 0),
        Material = "ForceField",
        Speed = 1,
        Width = 0.3,
        TransparencyStart = 0,
        TransparencyEnd = 5,
        MinLength = 0.1
    },
    BallTrail = {
        Enabled = false,
        Color = Color3.fromRGB(0, 0, 0),
        Material = "ForceField",
        Speed = 0,
        Lifetime = 5,
        Size = Vector3.new(1, 1, 1),
        TransparencyStart = 0,
        TransparencyEnd = 1
    },
    Loaded = false
}

local target = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local playerCamera = Workspace.CurrentCamera
local Camera = Workspace.CurrentCamera

local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoid = playerCharacter:FindFirstChild("Humanoid") or playerCharacter:WaitForChild("Humanoid")
local playerHumanoidRootPart =
    playerCharacter:FindFirstChild("HumanoidRootPart") or playerCharacter:WaitForChild("HumanoidRootPart")

if elisium.Loaded then
    notify("Already Loaded")
    return
end

elisium.Loaded = true

local isSpectating = false

game:GetService("RunService").RenderStepped:Connect(
    function(deltaTime)
        if elisium.Camlock.Spectate and target and target.Character then
            if not isSpectating then
                game.Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                isSpectating = true
            end

            local cameraPosition = game.Workspace.CurrentCamera.CFrame.Position
            local targetPosition = target.Character.HumanoidRootPart.Position
            game.Workspace.CurrentCamera.CFrame =
                CFrame.new(cameraPosition, Vector3.new(targetPosition.X, cameraPosition.Y, targetPosition.Z))
        else
            if isSpectating then
                game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
                isSpectating = false
            end
        end
    end
)



local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = elisium.Fov.Visible
FOVCircle.Color = elisium.Fov.Color
FOVCircle.Transparency = elisium.Fov.Transparency
FOVCircle.Thickness = 1
FOVCircle.NumSides = 1000000
FOVCircle.Radius = elisium.Fov.Size
FOVCircle.Filled = elisium.Fov.Filled
FOVCircle.Position = Vector2.new(playerCamera.ViewportSize.X / 2, playerCamera.ViewportSize.Y / 2)

local Notification = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

for Key, Object in pairs(getgc(true)) do
    if type(Object) == "table" then
        setreadonly(Object, false)
        local indexInstance = rawget(Object, "indexInstance")
        if type(indexInstance) == "table" and indexInstance[1] == "kick" then
            setreadonly(indexInstance, false)
            rawset(
                Object,
                "Table",
                {
                    "kick",
                    function()
                        coroutine.yield()
                    end
                }
            ) --> By using coroutine.yield() we are preventing script table from communicating with the server.
            warn(
                "\n---[ INFO ]---\nBypassed Adonis Anti-Cheat/Anti-Exploit.\nBypass Method: Preventing Script Table From Communicating With The Server."
            )
            break
        end
    end
end

Notification.Name = "Notification"
Notification.Parent = game.CoreGui
Notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = Notification
Holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Holder.BackgroundTransparency = 1
Holder.Position = UDim2.new(1, -10, 0, 10)
Holder.AnchorPoint = Vector2.new(1, 0)
Holder.Size = UDim2.new(0, 243, 0, 240)

UIListLayout.Parent = Holder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local function createNotificationTemplate(text, duration)
    local Template = Instance.new("Frame")
    local ColorBar = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")

    Template.Name = text
    Template.Parent = Holder
    Template.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Template.BorderSizePixel = 0
    Template.Size = UDim2.new(1, 0, 0, 22)
    Template.Transparency = 1

    ColorBar.Name = "ColorBar"
    ColorBar.Parent = Template
    ColorBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    ColorBar.BorderSizePixel = 0
    ColorBar.Size = UDim2.new(0, 2, 0, 22)
    ColorBar.Transparency = 1

    TextLabel.Parent = Template
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0, 8, 0, 0)
    TextLabel.Size = UDim2.new(1, -10, 0, 22)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = text .. " [" .. duration .. "s]"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 12
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Transparency = 1

    return Template, ColorBar, TextLabel
end

function notify(text, time)
    if time <= 0 then
        warn("Notification duration must be greater than 0")
        return
    end

    local Template, ColorBar, TextLabel = createNotificationTemplate(text, time)

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeInGoal = {Transparency = 0}
    local fadeOutGoal = {Transparency = 1}

    local sizeTween = TweenService:Create(Template, tweenInfo, fadeInGoal)
    local colorBarTween = TweenService:Create(ColorBar, tweenInfo, fadeInGoal)
    local textTween = TweenService:Create(TextLabel, tweenInfo, fadeInGoal)

    sizeTween:Play()
    colorBarTween:Play()
    textTween:Play()

    local elapsed = 0
    local updateConnection

    updateConnection =
        RunService.RenderStepped:Connect(
        function(dt)
            elapsed = elapsed + dt
            local remainingTime = math.max(0, time - elapsed)
            TextLabel.Text = text .. " [" .. string.format("%.1f", remainingTime) .. "s]"

            if remainingTime <= 0 then
                updateConnection:Disconnect()
                local fadeOutTween = TweenService:Create(Template, tweenInfo, fadeOutGoal)
                fadeOutTween:Play()
                fadeOutTween.Completed:Wait()
                Template:Destroy()
            end
        end
    )
end

local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = math.huge

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= player and Player.Character then
            for _, PlayerPart in ipairs(Player.Character:GetChildren()) do
                if PlayerPart:IsA("BasePart") and PlayerPart.Transparency ~= 1 then
                    local ViewportPointPosition, OnScreen = Camera:WorldToViewportPoint(PlayerPart.Position)
                    local MagnitudeDistance =
                        (Vector2.new(ViewportPointPosition.X, ViewportPointPosition.Y) - FOVCircle.Position).Magnitude

                    if OnScreen and MagnitudeDistance < ShortestDistance and MagnitudeDistance <= FOVCircle.Radius then
                        ClosestPlayer = Player
                        ShortestDistance = MagnitudeDistance
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

local function clonePlayerForVisualizer()
    if getgenv().elisium.Visualizer.Enabled then
        local clonesFolder = workspace:FindFirstChild("PlayerClones")
        if not clonesFolder then
            clonesFolder = Instance.new("Folder")
            clonesFolder.Name = "PlayerClones"
            clonesFolder.Parent = workspace
        end

        if playerCharacter and not playerClone then
            playerCharacter.Archivable = true
            playerClone = playerCharacter:Clone()
            playerClone.Parent = clonesFolder
            playerClone.Name = "LocalPlayer Clone"
            playerClone:FindFirstChild("HumanoidRootPart").Anchored = true
            playerClone:FindFirstChild("HumanoidRootPart").CanCollide = false
            for _, child in ipairs(playerClone:GetChildren()) do
                if child:IsA("MeshPart") then
                    if child.Name == "Head" and child:FindFirstChild("face") then
                        child:FindFirstChild("face"):Destroy()
                    end

                    child.Color = getgenv().elisium.Visualizer.Color
                    child.Material = Enum.Material[getgenv().elisium.Visualizer.Material]
                    child.CanCollide = false
                elseif not child:IsA("MeshPart") and child.Name ~= "HumanoidRootPart" then
                    child:Destroy()
                end
            end
        end
    else
        if playerClone then
            playerClone:Destroy()
            playerClone = nil
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(clonePlayerForVisualizer)
clonePlayerForVisualizer()

local function ToggleLock()
    if elisium.Camlock.Enabled then
        if target then
            notify("Lock: Unlocked!", 5)
            target = nil
        else
            target = GetClosestPlayer()
            if target then
                notify("Lock: Locked onto " .. tostring(target.Name), 5)
            else
                notify("Lock: No target found", 5)
            end
        end
    else
        notify("Lock not enabled", 5)
    end
end

local function applyChamToPlayer()
    if getgenv().elisium.Selfcham.Enabled then
        if playerCharacter then
            for _, child in ipairs(playerCharacter:GetChildren()) do
                if child:IsA("MeshPart") then
                    child.Color = getgenv().elisium.Selfcham.Color

                    child.Material = Enum.Material[getgenv().elisium.Selfcham.Material]
                    child.CanCollide = false

                    if child.Name == "Head" and child:FindFirstChild("face") then
                        child:FindFirstChild("face"):Destroy()
                    end
                end
            end
        end
    end
end

applyChamToPlayer()

local function applyLineTrailChamToPlayer()
    if getgenv().elisium.LineTrail.Enabled then
        local playerCharacter = game.Players.LocalPlayer.Character

        if playerCharacter then
            local humanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                local attachment0 = Instance.new("Attachment")
                attachment0.Parent = humanoidRootPart
                attachment0.Name = "TrailStart"

                local attachment1 = Instance.new("Attachment")
                attachment1.Parent = humanoidRootPart
                attachment1.Position = Vector3.new(0, -3, 0)
                attachment1.Name = "TrailEnd"

                local trail = Instance.new("Trail")
                trail.Parent = humanoidRootPart
                trail.Attachment0 = attachment0
                trail.Attachment1 = attachment1

                trail.Color = ColorSequence.new(getgenv().elisium.LineTrail.Color)
                trail.Transparency =
                    NumberSequence.new(
                    {
                        NumberSequenceKeypoint.new(0, getgenv().elisium.LineTrail.TransparencyStart),
                        NumberSequenceKeypoint.new(1, getgenv().elisium.LineTrail.TransparencyEnd)
                    }
                )
                trail.Lifetime = getgenv().elisium.LineTrail.Speed
                trail.MinLength = getgenv().elisium.LineTrail.MinLength
                trail.FaceCamera = true
                trail.WidthScale = NumberSequence.new(getgenv().elisium.LineTrail.Width)

                humanoidRootPart.Material = Enum.Material[getgenv().elisium.LineTrail.Material]
            end
        end
    end
end

applyLineTrailChamToPlayer()

local function createBallTrail(playerCharacter)
    if getgenv().elisium.BallTrail.Enabled then
        local humanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            while getgenv().elisium.BallTrail.Enabled do
                local ball = Instance.new("Part")
                ball.Shape = Enum.PartType.Ball
                ball.Size = getgenv().elisium.BallTrail.Size
                ball.Color = getgenv().elisium.BallTrail.Color
                ball.Material = Enum.Material[getgenv().elisium.BallTrail.Material]
                ball.Anchored = true
                ball.CanCollide = false
                ball.CFrame = humanoidRootPart.CFrame
                ball.Parent = workspace

                local transparencyTween =
                    game:GetService("TweenService"):Create(
                    ball,
                    TweenInfo.new(getgenv().elisium.BallTrail.Lifetime, Enum.EasingStyle.Linear),
                    {Transparency = getgenv().elisium.BallTrail.TransparencyEnd}
                )
                transparencyTween:Play()

                game.Debris:AddItem(ball, getgenv().elisium.BallTrail.Lifetime)

                wait(getgenv().elisium.BallTrail.Speed)
            end
        end
    end
end

local function applyBallTrailToPlayer()
    local playerCharacter = game.Players.LocalPlayer.Character
    if playerCharacter then
        createBallTrail(playerCharacter)
    end
end

local UserInputService = game:GetService("UserInputService")

if elisium.Camlock.Mode == "Tool" then
    local Tool = Instance.new("Tool")
    Tool.RequiresHandle = false
    Tool.Name = "Lock Tool "
    Tool.Parent = player.Backpack

    Tool.Activated:Connect(ToggleLock)
elseif elisium.Camlock.Mode == "Pc" then
    Mouse.KeyDown:Connect(
        function(key)
            if key == "c" then
                ToggleLock()
            end
        end
    )
elseif elisium.Camlock.Mode == "Button" then
    local playerGui = player:WaitForChild("PlayerGui")

    local function setupGui()
        local screenGui = playerGui:FindFirstChild("LockScreenGui")

        if not screenGui then
            screenGui = Instance.new("ScreenGui")
            screenGui.Name = "LockScreenGui"
            screenGui.Parent = playerGui
        end

        local button = screenGui:FindFirstChild("LockButton")

        if not button then
            button = Instance.new("TextButton")
            button.Name = "LockButton"
            button.Size = UDim2.new(0, 100, 0, 50)
            button.Position = UDim2.new(1, -100, 0, 20)
            button.Text = "Elisium"
            button.TextSize = 15
            button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Parent = screenGui
            button.Active = true
            button.Draggable = true

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 25)
            UICorner.Parent = button

            button.MouseButton1Click:Connect(
                function()
                    ToggleLock()
                end
            )
        end
    end

    setupGui()

    player.CharacterAdded:Connect(
        function()
            setupGui()
        end
    )
elseif elisium.Camlock.Mode == "Controller" then
    UserInputService.InputBegan:Connect(
        function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.DPadDown then
                ToggleLock()
            end
        end
    )
end

RunService.RenderStepped:Connect(
    function()
        if target and target.Character and target.Character:FindFirstChild(elisium.Camlock.AimPart) then
            local aimPart = target.Character[elisium.Camlock.AimPart]
            local targetPosition = aimPart.Position + aimPart.Velocity * elisium.Camlock.Prediction
            local lookPosition = CFrame.new(Camera.CFrame.p, targetPosition)
            Camera.CFrame = Camera.CFrame:Lerp(lookPosition, elisium.Camlock.Smoothness)

            if elisium.Strafe.Enabled then
                local lp = player.Character
                local targpos = target.Character.HumanoidRootPart.Position
                local strafeOffset

                if elisium.Strafe.Mode == "Random" then
                    strafeOffset =
                        Vector3.new(
                        math.random(-elisium.Strafe.StrafeRadius, elisium.Strafe.StrafeRadius),
                        math.random(0, elisium.Strafe.StrafeHeight),
                        math.random(-elisium.Strafe.StrafeRadius, elisium.Strafe.StrafeRadius)
                    )
                elseif elisium.Strafe.Mode == "Strafe" then
                    strafeOffset =
                        Vector3.new(
                        math.cos(tick() * elisium.Strafe.StrafeSpeed) * elisium.Strafe.StrafeRadius,
                        elisium.Strafe.StrafeHeight,
                        math.sin(tick() * elisium.Strafe.StrafeSpeed) * elisium.Strafe.StrafeRadius
                    )
                end
 
                local strafePosition = targpos + strafeOffset
                strafePosition = Vector3.new(strafePosition.X, math.max(strafePosition.Y, targpos.Y), strafePosition.Z)

                lp:SetPrimaryPartCFrame(CFrame.new(strafePosition))
                player.Character.HumanoidRootPart.CFrame =
                    CFrame.new(
                    player.Character.HumanoidRootPart.CFrame.Position,
                    Vector3.new(targpos.X, player.Character.HumanoidRootPart.CFrame.Position.Y, targpos.Z)
                )
            end
        end
    end
)

        RunService.Heartbeat:Connect(
            function()
                local DesyncConfig = getgenv().elisium.Desync
                if DesyncConfig.Toggled then
                    local playerHumanoidRootPartAssemblyLinearVelocity = playerHumanoidRootPart.AssemblyLinearVelocity

                    if DesyncConfig.Mode == "Default" then
                        playerHumanoidRootPart.CFrame =
                            playerHumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(DesyncConfig.Speed), 0)
                        playerHumanoidRootPart.AssemblyLinearVelocity =
                            Vector3.new(DesyncConfig.X, DesyncConfig.Y, DesyncConfig.Z)
                        RunService.RenderStepped:Wait()
                        playerHumanoidRootPart.AssemblyLinearVelocity = playerHumanoidRootPartAssemblyLinearVelocity
                    elseif DesyncConfig.Mode == "Random" then
                        playerHumanoidRootPart.CFrame =
                            playerHumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(DesyncConfig.Speed), 0)
                        playerHumanoidRootPart.Velocity =
                            Vector3.new(
                            math.random(-DesyncConfig.X, DesyncConfig.X),
                            math.random(-DesyncConfig.Y, DesyncConfig.Y),
                            math.random(-DesyncConfig.Z, DesyncConfig.Z)
                        )
                        RunService.RenderStepped:Wait()
                        playerHumanoidRootPart.AssemblyLinearVelocity = playerHumanoidRootPartAssemblyLinearVelocity
                    elseif DesyncConfig.Mode == "Walkable" then
                        playerHumanoidRootPart.CFrame = playerHumanoidRootPart.CFrame * CFrame.Angles(0, 0, 0)
                        playerHumanoidRootPart.Velocity =
                            Vector3.new(
                            math.random(-DesyncConfig.X, DesyncConfig.X),
                            math.random(-DesyncConfig.Y, DesyncConfig.Y),
                            math.random(-DesyncConfig.Z, DesyncConfig.Z)
                        )
                        playerHumanoidRootPart.CFrame =
                            playerHumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(DesyncConfig.Speed), 0)
                        RunService.RenderStepped:Wait()
                        playerHumanoidRootPart.AssemblyLinearVelocity = playerHumanoidRootPartAssemblyLinearVelocity
                    end
                end
            end
        )

RunService.RenderStepped:Connect(
    function(deltaTime)
        if elisium.AutoAir.Enabled then
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = target.Character:FindFirstChild("Humanoid")

                if humanoid then
                    local state = humanoid:GetState()
                    local playerCharacter = game.Players.LocalPlayer.Character
                    local tool = playerCharacter and playerCharacter:FindFirstChildOfClass("Tool")

                    if (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall) then
                        if tool and tool.Name ~= "Lock Tool" then
                            task.wait(elisium.AutoAir.Delay)
                            tool:Activate()
                        end
                    end
                end
            end
        end

        if elisium.Strafe.Mode == "Random" then
            RunService.RenderStepped:Connect(
                function()
                    if
                        elisium.Strafe.Enabled and target and target.Character and
                            target.Character:FindFirstChild("HumanoidRootPart")
                     then
                        local hrp = target.Character.HumanoidRootPart
                        local randomOffset =
                            Vector3.new(
                            math.random(-1, 1) * elisium.Strafe.StrafeRadius,
                            elisium.Strafe.StrafeHeight,
                            math.random(-1, 1) * elisium.Strafe.StrafeRadius
                        )
                        hrp.CFrame = hrp.CFrame + randomOffset
                    end
                end
            )
        end
    end
)
RunService.RenderStepped:Connect(applyChamToPlayer)

RunService.Heartbeat:Connect(
    function(deltaTime)
        if
            elisium.Camlock.Enabled and elisium.Strafe.Enabled and elisium.Strafe.Mode == "CSync" and playerCharacter and
                playerHumanoid and
                playerHumanoidRootPart and
                target
         then
            local TickTime = tick() * elisium.Strafe.StrafeSpeed
            local Strafe =
                Vector3.new(
                math.cos(TickTime) * elisium.Strafe.StrafeRadius,
                elisium.Strafe.StrafeHeight,
                math.sin(TickTime) * elisium.Strafe.StrafeRadius
            )

            playerHumanoidRootPartCFrame = playerHumanoidRootPart.CFrame
            playerHumanoid.AutoRotate = true
            playerHumanoidRootPart.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position + Strafe)
            playerHumanoidRootPart.CFrame =
                CFrame.lookAt(
                playerHumanoidRootPart.Position,
                Vector3.new(
                    target.Character.HumanoidRootPart.Position.X,
                    playerHumanoidRootPart.Position.Y,
                    target.Character.HumanoidRootPart.Position.Z
                )
            )

            clonePlayerForVisualizer()
            if playerClone and playerClone:FindFirstChild("HumanoidRootPart") then
                playerClone.HumanoidRootPart.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position + Strafe)
                playerClone.HumanoidRootPart.CFrame =
                    CFrame.lookAt(
                    playerClone.HumanoidRootPart.Position,
                    Vector3.new(
                        target.Character.HumanoidRootPart.Position.X,
                        playerClone.HumanoidRootPart.Position.Y,
                        target.Character.HumanoidRootPart.Position.Z
                    )
                )
            end

            if elisium.Strafe.Spoof then
                RunService.RenderStepped:Wait()
                playerHumanoidRootPart.CFrame = playerHumanoidRootPartCFrame
                playerHumanoidRootPartCFrame = playerHumanoidRootPart.CFrame
            end
        else
            if playerClone then
                playerClone:Destroy()
                playerClone = nil
            end
        end
    end
)

do
    local OriginalIndex
    OriginalIndex =
        hookmetamethod(
        Game,
        "__index",
        function(Instance, Property)
            if
                elisium.Strafe.Enabled and elisium.Strafe.Spoof and not checkcaller() and target and playerCharacter and
                    playerHumanoidRootPart and
                    Instance == playerHumanoidRootPart and
                    Property == "CFrame"
             then
                return playerHumanoidRootPartCFrame
            end
            return OriginalIndex(Instance, Property)
        end
    )
end

spawn(
    function()
        RunService.Heartbeat:Connect(
            function()
                if elisium.Cframe.enabled then
                    player.Character.HumanoidRootPart.CFrame =
                        player.Character.HumanoidRootPart.CFrame +
                        player.Character.Humanoid.MoveDirection * elisium.Cframe.speed
                end
            end
        )
    end
)

for _, con in pairs(getconnections(Camera.Changed)) do
    con:Disable()
end
for _, con in pairs(getconnections(Camera:GetPropertyChangedSignal("CFrame"))) do
    con:Disable()
end


local mt = getrawmetatable(game)
local oldNameCall = mt.__namecall
setreadonly(mt, false)

mt.__namecall =
    newcclosure(
    function(Self, ...)
        local args = {...}
        local methodName = getnamecallmethod()
        if not checkcaller() and methodName == "FireServer" and elisium.TargetAim.enabled then
            for i, Argument in ipairs(args) do
                if typeof(Argument) == "Vector3" and target and target.Character then
                    args[i] =
                        target.Character[elisium.TargetAim.targetPart].Position +
                        (target.Character[elisium.TargetAim.targetPart].Velocity * elisium.TargetAim.prediction)
                end
            end
        end
        return oldNameCall(Self, unpack(args))
    end
)

setreadonly(mt, true)

RunService.Heartbeat:Connect(
    function(DeltaTime)
        if elisium.AutoPred.Enabled and elisium.AutoPred.Mode == "Ping" then
            local pingValue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local ping = tonumber((pingValue:match("%d+")))
            if ping then
                if ping > 225 then
                    elisium.Camlock.prediction = 0.166547
                elseif ping > 215 then
                    elisium.Camlock.prediction = 0.15692
                elseif ping > 205 then
                    elisium.Camlock.prediction = 0.165732
                elseif ping > 190 then
                    elisium.Camlock.prediction = 0.1690
                elseif ping > 185 then
                    elisium.Camlock.prediction = 0.1235666
                elseif ping > 180 then
                    elisium.Camlock.prediction = 0.16779123
                elseif ping > 175 then
                    elisium.Camlock.prediction = 0.165455312399999
                elseif ping > 170 then
                    elisium.Camlock.prediction = 0.16
                elseif ping > 165 then
                    elisium.Camlock.prediction = 0.15
                elseif ping > 160 then
                    elisium.Camlock.prediction = 0.1223333
                elseif ping > 155 then
                    elisium.Camlock.prediction = 0.125333
                elseif ping > 150 then
                    elisium.Camlock.prediction = 0.1652131
                elseif ping > 145 then
                    elisium.Camlock.prediction = 0.129934
                elseif ping > 140 then
                    elisium.Camlock.prediction = 0.1659921
                elseif ping > 135 then
                    elisium.Camlock.prediction = 0.1659921
                elseif ping > 130 then
                    elisium.Camlock.prediction = 0.12399
                elseif ping > 125 then
                    elisium.Camlock.prediction = 0.15465
                elseif ping > 110 then
                    elisium.Camlock.prediction = 0.142199
                elseif ping > 105 then
                    elisium.Camlock.prediction = 0.141199
                elseif ping > 100 then
                    elisium.Camlock.prediction = 0.134143
                elseif ping > 90 then
                    elisium.Camlock.prediction = 0.1433333333392
                elseif ping > 80 then
                    elisium.Camlock.prediction = 0.1332241241231
                elseif ping > 70 then
                    elisium.Camlock.prediction = 0.1513989
                elseif ping > 60 then
                    elisium.Camlock.prediction = 0.133
                elseif ping > 50 then
                    elisium.Camlock.prediction = 0.12118333
                elseif ping > 40 then
                    elisium.Camlock.prediction = 0.12588244444444
                elseif ping > 35 then
                    elisium.Camlock.prediction = 0.12565
                elseif ping > 30 then
                    elisium.Camlock.prediction = 0.1419283
                elseif ping > 25 then
                    elisium.Camlock.prediction = 0.12948111
                elseif ping > 20 then
                    elisium.Camlock.prediction = 0.1211928
                end
            end
        end
    end
)

RunService.Heartbeat:Connect(
    function(DeltaTime)
        if elisium.AutoPred.Enabled and elisium.AutoPred.Mode == "Advanced" then
            local pingValue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local ping = tonumber(pingValue:match("%d+"))

            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = target.Character.HumanoidRootPart
                local targetVelocity = targetHRP.Velocity

                local targetPosition = targetHRP.Position
                local distance = (targetPosition - Camera.CFrame.Position).magnitude
                local distanceFactor = math.clamp(distance / 1000, 0, 0.5)

                local environmentalInterference = (math.random() * 0.1) - 0.05
                local obstructionFactor = 0

                local ray = Ray.new(Camera.CFrame.Position, (targetPosition - Camera.CFrame.Position).unit * distance)
                local hitPart, hitPosition = workspace:FindPartOnRay(ray, Camera.Parent)
                if hitPart and hitPart.Transparency < 0.5 then
                    obstructionFactor = 0.1
                end

                if ping and ping > 0 then
                    local pingAdjustment = math.clamp(ping / 1000, 0, 0.3)

                    local velocityFactor = targetVelocity.magnitude / 500
                    local predictionValue =
                        pingAdjustment + distanceFactor + velocityFactor + environmentalInterference + obstructionFactor

                    elisium.Camlock.Prediction = predictionValue
                    elisium.TargetAim.Prediction = predictionValue
                end
            end
        end
    end
)
